Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbYGAWiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbYGAWiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761883AbYGAWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:37:48 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:18145 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760936AbYGAWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=diU1D2tSgRBbfZwqYl3u9uDDDK31nmS52snTZpsOW1YlBhXDYhUU0F/VsNU0q6Zru3
         WwWA+0TmDR/en2WCI+ZMBoGokYLw+/Novt2HAW6EvOEMg8wZSSB5J83s8TgpXoVtAXwo
         /Zn6lCAt1WWzPtvLjwn/LG7QpeiJZTX+xvJRQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 11/23] make section names compatible with -ffunction-sections -fdata-sections: mips
Date: Wed, 2 Jul 2008 02:37:36 +0200
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
Message-Id: <200807020237.36623.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes mips architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/mips/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/mips/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -27,7 +27,7 @@
  * The things we do for performance..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"),
+	__attribute__((__section__(".init_task.data"),
 	               __aligned__(THREAD_SIZE))) =
 		{ INIT_THREAD_INFO(init_task) };
 
--- 0.org/arch/mips/kernel/vmlinux.lds.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/mips/kernel/vmlinux.lds.S	Wed Jul  2 00:46:03 2008
@@ -76,7 +76,7 @@
 		 * object file alignment.  Using 32768
 		 */
 		. = ALIGN(_PAGE_SIZE);
-		*(.data.init_task)
+		*(.init_task.data)
 
 		DATA_DATA
 		CONSTRUCTORS
@@ -98,14 +98,14 @@
 	. = ALIGN(_PAGE_SIZE);
 	.data_nosave : {
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 	}
 	. = ALIGN(_PAGE_SIZE);
 	__nosave_end = .;
 
 	. = ALIGN(32);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 	_edata =  .;			/* End of data section */
 
--- 0.org/arch/mips/lasat/image/head.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/mips/lasat/image/head.S	Wed Jul  2 00:44:34 2008
@@ -1,7 +1,7 @@
 #include <asm/lasat/head.h>
 
 	.text
-	.section .text.start, "ax"
+	.section .start.text, "ax"
 	.set noreorder
 	.set mips3
 
--- 0.org/arch/mips/lasat/image/romscript.normal	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/mips/lasat/image/romscript.normal	Wed Jul  2 00:44:34 2008
@@ -4,7 +4,7 @@
 {
   .text :
   {
-    *(.text.start)
+    *(.start.text)
   }
 
   /* Data in ROM */
