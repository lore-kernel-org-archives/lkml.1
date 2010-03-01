Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0CAQxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:53:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0CAQxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:53:19 -0500
Date: Mon, 1 Mar 2010 17:50:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
Message-ID: <20100301165038.GA14558@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org> <20100228141135.GB5495@redhat.com> <4B8BD822.1010402@kernel.org> <20100301153750.GA11090@redhat.com> <4B8BED09.7000904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BED09.7000904@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Tejun Heo wrote:
>
> Hello,
>
> On 03/02/2010 12:37 AM, Oleg Nesterov wrote:
> >
> > Suppose that, when stop_machine_cpu_callback(CPU_POST_DEAD) is called,
> > that stop_cpu() thread T is still running and it is going to check state
> > before schedule().
>
> Oh, I see.  I was thinking get/put_online_cpus() block is exclusive
> against cpu_maps_update_begin/done() instead of
> cpu_hotplug_begin/done().  Will update and add comments.

Agreed, a little comment can help.

But, just in case, I forgot to repeat this case is not possible anyway.
_cpu_down() ensures idle_cpu(cpu) == T after __stop_machine(), this means
that this SCHED_FIFO thread we are going to kthread_stop() later can't
be active.

Oleg.

