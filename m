Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYDCTds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYDCTds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbYDCTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:57 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53005
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbYDCTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 02/35] KVM: Add stat counter for hypercalls
Date: Thu,  3 Apr 2008 22:32:17 +0300
Message-Id: <1207251170-5013-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |    2 ++
 include/asm-x86/kvm_host.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a063f44..15bba5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -72,6 +72,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "irq_window", VCPU_STAT(irq_window_exits) },
 	{ "halt_exits", VCPU_STAT(halt_exits) },
 	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
+	{ "hypercalls", VCPU_STAT(hypercalls) },
 	{ "request_irq", VCPU_STAT(request_irq_exits) },
 	{ "irq_exits", VCPU_STAT(irq_exits) },
 	{ "host_state_reload", VCPU_STAT(host_state_reload) },
@@ -2405,6 +2406,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	}
 	vcpu->arch.regs[VCPU_REGS_RAX] = ret;
 	kvm_x86_ops->decache_regs(vcpu);
+	++vcpu->stat.hypercalls;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 0c429c8..4f5a71a 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -327,6 +327,7 @@ struct kvm_vcpu_stat {
 	u32 fpu_reload;
 	u32 insn_emulation;
 	u32 insn_emulation_fail;
+	u32 hypercalls;
 };
 
 struct descriptor_table {
-- 
1.5.4.5

