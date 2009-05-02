Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZEBDbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZEBDbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 23:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZEBDbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 23:31:24 -0400
Received: from [192.16.179.4] ([192.16.179.4]:57472 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZEBDbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 23:31:23 -0400
Date: Sat, 02 May 2009 12:23:52 +0900 (JST)
Message-Id: <20090502.122352.99036120.ryusuke@osrg.net>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] Use feature code to eliminate quota pointers from
 inodes for filesystems that don't need it.
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1241112678-6615-3-git-send-email-jack@suse.cz>
References: <1241112678-6615-1-git-send-email-jack@suse.cz>
	<1241112678-6615-3-git-send-email-jack@suse.cz>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 02 May 2009 12:23:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 19:31:18 +0200, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext2/ext2.h     |    1 +
>  fs/ext2/super.c    |    5 ++
>  fs/inode.c         |    7 ++-
>  fs/nilfs2/mdt.c    |    3 -
>  fs/quota/dquot.c   |  134 ++++++++++++++++++++++++++++++----------------------
>  include/linux/fs.h |   10 +++-
>  6 files changed, 97 insertions(+), 63 deletions(-)

<snip>

> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 47dd815..725cd80 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -478,9 +478,6 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
>  		inode->i_blocks = 0;
>  		inode->i_bytes = 0;
>  		inode->i_generation = 0;
> -#ifdef CONFIG_QUOTA
> -		memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
> -#endif
>  		inode->i_pipe = NULL;
>  		inode->i_bdev = NULL;
>  		inode->i_cdev = NULL;

Ack-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

<snip>

Thanks,
Ryusuke Konishi
