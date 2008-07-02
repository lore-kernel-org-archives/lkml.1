Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbYGAWgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbYGAWgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbYGAWgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:36:24 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:3790 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762178AbYGAWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=WpaQmIUQGG2KNp+gl8I6txNkScXelHan/DNnMrhhaC5mBnIOhuKMGrd35GfhLynxbT
         eWKwXJzn3wcTEkHfr/h6pwLKl4lDnA8Vs9Y8z7Y5+8IbayUXlW0mAXeZK5IQTdr9uPSu
         UzokkpaDSQ6+LmdBccY7o/b3Pq9BZ814Vtmtw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 8/23] make section names compatible with -ffunction-sections -fdata-sections: h8300
Date: Wed, 2 Jul 2008 02:36:22 +0200
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
Message-Id: <200807020236.22585.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes h8300 architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/h8300/boot/compressed/head.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/h8300/boot/compressed/head.S	Wed Jul  2 00:44:34 2008
@@ -9,7 +9,7 @@
 
 #define SRAM_START 0xff4000
 
-	.section	.text.startup
+	.section	.startup.text
 	.global	startup
 startup:
 	mov.l	#SRAM_START+0x8000, sp
--- 0.org/arch/h8300/boot/compressed/vmlinux.lds	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/h8300/boot/compressed/vmlinux.lds	Wed Jul  2 00:44:34 2008
@@ -4,7 +4,7 @@
         {
         __stext = . ;
 	__text = .;
-	       *(.text.startup)
+	       *(.startup.text)
 	       *(.text)
         __etext = . ;
         }
--- 0.org/arch/h8300/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/h8300/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -37,6 +37,6 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
--- 0.org/arch/h8300/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/h8300/kernel/vmlinux.lds.S	Wed Jul  2 00:45:57 2008
@@ -101,7 +101,7 @@
 	___data_start = . ;
 
 	. = ALIGN(0x2000) ;
-		*(.data.init_task)
+		*(.init_task.data)
 	. = ALIGN(0x4) ;
 		DATA_DATA
 	. = ALIGN(0x4) ;
