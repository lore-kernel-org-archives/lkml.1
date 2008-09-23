Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYIWNzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYIWNzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYIWNr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbYIWNrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: [PATCH 23/40] KVM: ppc: trace powerpc instruction emulation
Date: Tue, 23 Sep 2008 16:46:37 +0300
Message-Id: <1222177614-26669-24-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch adds a trace point for the instruction emulation on embedded powerpc
utilizing the KVM_TRACE interface.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kvm/emulate.c |    2 ++
 include/linux/kvm.h        |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 4a3e274..c3ed63b 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -769,6 +769,8 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		break;
 	}
 
+	KVMTRACE_3D(PPC_INSTR, vcpu, inst, vcpu->arch.pc, emulated, entryexit);
+
 	if (advance)
 		vcpu->arch.pc += 4; /* Advance past emulated instruction. */
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index e21a505..d29b648 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -474,5 +474,6 @@ struct kvm_trace_rec {
 #define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
 #define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
 #define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
+#define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
 
 #endif
-- 
1.6.0.1

