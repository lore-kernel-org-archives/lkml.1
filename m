Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbXEVP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbXEVP0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934818AbXEVPTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:36 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4977
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965743AbXEVPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:15 -0400
Message-Id: <20070522141251.075067202@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:44 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 03/33] xen: paravirt: increase IRQ limit
Content-Disposition: inline; filename=paravirt-increase-irq-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When running with CONFIG_PARAVIRT, we may want lots of IRQs even if
there's no IO APIC.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com> 
---
 include/asm-i386/mach-default/irq_vectors_limits.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/include/asm-i386/mach-default/irq_vectors_limits.h
+++ b/include/asm-i386/mach-default/irq_vectors_limits.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_IRQ_VECTORS_LIMITS_H
 #define _ASM_IRQ_VECTORS_LIMITS_H
 
-#ifdef CONFIG_X86_IO_APIC
+#if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT)
 #define NR_IRQS 224
 # if (224 >= 32 * NR_CPUS)
 # define NR_IRQ_VECTORS NR_IRQS

-- 

