Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZJIJ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZJIJ64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZJIJ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:58:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbZJIJ6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:58:54 -0400
Date: Fri, 9 Oct 2009 11:58:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS: remove code that has been commented out for many
 years
Message-ID: <alpine.LSU.2.00.0910091156580.19284@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I have already queued this in trivial tree. If you have objections, 
  please shout ]

Remove the dump_tlb_all() function that has been commented out for
many years.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/cris/arch-v10/mm/tlb.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/cris/arch-v10/mm/tlb.c b/arch/cris/arch-v10/mm/tlb.c
index 4a496e4..21d78c5 100644
--- a/arch/cris/arch-v10/mm/tlb.c
+++ b/arch/cris/arch-v10/mm/tlb.c
@@ -134,28 +134,6 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	local_irq_restore(flags);
 }
 
-/* dump the entire TLB for debug purposes */
-
-#if 0
-void
-dump_tlb_all(void)
-{
-	int i;
-	unsigned long flags;
-
-	printk("TLB dump. LO is: pfn | reserved | global | valid | kernel | we  |\n");
-
-	local_save_flags(flags);
-	local_irq_disable();
-	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
-		*R_TLB_SELECT = ( IO_FIELD(R_TLB_SELECT, index, i) );
-		printk("Entry %d: HI 0x%08lx, LO 0x%08lx\n",
-		       i, *R_TLB_HI, *R_TLB_LO);
-	}
-	local_irq_restore(flags);
-}
-#endif
-
 /*
  * Initialize the context related info for a new mm_struct
  * instance.
-- 
1.5.6
