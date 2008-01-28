Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbYA1WN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbYA1WN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbYA1WKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:33 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47979 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760251AbYA1WKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:31 -0500
Date: Tue, 29 Jan 2008 00:10:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] stk-sensor.c: make 2 functions static
Message-ID: <20080128221058.GT8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- stk_sensor_outb()
- stk_sensor_inb()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/stk-sensor.c |    4 ++--
 drivers/media/video/stk-webcam.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

8e641823e6d54c8d45f6406bcd6716cbed81cb4e 
diff --git a/drivers/media/video/stk-sensor.c b/drivers/media/video/stk-sensor.c
index 4a9a0b6..1ce8cc8 100644
--- a/drivers/media/video/stk-sensor.c
+++ b/drivers/media/video/stk-sensor.c
@@ -225,7 +225,7 @@
 
 
 /* Returns 0 if OK */
-int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
+static int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
 {
 	int i = 0;
 	int tmpval = 0;
@@ -250,7 +250,7 @@ int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
 		return 0;
 }
 
-int stk_sensor_inb(struct stk_camera *dev, u8 reg, u8 *val)
+static int stk_sensor_inb(struct stk_camera *dev, u8 reg, u8 *val)
 {
 	int i = 0;
 	int tmpval = 0;
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
index 7e989d1..bc9ce78 100644
--- a/drivers/media/video/stk-webcam.h
+++ b/drivers/media/video/stk-webcam.h
@@ -127,8 +127,6 @@ void stk_camera_delete(struct kref *);
 int stk_camera_write_reg(struct stk_camera *, u16, u8);
 int stk_camera_read_reg(struct stk_camera *, u16, int *);
 
-int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val);
-int stk_sensor_inb(struct stk_camera *dev, u8 reg, u8 *val);
 int stk_sensor_init(struct stk_camera *);
 int stk_sensor_configure(struct stk_camera *);
 int stk_sensor_sleep(struct stk_camera *dev);

