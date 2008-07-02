Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbYGAWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbYGAWe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYGAWer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:34:47 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:16604 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbYGAWeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=mBmfopeGNvdJa0Z2pq32Jr0D96Em0PBVtE9qWPugP2D9VajSIzkmD2ywjY7ny7oDe8
         ywwy239NbI9068z5O6dO/DqPjfI/a2TfyLUsPa24vpCWWIOnzCSBsz+qwSRMSu3mPbEq
         EGEglgROShQm2fnTRjaiIbQnuq7nNdmgCetHY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 4/23] make section names compatible with -ffunction-sections -fdata-sections: avr
Date: Wed, 2 Jul 2008 02:34:38 +0200
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
Message-Id: <200807020234.38078.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes avr architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/avr32/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/avr32/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -24,7 +24,7 @@
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- 0.org/arch/avr32/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/avr32/kernel/vmlinux.lds.S	Wed Jul  2 00:45:57 2008
@@ -105,11 +105,11 @@
 		/*
 		 * First, the init task union, aligned to an 8K boundary.
 		 */
-		*(.data.init_task)
+		*(.init_task.data)
 
 		/* Then, the cacheline aligned data */
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 		/* And the rest... */
 		*(.data.rel*)
