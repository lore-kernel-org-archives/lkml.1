Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbZKFWbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbZKFWbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZKFWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:31:43 -0500
Received: from kroah.org ([198.145.64.141]:57002 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539AbZKFWXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:16 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.581202341@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Anand V. Avati" <avati@gluster.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [64/99] fuse: prevent fuse_put_request on invalid pointer
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=fuse-prevent-fuse_put_request-on-invalid-pointer.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Anand V. Avati <avati@gluster.com>

commit f60311d5f7670d9539b424e4ed8b5c0872fc9e83 upstream.

fuse_direct_io() has a loop where requests are allocated in each
iteration. if allocation fails, the loop is broken out and follows
into an unconditional fuse_put_request() on that invalid pointer.

Signed-off-by: Anand V. Avati <avati@gluster.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1063,7 +1063,8 @@ ssize_t fuse_direct_io(struct file *file
 				break;
 		}
 	}
-	fuse_put_request(fc, req);
+	if (!IS_ERR(req))
+		fuse_put_request(fc, req);
 	if (res > 0)
 		*ppos = pos;
 


