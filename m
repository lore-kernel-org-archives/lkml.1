Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbXIKNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbXIKNBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXIKNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:01:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbXIKNBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:01:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 15:12:34 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709112127.58597.ncunningham@crca.org.au> <200709111355.07369.rjw@sisk.pl>
In-Reply-To: <200709111355.07369.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111512.35348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 13:55, Rafael J. Wysocki wrote:
> On Tuesday, 11 September 2007 13:27, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Tuesday 11 September 2007 21:04:22 Rafael J. Wysocki wrote:
> > > On Tuesday, 11 September 2007 05:54, Nigel Cunningham wrote:
> > > > Hi all.
> > > > 
> > > > Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel 
> > threads
> > > > nonfreezable by default) breaks freezing when attempting to resume from an
> > > > initrd, because the init (which is freezeable) spins while waiting for 
> > another
> > > > thread to run /linuxrc, but doesn't check whether it has been told to 
> > enter
> > > > the refrigerator.
> > > 
> > > Hm.
> > > 
> > > I use a resume from an initrd on a regular basis and it works without the 
> > patch
> > > below.
> > > 
> > > I think we need to investigate what happens in your test case a bit.
> > 
> > Ah. That makes me realise that I see that too - my AMD64 uniprocessor laptop 
> > didn't need the patch (guess that's why I didn't notice the need and ack'd 
> > the patch). But my x86 SMP machine... it needs this. I'll see if they're 
> > running on different processors.
> 
> Well, strange.  My x86_64 SMP machines don't need the patch too.

Anyway, yes, init is freezable, but should it be?

I mean, shouldn't we rather add PF_NOFREEZE to kernel_init()?

Greetings,
Rafael
