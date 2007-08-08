Return-Path: <linux-kernel-owner+w=401wt.eu-S936807AbXHHDjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936807AbXHHDjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935888AbXHHDgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45539 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021AbXHHDfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:50 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639270:sNHT271184165"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Wed,  8 Aug 2007 11:35:27 +0800
Message-Id: <1186544139342-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-common/ints-priority-dc.c |    4 ++--
 arch/blackfin/mach-common/ints-priority-sc.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 660f881..d5d9e57 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -221,7 +221,7 @@ static unsigned int bf561_gpio_irq_startup(unsigned int irq)
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 
@@ -261,7 +261,7 @@ static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
 
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 4708023..505b948 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -343,7 +343,7 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	u16 gpionr = irq - IRQ_PF0;
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -377,7 +377,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
@@ -587,7 +587,7 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	}
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -627,7 +627,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
-- 
1.5.2
