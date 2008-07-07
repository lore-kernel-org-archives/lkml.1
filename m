Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYGGXLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYGGXLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYGGXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:11:08 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2565 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbYGGXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:11:07 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/10] MCE: Port K7 bank 0 quirk to 64bit mce code
Message-Id: <20080707231005.9049D1B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:05 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:41.0463 (UTC) FILETIME=[8F026470:01C8E085]
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
