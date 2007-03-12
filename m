Return-Path: <linux-kernel-owner+w=401wt.eu-S965187AbXCLGrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187AbXCLGrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 02:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965202AbXCLGrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 02:47:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:55151 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965193AbXCLGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 02:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i7IsMW1KgvQMD+NTrlTZpuVcHVcKRaRG3nS9MkBV0L45yqtuvHcxytu+CGUJQN5xjSkoJlv2TABPFT4FcOGUZU0GENAjQcxKiEtEcEpMZUH2lvVdLyGGlLQOpQdZbK5wcXlCLVSJkg2D+Kjbzen5s8O4Z1tQ3tbjvoSo7DQ+3pc=
Message-ID: <2375c9f90703112347r755bb59ehb17843c87f8e7353@mail.gmail.com>
Date: Mon, 12 Mar 2007 14:47:43 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org, avi@qumranet.com
Subject: [PATCH]Replace 0 with NULL when returning a pointer
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use NULL to indicate we are returning a pointer rather than an integer
and to eliminate some sparse warnings.

Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>

---
--- drivers/kvm/kvm_main.c.orig	2007-03-11 21:41:23.000000000 +0800
+++ drivers/kvm/kvm_main.c	2007-03-12 14:26:17.000000000 +0800
@@ -205,7 +205,7 @@ static struct kvm_vcpu *vcpu_load(struct
 	mutex_lock(&vcpu->mutex);
 	if (unlikely(!vcpu->vmcs)) {
 		mutex_unlock(&vcpu->mutex);
-		return 0;
+		return NULL;
 	}
 	return kvm_arch_ops->vcpu_load(vcpu);
 }
@@ -799,7 +799,7 @@ struct kvm_memory_slot *gfn_to_memslot(s
 		    && gfn < memslot->base_gfn + memslot->npages)
 			return memslot;
 	}
-	return 0;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(gfn_to_memslot);
