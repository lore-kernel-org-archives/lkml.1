Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbZJIJll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbZJIJll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbZJIJll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:41:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:36520 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760565AbZJIJlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:41:40 -0400
Date: Fri, 9 Oct 2009 11:41:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] CIRS: turn local_save_flags() + local_irq_disable()into
 local_irq_save()
Message-ID: <alpine.LSU.2.00.0910091138500.19284@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ This is just FYI. I have already queued this one in trivial tree. ]

This is a followup to my patches that fixed this all over the tree quite some
time ago. This one went unnoticed for some reason.

TLB handling for CRIS contains local_irq_disable() after local_save_flags().
Turn this into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 arch/cris/arch-v10/mm/fault.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/mm/fault.c b/arch/cris/arch-v10/mm/fault.c
index 087a209..ed60588 100644
--- a/arch/cris/arch-v10/mm/fault.c
+++ b/arch/cris/arch-v10/mm/fault.c
@@ -80,8 +80,7 @@ handle_mmu_bus_fault(struct pt_regs *regs)
 	 * do_page_fault may have flushed the TLB so we have to restore
 	 * the MMU registers.
 	 */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	pmd = (pmd_t *)(pgd + pgd_index(address));
 	if (pmd_none(*pmd))
 		goto exit;
-- 
1.5.6

