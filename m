Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZFLQaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZFLQaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764762AbZFLQZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39089 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764262AbZFLQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 16/27] Blackfin: bf548-ezkit: update smsc911x resources
Date: Fri, 12 Jun 2009 12:24:34 -0400
Message-Id: <1244823885-22410-17-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The older smsc911x driver made platform data optional, but the newer one
always requires it, so add proper settings to the BF548-EZKIT.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index a4b1ee8..805a57b 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -396,6 +396,8 @@ static struct platform_device bfin_sir3_device = {
 #endif
 
 #if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+#include <linux/smsc911x.h>
+
 static struct resource smsc911x_resources[] = {
 	{
 		.name = "smsc911x-memory",
@@ -409,11 +411,22 @@ static struct resource smsc911x_resources[] = {
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
 	},
 };
+
+static struct smsc911x_platform_config smsc911x_config = {
+	.flags = SMSC911X_USE_32BIT,
+	.irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_type = SMSC911X_IRQ_TYPE_OPEN_DRAIN,
+	.phy_interface = PHY_INTERFACE_MODE_MII,
+};
+
 static struct platform_device smsc911x_device = {
 	.name = "smsc911x",
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smsc911x_resources),
 	.resource = smsc911x_resources,
+	.dev = {
+		.platform_data = &smsc911x_config,
+	},
 };
 #endif
 
-- 
1.6.3.1

