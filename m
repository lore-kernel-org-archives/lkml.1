Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbZKXV4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbZKXV4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934232AbZKXV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:56:46 -0500
Received: from www.tglx.de ([62.245.132.106]:49062 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934319AbZKXV4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:56:45 -0500
Date: Tue, 24 Nov 2009 22:56:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.jf.intel.com, mingo@elte.hu, yong.zhang0@gmail.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
In-Reply-To: <20091124.095703.107687163.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0911242252190.24119@localhost.localdomain>
References: <20091124093518.3909.16435.stgit@ppwaskie-hc2.jf.intel.com> <alpine.LFD.2.00.0911241151360.24119@localhost.localdomain> <20091124.095703.107687163.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, David Miller wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, 24 Nov 2009 12:07:35 +0100 (CET)
> 
> > And what does the kernel do with this information and why are we not
> > using the existing device/numa_node information ?
> 
> It's a different problem space Thomas.
> 
> If the device lives on NUMA node X, we still end up wanting to
> allocate memory resources (RX ring buffers) on other NUMA nodes on a
> per-queue basis.
> 
> Otherwise a network card's forwarding performance is limited by the
> memory bandwidth of a single NUMA node, and on a multiqueue cards we
> therefore fare much better by allocating each device RX queue's memory
> resources on a different NUMA node.
> 
> It is this NUMA usage that PJ is trying to export somehow to userspace
> so that irqbalanced and friends can choose the IRQ cpu masks more
> intelligently.

So you need a preferred irq mask information on a per IRQ basis and
that mask is not restricted to the CPUs of a single NUMA node, right ?

Thanks,

	tglx



