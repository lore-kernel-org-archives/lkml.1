Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbYBNFzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbYBNFzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYBNFyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:54:54 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:48072 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752824AbYBNFyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:54:53 -0500
Date: Thu, 14 Feb 2008 14:53:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] video: Fix v4l2 build with CONFIG_I2C=n.
Message-ID: <20080214055341.GC12436@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/built-in.o: In function `v4l2_i2c_attach':
/home/pmundt/devel/git/sh-2.6.25/drivers/media/video/v4l2-common.c:1040: undefined reference to `i2c_attach_client'
make: *** [.tmp_vmlinux1] Error 1

The v4l2-common code contains a number of i2c helpers which are built in
unconditionally, despite the fact that the i2c routines it references are
not. Move these under a CONFIG_I2C.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/media/video/v4l2-common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index c056ff6..0e00531 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -973,6 +973,7 @@ u32 v4l2_ctrl_next(const u32 * const * ctrl_classes, u32 id)
 	return **ctrl_classes;
 }
 
+#ifdef CONFIG_I2C
 int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32 match_chip)
 {
 	switch (match_type) {
@@ -984,6 +985,7 @@ int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32 match_c
 		return 0;
 	}
 }
+EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
 
 int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_chip_ident *chip,
 		u32 ident, u32 revision)
@@ -1000,6 +1002,7 @@ int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_chip_ident *chi
 	}
 	return 0;
 }
+EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
 
 int v4l2_chip_match_host(u32 match_type, u32 match_chip)
 {
@@ -1010,6 +1013,7 @@ int v4l2_chip_match_host(u32 match_type, u32 match_chip)
 		return 0;
 	}
 }
+EXPORT_SYMBOL(v4l2_chip_match_host);
 
 /* ----------------------------------------------------------------- */
 
@@ -1038,6 +1042,8 @@ int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver
 	}
 	return err != -ENOMEM ? 0 : err;
 }
+EXPORT_SYMBOL(v4l2_i2c_attach);
+#endif /* CONFIG_I2C */
 
 /* ----------------------------------------------------------------- */
 
@@ -1062,12 +1068,6 @@ EXPORT_SYMBOL(v4l2_ctrl_query_menu);
 EXPORT_SYMBOL(v4l2_ctrl_query_fill);
 EXPORT_SYMBOL(v4l2_ctrl_query_fill_std);
 
-EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
-EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
-EXPORT_SYMBOL(v4l2_chip_match_host);
-
-EXPORT_SYMBOL(v4l2_i2c_attach);
-
 /*
  * Local variables:
  * c-basic-offset: 8
