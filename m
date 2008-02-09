Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYBIPSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYBIPSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYBIPRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:17:05 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:37653 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYBIPRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:17:04 -0500
From: Andi Kleen <ak@suse.de>
References: <20080209416.271135970@suse.de>
In-Reply-To: <20080209416.271135970@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/5] Enable ACPI extended century handling for 32bit too v2
Message-Id: <20080209151701.56CAB1B41D1@basil.firstfloor.org>
Date: Sat,  9 Feb 2008 16:17:01 +0100 (CET)
X-OriginalArrivalTime: 09 Feb 2008 15:10:40.0674 (UTC) FILETIME=[EEF43020:01C86B2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not that it matters much, see comment in the code.

v2: Fix compilation on !ACPI, pointed out by tglx

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/rtc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -112,8 +112,11 @@ unsigned long mach_get_cmos_time(void)
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86_64)
-	/* CHECKME: Is this really 64bit only ??? */
+#ifdef CONFIG_ACPI
+	/*
+	 * On 32bit not strictly needed because the world ends in 2038
+	 * and the code can handle that with the 2 digit heuristics.
+	 */
 	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 	    acpi_gbl_FADT.century)
 		century = CMOS_READ(acpi_gbl_FADT.century);
