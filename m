Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbZD1RIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbZD1RIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbZD1RF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:05:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55577 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933051AbZD1RF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:05:27 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH v2 07/15] avr32: Use standard macros for .data.page_aligned section.
Date: Tue, 28 Apr 2009 13:00:54 -0400
Message-Id: <1240938062-3264-8-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-7-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
 <1240938062-3264-2-git-send-email-tabbott@mit.edu>
 <1240938062-3264-3-git-send-email-tabbott@mit.edu>
 <1240938062-3264-4-git-send-email-tabbott@mit.edu>
 <1240938062-3264-5-git-send-email-tabbott@mit.edu>
 <1240938062-3264-6-git-send-email-tabbott@mit.edu>
 <1240938062-3264-7-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/kernel/vmlinux.lds.S |    3 +--
 arch/avr32/mm/init.c            |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 7910d41..36d676f 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -98,8 +98,7 @@ SECTIONS
 		*(.data.init_task)
 
 		/* Then, the page-aligned data */
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA
 
 		/* Then, the cacheline aligned data */
 		. = ALIGN(L1_CACHE_BYTES);
diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index e819fa6..cc60d10 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -24,11 +24,9 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
-#define __page_aligned	__attribute__((section(".data.page_aligned")))
-
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned;
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
 
 struct page *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
-- 
1.6.2.1

