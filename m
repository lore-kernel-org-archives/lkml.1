Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbYBOS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbYBOS66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbYBOS6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:58:51 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:43926 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYBOS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:58:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XiQMzm9xMrXXT1IHdRqMZP0d6saO9vvDA36Y2Xu/bGmNM26Z/aq933tEGuRroZ12KEkPMdiFDrJ4y/GDgkFpZFmpljASBLRKbwxvtnzTdCcMliTOC/XvWHMzvasOUx3wuOt6pIQV8Fqo+XFjP3asdohCa41gMTVa5BniZN/IJ00=
Subject: [RFC-PATCH] fuse: shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 10:58:22 -0800
Message-Id: <1203101902.15275.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/fuse/dir.c:909:7: warning: symbol 'err' shadows an earlier one
fs/fuse/dir.c:893:6: originally declared here

This means that an error between lines 909 and 923 will not be
returned.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Miklos, could you confirm whether or not you want the err from lines
909-923 returned or not.  If so, I can respin this patch changing the
variable name instead which would preserve the current behavior.
This patch changes behavior.

 fs/fuse/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 7fb514b..c4807b3 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -906,7 +906,7 @@ static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
-		int err = generic_permission(inode, mask, NULL);
+		err = generic_permission(inode, mask, NULL);
 
 		/* If permission is denied, try to refresh file
 		   attributes.  This is also needed, because the root
-- 
1.5.4.1.1278.gc75be



