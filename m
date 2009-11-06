Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbZKFWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbZKFWbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760199AbZKFWbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:31:18 -0500
Received: from kroah.org ([198.145.64.141]:57009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbZKFWXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:17 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.727479100@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>, Miklos Szeredi <mszeredi@suse.cz>,
       Tejun Heo <tj@kernel.org>
Subject: [65/99] fuse: fix kunmap in fuse_ioctl_copy_user
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=fuse-fix-kunmap-in-fuse_ioctl_copy_user.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jens Axboe <jens.axboe@oracle.com>

commit 0bd87182d3ab18a32a8e9175d3f68754c58e3432 upstream.

Looks like another victim of the confusing kmap() vs kmap_atomic() API
differences.

Reported-by: Todor Gyumyushev <yodor1@gmail.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1600,7 +1600,7 @@ static int fuse_ioctl_copy_user(struct p
 			kaddr += copy;
 		}
 
-		kunmap(map);
+		kunmap(page);
 	}
 
 	return 0;


