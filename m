Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZBFHO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZBFHO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZBFHLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:25 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:44045 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZBFHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:20 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422016"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 11/20] Blackfin SPI Driver: SPI slave select code cleanup
Date: Fri,  6 Feb 2009 15:12:59 +0800
Message-Id: <1233904388-5765-12-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

 - remove duplicated definition MAX_SPI_SSEL
 - remove unnecessary array size

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 54d8948..bfb587e 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -198,8 +198,6 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 		udelay(chip->cs_chg_udelay);
 }
 
-#define MAX_SPI_SSEL	7
-
 /* stop controller and re-config current chip*/
 static void restore_state(struct driver_data *drv_data)
 {
@@ -1001,7 +999,7 @@ static int transfer(struct spi_device *spi, struct spi_message *msg)
 
 #define MAX_SPI_SSEL	7
 
-static u16 ssel[3][MAX_SPI_SSEL] = {
+static u16 ssel[][MAX_SPI_SSEL] = {
 	{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
 	P_SPI0_SSEL4, P_SPI0_SSEL5,
 	P_SPI0_SSEL6, P_SPI0_SSEL7},
-- 
1.5.6.3
