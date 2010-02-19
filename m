Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0BSRNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:13:53 -0500
Received: from kroah.org ([198.145.64.141]:57491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0BSRAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:30 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:39 2010
Message-Id: <20100219163239.223544465@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [31/93] NFS: Fix a reference leak in nfs_wb_cancel_page()
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c9edda7140ec6a22accf7f2f86da362dfbfd41fc upstream.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1542,6 +1542,7 @@ int nfs_wb_page_cancel(struct inode *ino
 			break;
 		}
 		ret = nfs_wait_on_request(req);
+		nfs_release_request(req);
 		if (ret < 0)
 			goto out;
 	}


