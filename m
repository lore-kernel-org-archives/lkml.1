Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYIYMAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYIYMAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYIYLzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48562 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbYIYLzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 15/39] KVM: make irq ack notifier functions static
Date: Thu, 25 Sep 2008 14:54:47 +0300
Message-Id: <1222343711-12508-16-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

sparse says:

arch/x86/kvm/x86.c:107:32: warning: symbol 'kvm_find_assigned_dev' was not declared. Should it be static?
arch/x86/kvm/i8254.c:225:6: warning: symbol 'kvm_pit_ack_irq' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index fdaa0f0..4cb4430 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -222,7 +222,7 @@ int pit_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_pit_ack_irq(struct kvm_irq_ack_notifier *kian)
+static void kvm_pit_ack_irq(struct kvm_irq_ack_notifier *kian)
 {
 	struct kvm_kpit_state *ps = container_of(kian, struct kvm_kpit_state,
 						 irq_ack_notifier);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b3c882..22edd95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -104,7 +104,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
+static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
 						      int assigned_dev_id)
 {
 	struct list_head *ptr;
-- 
1.6.0.1

