Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbXIQJAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbXIQJAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXIQIdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:45292 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbXIQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: [PATCH 055/104] KVM: Communicate cr8 changes to userspace
Date: Mon, 17 Sep 2007 10:31:37 +0200
Message-Id: <11900179482472-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang, Sheng <sheng.yang@intel.com>

This allows running 64-bit Windows.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c   |    3 ++-
 include/linux/kvm.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index a9b4cb5..cd999c0 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1831,7 +1831,8 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			vcpu_load_rsp_rip(vcpu);
 			set_cr8(vcpu, vcpu->regs[reg]);
 			skip_emulated_instruction(vcpu);
-			return 1;
+			kvm_run->exit_reason = KVM_EXIT_SET_TPR;
+			return 0;
 		};
 		break;
 	case 2: /* clts */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 91a446f..1d5a49c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -46,6 +46,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_SHUTDOWN         = 8,
 	KVM_EXIT_FAIL_ENTRY       = 9,
 	KVM_EXIT_INTR             = 10,
+	KVM_EXIT_SET_TPR          = 11
 };
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
-- 
1.5.3

