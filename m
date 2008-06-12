Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYFLFW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYFLFW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYFLFWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:22:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:44646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYFLFWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:22:46 -0400
Subject: Re: [PATCH 2/5] futex: update prio on requeue
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080611204917.136735991@mvista.com>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.136735991@mvista.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 07:22:43 +0200
Message-Id: <1213248163.31518.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> plain text document attachment (futex-update-prio-on-requeue.patch)
> Since the priority may have changed, the requeue is a good place to update
> the priority since we're already deleting and adding to a new list.
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  kernel/futex.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.25/kernel/futex.c
> ===================================================================
> --- linux-2.6.25.orig/kernel/futex.c
> +++ linux-2.6.25/kernel/futex.c
> @@ -980,7 +980,10 @@ static int futex_requeue(u32 __user *uad
>  			 * requeue.
>  			 */
>  			if (likely(head1 != &hb2->chain)) {
> +				struct task_struct *task = this->task;
> +				int prio = min(task->normal_prio, MAX_RT_PRIO);

we want whitespace between var declarations and code

>  				plist_del(&this->list, &hb1->chain);
> +				plist_node_init(&this->list, prio);
>  				plist_add(&this->list, &hb2->chain);
>  				this->lock_ptr = &hb2->lock;
>  #ifdef CONFIG_DEBUG_PI_LIST
> 

