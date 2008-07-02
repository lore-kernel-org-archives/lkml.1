Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbYGAWft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbYGAWft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbYGAWfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:35:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:17123 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762000AbYGAWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=pxcSXWvsV9aa2kCxzh2p+0mIRkCAeI22NXZkaxaRS4p8dorfLB57dk7ff1BXgTaWDX
         Ecg/fmRW3tvT/HwbRxSIe3324ZXAI5g8/+YbHBqvVDwuyyp0RD3gT3ijCpeAzRCBvjhB
         UZCFLajlFZRAgycxoglG+V5LaWzThBx7sSFbw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 6/23] make section names compatible with -ffunction-sections -fdata-sections: cris
Date: Wed, 2 Jul 2008 02:35:33 +0200
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
Message-Id: <200807020235.33533.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes cris architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/cris/arch-v10/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/cris/arch-v10/vmlinux.lds.S	Wed Jul  2 00:45:57 2008
@@ -51,7 +51,7 @@
 	_edata = . ;
 
 	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned */
-  	.data.init_task : { *(.data.init_task) }
+  	.init_task.data : { *(.init_task.data) }
 
 	. = ALIGN(PAGE_SIZE);	/* Init code and data */
   	__init_begin = .;
--- 0.org/arch/cris/arch-v32/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/cris/arch-v32/vmlinux.lds.S	Wed Jul  2 00:45:57 2008
@@ -63,7 +63,7 @@
 	_edata = . ;
 
 	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
-	.data.init_task : { *(.data.init_task) }
+	.init_task.data : { *(.init_task.data) }
 
 	. = ALIGN(PAGE_SIZE);	/* Init code and data. */
 	__init_begin = .;
--- 0.org/arch/cris/kernel/process.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/cris/kernel/process.c	Wed Jul  2 00:45:57 2008
@@ -52,7 +52,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
