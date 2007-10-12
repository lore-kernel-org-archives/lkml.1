Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbXJLEcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbXJLEcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXJLEcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:32:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41544 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXJLEcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:32:41 -0400
Date: Thu, 11 Oct 2007 21:29:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jiri Slaby <jirislaby@gmail.com>, video4linux-list@redhat.com,
       daniel@qanu.de, linux-kernel@vger.kernel.org, holger@qanu.de,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2, remove bad
 usage of ERESTARTSYS
Message-Id: <20071011212921.f97c8423.randy.dunlap@oracle.com>
In-Reply-To: <470C5294.8060502@linuxtv.org>
References: <24841282012868130110@pripojeni.net>
	<1191979260.5492.32.camel@gaivota>
	<470C5294.8060502@linuxtv.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 00:18:28 -0400 Michael Krufky wrote:

> Mauro Carvalho Chehab wrote:
> > Hi Jiri,
> >
> > Em Seg, 2007-10-08 às 13:41 +0100, Jiri Slaby escreveu:
> >   
> >> cinergyT2, remove bad usage of ERESTARTSYS
> >>
> >> test of cinergyt2->disconnect_pending doesn't ensure pending signal and so
> >> ERESTARTSYS would reach userspace, which is not permitted. Change it to
> >> EAGAIN
> >>
> >>     
> >
> > checkpatch.pl is complaining about your changeset:
> >
> > do not use assignment in if condition
> > #82: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:492:
> > +     if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))
> >
> > do not use assignment in if condition
> > #86: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:495:
> > +     if ((err = mutex_lock_interruptible(&cinergyt2->sem)))
> >
> > do not use assignment in if condition
> > #133: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:1036:
> > +     if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))
> >
> > do not use assignment in if condition
> > #137: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:1039:
> > +     if ((err = mutex_lock_interruptible(&cinergyt2->sem)))
> 
> Is this illegal as per kernel codingstyle?  I could understand if we may
> want to avoid this sort of thing for the sake of code readability, but
> this seems 100% proper to me, especially considering that we're simply
> trying to catch an error return code.

Anyway, it's not strictly from CodingStyle.  The closest that
CodingStyle has to say about it IMO is this:

"Don't put multiple assignments on a single line either.  Kernel coding style
is super simple.  Avoid tricky expressions."

Also, Andrew Morton and Christoph Hellwig push for splitting up
the if-assignment lines, so it's a trend over the past few
(probably) years.  It's not real new.


> One of the things that I really enjoy about the c programming language
> is the fact that you can string many operations together into a single
> statement through the use of logic.  I hate the thought of a patch being
> nacked because of the above.  :-/

so you like the challenge of reading obfuscated code?

At any rate, it's rare that a patch is nacked only due to coding style,
unless it's blatant and occurs many times (like throughout the entire
source file).


> If this is indeed kernel codingstyle, then IMHO, we should let it slide
> for catching error return codes.

Nope.

---
~Randy
