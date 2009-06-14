Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZFNMBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZFNMBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbZFNMB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52643 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbZFNMB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 01/17] Blackfin: use common test_bit() rather than __test_bit()
Date: Sun, 14 Jun 2009 08:01:02 -0400
Message-Id: <1244980878-2124-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to test_bit() as that is what pretty much everyone uses and allows
us to migrate asm/bitops.h to the asm-generic version.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/ints-priority.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 351afd0..af70f09 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -472,7 +472,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 
 	if (type == IRQ_TYPE_PROBE) {
 		/* only probe unenabled GPIO interrupt lines */
-		if (__test_bit(gpionr, gpio_enabled))
+		if (test_bit(gpionr, gpio_enabled))
 			return 0;
 		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
 	}
@@ -782,7 +782,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 
 	if (type == IRQ_TYPE_PROBE) {
 		/* only probe unenabled GPIO interrupt lines */
-		if (__test_bit(gpionr, gpio_enabled))
+		if (test_bit(gpionr, gpio_enabled))
 			return 0;
 		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
 	}
-- 
1.6.3.1

