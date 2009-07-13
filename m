Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZGMV2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZGMV2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbZGMV2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:28:07 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50006 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311AbZGMV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:28:05 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] GPU: drm_debugfs, check kmalloc retval
Date: Mon, 13 Jul 2009 23:20:20 +0200
Message-Id: <1247520021-31684-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kmalloc return value in drm_debugfs_create_files and bail out
appropriately if the pointer is NULL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/gpu/drm/drm_debugfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 2960b6d..9903f27 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -101,6 +101,10 @@ int drm_debugfs_create_files(struct drm_info_list *files, int count,
 			continue;
 
 		tmp = kmalloc(sizeof(struct drm_info_node), GFP_KERNEL);
+		if (tmp == NULL) {
+			ret = -1;
+			goto fail;
+		}
 		ent = debugfs_create_file(files[i].name, S_IFREG | S_IRUGO,
 					  root, tmp, &drm_debugfs_fops);
 		if (!ent) {
-- 
1.6.3.2

