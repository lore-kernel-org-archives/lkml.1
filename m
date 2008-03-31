Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbYCaOjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbYCaOjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYCaOhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:35 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51311
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYCaOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/40] KVM: Only x86 has pio
Date: Mon, 31 Mar 2008 17:36:53 +0300
Message-Id: <1206974244-9716-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 04595fe..121e65c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -678,8 +678,10 @@ static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	if (vmf->pgoff == 0)
 		page = virt_to_page(vcpu->run);
+#ifdef CONFIG_X86
 	else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->arch.pio_data);
+#endif
 	else
 		return VM_FAULT_SIGBUS;
 	get_page(page);
-- 
1.5.4.5

