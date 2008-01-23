Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYAWL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYAWL7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYAWL7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:59:12 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:40349 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYAWL7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:59:11 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2008 06:59:11 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAC+5lkc7pynT/2dsb2JhbAAIrUWBfw
X-IronPort-AV: E=Sophos;i="4.25,238,1199626200"; 
   d="scan'208";a="38368919"
Message-ID: <47972AD2.20801@niasdigital.com>
Date: Wed, 23 Jan 2008 22:53:54 +1100
From: Ben Nizette <bn@niasdigital.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] define empty unxlate_dev_mem_ptr on AVR32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Defined as a NOP on AVR32 as per the asm-generic implementation.
This keeps /dev/mem happy.

Signed-Off-By: Ben Nizette <bn@niasdigital.com>

---
Index: linux-2.6.24-rc8-mm1/include/asm-avr32/io.h
===================================================================
--- linux-2.6.24-rc8-mm1.orig/include/asm-avr32/io.h
+++ linux-2.6.24-rc8-mm1/include/asm-avr32/io.h
@@ -305,6 +305,12 @@ extern void __iounmap(void __iomem *addr
 #define xlate_dev_mem_ptr(p)    __va(p)

 /*
+ * We just keep an empty definition of this around (a-la the asm-generic
+ * implementation) to keep /dev/mem happy
+ */
+#define unxlate_dev_mem_ptr(p, a) {}
+
+/*
  * Convert a virtual cached pointer to an uncached pointer
  */
 #define xlate_dev_kmem_ptr(p)   p
