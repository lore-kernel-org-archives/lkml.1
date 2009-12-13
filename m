Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZLNAOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZLNAOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZLNAOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:14:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbZLMX5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:55 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, avi@redhat.com,
       torvalds@linux-foundation.org
Subject: [PATCH 4/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:32 +0100
Message-Id: <c410609da64d34b3db545a22b6bb1c5313c3f0b1.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 virt/kvm/kvm_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f92ba13..f7a2269 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1164,6 +1164,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/* cannot be const, see kvm_init */
 static struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
@@ -1620,6 +1621,7 @@ static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+/* cannot be const, see kvm_init */
 static struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
@@ -1710,6 +1712,7 @@ out:
 	return r;
 }
 
+/* cannot be const, see kvm_init */
 static struct file_operations kvm_chardev_ops = {
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.compat_ioctl   = kvm_dev_ioctl,
-- 
1.6.5.3

