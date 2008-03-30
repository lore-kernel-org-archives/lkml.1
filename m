Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYC3Xaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYC3Xaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYC3X3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:29:16 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55285 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662AbYC3X3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:29:15 -0400
Date: Mon, 31 Mar 2008 02:29:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Luca Risolia <luca.risolia@studio.unibo.it>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make sn9c102_i2c_try_write() static
Message-ID: <20080330232902.GC28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global sn9c102_i2c_try_write() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/sn9c102/sn9c102_core.c   |    6 +++---
 drivers/media/video/sn9c102/sn9c102_sensor.h |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

c8fdc53e6418519becd61f65a9039a47f189eebb diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index c40ba3a..8c52e11 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -464,9 +464,9 @@ sn9c102_i2c_try_read(struct sn9c102_device* cam,
 }
 
 
-int
-sn9c102_i2c_try_write(struct sn9c102_device* cam,
-		      const struct sn9c102_sensor* sensor, u8 address, u8 value)
+static int sn9c102_i2c_try_write(struct sn9c102_device* cam,
+				 const struct sn9c102_sensor* sensor,
+				 u8 address, u8 value)
 {
 	return sn9c102_i2c_try_raw_write(cam, sensor, 3,
 					 sensor->i2c_slave_id, address,
diff --git a/drivers/media/video/sn9c102/sn9c102_sensor.h b/drivers/media/video/sn9c102/sn9c102_sensor.h
index 2d7d786..98eac04 100644
--- a/drivers/media/video/sn9c102/sn9c102_sensor.h
+++ b/drivers/media/video/sn9c102/sn9c102_sensor.h
@@ -85,9 +85,6 @@ sn9c102_attach_sensor(struct sn9c102_device* cam,
 */
 
 /* The "try" I2C I/O versions are used when probing the sensor */
-extern int sn9c102_i2c_try_write(struct sn9c102_device*,
-				 const struct sn9c102_sensor*, u8 address,
-				 u8 value);
 extern int sn9c102_i2c_try_read(struct sn9c102_device*,
 				const struct sn9c102_sensor*, u8 address);
 

