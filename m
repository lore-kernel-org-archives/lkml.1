Return-Path: <linux-kernel-owner+w=401wt.eu-S1762410AbYBTKhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762410AbYBTKhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYBTKhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:37:24 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45539 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYBTKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:37:23 -0500
Date: Wed, 20 Feb 2008 16:07:30 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
       srikar@linux.vnet.ibm.com
Subject: Re: [RFC] [PATCH] Refuse kprobe insertion on
	add/sub_preempt_counter()
Message-ID: <20080220103730.GA6689@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <200802201545.17986.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802201545.17986.srinivasa@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 03:45:17PM +0530, Srinivasa Ds wrote:
> Kprobes makes use of preempt_disable(),preempt_enable_noresched() and these
> functions inturn call add/sub_preempt_count(). So we need to refuse user from 
> inserting probe in to these functions. 
> 
> This patch disallows user from probing add/sub_preempt_count(). 
> 
> Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
>  kernel/sched.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.25-rc2/kernel/sched.c
> ===================================================================
> --- linux-2.6.25-rc2.orig/kernel/sched.c
> +++ linux-2.6.25-rc2/kernel/sched.c
> @@ -3766,7 +3766,7 @@ void scheduler_tick(void)
> 
>  #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
> 
> -void add_preempt_count(int val)
> +void __kprobes add_preempt_count(int val)
>  {
>  	/*
>  	 * Underflow?
> @@ -3782,7 +3782,7 @@ void add_preempt_count(int val)
>  }
>  EXPORT_SYMBOL(add_preempt_count);
> 
> -void sub_preempt_count(int val)
> +void __kprobes sub_preempt_count(int val)
>  {
>  	/*
>  	 * Underflow?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
