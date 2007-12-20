Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXLTUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXLTUKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXLTUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:10:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbXLTUKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:10:31 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 08/15] add macro for privileged x86_64 operation
Date: Thu, 20 Dec 2007 18:04:03 -0200
Message-Id: <1198181309285-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981812771615-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 has a macro GET_CR0_INTO_EAX, used in early trap handling code.
x86_64 has similar needs, only it needs to put cr2 into rcx. We provide
a macro for such task, in the same way

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:28.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:29.000000000 -0800
@@ -1227,6 +1227,12 @@
 	push %ecx; push %edx;			\
 	call *pv_cpu_ops+PV_CPU_read_cr0;	\
 	pop %edx; pop %ecx
+#else
+#define GET_CR2_INTO_RCX			\
+	call *pv_mmu_ops+PV_MMU_read_cr2;	\
+	movq %rax, %rcx;			\
+	xorq %rax, %rax;
+
 #endif
 
 #endif /* __ASSEMBLY__ */
