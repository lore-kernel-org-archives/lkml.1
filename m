Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbZFLQ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbZFLQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764019AbZFLQZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39089 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764630AbZFLQZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 13/27] Blackfin: bf518f-ezbrd: fix SPI CS for SPI flash
Date: Fri, 12 Jun 2009 12:24:31 -0400
Message-Id: <1244823885-22410-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The SPI flash on the BF518F-EZBRD board is actually hooked up to CS2,
not CS1, so make sure the resources are correct.

URL: http://blackfin.uclinux.org/gf/tracker/5220
Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 8969a24..1382f03 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -246,7 +246,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.modalias = "m25p80", /* Name of spi_driver for this device */
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0, /* Framework bus number */
-		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
+		.chip_select = 2, /* On BF518F-EZBRD it's SPI0_SSEL2 */
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
 		.mode = SPI_MODE_3,
-- 
1.6.3.1

