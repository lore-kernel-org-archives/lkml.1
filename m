Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZIXVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZIXVMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZIXVMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:12:41 -0400
Received: from mail.perches.com ([173.55.12.10]:1176 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZIXVMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:12:41 -0400
Subject: Re: [PATCH] hrtimer: Remove overly verbose "switch to high res
 mode" message
From: Joe Perches <joe@perches.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ada1vlw126s.fsf_-_@cisco.com>
References: <adavdj92sso.fsf@cisco.com> <adar5tx2s9d.fsf@cisco.com>
	 <20090924093800.GA23158@elte.hu>  <ada1vlw126s.fsf_-_@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Sep 2009 14:12:44 -0700
Message-Id: <1253826764.1806.24.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 14:07 -0700, Roland Dreier wrote:
> On big systems, printing <number of CPUs> copies of
>     Switched to high resolution mode on CPU nnn
> clutters up the kernel log for minimal gain.  Just get rid of them.
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index e5d98ce..4267279 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -720,8 +720,6 @@ static int hrtimer_switch_to_hres(void)
>  	/* "Retrigger" the interrupt to get things going */
>  	retrigger_next_event(NULL);
>  	local_irq_restore(flags);
> -	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
> -	       smp_processor_id());

Perhaps pr_debug instead?
It gets compiled to nothing unless DEBUG is defined.


