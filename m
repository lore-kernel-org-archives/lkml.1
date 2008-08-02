Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYHBIHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYHBIHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 04:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYHBIHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 04:07:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:49609 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYHBIHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 04:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HkOEP7Oaf8qgpwNoLWGNXcLAAGKh54OGlw3BC7kzPxxS3RIJwpLoiUw8UfhlHRVysZ
         0y/xfz5LnFhRhwNdoW36UgGflhfakpw6n4tuwGsb9Q0klSrr48zSLjRcKBQyD+hcR7Fd
         HE+UfcVspbcYK/DKRbazxHUUkS6pouZLj79nI=
Date: Sat, 2 Aug 2008 12:07:25 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: me@bobcopeland.com, linux-karma-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] omfs: fix warning
Message-ID: <20080802080725.GA4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

omfs: fix warnings

fs/omfs/inode.c:495: warning: format '%llx' expects type 'long long
	unsigned int', but argument 2 has type 'u64'
fs/omfs/inode.c:495: warning: format '%llx' expects type 'long
	long unsigned int', but argument 3 has type '__be64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>

---

 fs/omfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index d865f55..a95fe59 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -492,7 +492,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (sbi->s_num_blocks != be64_to_cpu(omfs_rb->r_num_blocks)) {
 		printk(KERN_ERR "omfs: block count discrepancy between "
 			"super and root blocks (%llx, %llx)\n",
-			sbi->s_num_blocks, be64_to_cpu(omfs_rb->r_num_blocks));
+			(unsigned long long)sbi->s_num_blocks,
+			(unsigned long long)be64_to_cpu(omfs_rb->r_num_blocks));
 		goto out_brelse_bh2;
 	}
 
