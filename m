Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbXIQIg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbXIQIg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXIQIce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:45258 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXIQIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 027/104] KVM: add hypercall nr to kvm_run
Date: Mon, 17 Sep 2007 10:31:09 +0200
Message-Id: <1190017947685-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>

Add the hypercall number to kvm_run and initialize it.  This changes the ABI,
but as this particular ABI was unusable before this no users are affected.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 include/linux/kvm.h    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 69d9ab4..2094746 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1378,6 +1378,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 	switch (nr) {
 	default:
+		run->hypercall.nr = nr;
 		run->hypercall.args[0] = a0;
 		run->hypercall.args[1] = a1;
 		run->hypercall.args[2] = a2;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 8db01a9..91a446f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -99,6 +99,7 @@ struct kvm_run {
 		} mmio;
 		/* KVM_EXIT_HYPERCALL */
 		struct {
+			__u64 nr;
 			__u64 args[6];
 			__u64 ret;
 			__u32 longmode;
-- 
1.5.3

