Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYFZM2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYFZM2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYFZM2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:34 -0400
Received: from il.qumranet.com ([212.179.150.194]:32309 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYFZM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 01/50] KVM: remove long -> void *user -> long cast
Date: Thu, 26 Jun 2008 15:27:43 +0300
Message-Id: <1214483312-9265-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

kvm_dev_ioctl casts the arg value to void __user *, just to recast it
again to long. This seems unnecessary.

According to objdump the binary code on x86 is unchanged by this patch.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2d29e26..764d702 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1179,7 +1179,6 @@ static int kvm_dev_ioctl_create_vm(void)
 static long kvm_dev_ioctl(struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
-	void __user *argp = (void __user *)arg;
 	long r = -EINVAL;
 
 	switch (ioctl) {
@@ -1196,7 +1195,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		r = kvm_dev_ioctl_create_vm();
 		break;
 	case KVM_CHECK_EXTENSION:
-		r = kvm_dev_ioctl_check_extension((long)argp);
+		r = kvm_dev_ioctl_check_extension(arg);
 		break;
 	case KVM_GET_VCPU_MMAP_SIZE:
 		r = -EINVAL;
-- 
1.5.6

