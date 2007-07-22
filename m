Return-Path: <linux-kernel-owner+w=401wt.eu-S1765725AbXGVJ7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765725AbXGVJ7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbXGVJ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:59:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38432 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbXGVJ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:59:13 -0400
Date: Sun, 22 Jul 2007 10:59:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix broken handling of port=... in NFS option parsing
Message-ID: <20070722095906.GX21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Obviously broken on little-endian; fortunately, the option is
not frequently used...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b34b7a7..b2a851c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -732,7 +732,7 @@ static int nfs_parse_mount_options(char *raw,
 				return 0;
 			if (option < 0 || option > 65535)
 				return 0;
-			mnt->nfs_server.address.sin_port = htonl(option);
+			mnt->nfs_server.address.sin_port = htons(option);
 			break;
 		case Opt_rsize:
 			if (match_int(args, &mnt->rsize))
