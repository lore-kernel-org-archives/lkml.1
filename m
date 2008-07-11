Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYGKQ4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYGKQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYGKQz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:55:58 -0400
Received: from mail1.physik.fu-berlin.de ([160.45.35.12]:38588 "EHLO
	mail1.physik.fu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbYGKQz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:55:57 -0400
X-Greylist: delayed 3069 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 12:55:57 EDT
Subject: [PATCH] x86: Fix ldt limit for 64 bit
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: tglx@linuxtronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jul 2008 18:04:46 +0200
Message-Id: <1215792286.8831.14.camel@hermes2.karcher.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-ZEDV-Virus-Scanned: No viruses found. [ClamAV 0.92/7691/Fri Jul 11 16:33:58 2008]
X-ZEDV-Spam-Level: ----
X-ZEDV-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on zs01.physik.fu-berlin.de
X-ZEDV-Spam-Status: No, score=-4.4 required=5.0 tests=ALL_TRUSTED,BAYES_00 autolearn=ham version=3.2.3
X-ZEDV-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Scan-Signature: 48a0a142371ef84aa1c0cd31e7bdf556
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

Fix size of LDT entries. On x86-64, ldt_desc is a double-sized descriptor.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 include/asm-x86/desc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 268a012..28bddbc 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -192,8 +192,8 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 		unsigned cpu = smp_processor_id();
 		ldt_desc ldt;
 
-		set_tssldt_descriptor(&ldt, (unsigned long)addr,
-				      DESC_LDT, entries * sizeof(ldt) - 1);
+		set_tssldt_descriptor(&ldt, (unsigned long)addr, DESC_LDT,
+				      entries * LDT_ENTRY_SIZE - 1);
 		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
 				&ldt, DESC_LDT);
 		asm volatile("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
-- 
1.5.5.4

