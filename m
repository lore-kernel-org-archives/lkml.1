Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYGSA30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYGSA30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYGSA3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:29:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:50821 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYGSA3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=cwSJoj/MUtIwz8bUlpuFTjQRj5o33yS9CZprjfjAzKm1ca2vy+K2+5sDK5CbdV0Gh+
         S3M+HEr5lA16A9cre2PEoaHd7c5MMCuHI8UsgOAiqkff+bCLNhOgzRX9vAzTdaSJbBQe
         T9zI7a+fRSfYxfWCHPjHzbJz4X5p+9aulkSe8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove arch_get_ram_range
Date: Fri, 18 Jul 2008 17:28:40 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181728.40588.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


no user now

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   21 ---------------------
 1 file changed, 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1368,24 +1368,3 @@ void __init setup_memory_map(void)
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
-
-#ifdef CONFIG_X86_64
-int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
-{
-	int i;
-
-	if (slot < 0 || slot >= e820.nr_map)
-		return -1;
-	for (i = slot; i < e820.nr_map; i++) {
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		break;
-	}
-	if (i == e820.nr_map || e820.map[i].addr > (max_pfn << PAGE_SHIFT))
-		return -1;
-	*addr = e820.map[i].addr;
-	*size = min_t(u64, e820.map[i].size + e820.map[i].addr,
-		max_pfn << PAGE_SHIFT) - *addr;
-	return i + 1;
-}
-#endif
