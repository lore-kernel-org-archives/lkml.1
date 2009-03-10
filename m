Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZCJOUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZCJOUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZCJOTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:19:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47219 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754951AbZCJOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:19:49 -0400
Date: Tue, 10 Mar 2009 10:19:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 01/11] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20090310135018.GB3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101017040.2962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> * prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:
> 
> 
> > +static u8			tprio[HB_NUM];	/* Thread bp max priorities */
> > +LIST_HEAD(kernel_bps);			/* Kernel breakpoint list */
> > +static LIST_HEAD(thread_list);			/* thread_hw_breakpoint list */
> > +DEFINE_PER_CPU(struct cpu_hw_breakpoint, cpu_bp);

If nobody minds, I'll answer some of these questions on Prasad's behalf 
because they address parts of the code that were written before he took 
over the project.

> hm, why do we need the whole 'priority' mechanism? It seems very 
> over-designed to me.

This was done at Roland McGrath's express request.  We should see what 
he has to say about it.

> The likelyhood of both user-space and kernel-space to use 
> hw-breakpoints is very low to begin with. And if they use them, 
> the likelyhood of there being more than 4 debugregs required in 
> the same context is even lower.

Not all architectures have 4 debug registers.  Most have only one.

> If that happens we shouldnt try to be too smart about them - 
> just override user-space ones with kernel space ones and that's 
> it. No explicit priorities are needed.

Roland really did not want it done this way.

Alan Stern

