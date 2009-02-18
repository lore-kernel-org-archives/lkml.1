Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZBRWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZBRWbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZBRWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:25 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43889
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469AbZBRWaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:23 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 7/9] mm: allow preemption in apply_to_pte_range
Date: Wed, 18 Feb 2009 14:30:16 -0800
Message-Id: <72c108781364f9cbf0f9094978d59c271602896f.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Preemption is now allowed for lazy mmu mode, so don't disable
it for the inner loop of apply_to_pte_range.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/memory.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b80cc31..baa999e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1718,7 +1718,6 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	BUG_ON(pmd_huge(*pmd));
 
-	preempt_disable();
 	arch_enter_lazy_mmu_mode();
 
 	token = pmd_pgtable(*pmd);
@@ -1730,7 +1729,6 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
-	preempt_enable();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
-- 
1.6.0.6

