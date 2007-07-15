Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbXGOTGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbXGOTGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXGOTGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:06:34 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33839
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281AbXGOTGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:06:33 -0400
Date: Sun, 15 Jul 2007 21:08:01 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: PATCH [5/5] fs/block_dev.c: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070715190801.GJ4034@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070715185409.GE4034@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715185409.GE4034@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/block_dev.c: use list_for_each_entry() instead of list_for_each()
in nr_blockdev_pages()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/block_dev.c b/fs/block_dev.c
index b3e9bfa..da5f051 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -588,12 +588,10 @@ EXPORT_SYMBOL(bdget);
 
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

  Si deseas mantener tu libertad, debes estar preparado para defenderla
                          (Richard Stallman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
