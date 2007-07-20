Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbXGTV37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbXGTV37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934253AbXGTV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:29:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49530 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689AbXGTV3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:29:36 -0400
Date: Fri, 20 Jul 2007 23:29:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/7] x86_64: fix section mismatch warning in init.c
Message-ID: <20070720212947.GD25064@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x188ea): Section mismatch: reference to .init.text:__alloc_bootmem_core (between 'alloc_bootmem_high_node' and 'get_gate_vma')

alloc_bootmem_high_node() is only used from __init scope so declare it __init.
And in addition declare the weak variant __init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86_64/mm/init.c |    2 +-
 mm/sparse.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 9a0e98a..75afe9c 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -769,7 +769,7 @@ int in_gate_area_no_task(unsigned long addr)
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
 
-void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size,
 			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
diff --git a/mm/sparse.c b/mm/sparse.c
index e03b39f..3047bf0 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -209,7 +209,7 @@ static int __meminit sparse_init_one_section(struct mem_section *ms,
 	return 1;
 }
 
-__attribute__((weak))
+__attribute__((weak)) __init
 void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return NULL;
-- 
1.5.1.rc3.g84b7-dirty

