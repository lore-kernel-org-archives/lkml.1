Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbZEEA2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbZEEA2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbZEEA1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:27:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:20311 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbZEEA1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:27:06 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
Date: Mon,  4 May 2009 17:27:04 -0700
Message-Id: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupts that are flagged as wakeup sources via set_irq_wake()
should not be disabled for suspend.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 kernel/irq/pm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 638d8be..99113bd 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -28,6 +28,9 @@ void suspend_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
+		if (desc->status & IRQ_WAKEUP)
+			continue;
+
 		spin_lock_irqsave(&desc->lock, flags);
 		__disable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
-- 
1.6.2.2

