Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbZHWMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbZHWMGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933534AbZHWMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933523AbZHWL4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/46] KVM: Trace irq level and source id
Date: Sun, 23 Aug 2009 14:56:00 +0300
Message-Id: <1251028605-31977-2-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/trace/events/kvm.h |   11 ++++++++---
 virt/kvm/irq_comm.c        |    2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index d74b23d..035232d 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -9,18 +9,23 @@
 
 #if defined(__KVM_HAVE_IOAPIC)
 TRACE_EVENT(kvm_set_irq,
-	TP_PROTO(unsigned int gsi),
-	TP_ARGS(gsi),
+	TP_PROTO(unsigned int gsi, int level, int irq_source_id),
+	TP_ARGS(gsi, level, irq_source_id),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	gsi		)
+		__field(	int,		level		)
+		__field(	int,		irq_source_id	)
 	),
 
 	TP_fast_assign(
 		__entry->gsi		= gsi;
+		__entry->level		= level;
+		__entry->irq_source_id	= irq_source_id;
 	),
 
-	TP_printk("gsi %u", __entry->gsi)
+	TP_printk("gsi %u level %d source %d",
+		  __entry->gsi, __entry->level, __entry->irq_source_id)
 );
 
 
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 94759ed..56e6961 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -126,7 +126,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 	unsigned long *irq_state, sig_level;
 	int ret = -1;
 
-	trace_kvm_set_irq(irq);
+	trace_kvm_set_irq(irq, level, irq_source_id);
 
 	WARN_ON(!mutex_is_locked(&kvm->irq_lock));
 
-- 
1.6.4.1

