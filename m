Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYA1Aeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYA1Aeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 19:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYA1AeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 19:34:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49832 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYA1AeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 19:34:09 -0500
Date: Sun, 27 Jan 2008 22:33:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>, Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 regression: VIDEO_DEV=y/m, I2C=n compile error
Message-ID: <20080127223334.696fce6e@gaivota>
In-Reply-To: <20080127185216.GB13300@does.not.exist>
References: <20080127185216.GB13300@does.not.exist>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian and Marcin,

On Sun, 27 Jan 2008 20:52:16 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> Commit 8ffbc6559493c64d6194c92d856196fdaeb8a5fb causes the following 
> compile error with CONFIG_VIDEO_DEV=y/m, CONFIG_I2C=n:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 26 modules
> ERROR: "i2c_attach_client" [drivers/media/video/v4l2-common.ko] undefined!
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->


Thanks for getting this regression. Please test the enclosed patch.


Cheers,
Mauro

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r b0815101889d linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Sun Jan 27 20:39:00 2008
-0200 +++ b/linux/drivers/media/video/v4l2-common.c	Sun Jan 27 22:23:25
2008 -0200 @@ -1585,6 +1585,7 @@ u32 v4l2_ctrl_next(const u32 * const * c
 	return **ctrl_classes;
 }
 
+#ifdef CONFIG_I2C
 int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32
match_chip) {
 	switch (match_type) {
@@ -1596,6 +1597,7 @@ int v4l2_chip_match_i2c_client(struct i2
 		return 0;
 	}
 }
+EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
 
 int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_chip_ident
*chip, u32 ident, u32 revision)
@@ -1612,6 +1614,7 @@ int v4l2_chip_ident_i2c_client(struct i2
 	}
 	return 0;
 }
+EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
 
 int v4l2_chip_match_host(u32 match_type, u32 match_chip)
 {
@@ -1622,6 +1625,7 @@ int v4l2_chip_match_host(u32 match_type,
 		return 0;
 	}
 }
+EXPORT_SYMBOL(v4l2_chip_match_host);
 
 /* ----------------------------------------------------------------- */
 
@@ -1656,6 +1660,8 @@ int v4l2_i2c_attach(struct i2c_adapter *
 	}
 	return err != -ENOMEM ? 0 : err;
 }
+EXPORT_SYMBOL(v4l2_i2c_attach);
+#endif
 
 /* ----------------------------------------------------------------- */
 
@@ -1679,15 +1685,3 @@ EXPORT_SYMBOL(v4l2_ctrl_query_menu);
 EXPORT_SYMBOL(v4l2_ctrl_query_menu);
 EXPORT_SYMBOL(v4l2_ctrl_query_fill);
 EXPORT_SYMBOL(v4l2_ctrl_query_fill_std);
-
-EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
-EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
-EXPORT_SYMBOL(v4l2_chip_match_host);
-
-EXPORT_SYMBOL(v4l2_i2c_attach);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
