Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbZFRH0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbZFRH0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbZFRH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:26:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbZFRH0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:26:15 -0400
Message-ID: <4A39EC49.6060709@kernel.org>
Date: Thu, 18 Jun 2009 16:27:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com
Subject: [UPDATED PATCH 3/9] CRIS: Change DEFINE_PER_CPU of current_pgd to
 be non volatile.
References: <1245210060-24344-1-git-send-email-tj@kernel.org> <1245210060-24344-4-git-send-email-tj@kernel.org>
In-Reply-To: <1245210060-24344-4-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 07:25:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: CRIS: Change DEFINE_PER_CPU of current_pgd to be non volatile.

The DEFINE_PER_CPU of current_pgd was on CRIS defined using volatile,
which is not needed. Remove volatile.

Tested on an ARTPEC-3 (CRISv32) board.

tj: extern DEFINE_PER_CPU() replaced with DECLARE_PER_CPU()

[ Impact: code cleanup ]

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Updated such that extern DEFINE -> DECLARE change is done here not
later in the series as suggested by Christoph Lameter.

 arch/cris/include/asm/mmu_context.h |    3 ++-
 arch/cris/mm/fault.c                |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: work/arch/cris/include/asm/mmu_context.h
===================================================================
--- work.orig/arch/cris/include/asm/mmu_context.h
+++ work/arch/cris/include/asm/mmu_context.h
@@ -17,7 +17,8 @@ extern void switch_mm(struct mm_struct *
  * registers like cr3 on the i386
  */
 
-extern volatile DEFINE_PER_CPU(pgd_t *,current_pgd); /* defined in arch/cris/mm/fault.c */
+/* defined in arch/cris/mm/fault.c */
+DECLARE_PER_CPU(pgd_t *, current_pgd);
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: work/arch/cris/mm/fault.c
===================================================================
--- work.orig/arch/cris/mm/fault.c
+++ work/arch/cris/mm/fault.c
@@ -29,7 +29,7 @@ extern void die_if_kernel(const char *,
 
 /* current active page directory */
 
-volatile DEFINE_PER_CPU(pgd_t *,current_pgd);
+DEFINE_PER_CPU(pgd_t *, current_pgd);
 unsigned long cris_signal_return_page;
 
 /*
