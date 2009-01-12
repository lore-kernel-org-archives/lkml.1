Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZALNzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZALNzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZALNxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:53:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49704 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZALNxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:53:22 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:52:17 +0100
Message-Id: <1231768351-30502-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move mpc85xx_pci_err_remove to .devexit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function mpc85xx_pci_err_remove is used only wrapped by __devexit_p
so define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/edac/mpc85xx_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 853ef37..2459bdc 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -302,7 +302,7 @@ err:
 	return res;
 }
 
-static int mpc85xx_pci_err_remove(struct of_device *op)
+static int __devexit mpc85xx_pci_err_remove(struct of_device *op)
 {
 	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
-- 
1.5.6.5

