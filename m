Return-Path: <linux-kernel-owner+w=401wt.eu-S1764118AbXIXQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764118AbXIXQr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761972AbXIXQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:38:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51754 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762508AbXIXQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:38:12 -0400
Date: Mon, 24 Sep 2007 18:37:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: MAX_LOCKDEP_SUBCLASSES too low in 2.6.23-rc7-mm1
Message-ID: <20070924183759.085d901c@twins>
In-Reply-To: <20070924160358.GA19736@Krystal>
References: <20070924160358.GA19736@Krystal>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 12:03:58 -0400 Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca> wrote:

> Hi Ingo,
> 
> I got the following printk when booting 2.6.23-rc7-mm1 :
> 
> BUG: MAX_LOCKDEP_SUBCLASSES too low!
> turning off the locking correctness validator.
> 
> Is it known/correct situation ?

Known, bug in r/o mounts code:

> static void lock_and_coalesce_cpu_mnt_writer_counts(void)
> {
> 	int cpu;
> 	struct mnt_writer *cpu_writer;
> 
> 	for_each_possible_cpu(cpu) {
> 		cpu_writer = &per_cpu(mnt_writers, cpu);
> 		spin_lock_nested(&cpu_writer->lock, 42);
> 		                                   ^^^^
> 
> What the heck is going on? Given that MAX_LOCKDEP_SUBCLASSES is only 8,
> this reliably turns off lockdep at boot.
