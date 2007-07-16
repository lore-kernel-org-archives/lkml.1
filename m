Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbXGPT0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbXGPT0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761325AbXGPTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:25:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34509 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbXGPTZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:25:09 -0400
Date: Mon, 16 Jul 2007 15:24:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: [PATCH 3/3] KVM - add hypercall nr to kvm_run
Message-ID: <20070716192447.GA16253@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hypercall number to kvm_run and initialize it.  This might be
considered API-changing, so I kept it separate.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 drivers/kvm/kvm_main.c |    1 +
 include/linux/kvm.h    |    1 +
 2 files changed, 2 insertions(+)

Index: kvm/drivers/kvm/kvm_main.c
===================================================================
--- kvm.orig/drivers/kvm/kvm_main.c
+++ kvm/drivers/kvm/kvm_main.c
@@ -1361,6 +1361,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
 	}
 	switch (nr) {
 	default:
+		run->hypercall.nr = nr;
 		run->hypercall.args[0] = a0;
 		run->hypercall.args[1] = a1;
 		run->hypercall.args[2] = a2;
Index: kvm/include/linux/kvm.h
===================================================================
--- kvm.orig/include/linux/kvm.h
+++ kvm/include/linux/kvm.h
@@ -106,6 +106,7 @@ struct kvm_run {
 		} mmio;
 		/* KVM_EXIT_HYPERCALL */
 		struct {
+			__u64 nr;
 			__u64 args[6];
 			__u64 ret;
 			__u32 longmode;
