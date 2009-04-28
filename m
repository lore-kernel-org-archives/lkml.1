Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbZD1NBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbZD1NBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760323AbZD1NAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:00:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48563 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760332AbZD1NAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:00:52 -0400
Subject: [PATCH 2/2] x86: move per-cpu mmu_gathers to mm/init.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 16:00:50 +0300
Message-Id: <1240923650.1982.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

[ Impact: cleanup ]
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c    |    3 +++
 arch/x86/mm/init_32.c |    1 -
 arch/x86/mm/init_64.c |    2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fd3da1d..388da91 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -9,6 +9,9 @@
 #include <asm/sections.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
 unsigned long __initdata e820_table_start;
 unsigned long __meminitdata e820_table_end;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ce2ec31..1c74d62 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -52,7 +52,6 @@
 #include <asm/page_types.h>
 #include <asm/init.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index abb932f..01172a8 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -52,8 +52,6 @@
 
 static unsigned long dma_reserve __initdata;
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
-- 
1.5.6.3



