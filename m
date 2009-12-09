Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZLIIyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZLIIyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZLIIyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:54:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:29126 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZLIIyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o9hcAGtcVQb6nzTml4mOsFH7uW1zcRBCkB5Dds0xp+gQifoHli0QbKQxW/af7+hXbT
         56RWMPgYC2W/0786bV9TDvmOJM+f/vBt485UECYdOVn71D7rPtnIuHuBxUVwEjTY/yY7
         gChH3spBq7pts0cL5wR8QsHppSVBm2yu7UjaA=
Date: Wed, 9 Dec 2009 09:54:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf_event: cleanup for
	cpu_clock_perf_event_update()
Message-ID: <20091209085417.GC5152@nowhere>
References: <4B1F194D.7080306@cn.fujitsu.com> <4B1F19A8.5040805@cn.fujitsu.com> <4B1F19DC.90204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F19DC.90204@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 11:30:36AM +0800, Xiao Guangrong wrote:
> Using atomic64_xchg() instead of atomic64_read() and atomic64_set().
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 592b293..8f46012 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4079,8 +4079,7 @@ static void cpu_clock_perf_event_update(struct perf_event *event)
>  	u64 now;
>  
>  	now = cpu_clock(cpu);
> -	prev = atomic64_read(&event->hw.prev_count);
> -	atomic64_set(&event->hw.prev_count, now);
> +	prev = atomic64_xchg(&event->hw.prev_count, now);
>  	atomic64_add(now - prev, &event->count);
>  }


Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

