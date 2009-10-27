Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZJ0Ky2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZJ0Ky2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZJ0Ky2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:54:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZJ0Ky1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:54:27 -0400
Date: Tue, 27 Oct 2009 11:54:31 +0100
From: Jan Kara <jack@suse.cz>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] const: struct quota_format_ops
Message-ID: <20091027105430.GD4285@duck.suse.cz>
References: <20091016112603.GA32474@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016112603.GA32474@x200>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-10-09 15:26:03, Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
  Thanks. Merged into my tree. I plan to push it to Linus in the next merge
window.

							Honza
> ---
> 
>  fs/ocfs2/quota_local.c |    2 +-
>  fs/quota/quota_v1.c    |    2 +-
>  fs/quota/quota_v2.c    |    2 +-
>  include/linux/quota.h  |    4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -1325,7 +1325,7 @@ out:
>  	return status;
>  }
>  
> -static struct quota_format_ops ocfs2_format_ops = {
> +static const struct quota_format_ops ocfs2_format_ops = {
>  	.check_quota_file	= ocfs2_local_check_quota_file,
>  	.read_file_info		= ocfs2_local_read_info,
>  	.write_file_info	= ocfs2_global_write_info,
> --- a/fs/quota/quota_v1.c
> +++ b/fs/quota/quota_v1.c
> @@ -204,7 +204,7 @@ out:
>  	return ret;
>  }
>  
> -static struct quota_format_ops v1_format_ops = {
> +static const struct quota_format_ops v1_format_ops = {
>  	.check_quota_file	= v1_check_quota_file,
>  	.read_file_info		= v1_read_file_info,
>  	.write_file_info	= v1_write_file_info,
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -207,7 +207,7 @@ static int v2_free_file_info(struct super_block *sb, int type)
>  	return 0;
>  }
>  
> -static struct quota_format_ops v2_format_ops = {
> +static const struct quota_format_ops v2_format_ops = {
>  	.check_quota_file	= v2_check_quota_file,
>  	.read_file_info		= v2_read_file_info,
>  	.write_file_info	= v2_write_file_info,
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -334,7 +334,7 @@ struct quotactl_ops {
>  
>  struct quota_format_type {
>  	int qf_fmt_id;	/* Quota format id */
> -	struct quota_format_ops *qf_ops;	/* Operations of format */
> +	const struct quota_format_ops *qf_ops;	/* Operations of format */
>  	struct module *qf_owner;		/* Module implementing quota format */
>  	struct quota_format_type *qf_next;
>  };
> @@ -383,7 +383,7 @@ struct quota_info {
>  	struct rw_semaphore dqptr_sem;		/* serialize ops using quota_info struct, pointers from inode to dquots */
>  	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
>  	struct mem_dqinfo info[MAXQUOTAS];	/* Information for each quota type */
> -	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
> +	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
>  };
>  
>  int register_quota_format(struct quota_format_type *fmt);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
