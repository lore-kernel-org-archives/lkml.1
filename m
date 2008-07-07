Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYGGG34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYGGG34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYGGG2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:28:55 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56828 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYGGG2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:28:54 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080707828.405203787@firstfloor.org>
In-Reply-To: <20080707828.405203787@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/9] MCE: Port K7 bank 0 quirk to 64bit mce code
Message-Id: <20080707062835.9E4281B4315@basil.firstfloor.org>
Date: Mon,  7 Jul 2008 08:28:35 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 06:21:11.0875 (UTC) FILETIME=[A6D2E930:01C8DFF9]
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
