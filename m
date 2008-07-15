Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYGOHEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYGOHEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYGOHEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:04:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:4784 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYGOHEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CuHwjklS9jl4WGdpYoBpPOWO2O8mT1/HBGDeVePTSVNMhbtVJZTsS5VtEc0yKgAji0
         bdEi5zSZ2XYzLPL4HMDMXiYTQoffMwi4mJ2JkNQknQpm8CknAUagENzM3TXowisins+x
         IYNgwPpMj2DSlhLquO4+/DvqNa7fvDMKZXcvE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: make memtest support 32bit
Date: Tue, 15 Jul 2008 00:03:44 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807150002.28398.yhlu.kernel@gmail.com>
In-Reply-To: <200807150002.28398.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807150003.44497.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


only support max_low_pfn below...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/Kconfig                    |    1 -
 arch/x86/mm/init_32.c               |    3 +++
 3 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -1200,7 +1200,7 @@ and is between 256 and 4096 characters.
 			         or
 			         memmap=0x10000$0x18690000
 
-	memtest=	[KNL,X86_64] Enable memtest
+	memtest=	[KNL,X86] Enable memtest
 			Format: <integer>
 			range: 0,4 : pattern number
 			default : 0 <disable>
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -844,6 +844,9 @@ unsigned long __init_refok init_memory_m
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
 
+	if (!after_init_bootmem)
+		early_memtest(start, end);
+
 	return end >> PAGE_SHIFT;
 }
 
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -448,7 +448,6 @@ config PARAVIRT_DEBUG
 
 config MEMTEST
 	bool "Memtest"
-	depends on X86_64
 	default y
 	help
 	  This option adds a kernel parameter 'memtest', which allows memtest
