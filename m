Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYBHMPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYBHMPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYBHMO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:14:59 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:24717 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYBHMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:14:58 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080208114.066167427@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] Only do century BCD conversion when we know the RTC is BCD
Date: Fri,  8 Feb 2008 13:14:53 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 12:08:33.0136 (UTC) FILETIME=[53387700:01C86A4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minor logic fix. The century change was previously always BCD,
even when the CMOS data would report itself not being BCD.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -130,10 +130,10 @@ unsigned long mach_get_cmos_time(void)
 		BCD_TO_BIN(day);
 		BCD_TO_BIN(mon);
 		BCD_TO_BIN(year);
+		BCD_TO_BIN(century);
 	}
 
 	if (century) {
-		BCD_TO_BIN(century);
 		year += century * 100;
 		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else {
