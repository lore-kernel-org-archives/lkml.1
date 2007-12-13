Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbXLMJK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbXLMJK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXLMJKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:10:11 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30951
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbXLMJKJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:10:09 -0500
Message-Id: <47610530.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:10:56 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This generally allows better code to be generated, since the zero-
extension during 32-bit operations comes for free (needed when the
result is used as array index or similar), whereas sign extension must
be done explicitly and frequently requires a one byte larger
instruction due to the necessary rex64 prefix.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 include/asm-x86/pda.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc5/include/asm-x86/pda.h	2007-12-12 16:48:43.000000000 +0100
+++ 2.6.24-rc5-x86_64-unsigned-cpu/include/asm-x86/pda.h	2007-12-07 15:32:15.000000000 +0100
@@ -15,14 +15,14 @@ struct x8664_pda {
 	unsigned long kernelstack;  /* 16 top of kernel stack for current */
 	unsigned long oldrsp; 	    /* 24 user rsp for system call */
         int irqcount;		    /* 32 Irq nesting counter. Starts with -1 */
-	int cpunumber;		    /* 36 Logical CPU number */
+	unsigned int cpunumber;	    /* 36 Logical CPU number */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 #endif
 	char *irqstackptr;
-	int nodenumber;		    /* number of current node */
+	unsigned int nodenumber;	/* number of current node */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;



