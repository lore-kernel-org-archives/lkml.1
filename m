Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbZARNqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbZARNqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 08:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbZARNq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 08:46:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:32792 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912AbZARNq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 08:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dW4fBiaszaDpXZ1gAh8/pKbacys8G4hCywklPu0HDGY0buWw6hXMY6AQxPBadF7J+8
         dCFDMNS2wV83KBu6sDu5GxPnwGWgR6uGlBwZ2vXfNgiywyM0MxJRDHOsAf3A8i3ASnvR
         C7iq5JJmSuQeYY7DUx8ntkUpkJRQUn4+tma/c=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] power: stop pda_power from requesting shared a IRQ as IRQF_DISABLED
Date: Sun, 18 Jan 2009 14:46:21 +0100
Message-Id: <1232286381-6748-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_DISABLED is not guaranteed for shared IRQs. I think power_changed_isr
doesn't need it anyway, as it only fires a timer.
This patch enables IRQF_SAMPLE_RANDOM instead.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/power/pda_power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index d30bb76..b56a704 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -20,7 +20,7 @@
 
 static inline unsigned int get_irq_flags(struct resource *res)
 {
-	unsigned int flags = IRQF_DISABLED | IRQF_SHARED;
+	unsigned int flags = IRQF_SAMPLE_RANDOM | IRQF_SHARED;
 
 	flags |= res->flags & IRQF_TRIGGER_MASK;
 
-- 
1.5.6.5

