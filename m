Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYGDVXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYGDVXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGDVVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:34 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:59507 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYGDVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/9] MCE: Port K7 bank 0 quirk to 64bit mce code
Message-Id: <20080704212027.B7F441B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:27 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:05.0142 (UTC) FILETIME=[BFFA3160:01C8DE1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various K7 have broken bank 0s. Don't enable it by default

Port from the 32bit code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -482,6 +482,12 @@ static void __cpuinit mce_cpu_quirks(str
 			/* Lots of broken BIOS around that don't clear them
 			   by default and leave crap in there. Don't log. */
 			mce_bootlog = 0;
+		/*
+		 * Various K7s with broken bank 0 around. Always disable
+		 * by default.
+		 */
+		if (c->x86 == 6)
+			bank[0] = 0;
 	}
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
 		/*
