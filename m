Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZKBKHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZKBKHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZKBKHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Boaz Harrosh <bharrosh@panasas.com>,
       Benny Halevy <bhalevy@panasas.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Avishay Traeger <avishay@gmail.com>,
       osd-dev@open-osd.org
Subject: [PATCH 17/27] BKL: Remove BKL from exofs
Date: Mon,  2 Nov 2009 11:04:57 +0100
Message-Id: <1257156307-24175-18-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need the BKL in exofs.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/exofs/super.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index ea045b8..8358532 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -31,7 +31,6 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/vfs.h>
@@ -297,13 +296,10 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	struct osd_obj_id obj;
 	int ret;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
+
 	sb->s_fs_info = sbi;
 
 	/* use mount options to fill superblock */
@@ -403,7 +399,6 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 out:
 	if (or)
 		osd_end_request(or);
-	unlock_kernel();
 	return ret;
 
 free_sbi:
-- 
1.6.4.2

