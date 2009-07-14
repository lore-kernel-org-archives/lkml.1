Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZGNRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZGNRLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZGNRLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:11:04 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:49989 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZGNRLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:11:02 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: me@felipe.balbi.com
Cc: linux-kernel@vger.kernel.org, rpurdie@linux.intel.com, rpurdie@rpsys.net,
       srcvale@holoscopio.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 3/3] After setting inverted attribute, we must update the LED.
Date: Tue, 14 Jul 2009 14:03:35 -0300
Message-Id: <1247591015-2428-3-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247591015-2428-2-git-send-email-cascardo@holoscopio.com>
References: <1247591015-2428-1-git-send-email-cascardo@holoscopio.com>
 <1247591015-2428-2-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we change the inverted attribute to another value, the LED will not
be inverted until we change the GPIO state.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/leds/ledtrig-gpio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index 7c9aff9..1136f50 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -117,6 +117,9 @@ static ssize_t gpio_trig_inverted_store(struct device *dev,
 
 	gpio_data->inverted = !!inverted;
 
+	/* After inverting, we need to update the LED. */
+	schedule_work(&gpio_data->work);
+
 	return n;
 }
 static DEVICE_ATTR(inverted, 0644, gpio_trig_inverted_show,
-- 
1.6.3.3

