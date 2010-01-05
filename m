Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517Ab0AEUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0AEUKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494Ab0AEUGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:21 -0500
Received: from kroah.org ([198.145.64.141]:50020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab0AEUGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:18 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:02 2010
Message-Id: <20100105200302.092124910@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Michele Jr De Candia <michele.decandia@valueteam.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [24/39] i2c/tsl2550: Fix lux value in extended mode
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michele Jr De Candia <michele.decandia@valueteam.com>

commit 5f5bfb09d81c9a1d26238ae6668e584c14ae3daf upstream.

According to the TAOS Application Note 'Controlling a Backlight with
the TSL2550 Ambient Light Sensor' (page 14), the actual lux value in
extended mode should be obtained multiplying the calculated lux value
by 5.

Signed-off-by: Michele Jr De Candia <michele.decandia@valueteam.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/chips/tsl2550.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -277,6 +277,7 @@ static DEVICE_ATTR(operating_mode, S_IWU
 
 static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
 {
+	struct tsl2550_data *data = i2c_get_clientdata(client);
 	u8 ch0, ch1;
 	int ret;
 
@@ -296,6 +297,8 @@ static ssize_t __tsl2550_show_lux(struct
 	ret = tsl2550_calculate_lux(ch0, ch1);
 	if (ret < 0)
 		return ret;
+	if (data->operating_mode == 1)
+		ret *= 5;
 
 	return sprintf(buf, "%d\n", ret);
 }


