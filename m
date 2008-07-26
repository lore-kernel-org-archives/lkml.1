Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYGZUfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYGZUfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYGZUfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:35:10 -0400
Received: from main.gmane.org ([80.91.229.2]:36448 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234AbYGZUfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:35:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: do_IRQ: 0.83/0.84 No irq handler for vector
Date: Sat, 26 Jul 2008 23:28:09 +0300
Message-ID: <g6g1ct$6es$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-49250.home.otenet.gr
User-Agent: Thunderbird 2.0.0.14 (X11/20080715)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list.

Kernel 2.6.26 (on x86-64) gives "do_IRQ: 0.83 No irq handler for vector" 
(and "do_IRQ: 0.83", but less often) warnings periodically.  It seems 
that the kernel's Radeon DRM driver is at fault, or at least involved 
(no warnings on a kernel without Radeon DRM).  The hardware in question 
is an R580 chip (AFAIK, R500 support was introduced with 2.6.26).

The "do_IRQ: 0.83" warning is 100% reproducible when switching from X 
(xf86-video-ati 6.9.0) to a console (vesafb):

   [drm] Setting GART location based on new memory map
   [drm] Loading R500 Microcode
   [drm] Num pipes: 4
   [drm] writeback test succeeded in 1 usecs
   do_IRQ: 0.83 No irq handler for vector
   do_IRQ: 0.83 No irq handler for vector
   do_IRQ: 0.83 No irq handler for vector

When enabling 3D (compiz fusion) this happens:

   do_IRQ: 0.83 No irq handler for vector
   do_IRQ: 0.83 No irq handler for vector
   [repeated 8 more times]
   __ratelimit: 5 messages suppressed
   do_IRQ: 0.83 No irq handler for vector
   do_IRQ: 0.83 No irq handler for vector

Some apps (glxgears) report the following when they try to do vertical 
synchronization (vblank_mode 1):

   do_wait: drmWaitVBlank returned -1, IRQs don't seem
   to be working correctly.

(the result is that vsync doesn't work as intended and rendering speed 
gets locked at exactly 0.333 FPS).

Of course I filed a bug on X.Org's bugzilla first 
(http://bugs.freedesktop.org/show_bug.cgi?id=16850), but it is not clear 
what exactly this warning means and I'm not sure if it's a problem with 
the kernel's DRM driver or with X.Org (or both.)

