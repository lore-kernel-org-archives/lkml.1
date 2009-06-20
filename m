Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZFTSpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZFTSpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZFTSpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48007 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546AbZFTSpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 02/25] Blackfin: bf518f-ezbrd: update DSA resources
Date: Sat, 20 Jun 2009 14:44:25 -0400
Message-Id: <1245523488-26536-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common DSA code changed structure layout, so update the BF518F-EZBRD
resources accordingly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 1382f03..d979110 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -119,13 +119,19 @@ static struct platform_device bfin_mac_device = {
 };
 
 #if defined(CONFIG_NET_DSA_KSZ8893M) || defined(CONFIG_NET_DSA_KSZ8893M_MODULE)
-static struct dsa_platform_data ksz8893m_switch_data = {
+static struct dsa_chip_data ksz8893m_switch_chip_data = {
 	.mii_bus = &bfin_mii_bus.dev,
+	.port_names = {
+		NULL,
+		"eth%d",
+		"eth%d",
+		"cpu",
+	},
+};
+static struct dsa_platform_data ksz8893m_switch_data = {
+	.nr_chips = 1,
 	.netdev = &bfin_mac_device.dev,
-	.port_names[0]	= NULL,
-	.port_names[1]	= "eth%d",
-	.port_names[2]	= "eth%d",
-	.port_names[3]	= "cpu",
+	.chip = &ksz8893m_switch_chip_data,
 };
 
 static struct platform_device ksz8893m_switch_device = {
-- 
1.6.3.1

