Return-Path: <linux-kernel-owner+w=401wt.eu-S1751522AbZL0V1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbZL0V1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZL0V1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:27:34 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47754 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZL0V1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:27:31 -0500
Date: Sun, 27 Dec 2009 22:27:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/gpu: Correct NULL test
Message-ID: <Pine.LNX.4.64.0912272227130.20548@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/nouveau/nouveau_grctx.c        |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_grctx.c b/drivers/gpu/drm/nouveau/nouveau_grctx.c
index 419f4c2..c7ebec6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_grctx.c
+++ b/drivers/gpu/drm/nouveau/nouveau_grctx.c
@@ -97,8 +97,8 @@ nouveau_grctx_prog_load(struct drm_device *dev)
 		}
 
 		pgraph->ctxvals = kmalloc(fw->size, GFP_KERNEL);
-		if (!pgraph->ctxprog) {
-			NV_ERROR(dev, "OOM copying ctxprog\n");
+		if (!pgraph->ctxvals) {
+			NV_ERROR(dev, "OOM copying ctxvals\n");
 			release_firmware(fw);
 			nouveau_grctx_fini(dev);
 			return -ENOMEM;
