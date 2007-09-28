Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXI1MET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXI1MET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXI1MEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:04:09 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:22981 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbXI1MEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:04:07 -0400
Date: Fri, 28 Sep 2007 14:03:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 01/12] lockdep: syscall exit check
Message-ID: <20070928120331.GC25726@osiris.boeblingen.de.ibm.com>
References: <20070928074200.436463000@chello.nl> <20070928080040.893443000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928080040.893443000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +void lockdep_sys_exit(void)
> +{
> +	struct task_struct *curr = current;
> +
> +	if (unlikely(curr->lockdep_depth)) {
> +		if (!debug_locks_off())
> +			return;
> +		printk("\n========================================\n");
> +		printk(  "[ BUG: lock held at syscall exit time! ]\n");
> +		printk(  "----------------------------------------\n");
> +		printk("%s/%d is leaving the kernel with locks still held!\n",
> +				curr->comm, curr->pid);
> +		lockdep_print_held_locks(curr);
> +	}
> +}

By the way, the s390 patch I just posted also checks if we hold any locks
when returning from interrupt context to user space. Maybe the above text
could be changed to "lock held when returning to user space" ?
