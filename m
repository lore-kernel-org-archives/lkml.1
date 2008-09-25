Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYIYL5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYIYL5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYIYLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbYIYLze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/39] KVM: Handle spurious acks for PIT interrupts
Date: Thu, 25 Sep 2008 14:54:39 +0300
Message-Id: <1222343711-12508-8-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Spurious acks can be generated, for example if the PIC is being reset.
Handle those acks gracefully rather than flooding the log with warnings.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 7d04dd3..c842060 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -228,7 +228,7 @@ void kvm_pit_ack_irq(struct kvm_irq_ack_notifier *kian)
 						 irq_ack_notifier);
 	spin_lock(&ps->inject_lock);
 	if (atomic_dec_return(&ps->pit_timer.pending) < 0)
-		WARN_ON(1);
+		atomic_inc(&ps->pit_timer.pending);
 	ps->irq_ack = 1;
 	spin_unlock(&ps->inject_lock);
 }
-- 
1.6.0.1

