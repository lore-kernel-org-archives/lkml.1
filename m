Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZERH52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZERH52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZERH5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:57:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39981 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZERH5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:57:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Juergen Beisert <j.beisert@pengutronix.de>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] gpio: max7301: add missing __devexit marking
Date: Mon, 18 May 2009 03:57:08 -0400
Message-Id: <1242633428-16460-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove member of the spi_driver max7301_driver uses __devexit_p(),
so the remove function itself should be marked with __devexit.  Even
more so considering the probe function is marked with __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Juergen Beisert <j.beisert@pengutronix.de>
CC: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/gpio/max7301.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/max7301.c b/drivers/gpio/max7301.c
index 3e7f4e0..7b82eaa 100644
--- a/drivers/gpio/max7301.c
+++ b/drivers/gpio/max7301.c
@@ -287,7 +287,7 @@ exit_destroy:
 	return ret;
 }
 
-static int max7301_remove(struct spi_device *spi)
+static int __devexit max7301_remove(struct spi_device *spi)
 {
 	struct max7301 *ts;
 	int ret;
-- 
1.6.3

