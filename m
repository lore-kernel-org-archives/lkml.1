Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbYGAWhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbYGAWhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762131AbYGAWhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:37:09 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:5514 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761915AbYGAWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=OofEM1saBBVrSRJXHTWH6TD1XZoLD0Gi8J6/qmwtEg1t6mj1rt6JIMQAOMKMUFVGDi
         yMbCSu4gXrJCRVOHdTVTrtSM7hOt6JcBL6ZUgm7AVfQeCs0uW599/VnmDxIJ+uK1KDn0
         k6lZsHXUE0uoR7FdPgFOtR7ftdOOAN/ukLmXw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 10/23] make section names compatible with -ffunction-sections -fdata-sections: m32r
Date: Wed, 2 Jul 2008 02:37:14 +0200
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
Message-Id: <200807020237.14092.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes m32r architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/m32r/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m32r/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -26,7 +26,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- 0.org/arch/m32r/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m32r/kernel/vmlinux.lds.S	Wed Jul  2 00:46:03 2008
@@ -56,17 +56,17 @@
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
+  .data_nosave : { *(.nosave.data) }
   . = ALIGN(4096);
   __nosave_end = .;
 
   . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) }
 
   _edata = .;			/* End of data section */
 
   . = ALIGN(8192);		/* init_task */
-  .data.init_task : { *(.data.init_task) }
+  .init_task.data : { *(.init_task.data) }
 
   /* will be freed after init */
   . = ALIGN(4096);		/* Init code and data */
