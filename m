Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbXGHL5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbXGHL5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbXGHLzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:38400 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXGHLyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/20] KVM: VMX: Reinitialize the real-mode tss when entering real mode
Date: Sun,  8 Jul 2007 14:54:37 +0300
Message-Id: <1183895689989-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Protected mode code may have corrupted the real-mode tss, so re-initialize
it when switching to real mode.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b47ddcc..42a9163 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -31,6 +31,8 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static int init_rmode_tss(struct kvm *kvm);
+
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 
@@ -951,6 +953,8 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_DS, &vcpu->rmode.ds);
 	fix_rmode_seg(VCPU_SREG_GS, &vcpu->rmode.gs);
 	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
+
+	init_rmode_tss(vcpu->kvm);
 }
 
 #ifdef CONFIG_X86_64
-- 
1.5.2.2

