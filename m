Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbZJMHIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbZJMHIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933529AbZJMHIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:08:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51529 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbZJMHIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:08:53 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Alan Cox <alan@linux.intel.com>
Subject: [PATCH] serial/atmel_serial: Fix another fallout of the change to BUILD_BUG_ON
Date: Tue, 13 Oct 2009 09:08:00 +0200
Message-Id: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
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

Commit 8c87df457cb5 fixed BUILD_BUG_ON with the result that some
expressions (e.g. "not really constant" ones) result in a build failure.

Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Alan Cox <alan@linux.intel.com>
---
Hello,

currently 27 arm defconfigs fail because of that error, see

	http://armlinux.simtec.co.uk/kautobuild/2.6.32-rc4-git1/errors.html

Best regards
Uwe

 drivers/serial/atmel_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 3551c5c..b37d75f 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1531,7 +1531,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	void *data;
 	int ret;
 
-	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
+	MAYBE_BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
 
 	port = &atmel_ports[pdev->id];
 	port->backup_imr = 0;
-- 
1.6.4.3

