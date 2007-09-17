Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbXIQIlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbXIQIlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXIQIcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:45264 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 047/104] KVM: Remove unneeded kvm_dev_open and kvm_dev_release functions.
Date: Mon, 17 Sep 2007 10:31:29 +0200
Message-Id: <11900179481213-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Devices don't need open or release functions.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 25d76a5..9de3b1a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -302,11 +302,6 @@ static struct kvm *kvm_create_vm(void)
 	return kvm;
 }
 
-static int kvm_dev_open(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
 /*
  * Free any memory in @free but not in @dont.
  */
@@ -376,11 +371,6 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 }
 
-static int kvm_dev_release(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
 static void kvm_destroy_vm(struct kvm *kvm)
 {
 	spin_lock(&kvm_lock);
@@ -2841,8 +2831,6 @@ out:
 }
 
 static struct file_operations kvm_chardev_ops = {
-	.open		= kvm_dev_open,
-	.release        = kvm_dev_release,
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.compat_ioctl   = kvm_dev_ioctl,
 };
-- 
1.5.3

