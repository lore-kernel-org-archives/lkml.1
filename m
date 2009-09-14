Return-Path: <linux-kernel-owner+w=401wt.eu-S933710AbZINUQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbZINUQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933617AbZINUQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:16:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54106 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbZINUIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 41/72] Blackfin: cm-bf527/bf537-stamp: fix dm9000 resources
Date: Mon, 14 Sep 2009 16:07:45 -0400
Message-Id: <1252958896-25150-42-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

The dm9000 driver expects two IORESOURCE_MEM to get at the device, so make
sure we declare things properly.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c |    7 ++++++-
 arch/blackfin/mach-bf537/boards/stamp.c    |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index cb360e9..18b9bd7 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -311,10 +311,15 @@ static struct platform_device smc91x_device = {
 static struct resource dm9000_resources[] = {
 	[0] = {
 		.start	= 0x203FB800,
-		.end	= 0x203FB800 + 8,
+		.end	= 0x203FB800 + 1,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
+		.start	= 0x203FB804,
+		.end	= 0x203FB804 + 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
 		.start	= IRQ_PF9,
 		.end	= IRQ_PF9,
 		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 313249e..9b67006 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -207,10 +207,15 @@ static struct platform_device smc91x_device = {
 static struct resource dm9000_resources[] = {
 	[0] = {
 		.start	= 0x203FB800,
-		.end	= 0x203FB800 + 8,
+		.end	= 0x203FB800 + 1,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
+		.start	= 0x203FB804,
+		.end	= 0x203FB804 + 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
 		.start	= IRQ_PF9,
 		.end	= IRQ_PF9,
 		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
-- 
1.6.4.2

