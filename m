Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbZE1Ua5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbZE1Ua5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763726AbZE1Uat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:30:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38869 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbZE1Uas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:30:48 -0400
Date: Thu, 28 May 2009 22:30:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml@morethan.org, Harald Welte <HaraldWelte@viatech.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090528203022.GB1290@ucw.cz>
References: <200905221139.26941.lkml@morethan.org> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <200905240727.30677.lkml@morethan.org> <4A198B24.9040404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A198B24.9040404@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > @hpa - I still like your suggestion that it is only one (or a few)
> > uses of atomic ops that is incorrect and in general atomic ops
> > should compile away on uni-processor.
> > 
> 
> Actually, the more I think about it the more I suspect there is a race
> condition either in the chip set or in any VIA-specific drivers (if
> there are any.)  Putting LOCKs in random places will slow the CPU down
> significantly, so it might resolve the race condition without actually
> solving the problem.

Which you can verify; replace lock with something slow (pushad,
popad)? And see what happens.

(And if it never ever triggers on hp2133, you have strong clue that it
may not be cpu-related, but bios-related or chipset related or something).

Some time ago I was trying to debug misterious hangs on some
via/fic machines. 

We never figured out what was wrong, but we discovered many other bios
bugs, and those were not being fixed; so debugging was
hard/impossible. Unfortunately I no longer have access to that hw.

hp2133 did _not_ have that problem.

Try forcing maximum throttling, then move mouse for like five
seconds. If kbc dies, you have same buggy bios, and probably are
debugging same problem....
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
