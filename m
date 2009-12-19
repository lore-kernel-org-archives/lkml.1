Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbZLSHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbZLSHQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZLSHQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:16:18 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34248 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZLSHQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:16:16 -0500
Date: Sat, 19 Dec 2009 08:16:13 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ecashin@coraid.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/7] drivers/block/aoe: Use kzalloc for allocating only one
 thing
Message-ID: <Pine.LNX.4.64.0912190815550.30546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/block/aoe/aoecmd.c |    2 +-
 drivers/block/aoe/aoedev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c 2009-12-08 20:58:27.000000000 +0100
+++ b/drivers/block/aoe/aoecmd.c 2009-12-19 07:52:28.000000000 +0100
@@ -954,7 +954,7 @@ addtgt(struct aoedev *d, char *addr, ulo
 			"aoe: device addtgt failure; too many targets\n");
 		return NULL;
 	}
-	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
+	t = kzalloc(sizeof *t, GFP_ATOMIC);
 	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
 	if (!t || !f) {
 		kfree(f);
diff -u -p a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c 2009-09-14 14:55:49.000000000 +0200
+++ b/drivers/block/aoe/aoedev.c 2009-12-19 07:52:28.000000000 +0100
@@ -211,7 +211,7 @@ aoedev_by_sysminor_m(ulong sysminor)
 			break;
 	if (d)
 		goto out;
-	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
+	d = kzalloc(sizeof *d, GFP_ATOMIC);
 	if (!d)
 		goto out;
 	INIT_WORK(&d->work, aoecmd_sleepwork);
