Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXFCUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXFCUz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXFCUyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:54:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52709 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753982AbXFCUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:54:35 -0400
Date: Sun, 3 Jun 2007 22:54:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: [-mm patch] fix the tea5761 tuner support
Message-ID: <20070603205437.GR5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc2-mm1:
>...
>  git-dvb.patch
>...
>  git trees
>...

Due to a typo the tea5761 tuner support was dead code.

This patch also fixes a bug in the no longer dead code:
A void function can't return anything.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/tuner-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc3-mm1/drivers/media/video/tuner-core.c.old	2007-06-03 22:29:37.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/media/video/tuner-core.c	2007-06-03 22:35:54.000000000 +0200
@@ -25,7 +25,7 @@
 
 /* standard i2c insmod options */
 static unsigned short normal_i2c[] = {
-#ifdef CONFIG_TUNER_5761
+#ifdef CONFIG_TUNER_TEA5761
 	0x10,
 #endif
 	0x42, 0x43, 0x4a, 0x4b,			/* tda8290 */
@@ -192,12 +192,12 @@ static void set_type(struct i2c_client *
 		}
 		t->mode_mask = T_RADIO;
 		break;
-#ifdef CONFIG_TUNER_5761
+#ifdef CONFIG_TUNER_TEA5761
 	case TUNER_TEA5761:
 		if (tea5761_tuner_init(c) == EINVAL) {
 			t->type = TUNER_ABSENT;
 			t->mode_mask = T_UNINITIALIZED;
-			return -ENODEV;
+			return;
 		}
 		t->mode_mask = T_RADIO;
 		break;
@@ -473,7 +473,7 @@ static int tuner_attach(struct i2c_adapt
 	/* autodetection code based on the i2c addr */
 	if (!no_autodetect) {
 		switch (addr) {
-#ifdef CONFIG_TUNER_5761
+#ifdef CONFIG_TUNER_TEA5761
 		case 0x10:
 			if (tea5761_autodetection(&t->i2c) != EINVAL) {
 				t->type = TUNER_TEA5761;
