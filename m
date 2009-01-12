Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZALN6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZALN6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZALNyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:54:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49811 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbZALNyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:54:12 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:52:26 +0100
Message-Id: <1231768351-30502-19-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move stli_pciremove to .devexit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function stli_pciremove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/istallion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 5c3dc6b..41f42eb 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -3802,7 +3802,7 @@ err:
 	return retval;
 }
 
-static void stli_pciremove(struct pci_dev *pdev)
+static void __devexit stli_pciremove(struct pci_dev *pdev)
 {
 	struct stlibrd *brdp = pci_get_drvdata(pdev);
 
-- 
1.5.6.5

