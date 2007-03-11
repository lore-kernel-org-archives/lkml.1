Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXCKN5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXCKN5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXCKNya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:54:30 -0400
Received: from il.qumranet.com ([82.166.9.18]:36767 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933584AbXCKNxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 15/15] KVM: Future-proof argument-less ioctls
Date: Sun, 11 Mar 2007 15:53:27 +0200
Message-Id: <117362120890-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some ioctls ignore their arguments.  By requiring them to be zero now,
we allow a nonzero value to have some special meaning in the future.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b81f007..bf8403e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2169,6 +2169,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_RUN:
+		r = -EINVAL;
+		if (arg)
+			goto out;
 		r = kvm_vcpu_ioctl_run(vcpu, vcpu->run);
 		break;
 	case KVM_GET_REGS: {
@@ -2440,9 +2443,15 @@ static long kvm_dev_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_GET_API_VERSION:
+		r = -EINVAL;
+		if (arg)
+			goto out;
 		r = KVM_API_VERSION;
 		break;
 	case KVM_CREATE_VM:
+		r = -EINVAL;
+		if (arg)
+			goto out;
 		r = kvm_dev_ioctl_create_vm();
 		break;
 	case KVM_GET_MSR_INDEX_LIST: {
-- 
1.5.0.2

