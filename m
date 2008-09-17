Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYIQWWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYIQWWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIQWW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:22:27 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55046 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYIQWW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:22:26 -0400
Message-ID: <48D182EB.60407@euromail.se>
Date: Thu, 18 Sep 2008 00:21:31 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] hwmon: applesmc: Specified number of bytes to read should
 match actual
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.63
X-Scan-Result: No virus found in message 1Kg5Pl-0007CV-6T.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Kg5Pl-0007CV-6T 24ff15cbd1cd3e4841bf982b9bad6a31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At one single place in the code, the specified number of bytes to read
and the actual number of bytes read differ by one. This one-liner
patch fixes that inconsistency.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b06b8e0..b401975 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -325,7 +325,7 @@ static int applesmc_get_key_type(char* key, char* type)
 			return -EIO;
 	}

-	outb(5, APPLESMC_DATA_PORT);
+	outb(6, APPLESMC_DATA_PORT);

 	for (i = 0; i < 6; i++) {
 		if (__wait_status(0x05))
-- 
1.5.4.3


