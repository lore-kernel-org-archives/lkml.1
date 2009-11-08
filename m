Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZKHLjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZKHLjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZKHLjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:39:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35507 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbZKHLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:39:16 -0500
Message-ID: <4AF6ADE1.60201@cs.helsinki.fi>
Date: Sun, 08 Nov 2009 13:39:13 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: mel@csn.ul.fi, linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] slqb: A not quite so trivial warning
References: <20091106112942.14595.29799.stgit@localhost.localdomain>
In-Reply-To: <20091106112942.14595.29799.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
> mm/slqb.c:2773: warning: initialization from incompatible pointer type
> 
> Variable scope...
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

I don't see this warning in my tree. Is this coming from linux-next? Did 
someone change DEFINE_PER_CPU not to prefix the variable name with 
"per_cpu__"?

			Pekka

> ---
> 
>  mm/slqb.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> index e745d9a..fddcf85 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -2770,16 +2770,16 @@ static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);
>  
>  static void __cpuinit start_cpu_timer(int cpu)
>  {
> -	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
> +	struct delayed_work *lcache_trim_work = &per_cpu(cache_trim_work, cpu);
>  
>  	/*
>  	 * When this gets called from do_initcalls via cpucache_init(),
>  	 * init_workqueues() has already run, so keventd will be setup
>  	 * at that time.
>  	 */
> -	if (keventd_up() && cache_trim_work->work.func == NULL) {
> -		INIT_DELAYED_WORK(cache_trim_work, cache_trim_worker);
> -		schedule_delayed_work_on(cpu, cache_trim_work,
> +	if (keventd_up() && lcache_trim_work->work.func == NULL) {
> +		INIT_DELAYED_WORK(lcache_trim_work, cache_trim_worker);
> +		schedule_delayed_work_on(cpu, lcache_trim_work,
>  					__round_jiffies_relative(HZ, cpu));
>  	}
>  }
> 

