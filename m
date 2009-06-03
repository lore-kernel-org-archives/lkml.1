Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZFCIRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZFCIRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZFCIRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:17:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60772 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbZFCIRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:17:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio sysfs: add a "toggle" value
Date: Wed,  3 Jun 2009 04:16:59 -0400
Message-Id: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/gpio/gpiolib.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..7f79732 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -274,7 +274,12 @@ static ssize_t gpio_value_store(struct device *dev,
 	else {
 		long		value;
 
-		status = strict_strtol(buf, 0, &value);
+		if (sysfs_streq(buf, "toggle")) {
+			value = !gpio_get_value_cansleep(gpio);
+			status = 0;
+		} else
+			status = strict_strtol(buf, 0, &value);
+
 		if (status == 0) {
 			gpio_set_value_cansleep(gpio, value != 0);
 			status = size;
-- 
1.6.3.1

