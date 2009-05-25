Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZEYKNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZEYKNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZEYKNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:13:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:59622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbZEYKNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:13:24 -0400
Date: Mon, 25 May 2009 12:13:24 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 06/12] writeback: separate the flushing state/task from
	the bdi
Message-ID: <20090525101323.GD23546@duck.suse.cz>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-7-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243236887-3931-7-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-05-09 09:34:41, Jens Axboe wrote:
> Add a struct bdi_writeback for tracking and handling dirty IO. This
> is in preparation for adding > 1 flusher task per bdi.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
...
>  static int bdi_start_fn(void *ptr)
>  {
> -	struct backing_dev_info *bdi = ptr;
> +	struct bdi_writeback *wb = ptr;
> +	struct backing_dev_info *bdi = wb->bdi;
>  	struct task_struct *tsk = current;
> -
> -	/*
> -	 * Add us to the active bdi_list
> -	 */
> -	mutex_lock(&bdi_lock);
> -	list_add(&bdi->bdi_list, &bdi_list);
> -	mutex_unlock(&bdi_lock);
  I'm probably missing something but I cannot find where the bdi is added
to the bdi_list after this patch...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
