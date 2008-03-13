Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYCMVmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYCMVmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbYCMVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:42:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbYCMVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:42:43 -0400
Date: Thu, 13 Mar 2008 14:42:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add possibly missing iput() when quotaon and
 quotaoff races
Message-Id: <20080313144211.d32c58f2.akpm@linux-foundation.org>
In-Reply-To: <20080313120552.GC12523@duck.suse.cz>
References: <20080313120344.GB12523@duck.suse.cz>
	<20080313120552.GC12523@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 13:05:52 +0100
Jan Kara <jack@suse.cz> wrote:

> We should always put inode we have reference to, even if quota was reenabled
> in the mean time.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> ---
>  dquot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dquot.c b/fs/dquot.c
> index f816d06..24eef58 100644
> --- a/fs/dquot.c
> +++ b/fs/dquot.c
> @@ -1522,8 +1522,8 @@ int vfs_quota_off(struct super_block *sb, int type)
>  				truncate_inode_pages(&toputinode[cnt]->i_data, 0);
>  				mutex_unlock(&toputinode[cnt]->i_mutex);
>  				mark_inode_dirty(toputinode[cnt]);
> -				iput(toputinode[cnt]);
>  			}
> +			iput(toputinode[cnt]);
>  			mutex_unlock(&dqopt->dqonoff_mutex);
>  		}
>  	if (sb->s_bdev)

This one looks like 2.6.25 material?
