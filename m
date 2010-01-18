Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903Ab0ARJ6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0ARJ6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:58:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428Ab0ARJ6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:58:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:42278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0ARJ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:57:59 -0500
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1263776272-382-5-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 10:56:10 +0100
Message-ID: <1263808570.4283.149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
> set_cpus_allowed_ptr() modifies the allowed cpu mask of a task.  The
> function performs the following checks before applying new mask.
> 
> * Check whether PF_THREAD_BOUND is set.  This is set for bound
>   kthreads so that they can't be moved around.
> 
> * Check whether the target cpu is still marked active - cpu_active().
>   Active state is cleared early while downing a cpu.
> 
> This patch adds __set_cpus_allowed() which takes @force parameter
> which when true makes __set_cpus_allowed() ignore PF_THREAD_BOUND and
> use cpu online state instead of active state for the latter.  This
> allows migrating tasks to CPUs as long as they are online.
> set_cpus_allowed_ptr() is implemented as inline wrapper around
> __set_cpus_allowed().
> 
> Due to the way migration is implemented, the @force parameter needs to
> be passed over to the migration thread.  @force parameter is added to
> struct migration_req and passed to __migrate_task().
> 
> Please note the naming discrepancy between set_cpus_allowed_ptr() and
> the new functions.  The _ptr suffix is from the days when cpumask API
> wasn't mature and future changes should drop it from
> set_cpus_allowed_ptr() too.
> 
> NOTE: It would be nice to implement kthread_bind() in terms of
>       __set_cpus_allowed() if we can drop the capability to bind to a
>       dead CPU from kthread_bind(), which doesn't seem too popular
>       anyway.  With such change, we'll have set_cpus_allowed_ptr() for
>       regular tasks and kthread_bind() for kthreads and can use
>       PF_THREAD_BOUND instead of passing @force parameter around.


And your changelog still sucks... it only says what it does, not why.

still hate the patch too.

