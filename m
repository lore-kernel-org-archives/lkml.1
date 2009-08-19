Return-Path: <linux-kernel-owner+w=401wt.eu-S1751361AbZHSQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbZHSQ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZHSQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:56:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38069 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbZHSQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:56:37 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] pohmelfs: fix type errors
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 19 Aug 2009 17:52:08 +0100
Message-ID: <20090819165207.14632.3743.stgit@localhost.localdomain>
In-Reply-To: <20090819165201.14632.96567.stgit@localhost.localdomain>
References: <20090819165201.14632.96567.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/pohmelfs/config.c |    3 +--
 drivers/staging/pohmelfs/dir.c    |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index a6eaa42..99ae1d9 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -446,9 +446,8 @@ out_unlock:
 	return err;
 }
 
-static void pohmelfs_cn_callback(void *data)
+static void pohmelfs_cn_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = data;
 	int err;
 
 	switch (msg->flags) {
diff --git a/drivers/staging/pohmelfs/dir.c b/drivers/staging/pohmelfs/dir.c
index 4c58e22..4c63a4c 100644
--- a/drivers/staging/pohmelfs/dir.c
+++ b/drivers/staging/pohmelfs/dir.c
@@ -412,7 +412,7 @@ static int pohmelfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 				__func__, file->f_pos, pi->ino, n->data, n->len,
 				n->ino, n->mode, mode, file->f_pos, n->hash);
 
-		file->private_data = (void *)n->hash;
+		file->private_data = (void *)(unsigned long)n->hash;
 
 		len = n->len;
 		err = filldir(dirent, n->data, n->len, file->f_pos, n->ino, mode);

