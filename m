Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYLCAca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYLCAca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYLCAcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:32:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYLCAcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:32:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 3 Dec 2008 01:31:41 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812021518160.3256@nehalem.linux-foundation.org> <200812030100.18400.rjw@sisk.pl>
In-Reply-To: <200812030100.18400.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812030131.42157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Rafael J. Wysocki wrote:
> On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> > 
> > On Tue, 2 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > * dmesg output including one hibernation-resume cycle from 2.6.28-rc7 with the
> > >   debug patch (appended for completness):
> > > 
> > >   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-patched-prep.log
> > > 
> > > * dmesg output including one hibernation-resume cycle from 2.6.28-rc7 without
> > >   the debug patch:
> > > 
> > >   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-nopatch-prep.log
> > 
> > As with Frans, the debug patch seems to make no difference what-so-ever. 
> > Yes, the cardbus regions get allocated differently, but they're fine in 
> > either case, and arguably (exactly as with Frans) the debug patch actually 
> > makes things uglier by actively getting the alignment wrong, and skipping 
> > cardbus setup until later.
> 
> Hm, what about (from the copy of /proc/iomem without the patch at
> http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/rc7-nopatch/iomem):
> 
> 88000000-8bffffff : PCI Bus 0000:03
>   88000000-8bffffff : PCI CardBus 0000:04
> 8c000000-91ffffff : PCI Bus 0000:03
>   8c000000-8fffffff : PCI CardBus 0000:04
> 
> (1) Why two ranges are allocated for 0000:03 without the patch while there is
>     only one range with the patch:
> 
> 88000000-880fffff : PCI Bus 0000:03
> 
>     (copy of the file at
>     http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/rc7-patched/iomem)?
>     That seems to look like a difference to me.

OK, I see why this happens.

> (2) Why are they so large without the patch while with the patch they are much
>     smaller (O(2^28) vs O(2^21) if I'm not mistaken)?

I don't see why this should happen, though.  Even if the prefetch window is
discarded, the MEM window seems to be much wider without the patch.

> (3) Why are they overlapping with the ranges for CardBus 0000:04, although
>     without the patch they aren't?  Is that actually correct at all?

OK, I see why this happens too.

Sorry for the noise,
Rafael
