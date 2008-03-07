Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbYCGXa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbYCGXa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYCGXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:30:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYCGXaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:30:17 -0500
Date: Fri, 7 Mar 2008 15:29:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: rjw@sisk.pl, dmitry.adamushko@gmail.com, ego@in.ibm.com, mingo@elte.hu,
       oleg@tv-sign.ru, yi.y.yang@intel.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
 dealocked when cpu is set to offline
Message-Id: <20080307152934.5c4052db.akpm@linux-foundation.org>
In-Reply-To: <20080307230126.GA15909@linux-os.sc.intel.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	<b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com>
	<20080307121822.54b8c2fb.akpm@linux-foundation.org>
	<200803072236.26256.rjw@sisk.pl>
	<20080307230126.GA15909@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 15:01:26 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> 
> Andrew, Please check if the appended patch fixes your power-off problem aswell.
> ...
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5882,6 +5882,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  
>  	case CPU_DOWN_PREPARE:
> +	case CPU_DOWN_PREPARE_FROZEN:
>  		/* Update our root-domain */
>  		rq = cpu_rq(cpu);
>  		spin_lock_irqsave(&rq->lock, flags);

No, it does not.
