Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYJWWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYJWWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYJWWrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:47:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:23995 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYJWWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JDCzYv398Jd3/CsHaEu1g9Q0MFxsZmvmVKno15pHBR2VHuKsQEuOklGWFU5Ltx+OL2
         rXkEIJrP/75aVJ6Xh0G6tNTPZfBCXxUspxgbEMxw4iTYZC4N0/YG+mncPsjrWFlYMo37
         t5lc70t1wDOOC+K2s8uBPIcNrnA8gzhIXE4Xw=
Date: Fri, 24 Oct 2008 02:47:00 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] ext4: fix printk format warning
Message-ID: <20081023224700.GA28845@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/ext4/balloc.c:607: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1822: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1824: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index bd2ece2..f62a885 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -604,7 +604,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
-					dirty_blocks);
+					(long long)dirty_blocks);
 		}
 	}
 	/* Check whether we have space after
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b4ec9d..a5cd96b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1819,9 +1819,9 @@ static void ext4_print_free_blocks(struct inode *inode)
 			ext4_count_free_blocks(inode->i_sb));
 	printk(KERN_EMERG "Free/Dirty block details\n");
 	printk(KERN_EMERG "free_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_freeblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_freeblocks_counter));
 	printk(KERN_EMERG "dirty_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_dirtyblocks_counter));
 	printk(KERN_EMERG "Block reservation details\n");
 	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
 			EXT4_I(inode)->i_reserved_data_blocks);
