Return-Path: <linux-kernel-owner+w=401wt.eu-S933733AbZINUM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbZINUM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933624AbZINUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:12:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54179 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662AbZINUJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 62/72] Blackfin: bf537-stamp: add adp5588 gpio resources
Date: Mon, 14 Sep 2009 16:08:06 -0400
Message-Id: <1252958896-25150-63-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

For the adp5588 GPIO daughter card.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 7ce7d94..9db6b40 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1437,6 +1437,14 @@ static struct adp5520_platform_data adp5520_pdev_data = {
 
 #endif
 
+#if defined(CONFIG_GPIO_ADP5588) || defined(CONFIG_GPIO_ADP5588_MODULE)
+#include <linux/i2c/adp5588.h>
+static struct adp5588_gpio_platfrom_data adp5588_gpio_data = {
+	.gpio_start = 50,
+	.pullup_dis_mask = 0,
+};
+#endif
+
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 #if defined(CONFIG_INPUT_EVAL_AD7142EB)
 	{
@@ -1484,6 +1492,12 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.platform_data = (void *)&adxl34x_info,
 	},
 #endif
+#if defined(CONFIG_GPIO_ADP5588) || defined(CONFIG_GPIO_ADP5588_MODULE)
+	{
+		I2C_BOARD_INFO("adp5588-gpio", 0x34),
+		.platform_data = (void *)&adp5588_gpio_data,
+	},
+#endif
 };
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
-- 
1.6.4.2

