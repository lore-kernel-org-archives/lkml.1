Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377Ab0AJMkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0AJMkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207Ab0AJMkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:40:10 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64609 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0AJMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:40:08 -0500
X-Authuid: nmarci
Message-ID: <4B49CAA2.3000601@freemail.hu>
Date: Sun, 10 Jan 2010 13:40:02 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 5/5] block: make virtio device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct virtio_driver is constant in <linux/virtio.h>
so it is worth to make id_table also constant.

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

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/block/virtio_blk.c 2010-01-08 09:30:00.000000000 +0100
@@ -404,7 +404,7 @@ static void __devexit virtblk_remove(str
 	kfree(vblk);
 }

-static struct virtio_device_id id_table[] = {
+static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
