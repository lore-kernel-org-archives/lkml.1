Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0AOBit (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897Ab0AOBis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:38:48 -0500
Received: from kroah.org ([198.145.64.141]:50983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab0AOBis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:38:48 -0500
Subject: patch staging-make-i2c-device-id-constant.patch added to gregkh-2.6 tree
To: nm127@freemail.hu, gregkh@suse.de, julia@diku.dk,
        linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 14 Jan 2010 17:36:46 -0800
In-Reply-To: <4B490ED1.6090705@freemail.hu>
Message-ID: <12635194063606@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: make i2c device id constant

to my gregkh-2.6 tree.  Its filename is

    staging-make-i2c-device-id-constant.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From nm127@freemail.hu  Thu Jan 14 17:10:22 2010
From: Németh Márton <nm127@freemail.hu>
Date: Sun, 10 Jan 2010 00:18:41 +0100
Subject: staging: make i2c device id constant
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Julia Lawall <julia@diku.dk>, LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Message-ID: <4B490ED1.6090705@freemail.hu>


From: Németh Márton <nm127@freemail.hu>

The id_table field of the struct i2c_driver is constant in <linux/i2c.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Németh Márton <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/go7007/s2250-board.c    |    2 +-
 drivers/staging/go7007/wis-ov7640.c     |    2 +-
 drivers/staging/go7007/wis-saa7113.c    |    2 +-
 drivers/staging/go7007/wis-saa7115.c    |    2 +-
 drivers/staging/go7007/wis-sony-tuner.c |    2 +-
 drivers/staging/go7007/wis-tw2804.c     |    2 +-
 drivers/staging/go7007/wis-tw9903.c     |    2 +-
 drivers/staging/go7007/wis-uda1342.c    |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/staging/go7007/s2250-board.c
+++ b/drivers/staging/go7007/s2250-board.c
@@ -667,7 +667,7 @@ static int s2250_remove(struct i2c_clien
 	return 0;
 }
 
-static struct i2c_device_id s2250_id[] = {
+static const struct i2c_device_id s2250_id[] = {
 	{ "s2250", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-ov7640.c
+++ b/drivers/staging/go7007/wis-ov7640.c
@@ -77,7 +77,7 @@ static int wis_ov7640_remove(struct i2c_
 	return 0;
 }
 
-static struct i2c_device_id wis_ov7640_id[] = {
+static const struct i2c_device_id wis_ov7640_id[] = {
 	{ "wis_ov7640", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-saa7113.c
+++ b/drivers/staging/go7007/wis-saa7113.c
@@ -304,7 +304,7 @@ static int wis_saa7113_remove(struct i2c
 	return 0;
 }
 
-static struct i2c_device_id wis_saa7113_id[] = {
+static const struct i2c_device_id wis_saa7113_id[] = {
 	{ "wis_saa7113", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-saa7115.c
+++ b/drivers/staging/go7007/wis-saa7115.c
@@ -437,7 +437,7 @@ static int wis_saa7115_remove(struct i2c
 	return 0;
 }
 
-static struct i2c_device_id wis_saa7115_id[] = {
+static const struct i2c_device_id wis_saa7115_id[] = {
 	{ "wis_saa7115", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-sony-tuner.c
+++ b/drivers/staging/go7007/wis-sony-tuner.c
@@ -688,7 +688,7 @@ static int wis_sony_tuner_remove(struct 
 	return 0;
 }
 
-static struct i2c_device_id wis_sony_tuner_id[] = {
+static const struct i2c_device_id wis_sony_tuner_id[] = {
 	{ "wis_sony_tuner", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-tw2804.c
+++ b/drivers/staging/go7007/wis-tw2804.c
@@ -327,7 +327,7 @@ static int wis_tw2804_remove(struct i2c_
 	return 0;
 }
 
-static struct i2c_device_id wis_tw2804_id[] = {
+static const struct i2c_device_id wis_tw2804_id[] = {
 	{ "wis_tw2804", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-tw9903.c
+++ b/drivers/staging/go7007/wis-tw9903.c
@@ -309,7 +309,7 @@ static int wis_tw9903_remove(struct i2c_
 	return 0;
 }
 
-static struct i2c_device_id wis_tw9903_id[] = {
+static const struct i2c_device_id wis_tw9903_id[] = {
 	{ "wis_tw9903", 0 },
 	{ }
 };
--- a/drivers/staging/go7007/wis-uda1342.c
+++ b/drivers/staging/go7007/wis-uda1342.c
@@ -82,7 +82,7 @@ static int wis_uda1342_remove(struct i2c
 	return 0;
 }
 
-static struct i2c_device_id wis_uda1342_id[] = {
+static const struct i2c_device_id wis_uda1342_id[] = {
 	{ "wis_uda1342", 0 },
 	{ }
 };

