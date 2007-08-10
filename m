Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbXHJWHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbXHJWHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbXHJWBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979AbXHJWBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:11 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 14/25 -v2] get rid of inline asm for load_cr3
Date: Fri, 10 Aug 2007 16:12:26 -0300
Message-Id: <11867732273108-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732221652-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com>
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

