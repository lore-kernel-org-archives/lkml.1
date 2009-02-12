Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZBLCDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZBLCDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZBLCDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:03:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZBLCDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:03:23 -0500
Date: Wed, 11 Feb 2009 18:02:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Jan Kara <jack@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029
 slows down Berkeley DB
In-Reply-To: <20090212014718.GF30043@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0902111757030.3189@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gUG.420jJB@chimera> <20090210162830.GD12146@placka.suse.cz> <20090212014718.GF30043@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Feb 2009, Nick Piggin wrote:

> On Tue, Feb 10, 2009 at 05:28:30PM +0100, Jan Kara wrote:
> > On Sun 08-02-09 20:21:42, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> >   Yes, I've verified with latest git and the regression is still there.
> 
> I'm working on this FWIW...

Shouldn't we just revert it? The code does look to be broken.

It also looks like the interaction with that ever-buggy "nr_to_write" 
thing are totally wrong. I can see that whole

	if (!cycled) {
		..
		index = 0;
		goto retry
	}

doing all the wrong things: if we ever hit the combination of 
"!cycled + nr_to-write==0", we're always screwed. It simply _cannot_ do 
the right thing.

I dunno. That whole piece-of-sh*t function has been incredibly buggy this 
release. The code is an unreadable mess, and I think that "cyclic" stuff 
is part of the reason for it being messy and buggy. Please convince me 
it's worth saving, or let me revert the whole stinking pile of crud?

Please?

			Linus
