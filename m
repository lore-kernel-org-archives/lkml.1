Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbYGAWeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbYGAWeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYGAWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:34:12 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:15390 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbYGAWeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=H6JjTlbXghONGW1+l6AL4B0/VpZNjaBbjJJdbUrMbXmI2XGtowzv5a8HH97zA19K3y
         ooT7cc7yrqtAXg7N3+GETjehELTu8J7yCXTECauLEoSLvaETtpfB/zqACFRwaOpvp9lU
         hZkg9NhTg1C1bXIKfOq1fIIi1H5F1XS9DgT00=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 2/23] make section names compatible with -ffunction-sections -fdata-sections: alpha
Date: Wed, 2 Jul 2008 02:34:09 +0200
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
Message-Id: <200807020234.09577.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes alpha architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/alpha/kernel/head.S	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/alpha/kernel/head.S	Wed Jul  2 00:44:22 2008
@@ -10,7 +10,7 @@
 #include <asm/system.h>
 #include <asm/asm-offsets.h>
 
-.section .text.head, "ax"
+.section .head.text, "ax"
 .globl swapper_pg_dir
 .globl _stext
 swapper_pg_dir=SWAPPER_PGD
--- 0.org/arch/alpha/kernel/init_task.c	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/alpha/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -18,5 +18,5 @@
 EXPORT_SYMBOL(init_task);
 
 union thread_union init_thread_union
-	__attribute__((section(".data.init_thread")))
+	__attribute__((section(".init_thread.data")))
 	= { INIT_THREAD_INFO(init_task) };
--- 0.org/arch/alpha/kernel/vmlinux.lds.S	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/alpha/kernel/vmlinux.lds.S	Wed Jul  2 00:46:09 2008
@@ -16,7 +16,7 @@
 
 	_text = .;	/* Text and read-only data */
 	.text : {
-	*(.text.head)
+	*(.head.text)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -93,18 +93,18 @@
 	/* Freed after init ends here */
 
 	/* Note 2 page alignment above.  */
-	.data.init_thread : {
-		*(.data.init_thread)
+	.init_thread.data : {
+		*(.init_thread.data)
 	}
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.page_aligned)
+	.page_aligned.data : {
+		*(.page_aligned.data)
 	}
 
 	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	_data = .;
