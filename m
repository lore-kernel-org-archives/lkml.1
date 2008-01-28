Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbYA1WNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbYA1WNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759363AbYA1WKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:24 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52234 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256AbYA1WKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:22 -0500
Date: Tue, 29 Jan 2008 00:10:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] video/em28xx/: make 2 functions static
Message-ID: <20080128221048.GR8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- em28xx-core.c:em28xx_write_reg_bits()
- em28xx-video.c:em28xx_vdev_init()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/em28xx/em28xx-core.c  |    2 +-
 drivers/media/video/em28xx/em28xx-video.c |    8 ++++----
 drivers/media/video/em28xx/em28xx.h       |    2 --
 3 files changed, 5 insertions(+), 7 deletions(-)

b9852586183bf6b2b8cd410e594c4a1e13bd44b4 
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index f6b7835..41ed4be 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -237,7 +237,7 @@ int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len)
  * sets only some bits (specified by bitmask) of a register, by first reading
  * the actual value
  */
-int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
+static int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 				 u8 bitmask)
 {
 	int oldval;
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index a0c3346..c412605 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1796,10 +1796,10 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
-struct video_device *em28xx_vdev_init(struct em28xx *dev,
-				      const struct video_device *template,
-				      const int type,
-				      const char *type_name)
+static struct video_device *em28xx_vdev_init(struct em28xx *dev,
+					     const struct video_device *template,
+					     const int type,
+					     const char *type_name)
 {
 	struct video_device *vfd;
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index f3bad0c..9759a73 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -345,8 +345,6 @@ int em28xx_read_reg(struct em28xx *dev, u16 reg);
 int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			  int len);
 int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len);
-int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
-			  u8 bitmask);
 int em28xx_set_audio_source(struct em28xx *dev);
 int em28xx_audio_analog_set(struct em28xx *dev);
 

