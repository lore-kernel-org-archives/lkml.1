Return-Path: <linux-kernel-owner+w=401wt.eu-S1765729AbXHHHRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765729AbXHHHRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbXHHHIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760866AbXHHHIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:53 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 15/25] [PATCH] get rid of inline asm for load_cr3
Date: Wed,  8 Aug 2007 01:19:02 -0300
Message-Id: <11865468122642-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <118654680831-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Besides not elegant, it is now even forbidden, since it can
break paravirtualized guests. load_cr3 should call write_cr3()
instead.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/mmu_context.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86_64/mmu_context.h b/include/asm-x86_64/mmu_context.h
index c8cdc1e..9592698 100644
--- a/include/asm-x86_64/mmu_context.h
+++ b/include/asm-x86_64/mmu_context.h
@@ -25,7 +25,7 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 
 static inline void load_cr3(pgd_t *pgd)
 {
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
+	write_cr3(__pa(pgd));
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
-- 
1.4.4.2

