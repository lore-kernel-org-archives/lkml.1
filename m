Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZGKHuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZGKHuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGKHun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:50:43 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39102 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZGKHum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:50:42 -0400
Date: Sat, 11 Jul 2009 09:50:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/gpu: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907110949490.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/drm_stub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -489,7 +489,7 @@ int drm_put_minor(struct drm_minor **min
  */
 void drm_put_dev(struct drm_device *dev)
 {
-	struct drm_driver *driver = dev->driver;
+	struct drm_driver *driver;
 	struct drm_map_list *r_list, *list_temp;
 
 	DRM_DEBUG("\n");
@@ -498,6 +498,7 @@ void drm_put_dev(struct drm_device *dev)
 		DRM_ERROR("cleanup called no dev\n");
 		return;
 	}
+	driver = dev->driver;
 
 	drm_vblank_cleanup(dev);
 
