Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab0CAN1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:27:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:57695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0CAN1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:27:43 -0500
Date: Mon, 1 Mar 2010 14:27:52 +0100
From: Jan Kara <jack@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: Tree for February 25 (quota)
Message-ID: <20100301132752.GG3271@quack.suse.cz>
References: <20100225183523.80361261.sfr@canb.auug.org.au>
 <4B86B1A3.2090606@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B86B1A3.2090606@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-02-10 09:21:39, Randy Dunlap wrote:
> On 02/24/10 23:35, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20100224:
> 
> 
> When CONFIG_BLOCK=n:
> 
> fs/quota/dquot.c:2042: error: implicit declaration of function 'fsync_bdev'
  Thanks for notification. I've fixed this by the following patch:

>From 9007983e9bf994200194727bcb87d45bb924b4a8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 1 Mar 2010 14:24:36 +0100
Subject: [PATCH] vfs: Provide empty fsync_bdev if !CONFIG_BLOCK

Provide empty declaration of fsync_bdev when CONFIG_BLOCK is not defined so
that quota code can use it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ebb1cd5..b9e4f1c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1961,6 +1961,11 @@ static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
 	return 0;
 }
+
+static inline int fsync_bdev(struct block_device *bdev)
+{
+	return 0;
+}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
-- 
1.6.4.2

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
