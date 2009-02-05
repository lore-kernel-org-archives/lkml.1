Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbZBEKGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbZBEKGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbZBEKFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:05:48 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:31693 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbZBEKFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:05:44 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82351963"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/5] Blackfin SPI Driver: fix NULL pointer crash
Date: Thu,  5 Feb 2009 18:07:31 +0800
Message-Id: <1233828453-13311-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
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
index ce24d5e..b6098b5 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1240,6 +1240,9 @@ static void bfin_spi_cleanup(struct spi_device *spi)
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
