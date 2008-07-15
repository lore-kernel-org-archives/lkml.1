Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYGOMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYGOMOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYGOMMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:47 -0400
Received: from il.qumranet.com ([212.179.150.194]:30353 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbYGOMMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 05/19] KVM: Fix memory leak on guest exit
Date: Tue, 15 Jul 2008 15:12:24 +0300
Message-Id: <1216123958-10717-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch fixes a memory leak, we want to free the physmem when destroying
the vm.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/kvm-s390.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4585c8a..b802ce6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -194,6 +194,7 @@ out_nokvm:
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	debug_unregister(kvm->arch.dbf);
+	kvm_free_physmem(kvm);
 	free_page((unsigned long)(kvm->arch.sca));
 	kfree(kvm);
 	module_put(THIS_MODULE);
-- 
1.5.6.1

