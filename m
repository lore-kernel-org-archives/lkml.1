Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZKPM2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZKPM2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZKPMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 17/42] KVM: Return -ENOTTY on unrecognized ioctls
Date: Mon, 16 Nov 2009 14:19:18 +0200
Message-Id: <1258373983-8693-18-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not the incorrect -EINVAL.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c   |    2 +-
 arch/powerpc/kvm/powerpc.c |    2 +-
 arch/s390/kvm/kvm-s390.c   |    2 +-
 arch/x86/kvm/x86.c         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index f534e0f..f6471c8 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -941,7 +941,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
-	int r = -EINVAL;
+	int r = -ENOTTY;
 
 	switch (ioctl) {
 	case KVM_SET_MEMORY_REGION: {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2a4551f..95af622 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -421,7 +421,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	default:
-		r = -EINVAL;
+		r = -ENOTTY;
 	}
 
 	return r;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 07ced89..00e2ce8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -150,7 +150,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	}
 	default:
-		r = -EINVAL;
+		r = -ENOTTY;
 	}
 
 	return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5beb4c1..829e306 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2176,7 +2176,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
-	int r = -EINVAL;
+	int r = -ENOTTY;
 	/*
 	 * This union makes it completely explicit to gcc-3.x
 	 * that these two variables' stack usage should be
-- 
1.6.5.2

