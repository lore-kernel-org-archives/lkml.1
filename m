Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbXJLQCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbXJLQCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXJLQBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:01:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:53865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbXJLQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:01:39 -0400
Message-Id: <20071012155019.985151100@hasse.suse.de>
References: <20071012155019.747515889@hasse.suse.de>
User-Agent: quilt/0.46-62.1
Date: Fri, 12 Oct 2007 17:50:20 +0200
From: Jan Blunck <jblunck@suse.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch 1/2] r/o bind mounts: Dont touch the vfsmount after path_put()
Content-Disposition: inline; filename=vfs/r-o-af_unix-bind-mnt_drop_write-fix.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mnt_drop_write() is called after releasing the reference to the path with
path_put().

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/net/unix/af_unix.c
===================================================================
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -752,8 +752,8 @@ static struct sock *unix_find_other(stru
 		if (u->sk_type == type)
 			touch_atime(nd.path.mnt, nd.path.dentry);
 
-		path_put(&nd.path);
 		mnt_drop_write(nd.path.mnt);
+		path_put(&nd.path);
 
 		err=-EPROTOTYPE;
 		if (u->sk_type != type) {

-- 

