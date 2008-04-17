Return-Path: <linux-kernel-owner+w=401wt.eu-S1764732AbYDQJTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764732AbYDQJTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763492AbYDQJLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:19 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59037
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621AbYDQJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/45] KVM: Free apic access page on vm destruction
Date: Thu, 17 Apr 2008 12:10:25 +0300
Message-Id: <1208423450-29415-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by Marcelo Tosatti.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6a38bf..c7ad235 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3853,6 +3853,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.vioapic);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
+	if (kvm->arch.apic_access_page)
+		put_page(kvm->arch.apic_access_page);
 	kfree(kvm);
 }
 
-- 
1.5.5

