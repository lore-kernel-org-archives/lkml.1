Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXGPTZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXGPTZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXGPTZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:25:05 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34507 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXGPTZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:25:04 -0400
Date: Mon, 16 Jul 2007 15:24:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: [PATCH 2/3] KVM - Fix hypercall arguments
Message-ID: <20070716192447.GA16248@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like kvm_hypercall is trying to match the system call
convention and mixed up the call number and first argument in the
32-bit case.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 drivers/kvm/kvm_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: kvm/drivers/kvm/kvm_main.c
===================================================================
--- kvm.orig/drivers/kvm/kvm_main.c
+++ kvm/drivers/kvm/kvm_main.c
@@ -1351,8 +1351,8 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
 	} else
 #endif
 	{
-		nr = vcpu->regs[VCPU_REGS_RBX] & -1u;
-		a0 = vcpu->regs[VCPU_REGS_RAX] & -1u;
+		nr = vcpu->regs[VCPU_REGS_RAX] & -1u;
+		a0 = vcpu->regs[VCPU_REGS_RBX] & -1u;
 		a1 = vcpu->regs[VCPU_REGS_RCX] & -1u;
 		a2 = vcpu->regs[VCPU_REGS_RDX] & -1u;
 		a3 = vcpu->regs[VCPU_REGS_RSI] & -1u;
