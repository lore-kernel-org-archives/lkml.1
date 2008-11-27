Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYK0CgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYK0CgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYK0CgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:36:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYK0CgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:36:08 -0500
Date: Wed, 26 Nov 2008 21:36:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: prevent recursion
In-Reply-To: <492E043A.9040503@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0811262134070.1501@gandalf.stny.rr.com>
References: <492E043A.9040503@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Nov 2008, Lai Jiangshan wrote:

> 
> if the resched flag was set before we entered, then don't reschedule.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index f780e95..668bbb5 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1215,7 +1215,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
>  
>   out:
>  	if (resched)
> -		preempt_enable_notrace();
> +		preempt_enable_no_resched_notrace();
>  	else
>  		preempt_enable_notrace();
>  	return NULL;


Ouch! Thanks, this patch should go straight to mainline. The version in 
tip uses the new ftrace_preempt_disable which is not yet in mainline.

-- Steve

