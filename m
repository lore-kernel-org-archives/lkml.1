Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbZINUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbZINUI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933619AbZINUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54100 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbZINUIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 39/72] Blackfin: convert boards to use platform data with smc91x
Date: Mon, 14 Sep 2009 16:07:43 -0400
Message-Id: <1252958896-25150-40-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Latest smc91x driver allows you to specify settings in board resources
rather than needing CONFIG_BLACKFIN in the drivers/net/smc91x.h header.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |   11 +++++++++++
 arch/blackfin/mach-bf527/boards/ezkit.c      |   11 +++++++++++
 arch/blackfin/mach-bf533/boards/H8606.c      |   11 +++++++++++
 arch/blackfin/mach-bf533/boards/blackstamp.c |   11 +++++++++++
 arch/blackfin/mach-bf533/boards/cm_bf533.c   |   11 +++++++++++
 arch/blackfin/mach-bf533/boards/ezkit.c      |   11 +++++++++++
 arch/blackfin/mach-bf533/boards/stamp.c      |   11 +++++++++++
 arch/blackfin/mach-bf537/boards/cm_bf537.c   |   11 +++++++++++
 arch/blackfin/mach-bf537/boards/pnav10.c     |   11 +++++++++++
 arch/blackfin/mach-bf537/boards/stamp.c      |   11 +++++++++++
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |   11 +++++++++++
 arch/blackfin/mach-bf538/boards/ezkit.c      |   11 +++++++++++
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |   10 ++++++++++
 arch/blackfin/mach-bf561/boards/ezkit.c      |   11 +++++++++++
 14 files changed, 153 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 85f9ac5..cb360e9 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -275,6 +275,14 @@ static struct platform_device rtc_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -293,6 +301,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index b843d0e..617a287 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -292,6 +292,14 @@ static struct platform_device rtc_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -310,6 +318,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 38cf8ff..1bd8b61 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -88,6 +88,14 @@ static struct platform_device dm9000_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -110,6 +118,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c b/arch/blackfin/mach-bf533/boards/blackstamp.c
index 9ecdc36..8208d67 100644
--- a/arch/blackfin/mach-bf533/boards/blackstamp.c
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -48,6 +48,14 @@ static struct platform_device rtc_device = {
  *  Driver needs to know address, irq and flag pin.
  */
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -66,6 +74,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 1443e92..7052568 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -195,6 +195,14 @@ static struct platform_device rtc_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.start = 0x20200300,
@@ -211,6 +219,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 4e3e511..88b2dfc 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -67,6 +67,14 @@ static struct platform_device bfin_fb_adv7393_device = {
  *  Driver needs to know address, irq and flag pin.
  */
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -84,6 +92,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 7a7b656..f3dc283 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -63,6 +63,14 @@ static struct platform_device rtc_device = {
  *  Driver needs to know address, irq and flag pin.
  */
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -81,6 +89,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 2a87d1c..3681d2c 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -223,6 +223,14 @@ static struct platform_device hitachi_fb_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.start = 0x20200300,
@@ -240,6 +248,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 838240f..3bbe102 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -92,6 +92,14 @@ static struct platform_device rtc_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -110,6 +118,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 192e34e..313249e 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -171,6 +171,14 @@ static struct platform_device rtc_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -189,6 +197,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index e523e6e..97a86b4 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -223,6 +223,14 @@ static struct platform_device hitachi_fb_device = {
 #endif
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.start = 0x20200300,
@@ -240,6 +248,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index 57695b4..42297fa 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -177,6 +177,14 @@ static struct platform_device bfin_sir2_device = {
  *  Driver needs to know address, irq and flag pin.
  */
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -194,6 +202,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 0c9d72c..ebb0755 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -213,6 +213,13 @@ static struct platform_device hitachi_fb_device = {
 
 
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_32BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
 
 static struct resource smc91x_resources[] = {
 	{
@@ -231,6 +238,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 4df904f..10edc99 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -147,6 +147,14 @@ static struct platform_device net2272_bfin_device = {
  *  Driver needs to know address, irq and flag pin.
  */
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+#include <linux/smc91x.h>
+
+static struct smc91x_platdata smc91x_info = {
+	.flags = SMC91X_USE_32BIT | SMC91X_NOWAIT,
+	.leda = RPC_LED_100_10,
+	.ledb = RPC_LED_TX_RX,
+};
+
 static struct resource smc91x_resources[] = {
 	{
 		.name = "smc91x-regs",
@@ -166,6 +174,9 @@ static struct platform_device smc91x_device = {
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smc91x_resources),
 	.resource = smc91x_resources,
+	.dev	= {
+		.platform_data	= &smc91x_info,
+	},
 };
 #endif
 
-- 
1.6.4.2

