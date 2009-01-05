Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZAEU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZAEU4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZAEU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:56:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZAEU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:56:08 -0500
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long
 periods
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
In-Reply-To: <20090105175641.GA17055@sgi.com>
References: <20090105175641.GA17055@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Jan 2009 21:55:58 +0100
Message-Id: <1231188958.11687.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 11:56 -0600, Dimitri Sivanich wrote:
> One place we've found this happens is in update_curr(), which calculates a
> delta_exec value as follows:
>         delta_exec = (unsigned long)(now - curr->exec_start);
> 
> Sometimes this value will be very large, as 'now' (the rq clock time) will
> be less than 'exec_start'.  When this happens, __update_curr() will
> calculate a delta_exec_weighted based on this large value and add it to the
> thread's vruntime:
>         curr->vruntime += delta_exec_weighted;

So you're saying your rq->clock = sched_clock_cpu(cpu) = sched_clock()
[on ia64] goes backwards?

If so, then that's an architecture bug, sched_clock() must never be seen
to go backwards!
