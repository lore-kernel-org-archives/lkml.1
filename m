Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZFDJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZFDJl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZFDJlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:41:22 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:25848
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153AbZFDJlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:41:21 -0400
Message-ID: <4A2796C0.6080702@panasas.com>
Date: Thu, 04 Jun 2009 12:41:20 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@infradead.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH v2 04/17] EXOFS: do not manipulate s_dirt directly
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org> <1244112114-23144-5-git-send-email-dedekind@infradead.org>
In-Reply-To: <1244112114-23144-5-git-send-email-dedekind@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2009 09:41:23.0926 (UTC) FILETIME=[9FB56F60:01C9E4F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2009 01:41 PM, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> ... use new VFS helpers instead.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  fs/exofs/inode.c |    2 +-
>  fs/exofs/super.c |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
> index ba8d9fa..80d3d03 100644
> --- a/fs/exofs/inode.c
> +++ b/fs/exofs/inode.c
> @@ -1066,7 +1066,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
>  
>  	sbi = sb->s_fs_info;
>  
> -	sb->s_dirt = 1;
> +	mark_sb_dirty(sb);
>  	inode->i_uid = current->cred->fsuid;
>  	if (dir->i_mode & S_ISGID) {
>  		inode->i_gid = dir->i_gid;
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 49e16af..9cf9738 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -241,7 +241,7 @@ static void exofs_write_super(struct super_block *sb)
>  		EXOFS_ERR("exofs_write_super: exofs_sync_op failed.\n");
>  		goto out;
>  	}
> -	sb->s_dirt = 0;
> +	mark_sb_clean(sb);
>  
>  out:
>  	if (or)
> @@ -262,7 +262,7 @@ static void exofs_put_super(struct super_block *sb)
>  
>  	lock_kernel();
>  
> -	if (sb->s_dirt)
> +	if (is_sb_dirty(sb))
>  		exofs_write_super(sb);
>  
>  	/* make sure there are no pending commands */

