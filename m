Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYLYSR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYLYSR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYLYSF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:56 -0500
Received: from mail.suse.de ([195.135.220.2]:60728 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbYLYSFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:55 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 35/35] ocfs2: Add xattr support checking in init_security
Date: Thu, 25 Dec 2008 10:04:50 -0800
Message-Id: <1230228290-22803-36-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tiger Yang <tiger.yang@oracle.com>

We must check whether ocfs2 volume support xattr in init_security,
if not support xattr and security is enable, would cause failure of mknod.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 095b0bb..e1d638a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5324,6 +5324,9 @@ int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    struct ocfs2_security_xattr_info *si)
 {
+	/* check whether ocfs2 support feature xattr */
+	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
+		return -EOPNOTSUPP;
 	return security_inode_init_security(inode, dir, &si->name, &si->value,
 					    &si->value_len);
 }
-- 
1.5.6

