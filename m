Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbZBFPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbZBFPr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZBFPrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:47:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56632 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbZBFPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:47:07 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       akataria@vmware.com
Subject: [PATCH 1/2] tell cpuinfo if we're running on top of KVM
Date: Fri,  6 Feb 2009 10:46:56 -0500
Message-Id: <1233935217-24090-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1233935217-24090-1-git-send-email-glommer@redhat.com>
References: <1233935217-24090-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM has a specific cpuid signature, for a long time now. It's currently
used in the kernel to advertise the possible availability of paravirt
functions, but it's safe to assume that any reasonably recent kvm
hypervisor will sign cpuid this way, regardless of any pv capability.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 091cd88..919c08d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -126,6 +126,7 @@ struct cpuinfo_x86 {
 
 #define X86_HYPER_VENDOR_NONE  0
 #define X86_HYPER_VENDOR_VMWARE 1
+#define X86_HYPER_VENDOR_KVM	2
 
 /*
  * capabilities of CPUs
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index fb5b86a..ee1b228 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -23,6 +23,7 @@
 
 #include <asm/processor.h>
 #include <asm/vmware.h>
+#include <asm/kvm_para.h>
 #include <asm/hypervisor.h>
 
 static inline void __cpuinit
@@ -30,6 +31,8 @@ detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 {
 	if (vmware_platform()) {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+	} else if (kvm_para_available()) {
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_KVM;
 	} else {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 	}
-- 
1.5.6.5

