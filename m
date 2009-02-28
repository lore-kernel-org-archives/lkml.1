Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbZB1Br7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbZB1Br7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbZB1Bmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/30] KVM: ia64: Fix the build errors due to lack of macros related to MSI.
Date: Sat, 28 Feb 2009 03:41:45 +0200
Message-Id: <1235785309-12835-27-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Include the newly introduced msidef.h to solve the build issues.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/irq.h |    2 ++
 virt/kvm/irq_comm.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/irq.h b/arch/ia64/kvm/irq.h
index c6786e8..c0785a7 100644
--- a/arch/ia64/kvm/irq.h
+++ b/arch/ia64/kvm/irq.h
@@ -23,6 +23,8 @@
 #ifndef __IRQ_H
 #define __IRQ_H
 
+#include "lapic.h"
+
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
 	return 1;
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index c516d61..a70d805 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -21,9 +21,7 @@
 
 #include <linux/kvm_host.h>
 
-#ifdef CONFIG_X86
 #include <asm/msidef.h>
-#endif
 
 #include "irq.h"
 
-- 
1.6.0.6

