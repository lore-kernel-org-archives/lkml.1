Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXJBRZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXJBRZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXJBRZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:25:30 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:33276 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbXJBRZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:25:29 -0400
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org
In-Reply-To: <20071002004324.be030b63.akpm@linux-foundation.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <p733awu6nva.fsf@bingen.suse.de>
	 <20071001233225.88c67e8b.akpm@linux-foundation.org>
	 <20071002070110.GA30490@one.firstfloor.org>
	 <20071002001809.0a814d0b.akpm@linux-foundation.org>
	 <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20071002004324.be030b63.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 02 Oct 2007 13:25:29 -0400
Message-Id: <1191345930.5026.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 00:43 -0700, Andrew Morton wrote:
> On Tue, 2 Oct 2007 16:36:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Tue, 2 Oct 2007 00:18:09 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > How come?  Memoryless node can and do occur in real-world machines.  Kernel
> > > > > should support that?
> > > > 
> > > > But a node is just defined by its memory? 
> > > 
> > > Don't think so.  A node is a lump of circuitry which can have zero or more
> > > CPUs, IO and memory.
> > > 
> > > It may initially have been conceived as a memory-only concept in the Linux
> > > kernel, but that doesn't fully map onto reality (does it?)
> > > 
> > > There was a real-world need for this, I think from the Fujitsu guys.  That
> > > should be spelled out in the changelog but isn't.
> > 
> > Yes, Fujitsu and HP guys really need this memory-less-node support. 
> > 
> 
> For what reason, please?

For the HP platforms, we can configure each cell with from 0% to 100%
"cell local memory".  When we configure with <100% CLM, the "missing
percentages" are interleaved by hardware on a cache-line granularity to
improve bandwidth at the expense of latency for numa-challenged
applications [and OSes, but not our problem ;-)].  When we boot Linux on
such a config, all of the real nodes have no memory--it all resides in a
single interleaved pseudo-node.  

When we boot Linux on a 100% CLM configuration [== NUMA], we still have
the interleaved pseudo-node.  It contains a few hundred MB stolen from
the real nodes to contain the DMA zone.  [Interleaved memory resides at
phys addr 0].  The memoryless-nodes patches, along with the zoneorder
patches, support this config as well.

Also, when we boot a NUMA config with the "mem=" command line,
specifying less memory than actually exists, Linux takes the excluded
memory "off the top" rather than distributing it across the nodes.  This
can result in memoryless nodes, as well.

Lee

