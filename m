Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbXGHMAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbXGHMAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbXGHLz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:38415 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbXGHLyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 20/20] KVM: Use CPU_DYING for disabling virtualization
Date: Sun,  8 Jul 2007 14:54:49 +0300
Message-Id: <11838956893273-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
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
index 54cad51..83bb284 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3004,8 +3004,8 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
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
1.5.2.2

