Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZBIN2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZBIN2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZBIN20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:28:26 -0500
Received: from mail.openmoko.org ([88.198.124.205]:44534 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbZBIN2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:28:25 -0500
Date: Mon, 9 Feb 2009 18:58:08 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andy Green <andy@openmoko.com>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH] mmc: In mmc_power_up, use previously selected ocr if
	available
Message-ID: <20090209132806.GD3278@fedora.yogi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mmc_power_up is called during unsafe resume, host->ocr should be
used instead of host->ocr_avail.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
---
 drivers/mmc/core/core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df6ce4a..3ad7f87 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -572,7 +572,13 @@ void mmc_set_timing(struct mmc_host *host, unsigned int timing)
  */
 static void mmc_power_up(struct mmc_host *host)
 {
-	int bit = fls(host->ocr_avail) - 1;
+	int bit;
+
+	/* If ocr is set, we use it */
+	if (host->ocr)
+		bit = ffs(host->ocr) - 1;
+	else
+		bit = fls(host->ocr_avail) - 1;
 
 	host->ios.vdd = bit;
 	if (mmc_host_is_spi(host)) {
-- 
1.6.0.6
