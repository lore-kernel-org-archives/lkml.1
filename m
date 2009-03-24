Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbZCXMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbZCXMvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZCXMvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:51:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47272 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZCXMvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:51:36 -0400
Date: Tue, 24 Mar 2009 09:51:11 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] blktrace: fix t_error()
Message-ID: <20090324125111.GB8692@ghostprotocols.net>
References: <49C893FC.9080905@cn.fujitsu.com> <49C8945F.5020802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C8945F.5020802@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 24, 2009 at 04:05:51PM +0800, Li Zefan escreveu:
> t_error() should return t->error but not t->sector.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 0e91caa..f33c176 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -968,7 +968,7 @@ static inline unsigned long long t_sector(const struct trace_entry *ent)
>  
>  static inline __u16 t_error(const struct trace_entry *ent)
>  {
> -	return te_blk_io_trace(ent)->sector;
> +	return te_blk_io_trace(ent)->error;
>  }
>  
>  static __u64 get_pdu_int(const struct trace_entry *ent)

Doh, thanks a lot, c'n'paste at its "best"!

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
