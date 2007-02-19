Return-Path: <linux-kernel-owner+w=401wt.eu-S1750883AbXBSKdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbXBSKdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXBSKdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:33:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:57200 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXBSKdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:33:53 -0500
Subject: [PATCH 13/13] KVM: More 0 -> NULL conversions
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:33:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219103352.6777425016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -2229,13 +2229,13 @@ static void kvm_exit_debug(void)
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
 	decache_vcpus_on_cpu(raw_smp_processor_id());
-	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	return 0;
 }
 
 static int kvm_resume(struct sys_device *dev)
 {
-	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
 	return 0;
 }
 
