Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbYFZMpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbYFZMpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYFZM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:32382 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYFZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/50] KVM: Remove unnecessary ->decache_regs() call
Date: Thu, 26 Jun 2008 15:27:59 +0300
Message-Id: <1214483312-9265-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we aren't modifying any register, there's no need to decache
the register state.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9156d63..28642c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2297,7 +2297,6 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	kvm_x86_ops->cache_regs(vcpu);
 	memcpy(vcpu->arch.pio_data, &vcpu->arch.regs[VCPU_REGS_RAX], 4);
-	kvm_x86_ops->decache_regs(vcpu);
 
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 
-- 
1.5.6

