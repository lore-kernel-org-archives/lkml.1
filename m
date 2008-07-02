Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbYGAWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbYGAWm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbYGAWlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:41:52 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:24722 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763315AbYGAWlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=MqYQoEEOnxOgqVxjgB6Xa2qqOXh4KONNkeGw3sGk/6gzLjpiCfTGgV+tvGtgCmFoXr
         Ot7Nes6ZrTlYaa5oAvmSltqstsmtUIXMtGRs4TIejek86L0nkFc6ZgQ6IQhn2SA41FlU
         M1V4TsZbWZEiCuwnuEhEP3EhrI9+TAkvGOdoY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 20/23] make section names compatible with -ffunction-sections -fdata-sections: um
Date: Wed, 2 Jul 2008 02:41:58 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807020241.58201.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes User Mode Linux.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/um/kernel/dyn.lds.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/um/kernel/dyn.lds.S	Wed Jul  2 00:45:57 2008
@@ -97,9 +97,9 @@
   .fini_array     : { *(.fini_array) }
   .data           : {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    *(.init_task.data)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.init_irqstack.data)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
--- 0.org/arch/um/kernel/init_task.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/um/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -35,9 +35,9 @@
  */
 
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 union thread_union cpu0_irqstack
-	__attribute__((__section__(".data.init_irqstack"))) =
+	__attribute__((__section__(".init_irqstack.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
--- 0.org/arch/um/kernel/uml.lds.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/um/kernel/uml.lds.S	Wed Jul  2 00:45:57 2008
@@ -53,9 +53,9 @@
   .data    :
   {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    *(.init_task.data)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.init_irqstack.data)
     DATA_DATA
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
--- 0.org/include/asm-um/common.lds.S	Wed Jul  2 00:40:51 2008
+++ 1.fixname/include/asm-um/common.lds.S	Wed Jul  2 00:45:39 2008
@@ -49,9 +49,9 @@
   }
 
   . = ALIGN(32);
-  .data.percpu : {
+  .percpu.data : {
 	__per_cpu_start = . ;
-	*(.data.percpu)
+	*(.percpu.data)
 	__per_cpu_end = . ;
   }
 	
