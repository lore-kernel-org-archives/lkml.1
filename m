Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYCMKNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYCMKNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYCMKLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35235 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbYCMKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:35 -0400
Date: Thu, 13 Mar 2008 09:10:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080313081048.GB19808@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080310100008.GA9520@elf.ucw.cz> <20080310134915.45ae7446@mjolnir.drzeus.cx> <200803121511.17389.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803121511.17389.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > USB keeps processor out of C3 in many cases.
> > 
> > I figured that was the case. But I did not see any difference in powertop.
> 
> Modern Intel mobile processors have a feature called "C2 popup"
> that allows the processor to retire DMA from C3 without
> breaking into C0.  Instead the processor pops up to C2
> where the cache snoop can allow the DMA to retire --
> then it returns to C3, all transparent to software.

Does that mean we should go to C3 on modern intels, even with
busmaster going on, so that cpu can keep going C2..C3..C2 as needed?

> if you disable it at run-time, Linux puts it in C1.  If you never
> boot it in the first place (eg. maxcpusp=1), the BIOS leaves it in
> the deepest available C-sate.

It would be nice to fix this BTW. offlined cpu in C1 eats too much
power, and makes measurements on the second core impossible...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
