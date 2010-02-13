Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0BMIGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:06:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/39] KVM: Set cr0.et when the guest writes cr0
Date: Sat, 13 Feb 2010 10:01:42 +0200
Message-Id: <1266048119-14325-23-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the hardware.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1de2ad7..1ad34d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -428,6 +428,8 @@ out:
 
 void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
+	cr0 |= X86_CR0_ET;
+
 	if (cr0 & CR0_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
 		       cr0, kvm_read_cr0(vcpu));
-- 
1.6.5.3

