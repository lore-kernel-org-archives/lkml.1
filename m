Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbZEHXFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbZEHXFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZEHXFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:05:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbZEHXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:05:07 -0400
Date: Fri, 8 May 2009 16:01:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ron <ron@debian.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for sched_clock() when using jiffies
Message-Id: <20090508160142.ad89944f.akpm@linux-foundation.org>
In-Reply-To: <20090508200444.GA22132@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz>
	<1227712598.4454.199.camel@twins>
	<20081126153152.GB28153@homer.shelbyville.oz>
	<20081128144039.GG28138@elte.hu>
	<20090508132449.GV5417@homer.shelbyville.oz>
	<20090508200444.GA22132@homer.shelbyville.oz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 05:34:44 +0930
Ron <ron@debian.org> wrote:

>  
> Account for the initial offset to the jiffy count.
> 
> Signed-off-by: Ron Lee <ron@debian.org>
> 
> ---
>  kernel/sched_clock.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index a0b0852..a1567b1 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -37,7 +37,8 @@
>   */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
> +	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> +					* (NSEC_PER_SEC / HZ);
>  }
>  
>  static __read_mostly int sched_clock_running;

Why?  I assume that you encountered some problem which was fixed
by this patch.  What was that problem?
