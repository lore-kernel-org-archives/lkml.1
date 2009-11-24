Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbZKXVIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbZKXVIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933657AbZKXVIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:08:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbZKXVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:14 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 03/38] move excite_nand_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:06:58 +0100
Message-Id: <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function excite_nand_remove is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/excite_nandflash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/excite_nandflash.c b/drivers/mtd/nand/excite_nandflash.c
index 72446fb..af6a6a5 100644
--- a/drivers/mtd/nand/excite_nandflash.c
+++ b/drivers/mtd/nand/excite_nandflash.c
@@ -128,7 +128,7 @@ static int excite_nand_devready(struct mtd_info *mtd)
  * The binding to the mtd and all allocated
  * resources are released.
  */
-static int __exit excite_nand_remove(struct platform_device *dev)
+static int __devexit excite_nand_remove(struct platform_device *dev)
 {
 	struct excite_nand_drvdata * const this = platform_get_drvdata(dev);
 
-- 
1.6.5.2

