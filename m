Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017Ab0A0Ovv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0A0Ovv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741Ab0A0Ovu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:51:50 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:60794 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0A0Ovt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:51:49 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B60535F.5020400@cam.ac.uk>
Date: Wed, 27 Jan 2010 14:53:19 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, giometti@linux.it
Subject: [PATCH 2/2] als: tsl2550: Remove spurious check against a maximum
 lux value.
References: <4B23D029.9080004@cam.ac.uk>	<20100126105138.1006aaad@hyperion.delvare>	<4B5F38A3.1030208@cam.ac.uk>	<4B5F3961.3090103@jic23.retrosnub.co.uk>	<4B5F3AFE.7020404@cam.ac.uk> <20100127143659.784201ef@hyperion.delvare> <4B605000.8050500@jic23.retrosnub.co.uk> <4B6052A0.9090907@cam.ac.uk>
In-Reply-To: <4B6052A0.9090907@cam.ac.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

As Jean Delvare observed, this check is ineffective so lets clear it out whilst
we are working on this driver.

 drivers/als/tsl2550.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/als/tsl2550.c b/drivers/als/tsl2550.c
index b911e9c..27745a5 100644
--- a/drivers/als/tsl2550.c
+++ b/drivers/als/tsl2550.c
@@ -116,8 +116,6 @@ static int tsl2550_get_adc_value(struct i2c_client *client, u8 cmd)
  * of infrared level and visible light levels.
  */
 
-#define	TSL2550_MAX_LUX		1846
-
 static const u8 ratio_lut[] = {
 	100, 100, 100, 100, 100, 100, 100, 100,
 	100, 100, 100, 100, 100, 100, 99, 99,
@@ -187,8 +185,7 @@ static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
 	else
 		return -EAGAIN;
 
-	/* LUX range check */
-	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
+	return lux;
 }
 
 /*
-- 
1.6.4.4
