Return-Path: <linux-kernel-owner+w=401wt.eu-S965525AbXA3OnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525AbXA3OnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965530AbXA3OnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:43:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:53348 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965525AbXA3OnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:43:01 -0500
Subject: [PATCH 7/11] KVM: SVM: Hack initial cpu csbase to be consistent with
	intel
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:43:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144300.31B99A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to run the mmu testsuite on amd.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -528,7 +528,13 @@ static void init_vmcb(struct vmcb *vmcb)
 	save->cs.attrib = SVM_SELECTOR_READ_MASK | SVM_SELECTOR_P_MASK |
 		SVM_SELECTOR_S_MASK | SVM_SELECTOR_CODE_MASK;
 	save->cs.limit = 0xffff;
-	save->cs.base = 0xffff0000;
+	/*
+	 * cs.base should really be 0xffff0000, but vmx can't handle that, so
+	 * be consistent with it.
+	 *
+	 * Replace when we have real mode working for vmx.
+	 */
+	save->cs.base = 0xf0000;
 
 	save->gdtr.limit = 0xffff;
 	save->idtr.limit = 0xffff;
