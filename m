Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbZKXVNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbZKXVNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933549AbZKXVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:13:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532AbZKXVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:31 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Vladimir Barinov <vova.barinov@gmail.com>,
       Vladimir Barinov <vbarinov@embeddedalley.com>,
       linux-mtd@lists.infradead.org, Eric Benard <ebenard@eukrea.com>
Subject: [PATCH 13/38] don't use __exit_p to wrap mxcnd_remove
Date: Tue, 24 Nov 2009 22:07:08 +0100
Message-Id: <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
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
 <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function mxcnd_remove is defined using __devexit, so don't use
__exit_p but __devexit_p to wrap it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Vladimir Barinov <vova.barinov@gmail.com>
Cc: Vladimir Barinov <vbarinov@embeddedalley.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Eric Benard <ebenard@eukrea.com>
---
 drivers/mtd/nand/mxc_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 65b26d5..661d46a 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1113,7 +1113,7 @@ static struct platform_driver mxcnd_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   },
-	.remove = __exit_p(mxcnd_remove),
+	.remove = __devexit_p(mxcnd_remove),
 	.suspend = mxcnd_suspend,
 	.resume = mxcnd_resume,
 };
-- 
1.6.5.2

