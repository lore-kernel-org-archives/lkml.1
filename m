Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbYBHMQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbYBHMQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbYBHMPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:15:00 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:24717 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbYBHMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:14:59 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208114.066167427@suse.de>
In-Reply-To: <20080208114.066167427@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] Enable ACPI extended century handling for 32bit too
Message-Id: <20080208121455.228C31B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 13:14:55 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 12:08:34.0996 (UTC) FILETIME=[54544740:01C86A4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not that it matters much, see comment in the code.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/rtc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -112,12 +112,13 @@ unsigned long mach_get_cmos_time(void)
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86_64)
-	/* CHECKME: Is this really 64bit only ??? */
+	/*
+	 * On 32bit not strictly needed because the world ends in 2038
+	 * and the code can handle that with the 2 digit heuristics.
+	 */
 	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 	    acpi_gbl_FADT.century)
 		century = CMOS_READ(acpi_gbl_FADT.century);
-#endif
 
 	if (RTC_ALWAYS_BCD || !(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)) {
 		BCD_TO_BIN(sec);
