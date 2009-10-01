Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZJAIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZJAIb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZJAI3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56704 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbZJAI3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:48 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Vladimir Barinov <vova.barinov@gmail.com>,
       Vladimir Barinov <vbarinov@embeddedalley.com>,
       linux-mtd@lists.infradead.org
Subject: [PATCH 17/34] move mxcnd_remove to .exit.text
Date: Thu,  1 Oct 2009 10:28:21 +0200
Message-Id: <1254385718-14254-17-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function mxcnd_remove is used only wrapped by __exit_p so define it
using __exit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Vladimir Barinov <vova.barinov@gmail.com>
Cc: Vladimir Barinov <vbarinov@embeddedalley.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mtd/nand/mxc_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 65b26d5..ef3e199 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1052,7 +1052,7 @@ eclk:
 	return err;
 }
 
-static int __devexit mxcnd_remove(struct platform_device *pdev)
+static int __exit mxcnd_remove(struct platform_device *pdev)
 {
 	struct mxc_nand_host *host = platform_get_drvdata(pdev);
 
-- 
1.6.4.3

