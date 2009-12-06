Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbZLFKzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbZLFKzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbZLFKzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:55:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:49790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277AbZLFKzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:55:05 -0500
Subject: Re: Unable to use tools/perf sched and timechart correctly
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1B8A66.6040302@cn.fujitsu.com>
References: <4B18E2AD.3070507@gmail.com>  <4B1B8A66.6040302@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 11:55:05 +0100
Message-ID: <1260096905.7818.309.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 18:41 +0800, Xiao Guangrong wrote:

> You should enable "CONFIG_SCHED_DEBUG", because we use
> "/proc/<pid>/sched" file to get the task's cpu usage.
> 
> Ingo, I think we do better show the reason about this error,
> just like:
> 
> ---
>  tools/perf/builtin-sched.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index 26b782f..f823631 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -427,7 +427,11 @@ static u64 get_cpu_usage_nsec_self(void)
>  
>  	sprintf(filename, "/proc/%d/sched", getpid());
>  	file = fopen(filename, "r");
> -	BUG_ON(!file);
> +	if (!file)
> +	{
> +		printf("You should compile your kernel with CONFIG_SCHED_DEBUG option\n");
> +		BUG_ON(1);
> +	}
>  
>  	while ((chars = getline(&line, &len, file)) != -1) {
>  		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",

Hrmm, we shouldn't be using a proc file at all, the best solution is to
remove this dependency.



