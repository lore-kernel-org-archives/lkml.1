Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYGDRld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYGDRld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYGDRlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:41:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:61768 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYGDRlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:41:23 -0400
Subject: Re: [PATCH -rt] [resend as inlined patch]
	{queue,schedule}_work_prio() allowing work priorities other than caller's
	priority
From: Daniel Walker <dwalker@mvista.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, leon@sidebranch.com
In-Reply-To: <486E271E.705@sidebranch.com>
References: <486E271E.705@sidebranch.com>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 10:41:20 -0700
Message-Id: <1215193280.9513.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-04 at 15:35 +0200, Leon Woestenberg wrote:

> Index: linux-2.6.24/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.24.orig/kernel/workqueue.c    2008-06-30 
> 17:12:05.000000000 +0200
> +++ linux-2.6.24/kernel/workqueue.c    2008-06-30 17:25:03.000000000 +0200
> @@ -163,9 +163,10 @@
>  }
>  
>  /**
> - * queue_work - queue work on a workqueue
> + * queue_work_prio - queue work on a workqueue and set work priority
>   * @wq: workqueue to use
>   * @work: work to queue
> + * @prio: priority of work
>   *
>   * Returns 0 if @work was already on a queue, non-zero otherwise.
>   *
> @@ -174,17 +175,36 @@
>   *
>   * Especially no such guarantee on PREEMPT_RT.
>   */
> -int fastcall queue_work(struct workqueue_struct *wq, struct work_struct 
> *work)
> +int fastcall queue_work_prio(struct workqueue_struct *wq,
> +  struct work_struct *work, int prio)

Looks like you patch has line wrapped damage, and white space damage..
If your cutting an pasting the patches that will usually remove the
white space (which we don't want), and often mailers will line wrap if
you don't specify that it's formatted already.

Daniel

