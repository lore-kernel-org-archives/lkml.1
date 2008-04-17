Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbYDQJXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbYDQJXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763206AbYDQJL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58967
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763087AbYDQJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 25/45] KVM: s390: Fix incorrect return value
Date: Thu, 17 Apr 2008 12:10:30 +0300
Message-Id: <1208423450-29415-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

kvm_arch_vcpu_ioctl_run currently incorrectly always returns 0.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d3b1de8..d966137 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -497,7 +497,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	vcpu_put(vcpu);
 
 	vcpu->stat.exit_userspace++;
-	return 0;
+	return rc;
 }
 
 static int __guestcopy(struct kvm_vcpu *vcpu, u64 guestdest, const void *from,
-- 
1.5.5

