Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZGaGyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZGaGyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZGaGyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:54:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49689 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZGaGyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:54:36 -0400
Date: Fri, 31 Jul 2009 08:54:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Nikanth Karthikesan <knikanth@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io context: fix ref counting
Message-ID: <20090731065436.GM12579@kernel.dk>
References: <4A7280F8.1070401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7280F8.1070401@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31 2009, Li Zefan wrote:
> Commit d9c7d394a8ebacb60097b192939ae9f15235225e
> ("block: prevent possible io_context->refcount overflow") mistakenly
> changed atomic_inc(&ioc->nr_tasks) to atomic_long_inc(&ioc->refcount).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/iocontext.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
> index dd05434..4da4a75 100644
> --- a/include/linux/iocontext.h
> +++ b/include/linux/iocontext.h
> @@ -92,7 +92,7 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
>  	 * a race).
>  	 */
>  	if (ioc && atomic_long_inc_not_zero(&ioc->refcount)) {
> -		atomic_long_inc(&ioc->refcount);
> +		atomic_inc(&ioc->nr_tasks);
>  		return ioc;
>  	}

Irk, good catch. Applied to immediate upstream branch.

-- 
Jens Axboe

