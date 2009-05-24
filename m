Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZEXQCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZEXQCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759004AbZEXPzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:55:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41824 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 12/45] KVM: VMX: Disable VMX when system shutdown
Date: Sun, 24 May 2009 18:49:57 +0300
Message-Id: <1243180230-2480-13-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Intel TXT(Trusted Execution Technology) required VMX off for all cpu to work
when system shutdown.

CC: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3265566..2b73e19 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2391,15 +2391,15 @@ EXPORT_SYMBOL_GPL(kvm_handle_fault_on_reboot);
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
-	if (val == SYS_RESTART) {
-		/*
-		 * Some (well, at least mine) BIOSes hang on reboot if
-		 * in vmx root mode.
-		 */
-		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		kvm_rebooting = true;
-		on_each_cpu(hardware_disable, NULL, 1);
-	}
+	/*
+	 * Some (well, at least mine) BIOSes hang on reboot if
+	 * in vmx root mode.
+	 *
+	 * And Intel TXT required VMX off for all cpu when system shutdown.
+	 */
+	printk(KERN_INFO "kvm: exiting hardware virtualization\n");
+	kvm_rebooting = true;
+	on_each_cpu(hardware_disable, NULL, 1);
 	return NOTIFY_OK;
 }
 
-- 
1.6.0.6

