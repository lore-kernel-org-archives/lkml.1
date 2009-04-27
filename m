Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbZD0Udp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbZD0Udp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbZD0UdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:33:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55005 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758768AbZD0UdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:33:24 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 07/14] avr32: Use standard macros for .data.page_aligned section.
Date: Mon, 27 Apr 2009 16:33:01 -0400
Message-Id: <1240864388-26315-8-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240864388-26315-7-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
 <1240864388-26315-3-git-send-email-tabbott@mit.edu>
 <1240864388-26315-4-git-send-email-tabbott@mit.edu>
 <1240864388-26315-5-git-send-email-tabbott@mit.edu>
 <1240864388-26315-6-git-send-email-tabbott@mit.edu>
 <1240864388-26315-7-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
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

