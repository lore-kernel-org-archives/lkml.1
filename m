Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYBTIuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYBTIuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBTIuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:50:11 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26166 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYBTIuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:50:09 -0500
Date: Wed, 20 Feb 2008 11:49:03 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: [PATCH] 9p: fix oops on rmmod
Message-ID: <20080220084903.GD8367@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unloadable modules should just skip module_exit() hook ;-)

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 net/9p/trans_fd.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -459,14 +459,7 @@ static int __init p9_trans_fd_init(void)
 
 	return 1;
 }
-
-static void __exit p9_trans_fd_exit(void) {
-	printk(KERN_ERR "Removal of 9p transports not implemented\n");
-	BUG();
-}
-
 module_init(p9_trans_fd_init);
-module_exit(p9_trans_fd_exit);
 
 MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");

