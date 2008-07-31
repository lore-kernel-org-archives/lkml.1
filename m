Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYGaAhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYGaAhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYGaAgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:36:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:34518 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYGaAgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:36:54 -0400
Message-ID: <48910920.3010202@ct.jp.nec.com>
Date: Wed, 30 Jul 2008 17:36:48 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_32: use apic_ops at print_local_APIC()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Use apic_icr_read at print_local_APIC() in io_apic_32.c

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 67ec368..7f0d88c 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1488,6 +1488,7 @@ __apicdebuginit(void) print_APIC_bitfield(int base)
 __apicdebuginit(void) print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
+	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1538,10 +1539,9 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
 	}
 
-	v = apic_read(APIC_ICR);
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", v);
-	v = apic_read(APIC_ICR2);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", v);
+	icr = apic_icr_read();
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
-- 
1.5.4.1

