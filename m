Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYBIPRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYBIPRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYBIPQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:16:59 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:22707 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYBIPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:16:59 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080209416.271135970@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/5] Only do century BCD conversion when we know the RTC is BCD
Date: Sat,  9 Feb 2008 16:16:57 +0100 (CET)
X-OriginalArrivalTime: 09 Feb 2008 15:10:36.0611 (UTC) FILETIME=[EC883930:01C86B2D]
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
