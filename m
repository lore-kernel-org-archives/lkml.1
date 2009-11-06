Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbZKFWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbZKFWrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760071AbZKFWWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:23 -0500
Received: from kroah.org ([198.145.64.141]:56633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759986AbZKFWWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:39 2009
Message-Id: <20091106221539.517497730@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [06/99] nfs: Fix nfs_parse_mount_options() kfree() leak
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=nfs-fix-nfs_parse_mount_options-kfree-leak.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yinghai Lu <yinghai@kernel.org>

commit 4223a4a155f245d41c350ed9eba4fc32e965c4da upstream.

Fix a (small) memory leak in one of the error paths of the NFS mount
options parsing code.

Regression introduced in 2.6.30 by commit a67d18f (NFS: load the
rpc/rdma transport module automatically).

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1323,6 +1323,7 @@ static int nfs_parse_mount_options(char 
 			default:
 				dfprintk(MOUNT, "NFS:   unrecognized "
 						"transport protocol\n");
+				kfree(string);
 				return 0;
 			}
 			break;


