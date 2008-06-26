Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbYFZMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbYFZMmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYFZM3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:41 -0400
Received: from il.qumranet.com ([212.179.150.194]:32384 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYFZM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 22/50] KVM: Prefixes segment functions that will be exported with "kvm_"
Date: Thu, 26 Jun 2008 15:28:04 +0300
Message-Id: <1214483312-9265-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Prefixes functions that will be exported with kvm_.
We also prefixed set_segment() even if it still static
to be coherent.

signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |   78 ++++++++++++++++++++++----------------------
 include/asm-x86/kvm_host.h |    4 ++
 2 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2095e79..51810d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3100,8 +3100,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
-static void get_segment(struct kvm_vcpu *vcpu,
-			struct kvm_segment *var, int seg)
+void kvm_get_segment(struct kvm_vcpu *vcpu,
+		     struct kvm_segment *var, int seg)
 {
 	kvm_x86_ops->get_segment(vcpu, var, seg);
 }
@@ -3110,7 +3110,7 @@ void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 {
 	struct kvm_segment cs;
 
-	get_segment(vcpu, &cs, VCPU_SREG_CS);
+	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
 	*db = cs.db;
 	*l = cs.l;
 }
@@ -3124,15 +3124,15 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 
 	vcpu_load(vcpu);
 
-	get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	get_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	get_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	get_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
+	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
+	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
+	kvm_get_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
+	kvm_get_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
+	kvm_get_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
 
-	get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+	kvm_get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
+	kvm_get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
 	kvm_x86_ops->get_idt(vcpu, &dt);
 	sregs->idt.limit = dt.limit;
@@ -3184,7 +3184,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void set_segment(struct kvm_vcpu *vcpu,
+static void kvm_set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
 	kvm_x86_ops->set_segment(vcpu, var, seg);
@@ -3221,7 +3221,7 @@ static void get_segment_descritptor_dtable(struct kvm_vcpu *vcpu,
 	if (selector & 1 << 2) {
 		struct kvm_segment kvm_seg;
 
-		get_segment(vcpu, &kvm_seg, VCPU_SREG_LDTR);
+		kvm_get_segment(vcpu, &kvm_seg, VCPU_SREG_LDTR);
 
 		if (kvm_seg.unusable)
 			dtable->limit = 0;
@@ -3327,7 +3327,7 @@ static u16 get_segment_selector(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_segment kvm_seg;
 
-	get_segment(vcpu, &kvm_seg, seg);
+	kvm_get_segment(vcpu, &kvm_seg, seg);
 	return kvm_seg.selector;
 }
 
@@ -3343,8 +3343,8 @@ static int load_segment_descriptor_to_kvm_desct(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
-				   int type_bits, int seg)
+int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
+				int type_bits, int seg)
 {
 	struct kvm_segment kvm_seg;
 
@@ -3357,7 +3357,7 @@ static int load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 		if (!kvm_seg.s)
 			kvm_seg.unusable = 1;
 
-	set_segment(vcpu, &kvm_seg, seg);
+	kvm_set_segment(vcpu, &kvm_seg, seg);
 	return 0;
 }
 
@@ -3403,25 +3403,25 @@ static int load_state_from_tss32(struct kvm_vcpu *vcpu,
 	vcpu->arch.regs[VCPU_REGS_RSI] = tss->esi;
 	vcpu->arch.regs[VCPU_REGS_RDI] = tss->edi;
 
-	if (load_segment_descriptor(vcpu, tss->ldt_selector, 0, VCPU_SREG_LDTR))
+	if (kvm_load_segment_descriptor(vcpu, tss->ldt_selector, 0, VCPU_SREG_LDTR))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->es, 1, VCPU_SREG_ES))
+	if (kvm_load_segment_descriptor(vcpu, tss->es, 1, VCPU_SREG_ES))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->cs, 9, VCPU_SREG_CS))
+	if (kvm_load_segment_descriptor(vcpu, tss->cs, 9, VCPU_SREG_CS))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->ss, 1, VCPU_SREG_SS))
+	if (kvm_load_segment_descriptor(vcpu, tss->ss, 1, VCPU_SREG_SS))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->ds, 1, VCPU_SREG_DS))
+	if (kvm_load_segment_descriptor(vcpu, tss->ds, 1, VCPU_SREG_DS))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->fs, 1, VCPU_SREG_FS))
+	if (kvm_load_segment_descriptor(vcpu, tss->fs, 1, VCPU_SREG_FS))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->gs, 1, VCPU_SREG_GS))
+	if (kvm_load_segment_descriptor(vcpu, tss->gs, 1, VCPU_SREG_GS))
 		return 1;
 	return 0;
 }
@@ -3462,19 +3462,19 @@ static int load_state_from_tss16(struct kvm_vcpu *vcpu,
 	vcpu->arch.regs[VCPU_REGS_RSI] = tss->si;
 	vcpu->arch.regs[VCPU_REGS_RDI] = tss->di;
 
-	if (load_segment_descriptor(vcpu, tss->ldt, 0, VCPU_SREG_LDTR))
+	if (kvm_load_segment_descriptor(vcpu, tss->ldt, 0, VCPU_SREG_LDTR))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->es, 1, VCPU_SREG_ES))
+	if (kvm_load_segment_descriptor(vcpu, tss->es, 1, VCPU_SREG_ES))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->cs, 9, VCPU_SREG_CS))
+	if (kvm_load_segment_descriptor(vcpu, tss->cs, 9, VCPU_SREG_CS))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->ss, 1, VCPU_SREG_SS))
+	if (kvm_load_segment_descriptor(vcpu, tss->ss, 1, VCPU_SREG_SS))
 		return 1;
 
-	if (load_segment_descriptor(vcpu, tss->ds, 1, VCPU_SREG_DS))
+	if (kvm_load_segment_descriptor(vcpu, tss->ds, 1, VCPU_SREG_DS))
 		return 1;
 	return 0;
 }
@@ -3532,7 +3532,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 	struct desc_struct nseg_desc;
 	int ret = 0;
 
-	get_segment(vcpu, &tr_seg, VCPU_SREG_TR);
+	kvm_get_segment(vcpu, &tr_seg, VCPU_SREG_TR);
 
 	if (load_guest_segment_descriptor(vcpu, tss_selector, &nseg_desc))
 		goto out;
@@ -3591,7 +3591,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 | X86_CR0_TS);
 	seg_desct_to_kvm_desct(&nseg_desc, tss_selector, &tr_seg);
 	tr_seg.type = 11;
-	set_segment(vcpu, &tr_seg, VCPU_SREG_TR);
+	kvm_set_segment(vcpu, &tr_seg, VCPU_SREG_TR);
 out:
 	kvm_x86_ops->decache_regs(vcpu);
 	return ret;
@@ -3658,15 +3658,15 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
+	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
+	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
+	kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
+	kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
+	kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
 
-	set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
+	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
 	vcpu_put(vcpu);
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index fc72bad..cd6a4bb 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -503,6 +503,10 @@ int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
 int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 		    unsigned long value);
 
+void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
+				int type_bits, int seg);
+
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason);
 
 void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-- 
1.5.6

