Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZFXGqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZFXGqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZFXGqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:46:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZFXGqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:46:04 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] CRIS: Change DEFINE_PER_CPU of current_pgd to be non volatile.
Date: Wed, 24 Jun 2009 15:45:17 +0900
Message-Id: <1245825924-30412-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245825924-30412-1-git-send-email-tj@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 06:45:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <jesper.nilsson@axis.com>

The DEFINE_PER_CPU of current_pgd was on CRIS defined using volatile,
which is not needed. Remove volatile.

Tested on an ARTPEC-3 (CRISv32) board.

tj: extern DEFINE_PER_CPU() replaced with DECLARE_PER_CPU()

[ Impact: code cleanup ]

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/cris/include/asm/mmu_context.h |    3 ++-
 arch/cris/mm/fault.c                |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/asm/mmu_context.h b/arch/cris/include/asm/mmu_context.h
index 72ba08d..1d45fd6 100644
--- a/arch/cris/include/asm/mmu_context.h
+++ b/arch/cris/include/asm/mmu_context.h
@@ -17,7 +17,8 @@ extern void switch_mm(struct mm_struct *prev, struct mm_struct *next,
  * registers like cr3 on the i386
  */
 
-extern volatile DEFINE_PER_CPU(pgd_t *,current_pgd); /* defined in arch/cris/mm/fault.c */
+/* defined in arch/cris/mm/fault.c */
+DECLARE_PER_CPU(pgd_t *, current_pgd);
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index f925115..4a7cdd9 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -29,7 +29,7 @@ extern void die_if_kernel(const char *, struct pt_regs *, long);
 
 /* current active page directory */
 
-volatile DEFINE_PER_CPU(pgd_t *,current_pgd);
+DEFINE_PER_CPU(pgd_t *, current_pgd);
 unsigned long cris_signal_return_page;
 
 /*
-- 
1.6.0.2

