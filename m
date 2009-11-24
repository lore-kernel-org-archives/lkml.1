Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbZKXVLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbZKXVLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934034AbZKXVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:11:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44697 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025AbZKXVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:36 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Doug Thompson <dougthompson@xmission.com>,
       Dave Jiang <djiang@mvista.com>, Kumar Gala <galak@kernel.crashing.org>,
       Yang Shi <yang.shi@windriver.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 11/38] move mpc85xx_pci_err_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:06 +0100
Message-Id: <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function mpc85xx_pci_err_remove is used only wrapped by __devexit_p
so define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Yang Shi <yang.shi@windriver.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/edac/mpc85xx_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index cf27402..72b06c0 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -306,7 +306,7 @@ err:
 	return res;
 }
 
-static int mpc85xx_pci_err_remove(struct of_device *op)
+static int __devexit mpc85xx_pci_err_remove(struct of_device *op)
 {
 	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
-- 
1.6.5.2

