Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZA1EAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZA1EAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZA1D77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:59:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43564 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZA1D76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:59:58 -0500
Message-ID: <497FD678.9000504@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 12:52:24 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH take2 2/3] unify PM-Timer messages
References: <497FD4F3.3080006@jp.fujitsu.com>
In-Reply-To: <497FD4F3.3080006@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When LOCAL APIC was calibrated, the debug message is displayed as follows.

	CPU0: Intel(R) Xeon(R) CPU            5110  @ 1.60GHz stepping 06
	Using local APIC timer interrupts.
	calibrating APIC timer ...
	... lapic delta = 3773131
	... PM timer delta = 812434
	APIC calibration not consistent with PM Timer: 226ms instead of 100ms
	APIC delta adjusted to PM-Timer: 1662420 (3773131)
	TSC delta adjusted to PM-Timer: 159592409 (362220564)
	..... delta 1662420
	..... mult: 71411249
	..... calibration result: 265987
	..... CPU clock speed is 1595.0924 MHz.
	..... host bus clock speed is 265.0987 MHz.

There are three type of PM-Timer (PM-Timer, PM Timer, and PM timer),
in this message. This patch unifies those messages to PM-Timer.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/x86/kernel/apic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.29-rc2/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.29-rc2.orig/arch/x86/kernel/apic.c	2009-01-28 12:14:42.000000000 +0900
+++ linux-2.6.29-rc2/arch/x86/kernel/apic.c	2009-01-28 12:14:51.000000000 +0900
@@ -547,7 +547,7 @@ calibrate_by_pmtimer(long deltapm, long
 	return -1;
 #endif

-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+	apic_printk(APIC_VERBOSE, "... PM-Timer delta = %ld\n", deltapm);

 	/* Check, if the PM timer is available */
 	if (!deltapm)
@@ -557,14 +557,14 @@ calibrate_by_pmtimer(long deltapm, long

 	if (deltapm > (pm_100ms - pm_thresh) &&
 	    deltapm < (pm_100ms + pm_thresh)) {
-		apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+		apic_printk(APIC_VERBOSE, "... PM-Timer result ok\n");
 		return 0;
 	}

 	res = (((u64)deltapm) *  mult) >> 22;
 	do_div(res, 1000000);
 	pr_warning("APIC calibration not consistent "
-		   "with PM Timer: %ldms instead of 100ms\n",(long)res);
+		   "with PM-Timer: %ldms instead of 100ms\n",(long)res);

 	/* Correct the lapic counter value */
 	res = (((u64)(*delta)) * pm_100ms);
