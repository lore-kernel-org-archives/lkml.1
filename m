Return-Path: <linux-kernel-owner+w=401wt.eu-S935989AbXGLC50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989AbXGLC50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765191AbXGLC5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:57:17 -0400
Received: from ozlabs.org ([203.10.76.45]:53436 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765172AbXGLC5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:57:17 -0400
Subject: Re: [PATCH 1/2] SCHED: Generic hooks for trapping task preemption
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, shaohua.li@intel.com
In-Reply-To: <11841693333159-git-send-email-avi@qumranet.com>
References: <11841693332609-git-send-email-avi@qumranet.com>
	 <11841693333159-git-send-email-avi@qumranet.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 12:56:58 +1000
Message-Id: <1184209018.6005.706.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 18:55 +0300, Avi Kivity wrote:
> +config PREEMPT_HOOKS
> +	bool
> +	depends on X86
> +	default y

Hmm, I would have thought that having CONFIG_KVM "select PREEMPT_HOOKS"
would be a little clearer.

> +static void fire_sched_in_preempt_hooks(struct task_struct *tsk)
> +{
> +	struct preempt_hook *hook;
> +	struct hlist_node *node;
> +
> +	hlist_for_each_entry(hook, node, &tsk->preempt_hooks, link)
> +		hook->ops->sched_in(hook, raw_smp_processor_id());
> +}

The old current/tsk conflation.  You hand in "tsk" here, but since
that's not handed through to the sched_in, it must be "current".  It's
just unfortunate that this generates better code...

But patch looks good.

Cheers,
Rusty.

