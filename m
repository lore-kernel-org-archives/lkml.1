Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYEPQwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYEPQwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbYEPQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:51:04 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:34183 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1756696AbYEPQvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:51:03 -0400
Date: Fri, 16 May 2008 20:51:00 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 4/4] [POWERPC] 86xx: mpc8610_hpcd: add SD/MMC card detect
	polling
Message-ID: <20080516165100.GD24196@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPC8610HPCD seem to not use interrupts for the SD CD line, so we need
poll it.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index be430bc..47078e3 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -63,9 +63,15 @@ static int mmc_get_ro(struct device *dev)
 	return in_8(pixis_sdcsr) & PX_SDCSR_SD_WP;
 }
 
+static int mmc_get_cd(struct device *dev)
+{
+	return !(in_8(pixis_sdcsr) & PX_SDCSR_SD_nCD);
+}
+
 static struct mmc_spi_platform_data mmc_pdata = {
 	.ocr_mask = MMC_VDD_33_34,
 	.get_ro = mmc_get_ro,
+	.get_cd = mmc_get_cd,
 };
 
 static struct spi_board_info spi_boardinfo = {
-- 
1.5.5.1
