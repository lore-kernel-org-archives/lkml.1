Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYD2X62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYD2X62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYD2X6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:58:20 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40359 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYD2X6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:58:20 -0400
Date: Wed, 30 Apr 2008 02:57:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix arch/frv/mm/unaligned.o build error
Message-ID: <20080429235740.GC15987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error caused by
commit 6510d41954dc6a9c8b1dbca7eaca0f23195ca727
(kernel: Move arches to use common unaligned access):

<--  snip  -->

...
make[2]: *** No rule to make target `arch/frv/mm/unaligned.o', needed by `arch/frv/mm/built-in.o'.  Stop.
make[1]: *** [arch/frv/mm] Error 2

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e3dae1fd99455187e952928f53f43b3bde6d0a08 diff --git a/arch/frv/mm/Makefile b/arch/frv/mm/Makefile
index fb8b1d8..1bca5ab 100644
--- a/arch/frv/mm/Makefile
+++ b/arch/frv/mm/Makefile
@@ -6,4 +6,4 @@ obj-y := init.o kmap.o
 
 obj-$(CONFIG_MMU) += \
 	pgalloc.o highmem.o fault.o extable.o cache-page.o tlb-flush.o tlb-miss.o \
-	mmu-context.o dma-alloc.o unaligned.o elf-fdpic.o
+	mmu-context.o dma-alloc.o elf-fdpic.o

