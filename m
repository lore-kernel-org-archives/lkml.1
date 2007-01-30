Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXA3OmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXA3OmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXA3OmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:42:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:53314 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524AbXA3OmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:42:01 -0500
Subject: [PATCH 6/11] KVM: Fix mmu going crazy of guest sets cr0.wp == 0
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:42:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144200.2955FA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm mmu relies on cr0.wp being set even if the guest does not set it.  The
vmx code correctly forces cr0.wp at all times, the svm code does not, so it
can't boot solaris without this patch.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -723,7 +723,7 @@ static void svm_set_cr0(struct kvm_vcpu 
 	}
 #endif
 	vcpu->svm->cr0 = cr0;
-	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK;
+	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK | CR0_WP_MASK;
 	vcpu->cr0 = cr0;
 }
 
