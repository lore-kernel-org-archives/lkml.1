Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbZJHGFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbZJHGFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083AbZJHGFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34625 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbZJHGFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 09/13] Blackfin: drop cs_change_per_word setting
Date: Thu,  8 Oct 2009 02:04:25 -0400
Message-Id: <1254981869-21586-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structs get initialized to 0 already, and we want to punt this field, so
scrub it from all of our boards.

Reported-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf533/boards/ip0x.c     |    1 -
 arch/blackfin/mach-bf537/boards/pnav10.c   |    1 -
 arch/blackfin/mach-bf538/boards/ezkit.c    |    1 -
 arch/blackfin/mach-bf548/boards/cm_bf548.c |    2 --
 arch/blackfin/mach-bf548/boards/ezkit.c    |    3 ---
 5 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/ip0x.c b/arch/blackfin/mach-bf533/boards/ip0x.c
index 284038d..644be5e 100644
--- a/arch/blackfin/mach-bf533/boards/ip0x.c
+++ b/arch/blackfin/mach-bf533/boards/ip0x.c
@@ -123,7 +123,6 @@ static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.ctl_reg = 0x1000,		/* CPOL=0,CPHA=0,Sandisk 1G work */
 	.enable_dma = 0,		/* if 1 - block!!! */
 	.bits_per_word = 8,
-	.cs_change_per_word = 0,
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 29e38d5..9ba2904 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -280,7 +280,6 @@ static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
-	.cs_change_per_word = 0,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index d084617..8d612e7 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -215,7 +215,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
-	.cs_change_per_word = 0,
 };
 #endif
 
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index 0479d0c..283be63 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -525,13 +525,11 @@ static struct flash_platform_data bfin_spi_flash_data = {
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
-	.cs_change_per_word = 0,
 };
 #endif
 
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
-	.cs_change_per_word = 0,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index dae6d0f..ba745c6 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -614,7 +614,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
-	.cs_change_per_word = 0,
 };
 #endif
 
@@ -628,7 +627,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
-	.cs_change_per_word = 0,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -659,7 +657,6 @@ static struct bfin5xx_spi_chip spidev_chip_info = {
 static struct bfin5xx_spi_chip spi_adxl34x_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
-	.cs_change_per_word = 0,
 };
 #endif
 
-- 
1.6.5.rc2

