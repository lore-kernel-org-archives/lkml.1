Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbXGAHnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbXGAHnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbXGAHiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:38:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46882 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387AbXGAHiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:38:46 -0400
Subject: [EXT4 set 9][PATCH
	3/5]Morecleanups:ext4-remove-extra-is_rdonly-check
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:38:44 -0400
Message-Id: <1183275524.4010.139.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ext4: remove extra IS_RDONLY() check
From: Dave Hansen <haveblue@us.ibm.com>

ext4_change_inode_journal_flag() is only called from one location:
ext4_ioctl(EXT3_IOC_SETFLAGS).  That ioctl case already has a IS_RDONLY()
call in it so this one is superfluous.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
---

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-remove-extra-is_rdonly-check fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-remove-extra-is_rdonly-check
+++ a/fs/ext4/inode.c
@@ -3352,7 +3352,7 @@ int ext4_change_inode_journal_flag(struc
 	 */

 	journal = EXT4_JOURNAL(inode);
-	if (is_journal_aborted(journal) || IS_RDONLY(inode))
+	if (is_journal_aborted(journal))
 		return -EROFS;

 	jbd2_journal_lock_updates(journal);


