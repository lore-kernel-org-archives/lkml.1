Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab0BDRWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:14 -0500
Received: from kroah.org ([198.145.64.141]:34697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142Ab0BDRVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:50 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:04 2010
Message-Id: <20100204171503.743943291@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [27/74] Fix failure exit in ipathfs
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 12e9a45609054fb83d4a8b716a5265cc1a393e10 upstream.

deactivate_locked_super() will be done by caller of fill_super, doing
it there as well is b0rken.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/ipath/ipath_fs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -346,10 +346,8 @@ static int ipathfs_fill_super(struct sup
 	list_for_each_entry_safe(dd, tmp, &ipath_dev_list, ipath_list) {
 		spin_unlock_irqrestore(&ipath_devs_lock, flags);
 		ret = create_device_files(sb, dd);
-		if (ret) {
-			deactivate_locked_super(sb);
+		if (ret)
 			goto bail;
-		}
 		spin_lock_irqsave(&ipath_devs_lock, flags);
 	}
 


