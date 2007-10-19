Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbXJSOFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbXJSOFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXJSOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:04:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38544 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932857AbXJSOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:04:50 -0400
Date: Fri, 19 Oct 2007 16:05:18 +0200
From: Adrian Bunk <bunk@kernel.org>
To: miklos@szeredi.hu
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fuse_file_alloc(): fix NULL dereferences
Message-ID: <20071019140518.GE3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes obvious NULL dereferences spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
53b7c67ef9b6c26a0c7f554fef43021633a48ab7 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 0fcdba9..535b373 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -55,9 +55,10 @@ struct fuse_file *fuse_file_alloc(void)
 		if (!ff->reserved_req) {
 			kfree(ff);
 			ff = NULL;
+		} else {
+			INIT_LIST_HEAD(&ff->write_entry);
+			atomic_set(&ff->count, 0);
 		}
-		INIT_LIST_HEAD(&ff->write_entry);
-		atomic_set(&ff->count, 0);
 	}
 	return ff;
 }

