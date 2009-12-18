Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZLRQB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZLRQB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZLRQB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:01:56 -0500
Received: from smtp.nokia.com ([192.100.122.230]:16935 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZLRQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:01:55 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: akpm@linux-foundation.org, david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, ext-jani.1.nikula@nokia.com
Subject: [PATCH] gpiolib: fix poll(2) support reconfigure on sysfs polarity change
Date: Fri, 18 Dec 2009 17:59:03 +0200
Message-Id: <1261151943-11863-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 18 Dec 2009 15:59:09.0984 (UTC) FILETIME=[091C2A00:01CA7FFB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Previously enabled poll(2) support on one edge was never reconfigured
when sysfs polarity change was triggered from kernel, because 'struct
device *dev' shadowed an earlier definition.

Found by sparse, which I should've run much earlier.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/gpiolib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a25ad28..350842a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -858,8 +858,6 @@ int gpio_sysfs_set_active_low(unsigned gpio, int value)
 	desc = &gpio_desc[gpio];
 
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
-		struct device *dev;
-
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev == NULL) {
 			status = -ENODEV;
-- 
1.6.5.2

