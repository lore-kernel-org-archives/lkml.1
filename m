Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbYBBIXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbYBBIXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbYBBIX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:23:27 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:55015 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbYBBIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:23:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Wq0XXVUcvILSYfqVlvnMdYm/zAh97NzuuZkbcNePWnCJKSMarw4cd4IAhf67Jrv7zT2mUajH180Q4v6xcb1bR1jSPeiYWBYKA/k5CULB3PkIGTGgtzWrZtWokjjivyBY5oDoBeTSVBT72YO7mitHNBTnn1nx/ilzRhGprqXfxK0=
Subject: [PATCH] x86: remove final FASTCALL() uses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 00:23:28 -0800
Message-Id: <1201940608.1844.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few snuck back in to x86.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/highmem.h   |    4 ++--
 include/asm-x86/hw_irq_32.h |    2 +-
 include/asm-x86/system.h    |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index 13cdcd6..c25cfca 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -63,8 +63,8 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void * FASTCALL(kmap_high(struct page *page));
-extern void FASTCALL(kunmap_high(struct page *page));
+extern void *kmap_high(struct page *page);
+extern void kunmap_high(struct page *page);
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index 6d65fbb..ea88054 100644
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
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 3fcc40b..09b1434 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -20,8 +20,8 @@
 #ifdef CONFIG_X86_32
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
-extern struct task_struct *FASTCALL(__switch_to(struct task_struct *prev,
-						struct task_struct *next));
+struct task_struct *__switch_to(struct task_struct *prev,
+				struct task_struct *next);
 
 /*
  * Saving eflags is important. It switches not only IOPL between tasks,
-- 
1.5.4.rc4.1142.gf5a97



