Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZJGHCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZJGHCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZJGHCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:02:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57501 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbZJGHCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:02:36 -0400
Message-ID: <4ACC3C9D.9040106@cn.fujitsu.com>
Date: Wed, 07 Oct 2009 15:00:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zhenwen Xu <helight.xu@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] fix a warning on kernel/trace/trace_branch.c
References: <20091007063921.GA19756@helight>
In-Reply-To: <20091007063921.GA19756@helight>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhenwen Xu wrote:
> fix this warning:
> 
> kernel/trace/trace_branch.c: In function ‘probe_likely_condition’:
> kernel/trace/trace_branch.c:58: warning: passing argument 1 of ‘
> trace_buffer_lock_reserve’ from incompatible pointer type
> 
> The "tr" should be "(struct buffer *)tr" or "tr->buffer" here!!!
> 

It's caused by the API change of trace_buffer_lock_reserve() by
commit e77405ad80f53966524b5c31244e13fbbbecbd84.

Could you send an updated patch to also fix the same bug
in kernel/trace/trace_hw_branch.c ?

> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  kernel/trace/trace_branch.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 7a7a9fd..216e2dd 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  		goto out;
>  
>  	pc = preempt_count();
> -	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
>  					  sizeof(*entry), flags, pc);
>  	if (!event)
>  		goto out;

