Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZGQUVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZGQUVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZGQUT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:59 -0400
Received: from kroah.org ([198.145.64.141]:43140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbZGQUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:37 2009
Message-Id: <20090717201237.635913901@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 22/24] fuse: fix bad return value in fuse_file_poll()
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=fuse-fix-bad-return-value-in-fuse_file_poll.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 201fa69a2849536ef2912e8e971ec0b01c04eff4 upstream.

Fix fuse_file_poll() which returned a -errno value instead of a poll
mask.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1867,7 +1867,7 @@ static unsigned fuse_file_poll(struct fi
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
-		return PTR_ERR(req);
+		return POLLERR;
 
 	req->in.h.opcode = FUSE_POLL;
 	req->in.h.nodeid = get_node_id(inode);


