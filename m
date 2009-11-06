Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbZKFWks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbZKFWks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbZKFWWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:38 -0500
Received: from kroah.org ([198.145.64.141]:56736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314AbZKFWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.441256753@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zdenek Kabelac <zkabelac@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [21/99] dm: add missing del_gendisk to alloc_dev error path
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-add-missing-del_gendisk-to-alloc_dev-error-path.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zdenek Kabelac <zkabelac@redhat.com>

commit 03022c54b9725026c0370a810168975c387ad04c upstream.

Add missing del_gendisk() to error path when creation of workqueue fails.
Otherwice there is a resource leak and following warning is shown:

WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xc5/0x160()
sysfs: cannot create duplicate filename '/devices/virtual/block/dm-0'

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1819,6 +1819,7 @@ static struct mapped_device *alloc_dev(i
 bad_bdev:
 	destroy_workqueue(md->wq);
 bad_thread:
+	del_gendisk(md->disk);
 	put_disk(md->disk);
 bad_disk:
 	blk_cleanup_queue(md->queue);


