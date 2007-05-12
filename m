Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXELXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXELXQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 19:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbXELXQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 19:16:18 -0400
Received: from mail.aknet.ru ([82.179.72.26]:59669 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXELXQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 19:16:17 -0400
Message-ID: <46464B5C.2080302@aknet.ru>
Date: Sun, 13 May 2007 03:18:52 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] make pit clocksource continuous
Content-Type: multipart/mixed;
 boundary="------------000401030102040200000705"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000401030102040200000705
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

Without the attached patch, I wasn't able
to get the PIT to work as a clocksource for
high-res timers.
I don't know whether the patch is correct,
but I tested it and it works.
Can someone please tell me what exactly
does this flag mean? google reveals nothing
sensible to me, sorry...

---
Set CLOCK_SOURCE_IS_CONTINUOUS flag for the PIT clocksource

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
CC: Thomas Gleixner <tglx@linutronix.de>


--------------000401030102040200000705
Content-Type: text/x-patch;
 name="pit_cont.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pit_cont.diff"

--- linux-2.6.21/arch/i386/kernel/i8253.c	2007-05-12 11:29:23.000000000 +0400
+++ linux-2.6.21-xx/arch/i386/kernel/i8253.c	2007-05-13 02:19:57.000000000 +0400
@@ -193,6 +193,7 @@
 	.mask	= CLOCKSOURCE_MASK(32),
 	.mult	= 0,
 	.shift	= 20,
+	.flags  = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_pit_clocksource(void)

--------------000401030102040200000705--
