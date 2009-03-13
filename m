Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZCMJ0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZCMJ0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZCMJ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:26:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50809 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZCMJ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:26:13 -0400
Date: Fri, 13 Mar 2009 10:25:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "Steven Rostedt ;" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Avoid double-free of dyn_ftrace
Message-ID: <20090313092558.GD2571@elte.hu>
References: <49BA23D9.1050900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BA23D9.1050900@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> If dyn_ftrace is free before ftrace_release(), 
> ftrace_release() will free it again and make 
> ftrace_free_records wrong.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index d33d306..26c45aa 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -356,7 +356,8 @@ void ftrace_release(void *start, unsigned long size)
>  
>  	mutex_lock(&ftrace_lock);
>  	do_for_each_ftrace_rec(pg, rec) {
> -		if ((rec->ip >= s) && (rec->ip < e))
> +		if ((rec->ip >= s) && (rec->ip < e) &&
> +		    !(rec->flags & FTRACE_FL_FREE))
>  			ftrace_free_rec(rec);

Applied to tip:tracing/ftrace, thanks!

I'm wondering, did you trigger this in practice (if yes, how?), 
or have you found it via code review?

	Ingo
