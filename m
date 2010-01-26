Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858Ab0AZRKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0AZRKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589Ab0AZRKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:10:51 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:35853 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab0AZRKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:10:51 -0500
Subject: [PATCH] drm/ttm: remove padding from ttm_ref_object on 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: David Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>
Cc: lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 17:10:48 +0000
Message-ID: <1264525848.2044.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-order structure ttm_ref_object to remove 8 bytes of alignment padding
on 64 bit builds, so shrinking its size from 72 to 64 bytes allowing it
to fit into a smaller slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against 2.6.33-rc5
compiled & tested on x86_64 AMDX2 and nouveau 
regards
Richard


diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
index 1099aba..75e9d6f 100644
--- a/drivers/gpu/drm/ttm/ttm_object.c
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -109,8 +109,8 @@ struct ttm_ref_object {
 	struct drm_hash_item hash;
 	struct list_head head;
 	struct kref kref;
-	struct ttm_base_object *obj;
 	enum ttm_ref_type ref_type;
+	struct ttm_base_object *obj;
 	struct ttm_object_file *tfile;
 };
 


