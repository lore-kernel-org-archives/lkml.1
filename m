Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXDAOoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXDAOoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXDAOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:42:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:47540 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sergey Kiselev <sergey.kiselev@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 29/41] KVM: Handle writes to MCG_STATUS msr
Date: Sun,  1 Apr 2007 17:35:26 +0300
Message-Id: <11754381391119-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139877-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Kiselev <sergey.kiselev@intel.com>

Some older (~2.6.7) kernels write MCG_STATUS register during kernel
boot (mce_clear_all() function, called from mce_init()). It's not
currently handled by kvm and will cause it to inject a GPF.
Following patch adds a "nop" handler for this.

Signed-off-by: Sergey Kiselev <sergey.kiselev@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 12c3388..1ef5e9a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1467,6 +1467,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
 		       __FUNCTION__, data);
 		break;
+	case MSR_IA32_MCG_STATUS:
+		printk(KERN_WARNING "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
+			__FUNCTION__, data);
+		break;
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
 	case 0x200 ... 0x2ff: /* MTRRs */
-- 
1.5.0.5

