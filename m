Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZCTMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZCTMxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 08:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZCTMxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 08:53:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZCTMxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 08:53:35 -0400
Date: Fri, 20 Mar 2009 09:53:11 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] blktrace: fix possible memory leak
Message-ID: <20090320125311.GH30407@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F5B2.8000800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F5B2.8000800@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 20, 2009 at 09:47:30AM +0800, Li Zefan escreveu:
> When we failed to create "block" debugfs dir, we should do come cleanups.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index b171778..fb3bc53 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -432,7 +432,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  	if (!blk_tree_root) {
>  		blk_tree_root = debugfs_create_dir("block", NULL);
>  		if (!blk_tree_root)
> -			return -ENOMEM;
> +			goto err;
>  	}
>  
>  	dir = debugfs_create_dir(buts->name, blk_tree_root);

Nice catch,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
