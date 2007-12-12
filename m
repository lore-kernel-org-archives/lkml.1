Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbXLLGvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbXLLGvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 01:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXLLGuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 01:50:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:3034 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXLLGux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 01:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DEQfuJbDR+q9iJtAh7poIZqWTn5GdqwSKDFJOcOjSJM9ThO5RmojEC2yrJJ1E7IyggvF6wUEz2x7A+37Gymxbn1Ld15j1Oyboi/F+mzRNLlfP3zhdIwqBpq8t/wQoCzW24PM8+ITT/dM5xmIBcmHqzcHaz3UVxxx91bQHnxGXyY=
Subject: [PATCH] x86: Remove FASTCALL macro from asm-x86/*.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 22:50:43 -0800
Message-Id: <1197442243.5745.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that X86_32 uses regparm(3) by default, FASTCALL() is no
longer required.  Remove it from all headers in include/asm-x86

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/highmem.h   |    4 ++--
 include/asm-x86/hw_irq_32.h |    2 +-
 include/asm-x86/rwsem.h     |    8 ++++----
 include/asm-x86/system.h    |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index 13cdcd6..66d2c6f 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -63,8 +63,8 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void * FASTCALL(kmap_high(struct page *page));
-extern void FASTCALL(kunmap_high(struct page *page));
+extern void * kmap_high(struct page *page);
+extern void kunmap_high(struct page *page);
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index 0bedbdf..ca6e9fa 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -47,7 +47,7 @@ void enable_8259A_irq(unsigned int irq);
 int i8259A_irq_pending(unsigned int irq);
 void make_8259A_irq(unsigned int irq);
 void init_8259A(int aeoi);
-void FASTCALL(send_IPI_self(int vector));
+void send_IPI_self(int vector);
 void init_VISWS_APIC_irqs(void);
 void setup_IO_APIC(void);
 void disable_IO_APIC(void);
diff --git a/include/asm-x86/rwsem.h b/include/asm-x86/rwsem.h
index a7e7e14..eac6b1d 100644
--- a/include/asm-x86/rwsem.h
+++ b/include/asm-x86/rwsem.h
@@ -44,10 +44,10 @@
 
 struct rwsem_waiter;
 
-extern struct rw_semaphore *FASTCALL(rwsem_down_read_failed(struct rw_semaphore *sem));
-extern struct rw_semaphore *FASTCALL(rwsem_down_write_failed(struct rw_semaphore *sem));
-extern struct rw_semaphore *FASTCALL(rwsem_wake(struct rw_semaphore *));
-extern struct rw_semaphore *FASTCALL(rwsem_downgrade_wake(struct rw_semaphore *sem));
+extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
+extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
 /*
  * the semaphore definition
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 6e39d31..a8ea6e8 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -13,8 +13,8 @@
 #define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
-extern struct task_struct *FASTCALL(__switch_to(struct task_struct *prev,
-						struct task_struct *next));
+extern struct task_struct *__switch_to(struct task_struct *prev,
+						struct task_struct *next);
 
 /*
  * Saving eflags is important. It switches not only IOPL between tasks,
-- 
1.5.3.7.2212.gd092



