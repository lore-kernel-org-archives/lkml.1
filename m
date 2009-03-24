Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZCXMte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZCXMte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZCXMtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:49:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZCXMtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:49:23 -0400
Date: Tue, 24 Mar 2009 09:49:04 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] blktrace: mark ddir_act and what2act const
Message-ID: <20090324124904.GA8692@ghostprotocols.net>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89415.5080503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C89415.5080503@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 24, 2009 at 04:04:37PM +0800, Li Zefan escreveu:
> ddir_act and what2act are always stay immutable.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 108f4f7..1ffcbd4 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -147,8 +147,8 @@ static int act_log_check(struct blk_trace *bt, u32 what, sector_t sector,
>  /*
>   * Data direction bit lookup
>   */
> -static u32 ddir_act[2] __read_mostly = { BLK_TC_ACT(BLK_TC_READ),
> -					 BLK_TC_ACT(BLK_TC_WRITE) };
> +static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
> +				 BLK_TC_ACT(BLK_TC_WRITE) };
>  
>  /* The ilog2() calls fall out because they're constant */
>  #define MASK_TC_BIT(rw, __name) ((rw & (1 << BIO_RW_ ## __name)) << \
> @@ -1116,10 +1116,10 @@ static void blk_tracer_reset(struct trace_array *tr)
>  	blk_tracer_stop(tr);
>  }
>  
> -static struct {
> +static const struct {
>  	const char *act[2];
>  	int	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
> -} what2act[] __read_mostly = {
> +} what2act[] = {
>  	[__BLK_TA_QUEUE]	= {{  "Q", "queue" },	   blk_log_generic },
>  	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
>  	[__BLK_TA_FRONTMERGE]	= {{  "F", "frontmerge" }, blk_log_generic },

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
