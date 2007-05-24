Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbXEXMMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbXEXMMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbXEXMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:36456 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbXEXMKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:20 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 7/7] KVM: Use CPU_DYING for disabling virtualization
Date: Thu, 24 May 2007 15:10:15 +0300
Message-Id: <1180008616977-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Only at the CPU_DYING stage can we be sure that no user process will
be scheduled onto the cpu and oops when trying to use virtualization
extensions.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a632c8d..e9aa86d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2915,8 +2915,8 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	int cpu = (long)v;
 
 	switch (val) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
-- 
1.5.0.6

