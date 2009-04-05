Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZDERMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZDERMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 13:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZDERM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 13:12:28 -0400
Received: from smtp5.welho.com ([213.243.153.39]:52778 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZDERM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 13:12:27 -0400
Date: Sun, 5 Apr 2009 20:10:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, dhowells@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix frv compile breakage
Message-ID: <20090405171056.GD3718@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the follwing build error caused by
commit 7ca43e7564679604d86e9ed834e7bbcffd8a4a3f
(mm: use debug_kmap_atomic):

<--  snip  -->

...
  AS      arch/frv/mm/tlb-miss.o
...
In file included from 
arch/frv/mm/tlb-miss.S:13:
...
Assembler messages:
include/asm-generic/ioctl.h:73: 
Error: unrecognized instruction `extern unsigned int __invalid_size_argument_for_IO...'
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
diff --git a/arch/frv/mm/tlb-miss.S b/arch/frv/mm/tlb-miss.S
index 0764348..7f392bc 100644
--- a/arch/frv/mm/tlb-miss.S
+++ b/arch/frv/mm/tlb-miss.S
@@ -13,7 +13,6 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
 	.section	.text.tlbmiss

