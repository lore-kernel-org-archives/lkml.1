Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYEOD7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYEOD7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYEOD7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:59:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYEOD7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:59:20 -0400
Message-Id: <20080515035918.745026737@goodmis.org>
References: <20080515034942.109223655@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 23:49:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       paulus@samba.org, benh@kernel.crashing.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace ppc: add irqs_disabled_flags to ppc
Content-Disposition: inline; filename=powerpc-irqs-disabled-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPC doesn't have the irqs_disabled_flags needed by ftrace.
This patch adds it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/asm-powerpc/hw_irq.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-sched-devel.git/include/asm-powerpc/hw_irq.h
===================================================================
--- linux-sched-devel.git.orig/include/asm-powerpc/hw_irq.h	2008-05-14 18:12:21.000000000 -0700
+++ linux-sched-devel.git/include/asm-powerpc/hw_irq.h	2008-05-14 19:24:59.000000000 -0700
@@ -59,6 +59,11 @@ extern void iseries_handle_interrupts(vo
 		get_paca()->hard_enabled = 0;	\
 	} while(0)
 
+static inline int irqs_disabled_flags(unsigned long flags)
+{
+	return flags == 0;
+}
+
 #else
 
 #if defined(CONFIG_BOOKE)
@@ -113,6 +118,11 @@ static inline void local_irq_save_ptr(un
 #define hard_irq_enable()	local_irq_enable()
 #define hard_irq_disable()	local_irq_disable()
 
+static inline int irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & MSR_EE) == 0;
+}
+
 #endif /* CONFIG_PPC64 */
 
 /*

-- 
