Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbXCLAPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbXCLAPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965238AbXCLAPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:15:51 -0400
Received: from usul.saidi.cx ([204.11.33.34]:39356 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965114AbXCLAPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:15:47 -0400
Message-ID: <45F49B93.3020208@overt.org>
Date: Sun, 11 Mar 2007 17:15:15 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] MMC: Consolidate voltage definitions
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the list of available voltages.

Up until now, a separate set of defines has been
used for host->vdd than that used for the OCR
voltage mask values. Having two sets of defines
allows them to get out of sync and the current
sets are already inconsistent with one claiming
to describe ranges and the other specific voltages.

Only the SDHCI driver uses the host->vdd defines and
it is easily fixed to use the OCR defines.

Signed-off-by: Philip Langdale <philipl@overt.org>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 86d0957..2f34ae3 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -668,20 +668,17 @@ static void sdhci_set_power(struct sdhci

 	pwr = SDHCI_POWER_ON;

-	switch (power) {
-	case MMC_VDD_170:
-	case MMC_VDD_180:
-	case MMC_VDD_190:
+	switch (1 << power) {
+	case MMC_VDD_17_18:
+	case MMC_VDD_18_19:
 		pwr |= SDHCI_POWER_180;
 		break;
-	case MMC_VDD_290:
-	case MMC_VDD_300:
-	case MMC_VDD_310:
+	case MMC_VDD_29_30:
+	case MMC_VDD_30_31:
 		pwr |= SDHCI_POWER_300;
 		break;
-	case MMC_VDD_320:
-	case MMC_VDD_330:
-	case MMC_VDD_340:
+	case MMC_VDD_32_33:
+	case MMC_VDD_33_34:
 		pwr |= SDHCI_POWER_330;
 		break;
 	default:
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 43bf6a5..496f540 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -16,30 +16,7 @@ struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
 	unsigned short	vdd;

-#define	MMC_VDD_150	0
-#define	MMC_VDD_155	1
-#define	MMC_VDD_160	2
-#define	MMC_VDD_165	3
-#define	MMC_VDD_170	4
-#define	MMC_VDD_180	5
-#define	MMC_VDD_190	6
-#define	MMC_VDD_200	7
-#define	MMC_VDD_210	8
-#define	MMC_VDD_220	9
-#define	MMC_VDD_230	10
-#define	MMC_VDD_240	11
-#define	MMC_VDD_250	12
-#define	MMC_VDD_260	13
-#define	MMC_VDD_270	14
-#define	MMC_VDD_280	15
-#define	MMC_VDD_290	16
-#define	MMC_VDD_300	17
-#define	MMC_VDD_310	18
-#define	MMC_VDD_320	19
-#define	MMC_VDD_330	20
-#define	MMC_VDD_340	21
-#define	MMC_VDD_350	22
-#define	MMC_VDD_360	23
+/* vdd stores the bit number of the selected voltage range from below. */

 	unsigned char	bus_mode;		/* command output mode */

