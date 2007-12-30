Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbXL3HMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbXL3HMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbXL3HKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:59477 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 05/52] KVM: Add fpu_reload counter
Date: Sun, 30 Dec 2007 09:09:51 +0200
Message-Id: <1198998638-22713-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Measure the number of times we switch the fpu state.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 +
 drivers/kvm/x86.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 04efe88..a85c590 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -248,6 +248,7 @@ struct kvm_stat {
 	u32 irq_exits;
 	u32 host_state_reload;
 	u32 efer_reload;
+	u32 fpu_reload;
 };
 
 struct kvm_io_device {
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 923dfd4..c1211e1 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -62,6 +62,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "irq_exits", STAT_OFFSET(irq_exits) },
 	{ "host_state_reload", STAT_OFFSET(host_state_reload) },
 	{ "efer_reload", STAT_OFFSET(efer_reload) },
+	{ "fpu_reload", STAT_OFFSET(fpu_reload) },
 	{ NULL }
 };
 
@@ -2417,6 +2418,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	vcpu->guest_fpu_loaded = 0;
 	fx_save(&vcpu->guest_fx_image);
 	fx_restore(&vcpu->host_fx_image);
+	++vcpu->stat.fpu_reload;
 }
 EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
 
-- 
1.5.3.7

