Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZKJVWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZKJVWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZKJVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:22:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbZKJVWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:22:00 -0500
Date: Tue, 10 Nov 2009 22:22:05 +0100
From: Jan Kara <jack@suse.cz>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org, sunil.mushran@oracle.com,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] JBD/JBD2: free j_wbuf if journal init fails.
Message-ID: <20091110212205.GE27326@duck.suse.cz>
References: <1257844402-7828-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257844402-7828-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-11-09 17:13:22, Tao Ma wrote:
> If journal init fails, we need to free j_wbuf.
  Thanks, added to my tree.

							Honza
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/jbd/journal.c  |    2 ++
>  fs/jbd2/journal.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index bd3c073..49d5cd6 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -756,6 +756,7 @@ journal_t * journal_init_dev(struct block_device *bdev,
>  
>  	return journal;
>  out_err:
> +	kfree(journal->j_wbuf);
>  	kfree(journal);
>  	return NULL;
>  }
> @@ -820,6 +821,7 @@ journal_t * journal_init_inode (struct inode *inode)
>  
>  	return journal;
>  out_err:
> +	kfree(journal->j_wbuf);
>  	kfree(journal);
>  	return NULL;
>  }
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index b0ab521..fed8538 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -913,6 +913,7 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
>  
>  	return journal;
>  out_err:
> +	kfree(journal->j_wbuf);
>  	jbd2_stats_proc_exit(journal);
>  	kfree(journal);
>  	return NULL;
> @@ -986,6 +987,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
>  
>  	return journal;
>  out_err:
> +	kfree(journal->j_wbuf);
>  	jbd2_stats_proc_exit(journal);
>  	kfree(journal);
>  	return NULL;
> -- 
> 1.5.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
