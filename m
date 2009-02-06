Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZBFHRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZBFHRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZBFHLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:33 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:1470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbZBFHLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:22 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422023"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 18/20] Blackfin SPI Driver: fix NULL pointer crash
Date: Fri,  6 Feb 2009 15:13:06 +0800
Message-Id: <1233904388-5765-19-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

fix NULL pointer crash when cleaning up from invalid platform resources

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index f9e1fbc..9459c42 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1178,6 +1178,9 @@ static void bfin_spi_cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if (!chip)
+		return;
+
 	if ((chip->chip_select_num > 0)
 		&& (chip->chip_select_num <= spi->master->num_chipselect))
 		peripheral_free(ssel[spi->master->bus_num]
-- 
1.5.6.3
