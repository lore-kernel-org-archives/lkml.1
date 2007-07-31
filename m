Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbXGaTOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbXGaTOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGaTOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:14:33 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1334 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbXGaTOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:14:32 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 51] drivers/media/video/msp3400-driver.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 21:14:31 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312114.31646.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/media/video/msp3400-driver.c | 28945 -> 28898 (-47 bytes)
 drivers/media/video/msp3400-driver.o | 125620 -> 125320 (-300 bytes)

 drivers/media/video/msp3400-driver.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/media/video/msp3400-driver.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/media/video/msp3400-driver.c	2007-07-31 13:22:34.000000000 +0200
@@ -813,8 +813,9 @@ static int msp_attach(struct i2c_adapter
 	int msp_rom;

 	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (client == NULL)
+	if (!client)
 		return -ENOMEM;
+
 	client->addr = address;
 	client->adapter = adapter;
 	client->driver = &i2c_driver;
@@ -826,14 +827,14 @@ static int msp_attach(struct i2c_adapter
 		return 0;
 	}

-	state = kmalloc(sizeof(*state), GFP_KERNEL);
-	if (state == NULL) {
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state) {
 		kfree(client);
 		return -ENOMEM;
 	}
+
 	i2c_set_clientdata(client, state);

-	memset(state, 0, sizeof(*state));
 	state->v4l2_std = V4L2_STD_NTSC;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
 	state->volume = 58880;	/* 0db gain */
