Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbZHWMAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbZHWMAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbZHWMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/46] KVM: fix kvm_init() error handling
Date: Sun, 23 Aug 2009 14:56:38 +0300
Message-Id: <1251028605-31977-40-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Remove debugfs file if kvm_arch_init() return error

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 646cf2a..4470251 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2791,8 +2791,8 @@ out_free_0:
 	__free_page(bad_page);
 out:
 	kvm_arch_exit();
-	kvm_exit_debug();
 out_fail:
+	kvm_exit_debug();
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
-- 
1.6.4.1

