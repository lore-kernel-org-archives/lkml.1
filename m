Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXJ0OxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXJ0OxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXJ0OxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:53:03 -0400
Received: from ro-out-1112.google.com ([72.14.202.183]:25447 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbXJ0OxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=V5QaeDCN04BPuZTnyZ+EFV+c49xWpi01fKKFgZjKO2hqvrOGT5awAFGSjwMySksm2iyF+Mlhsgl2b/ardS7Nipz5n+G8OvEgFBSh12EhUVfGjvalFLRrI8aBJTUvTy4tKK1q+nDYP7y71bZAFVCSTnFMOud8C13sc0GKT/azIIA=
Date: Sat, 27 Oct 2007 22:47:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: KaiGai Kohei <kaigai@ak.jp.nec.com>, David Woodhouse <dwmw2@infradead.org>,
       jffs-dev@axis.com, linux-kernel@vger.kernel.org
Subject: [Git Patch]fs/jffs2/acl.c: Fix a may-be-uninitialized return value
Message-ID: <20071027144745.GF2506@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071027141842.GV30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027141842.GV30533@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a may-be-uninitialized return value.

Found-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 fs/jffs2/acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 9728614..5b14062 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -358,7 +358,7 @@ int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, int *i_mode)
 int jffs2_init_acl_post(struct inode *inode)
 {
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
-	int rc;
+	int rc = 0;
 
 	if (f->i_acl_default) {
 		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, f->i_acl_default);

-- 
May the Source Be With You.
