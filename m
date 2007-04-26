Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbXDZJWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbXDZJWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbXDZJW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:52999 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775AbXDZJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/18] KVM: Initialize cr0 to indicate an fpu is present
Date: Thu, 26 Apr 2007 12:22:03 +0300
Message-Id: <11775793381888-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Solaris panics if it sees a cpu with no fpu, and it seems to rely on this
bit.  Closes sourceforge bug 1698920.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b065c49..0b30631 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2332,6 +2332,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
 					   FX_IMAGE_ALIGN);
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
+	vcpu->cr0 = 0x10;
 
 	r = kvm_arch_ops->vcpu_create(vcpu);
 	if (r < 0)
-- 
1.5.0.6

