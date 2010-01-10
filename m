Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356Ab0AJMkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0AJMkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890Ab0AJMj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:39:58 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61201 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0AJMj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:39:57 -0500
X-Authuid: nmarci
Message-ID: <4B49CA98.50801@freemail.hu>
Date: Sun, 10 Jan 2010 13:39:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 4/5] block: make xenbus device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The ids field of the struct xenbus_device_id is constant in <linux/xen/xenbus.h>
so it is worth to make blkfront_ids also constant.

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
diff -u -p a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c 2010-01-07 19:08:39.000000000 +0100
+++ b/drivers/block/xen-blkfront.c 2010-01-08 09:28:49.000000000 +0100
@@ -1050,7 +1050,7 @@ static const struct block_device_operati
 };


-static struct xenbus_device_id blkfront_ids[] = {
+static const struct xenbus_device_id blkfront_ids[] = {
 	{ "vbd" },
 	{ "" }
 };
