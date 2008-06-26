Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYFZMkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYFZMkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYFZM3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:30 -0400
Received: from il.qumranet.com ([212.179.150.194]:32345 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYFZM2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 39/50] KVM: Do not calculate linear rip in emulation failure report
Date: Thu, 26 Jun 2008 15:28:21 +0300
Message-Id: <1214483312-9265-40-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

If we're not gonna do anything (case in which failure is already
reported), we do not need to even bother with calculating the linear rip.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d568792..82196c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2081,11 +2081,11 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 	unsigned long rip = vcpu->arch.rip;
 	unsigned long rip_linear;
 
-	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
-
 	if (reported)
 		return;
 
+	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
+
 	emulator_read_std(rip_linear, (void *)opcodes, 4, vcpu);
 
 	printk(KERN_ERR "emulation failed (%s) rip %lx %02x %02x %02x %02x\n",
-- 
1.5.6

