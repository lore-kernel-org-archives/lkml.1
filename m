Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXE3PUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXE3PUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXE3PUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:20:31 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:58972
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750890AbXE3PUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:20:30 -0400
Date: Wed, 30 May 2007 17:22:12 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] fs/block_dev.c: use list_for_each_entry()
Message-ID: <20070530152212.GI14284@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/block_dev.c: Use list_for_each_entry() instead of list_for_each()
in nr_blockdev_pages()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7428992..a63faab 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -590,12 +590,10 @@ EXPORT_SYMBOL(bdget);
 
 long nr_blockdev_pages(void)
 {
-	struct list_head *p;
+	struct block_device *bdev;
 	long ret = 0;
 	spin_lock(&bdev_lock);
-	list_for_each(p, &all_bdevs) {
-		struct block_device *bdev;
-		bdev = list_entry(p, struct block_device, bd_list);
+	list_for_each_entry(bdev, &all_bdevs, bd_list) {
 		ret += bdev->bd_inode->i_mapping->nrpages;
 	}
 	spin_unlock(&bdev_lock);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

               If sharing a thing in no way diminishes it,
               it is not rightly owned if it is not shared
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
