Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYIYL7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYIYL7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYIYLzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48541 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbYIYLzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:37 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 10/39] KVM: VMX: Add module parameter and emulation flag.
Date: Thu, 25 Sep 2008 14:54:42 +0300
Message-Id: <1222343711-12508-11-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

The patch adds the module parameter required to enable emulating invalid
guest state, as well as the emulation_required flag used to drive
emulation whenever needed.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e889b76..7c5f611 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -49,6 +49,9 @@ module_param(flexpriority_enabled, bool, 0);
 static int enable_ept = 1;
 module_param(enable_ept, bool, 0);
 
+static int emulate_invalid_guest_state = 0;
+module_param(emulate_invalid_guest_state, bool, 0);
+
 struct vmcs {
 	u32 revision_id;
 	u32 abort;
@@ -86,6 +89,7 @@ struct vcpu_vmx {
 		} irq;
 	} rmode;
 	int vpid;
+	bool emulation_required;
 };
 
 static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
-- 
1.6.0.1

