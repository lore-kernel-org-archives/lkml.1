Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZFEIKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZFEIKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZFEIFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37490 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbZFEIF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 14/62] Blackfin: do not error if GPIO IRQ is requested already as GPIO
Date: Fri,  5 Jun 2009 04:04:23 -0400
Message-Id: <1244189111-19639-15-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Some drivers expect to be able to request both as GPIO and GPIO IRQ, so
allow that use case.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_gpio.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index a0678da..32289b3 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -1021,15 +1021,6 @@ int bfin_gpio_irq_request(unsigned gpio, const char *label)
 
 	local_irq_save_hw(flags);
 
-	if (unlikely(reserved_gpio_irq_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		if (system_state == SYSTEM_BOOTING)
-			dump_stack();
-		printk(KERN_ERR
-		       "bfin-gpio: GPIO %d is already reserved as gpio-irq !\n",
-		       gpio);
-		local_irq_restore_hw(flags);
-		return -EBUSY;
-	}
 	if (unlikely(reserved_peri_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
 		if (system_state == SYSTEM_BOOTING)
 			dump_stack();
-- 
1.6.3.1

