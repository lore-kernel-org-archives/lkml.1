Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYHIW4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYHIW4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYHIW4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:56:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:55569 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYHIW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PMC2jyKMnbX9FVnKX2DnGZIOEm/VmxrVUJSiMc1HJYg5dUzjxYFhqLCFd8YLVYIQ1C
         VEaq64jgTs0TZ92xotbtfermK3tfiJHaRoyp0ut9NFU7aIO08mG2wKEH4BWRtmRTSVyR
         uuMs157CrX4dNviK5yDgVOGZbFjdL5U/JSG/c=
Subject: [PATCH] kvm: make functions static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 15:56:23 -0700
Message-Id: <1218322583.24441.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kvm/x86.c:107:32: warning: symbol 'kvm_find_assigned_dev' was not declared. Should it be static?
arch/x86/kvm/i8254.c:225:6: warning: symbol 'kvm_pit_ack_irq' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 7d04dd3..cbe78a7 100644
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
index a97157c..f4b072e 100644
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
1.6.0.rc1.278.g9c632


