Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXDAOpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXDAOpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXDAOpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:45:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:47550 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203AbXDAOfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 19/41] KVM: Future-proof argument-less ioctls
Date: Sun,  1 Apr 2007 17:35:16 +0300
Message-Id: <117543813978-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381392921-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some ioctls ignore their arguments.  By requiring them to be zero now,
we allow a nonzero value to have some special meaning in the future.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index cba0b87..ba7f43a 100644
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
1.5.0.5

