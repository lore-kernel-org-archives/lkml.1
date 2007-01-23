Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXAWOcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXAWOcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933033AbXAWOcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:32:06 -0500
Received: from il.qumranet.com ([62.219.232.206]:59972 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007AbXAWOcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:32:06 -0500
Subject: [PATCH 1/5] KVM: SVM: Fix SVM idt confusion
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 23 Jan 2007 14:32:04 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45B61C09.5020501@qumranet.com>
In-Reply-To: <45B61C09.5020501@qumranet.com>
Message-Id: <20070123143204.3639F250136@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonard Norrgard <leonard.norrgard@refactor.fi>

There's an obvious typo in svm_{get,set}_idt, causing it to access the ldt
instead.

Because these functions are only called for save/load on AMD, the bug does not
impact normal operation.  With the fix, save/load works as expected on AMD
hosts.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -680,14 +680,14 @@ static void svm_get_cs_db_l_bits(struct 
 
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	dt->limit = vcpu->svm->vmcb->save.ldtr.limit;
-	dt->base = vcpu->svm->vmcb->save.ldtr.base;
+	dt->limit = vcpu->svm->vmcb->save.idtr.limit;
+	dt->base = vcpu->svm->vmcb->save.idtr.base;
 }
 
 static void svm_set_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	vcpu->svm->vmcb->save.ldtr.limit = dt->limit;
-	vcpu->svm->vmcb->save.ldtr.base = dt->base ;
+	vcpu->svm->vmcb->save.idtr.limit = dt->limit;
+	vcpu->svm->vmcb->save.idtr.base = dt->base ;
 }
 
 static void svm_get_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
