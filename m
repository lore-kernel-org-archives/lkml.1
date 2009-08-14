Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZHNMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZHNMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbZHNMnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:14 -0400
Received: from www.tglx.de ([62.245.132.106]:49772 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733AbZHNMnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:12 -0400
Message-Id: <20090814123548.307374941@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:42:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 04/11] cifs: cleanup unload_nls() call
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=cifs-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steve French <sfrench@us.ibm.com>
---
 fs/cifs/cifsfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6-tip/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/cifsfs.c
+++ linux-2.6-tip/fs/cifs/cifsfs.c
@@ -185,8 +185,7 @@ out_mount_failed:
 			cifs_sb->mountdata = NULL;
 		}
 #endif
-		if (cifs_sb->local_nls)
-			unload_nls(cifs_sb->local_nls);
+		unload_nls(cifs_sb->local_nls);
 		kfree(cifs_sb);
 	}
 	return rc;


