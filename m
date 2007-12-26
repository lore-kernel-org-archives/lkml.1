Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbXLZLU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbXLZLU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXLZLHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:50481 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXLZLGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:09 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 43/55] KVM: Simplify CPU_TASKS_FROZEN cpu notifier handling
Date: Wed, 26 Dec 2007 13:05:48 +0200
Message-Id: <1198667160-22953-44-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 302473d..dacdc66 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1335,21 +1335,19 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 {
 	int cpu = (long)v;
 
+	val &= ~CPU_TASKS_FROZEN;
 	switch (val) {
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		hardware_disable(NULL);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		smp_call_function_single(cpu, hardware_disable, NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
 		smp_call_function_single(cpu, hardware_enable, NULL, 0, 1);
-- 
1.5.3.7

