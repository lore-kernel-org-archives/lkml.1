Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZEXPzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZEXPzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbZEXPw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:52:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 35/45] KVM: s390: Verify memory in kvm run
Date: Sun, 24 May 2009 18:50:20 +0300
Message-Id: <1243180230-2480-36-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This check verifies that the guest we're trying to run in KVM_RUN
has some memory assigned to it. It enters an endless exception
loop if this is not the case.

Reported-by: Mijo Safradin <mijo@linux.vnet.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/kvm-s390.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 628494a..10bccd1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -487,6 +487,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
+	/* verify, that memory has been registered */
+	if (!vcpu->kvm->arch.guest_memsize) {
+		vcpu_put(vcpu);
+		return -EINVAL;
+	}
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
-- 
1.6.0.6

