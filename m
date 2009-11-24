Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZKXWFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZKXWFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZKXWFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:05:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:14603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbZKXWFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:05:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="470280311"
Subject: Re: [PATCH v2] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0911242252190.24119@localhost.localdomain>
References: <20091124093518.3909.16435.stgit@ppwaskie-hc2.jf.intel.com>
	 <alpine.LFD.2.00.0911241151360.24119@localhost.localdomain>
	 <20091124.095703.107687163.davem@davemloft.net>
	 <alpine.LFD.2.00.0911242252190.24119@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 14:05:43 -0800
Message-Id: <1259100343.2631.78.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 13:56 -0800, Thomas Gleixner wrote:
> On Tue, 24 Nov 2009, David Miller wrote:
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Tue, 24 Nov 2009 12:07:35 +0100 (CET)
> > 
> > > And what does the kernel do with this information and why are we not
> > > using the existing device/numa_node information ?
> > 
> > It's a different problem space Thomas.
> > 
> > If the device lives on NUMA node X, we still end up wanting to
> > allocate memory resources (RX ring buffers) on other NUMA nodes on a
> > per-queue basis.
> > 
> > Otherwise a network card's forwarding performance is limited by the
> > memory bandwidth of a single NUMA node, and on a multiqueue cards we
> > therefore fare much better by allocating each device RX queue's memory
> > resources on a different NUMA node.
> > 
> > It is this NUMA usage that PJ is trying to export somehow to userspace
> > so that irqbalanced and friends can choose the IRQ cpu masks more
> > intelligently.
> 
> So you need a preferred irq mask information on a per IRQ basis and
> that mask is not restricted to the CPUs of a single NUMA node, right ?
> 

Just to clarify, I need a preferred CPU mask on a per IRQ basis.  And
yes, that mask may not be restricted to the CPUs of a single NUMA node.
But in the normal case, the mask will be restricted to CPUs of a single
node.

Cheers,
-PJ

