Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbXC0Er5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbXC0Er5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 00:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933977AbXC0Er5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 00:47:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38178 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933974AbXC0Er4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 00:47:56 -0400
Date: Mon, 26 Mar 2007 20:47:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][ 3/5] sched: implement staircase deadline cpu scheduler
Message-Id: <20070326204723.af7203af.akpm@linux-foundation.org>
In-Reply-To: <200703271210.39429.kernel@kolivas.org>
References: <200703271210.39429.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 13:10:39 +1100 Con Kolivas <kernel@kolivas.org> wrote:

> +	DECLARE_BITMAP(bitmap, PRIO_RANGE + 1);
> +	/*
> +	 * This bitmap shows what priorities this task has received quota
> +	 * from for this major priority rotation on its current runqueue.
> +	 */
>  	struct prio_array *array;
> +	unsigned long rotation;
> +	/* Which major runqueue rotation did this task run */
>  
>  	unsigned short ioprio;
>  #ifdef CONFIG_BLK_DEV_IO_TRACE
>  	unsigned int btrace_seq;
>  #endif
> -	unsigned long sleep_avg;
>  	unsigned long long timestamp, last_ran;
>  	unsigned long long sched_time; /* sched_clock time spent running */
> -	enum sleep_type sleep_type;
>  
>  	unsigned long policy;
>  	cpumask_t cpus_allowed;
> -	unsigned int time_slice, first_time_slice;
> +	int time_slice;
> +	/*
> +	 * How much this task is entitled to run at the current priority
> +	 * before being requeued at a lower priority.
> +	 */
> +	unsigned int first_time_slice;
> +	/* Is this the very first time_slice this task has ever run. */
> +	int quota;
> +	/* How much this task receives at each priority level */

This is nuts.  Nobody puts the description of the fields _below_ those fields.

I fixed it in my copy (while fixing the usual reject storm).  Please fix it
in your tree, wherever it occurs.

Weird.
