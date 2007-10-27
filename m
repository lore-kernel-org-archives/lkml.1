Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXJ0OSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXJ0OSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXJ0OSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:18:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56337 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752011AbXJ0OSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:18:21 -0400
Date: Sat, 27 Oct 2007 16:18:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>, David Woodhouse <dwmw2@infradead.org>
Cc: jffs-dev@axis.com, linux-kernel@vger.kernel.org
Subject: jffs2_init_acl_post() can return uninitialized variable
Message-ID: <20071027141842.GV30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cfc8dc6f6f69ede939e09c2af06a01adee577285 added the following 
function that can return the value of an uninitialized variable:

<--  snip  -->

...
int jffs2_init_acl_post(struct inode *inode)
{
        struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
        int rc;

        if (f->i_acl_default) {
                rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, f->i_acl_default);
                if (rc)
                        return rc;
        }

        if (f->i_acl_access) {
                rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, f->i_acl_access);
                if (rc)
                        return rc;
        }

        return rc;
}
...

<--  snip  -->

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


