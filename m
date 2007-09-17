Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXIQItJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXIQItJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXIQIdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:45331 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 078/104] KVM: disable tpr/cr8 sync when in-kernel APIC is used
Date: Mon, 17 Sep 2007 10:32:00 +0200
Message-Id: <11900179492754-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f4cbd4f..a25dfc9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2005,7 +2005,8 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
 	/* re-sync apic's tpr */
-	set_cr8(vcpu, kvm_run->cr8);
+	if (!irqchip_in_kernel(vcpu->kvm))
+		set_cr8(vcpu, kvm_run->cr8);
 
 	if (vcpu->pio.cur_count) {
 		r = complete_pio(vcpu);
-- 
1.5.3

