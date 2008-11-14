Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbYKNOv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbYKNOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYKNOvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:51:49 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64646 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750727AbYKNOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:51:48 -0500
Date: Fri, 14 Nov 2008 15:51:45 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #11988] Eliminate recursive mutex in compat fb ioctl path
In-Reply-To: <wnN9HICUAgP.A.Z-E.Q4zFJB@chimera>
Message-ID: <Pine.LNX.4.64.0811141549140.5955@vixen.sonytel.be>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.Z-E.Q4zFJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11988
> Subject		: Eliminate recursive mutex in compat fb ioctl path
> Submitter	: Keith Packard <keithp@keithp.com>
> Date		: 2008-11-03 7:06 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
> Handled-By	: Keith Packard <keithp@keithp.com>
> 		  Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
> 		  http://lkml.org/lkml/2008/10/31/162

Fixed in mainline.

commit a684e7d33096892093456dd56a582cfc3bfad648
Author: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date:   Thu Nov 6 12:53:37 2008 -0800

    fbdev: fix fb_compat_ioctl() deadlocks

    commit 3e680aae4e53ab54cdbb0c29257dae0cbb158e1c ("fb: convert
    lock/unlock_kernel() into local fb mutex") introduced several deadlocks
    in the fb_compat_ioctl() path, as mutex_lock() doesn't allow recursion,
    unlike lock_kernel().  This broke frame buffer applications on 64-bit
    systems with a 32-bit userland.
    
    commit 120a37470c2831fea49fdebaceb5a7039f700ce6 ("framebuffer compat_ioctl
    deadlock") fixed one of the deadlocks.
    
    This patch fixes the remaining deadlocks:
      - Revert commit 120a37470c2831fea49fdebaceb5a7039f700ce6,
      - Extract the core logic of fb_ioctl() into a new function do_fb_ioctl(),
      - Change all callsites of fb_ioctl() where info->lock is already held to
        call do_fb_ioctl() instead,
      - Add sparse annotations to all routines that take info->lock.
    
    Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
    Cc: Mikulas Patocka <mpatocka@redhat.com>
    Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
