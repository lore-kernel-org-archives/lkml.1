Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbXIRSN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbXIRSN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXIRSNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:13:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36077 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752411AbXIRSNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:13:51 -0400
Date: Tue, 18 Sep 2007 20:14:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mark Fasheh <mark.fasheh@oracle.com>, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: ocfs2: inconsequent NULL checking
Message-ID: <20070918181404.GA16401@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in 
fs/ocfs2/dlmglue.c:

<--  snip  -->

...
int ocfs2_meta_lock_atime(struct inode *inode,
                          struct vfsmount *vfsmnt,
                          int *level)
{
...
                if (ocfs2_should_update_atime(inode, vfsmnt))
                        ocfs2_update_inode_atime(inode, bh);
                if (bh)
                        brelse(bh);
...

<--  snip  -->

Since commit c11e9fafb398411af7558fca913c2fa4a10b1f48
ocfs2_update_inode_atime() contains an unconditional
dereference of "bh".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

