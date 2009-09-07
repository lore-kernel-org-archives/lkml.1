Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZIGVDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZIGVDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZIGVDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbZIGVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:03:17 -0400
Date: Mon, 7 Sep 2009 14:02:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 1/8] Do not call 'ima_path_check()' for each path component
In-Reply-To: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 10:05:33 -0700

Not only is that a supremely timing-critical path, but it's hopefully some 
day going to be lockless for the common case, and ima can't do that.

Plus the integrity code doesn't even care about non-regular files,
so it was always a total waste of time and effort.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/namei.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f3c5b27..164aa15 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -856,9 +856,6 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 		if (err == -EAGAIN)
 			err = inode_permission(nd->path.dentry->d_inode,
 					       MAY_EXEC);
-		if (!err)
-			err = ima_path_check(&nd->path, MAY_EXEC,
-				             IMA_COUNT_UPDATE);
  		if (err)
 			break;
 
-- 
1.6.4.1.209.g74b8

