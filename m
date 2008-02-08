Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbYBHMPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbYBHMPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYBHMO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:14:59 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:40578 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbYBHMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:14:58 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208114.066167427@suse.de>
In-Reply-To: <20080208114.066167427@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] Use 2000 offset for 32bit kernels
Message-Id: <20080208121454.1D9A01B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 13:14:54 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 12:08:33.0964 (UTC) FILETIME=[53B6CEC0:01C86A4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We know it is already after 2000.

This extends the effective lifetime of 32bit systems by 8 years:
from 2030 to 2038.

The only drawback is that users cannot set the cmos date to before 2000
now on 32bit with systems that don't support extended century in 
the RTC clock. 64bit systems had this limitation for some time
and nobody complained.

And they can always set it to such a date in Linux only using date -s 
if they really want.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/rtc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -9,7 +9,6 @@
 #include <asm/vsyscall.h>
 
 #ifdef CONFIG_X86_32
-# define CMOS_YEARS_OFFS 1900
 /*
  * This is a special lock that is owned by the CPU and holds the index
  * register we are working with.  It is required for NMI access to the
@@ -17,14 +16,11 @@
  */
 volatile unsigned long cmos_lock = 0;
 EXPORT_SYMBOL(cmos_lock);
-#else
-/*
- * x86-64 systems only exists since 2002.
- * This will work up to Dec 31, 2100
- */
-# define CMOS_YEARS_OFFS 2000
 #endif
 
+/* For two digit years assume time is always after that */
+#define CMOS_YEARS_OFFS 2000
+
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
