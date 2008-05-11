Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYEKUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYEKUJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYEKUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:09:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:41882 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYEKUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=WFx2jMzV7dDQtDsNvWLhM5LW/HzxlJKc7XbefBmGk+HT+AryLGb2osYFkepBH052GHklEOnxS7njb3mvHAAYYj8+cSU1mkycopY1PwYOBVlYD0m+1Hqeu/OwGwIYCvdLP8XXb0T9Zd3g7hRMj53S7uOaLRe8ed3ncP2hRJJe8OM=
Date: Sun, 11 May 2008 22:08:45 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] jfs: 0 is not valid errno value
Message-ID: <20080511200842.GN19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... so return NULL from jfs_lookup

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: jfs-discussion@lists.sourceforge.net
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
is it ok to return NULL from this function?
compile tested only
---
 fs/jfs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1455,7 +1455,7 @@ static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struc
 		free_UCSname(&key);
 		if (rc == -ENOENT) {
 			d_add(dentry, NULL);
-			return ERR_PTR(0);
+			return NULL;
 		} else if (rc) {
 			jfs_err("jfs_lookup: dtSearch returned %d", rc);
 			return ERR_PTR(rc);
-- 
