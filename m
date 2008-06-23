Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbYFWWn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbYFWWn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYFWWns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:43:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFWWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:43:48 -0400
Date: Mon, 23 Jun 2008 18:43:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: ciaby <ciaby@autistici.org>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] 2.6.25.4-rt6: missing =?UTF-8?Q?global=5Frt=5Fruntime=28=29=20in?=
 =?UTF-8?Q?=20sched=2Ec?=
In-Reply-To: <7688fdc041a8f848b0627dccccddcf12@localhost>
Message-ID: <Pine.LNX.4.58.0806231843120.27994@gandalf.stny.rr.com>
References: <7688fdc041a8f848b0627dccccddcf12@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Jun 2008, ciaby wrote:

>
>
> I already sent this patch, but seems that nobody cared... the last 2
> revisions of the -rt kernel don't compile properly.
> Second patch to fix this.
> Regards

I still don't have a "Signed-off-by:" for this patch. Please send it to me
ASAP, otherwise it will miss the next release.

-- Steve

>
> Giovanni "ciaby" Civardi
>
> diff -uNr linux-2.6.25.4-rt6.orig/kernel/sched.c
> linux-2.6.25.4-rt6/kernel/sched.c
> --- linux-2.6.25.4-rt6.orig/kernel/sched.c      2008-06-09
> 11:35:57.000000000 +0200
> +++ linux-2.6.25.4-rt6/kernel/sched.c   2008-06-09 11:40:45.000000000 +0200
> @@ -672,6 +672,13 @@
>   */
>  #define RUNTIME_INF    ((u64)~0ULL)
>
> +static u64 global_rt_runtime(void)
> +{
> +       if (sysctl_sched_rt_period < 0)
> +               return RUNTIME_INF;
> +       return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
> +}
> +
>  /*
>   * We really dont want to do anything complex within switch_to()
>   * on PREEMPT_RT - this check enforces this.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
