Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbYGOMSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbYGOMSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbYGOMNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:13:00 -0400
Received: from il.qumranet.com ([212.179.150.194]:30369 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbYGOMMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben-Ami Yassour <benami@il.ibm.com>
Subject: [PATCH 14/19] KVM: check injected pic irq within valid pic irqs
Date: Tue, 15 Jul 2008 15:12:33 +0300
Message-Id: <1216123958-10717-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben-Ami Yassour <benami@il.ibm.com>

Check that an injected pic irq is between 0 and 15.

Signed-off-by: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8259.c |    6 ++++--
 arch/x86/kvm/irq.h   |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 5857f59..c31164e 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -130,8 +130,10 @@ void kvm_pic_set_irq(void *opaque, int irq, int level)
 {
 	struct kvm_pic *s = opaque;
 
-	pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
-	pic_update_irq(s);
+	if (irq >= 0 && irq < PIC_NUM_PINS) {
+		pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
+		pic_update_irq(s);
+	}
 }
 
 /*
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 2a15be2..7ca47cb 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -30,6 +30,8 @@
 #include "ioapic.h"
 #include "lapic.h"
 
+#define PIC_NUM_PINS 16
+
 struct kvm;
 struct kvm_vcpu;
 
-- 
1.5.6.1

