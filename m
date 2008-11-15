Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYKOLrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYKOLrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 06:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYKOLrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 06:47:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40213 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbYKOLrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 06:47:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Bug #11988] Eliminate recursive mutex in compat fb ioctl path
Date: Sat, 15 Nov 2008 12:51:37 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.Z-E.Q4zFJB@chimera> <Pine.LNX.4.64.0811141549140.5955@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0811141549140.5955@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811151251.38492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of November 2008, Geert Uytterhoeven wrote:
> On Sun, 9 Nov 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11988
> > Subject		: Eliminate recursive mutex in compat fb ioctl path
> > Submitter	: Keith Packard <keithp@keithp.com>
> > Date		: 2008-11-03 7:06 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
> > Handled-By	: Keith Packard <keithp@keithp.com>
> > 		  Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
> > 		  http://lkml.org/lkml/2008/10/31/162
> 
> Fixed in mainline.
> 
> commit a684e7d33096892093456dd56a582cfc3bfad648
> Author: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Date:   Thu Nov 6 12:53:37 2008 -0800
> 
>     fbdev: fix fb_compat_ioctl() deadlocks
> 
>     commit 3e680aae4e53ab54cdbb0c29257dae0cbb158e1c ("fb: convert
>     lock/unlock_kernel() into local fb mutex") introduced several deadlocks
>     in the fb_compat_ioctl() path, as mutex_lock() doesn't allow recursion,
>     unlike lock_kernel().  This broke frame buffer applications on 64-bit
>     systems with a 32-bit userland.
>     
>     commit 120a37470c2831fea49fdebaceb5a7039f700ce6 ("framebuffer compat_ioctl
>     deadlock") fixed one of the deadlocks.
>     
>     This patch fixes the remaining deadlocks:
>       - Revert commit 120a37470c2831fea49fdebaceb5a7039f700ce6,
>       - Extract the core logic of fb_ioctl() into a new function do_fb_ioctl(),
>       - Change all callsites of fb_ioctl() where info->lock is already held to
>         call do_fb_ioctl() instead,
>       - Add sparse annotations to all routines that take info->lock.
>     
>     Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>     Cc: Mikulas Patocka <mpatocka@redhat.com>
>     Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
>     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks, closed.

Rafael
