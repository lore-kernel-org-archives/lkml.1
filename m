Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbZJAI3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbZJAI3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbZJAI3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56498 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbZJAI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Dave Jiang <djiang@mvista.com>, Kumar Gala <galak@kernel.crashing.org>,
       Yang Shi <yang.shi@windriver.com>
Subject: [PATCH 15/34] move mpc85xx_pci_err_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:19 +0200
Message-Id: <1254385718-14254-15-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
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
---
 drivers/edac/mpc85xx_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 157f650..ce6d759 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -304,7 +304,7 @@ err:
 	return res;
 }
 
-static int mpc85xx_pci_err_remove(struct of_device *op)
+static int __devexit mpc85xx_pci_err_remove(struct of_device *op)
 {
 	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
-- 
1.6.4.3

