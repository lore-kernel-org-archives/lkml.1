Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbZIPNPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbZIPNPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZIPNPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:15:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZIPNP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:15:29 -0400
Date: Wed, 16 Sep 2009 15:15:31 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 11/11] writeback: add comments to bdi_work structure
Message-ID: <20090916131531.GH26030@duck.suse.cz>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-12-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253038617-30204-12-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-09-09 20:16:57, Jens Axboe wrote:
> And document its retriever, get_next_work_item().
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
  Acked-by: Jan Kara <jack@suse.cz>

							Honza

> ---
>  fs/fs-writeback.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3de93a9..6e199ef 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -49,15 +49,15 @@ struct wb_writeback_args {
>   * Work items for the bdi_writeback threads
>   */
>  struct bdi_work {
> -	struct list_head list;
> -	struct rcu_head rcu_head;
> +	struct list_head list;		/* pending work list */
> +	struct rcu_head rcu_head;	/* for RCU free/clear of work */
>  
> -	unsigned long seen;
> -	atomic_t pending;
> +	unsigned long seen;		/* threads that have seen this work */
> +	atomic_t pending;		/* number of threads still to do work */
>  
> -	struct wb_writeback_args args;
> +	struct wb_writeback_args args;	/* writeback arguments */
>  
> -	unsigned long state;
> +	unsigned long state;		/* flag bits, see WS_* */
>  };
>  
>  enum {
> @@ -758,7 +758,11 @@ static long wb_writeback(struct bdi_writeback *wb,
>  
>  /*
>   * Return the next bdi_work struct that hasn't been processed by this
> - * wb thread yet
> + * wb thread yet. ->seen is initially set for each thread that exists
> + * for this device, when a thread first notices a piece of work it
> + * clears its bit. Depending on writeback type, the thread will notify
> + * completion on either receiving the work (WB_SYNC_NONE) or after
> + * it is done (WB_SYNC_ALL).
>   */
>  static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
>  					   struct bdi_writeback *wb)
> -- 
> 1.6.4.1.207.g68ea
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
