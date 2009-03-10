Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZCJVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZCJVKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZCJVKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:10:04 -0400
Received: from waste.org ([66.93.16.53]:56767 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbZCJVKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:10:02 -0400
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0903101649330.20363@qirst.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>
	 <20090309181756.CF66.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903091706540.1861@qirst.com>
	 <alpine.DEB.2.00.0903091422510.5410@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903101649330.20363@qirst.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 16:08:03 -0500
Message-Id: <1236719283.3205.24.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 16:50 -0400, Christoph Lameter wrote:
> On Mon, 9 Mar 2009, David Rientjes wrote:
> 
> > On Mon, 9 Mar 2009, Christoph Lameter wrote:
> >
> > > > On large NUMA machines, it is currently possible for a very large
> > > > percentage (if not all) of your slab allocations to come from memory that
> > > > is distant from your application's set of allowable cpus.  Such
> > > > allocations that are long-lived would benefit from having affinity to
> > > > those processors.  Again, this is the typical use case for cpusets: to
> > > > bind memory nodes to groups of cpus with affinity to it for the tasks
> > > > attached to the cpuset.
> > >
> > > Can you show us a real workload that suffers from this issue?
> > >
> >
> > We're more interested in the isolation characteristic, but that also
> > benefits large NUMA machines by keeping nodes free of egregious amounts of
> > slab allocated for remote cpus.
> 
> So no real workload just some isolation idea.
> 
> > > If you want to make sure that an allocation comes from a certain node then
> > > specifying the node in kmalloc_node() will give you what you want.
> > >
> >
> > That's essentially what the change does implicitly: it changes all
> > kmalloc() calls to kmalloc_node() for current->mems_allowed.
> 
> Ok then you can use kmalloc_node?

Yes, he certainly could change every single kmalloc that a process might
ever reach to kmalloc_node. But I don't think that's optimal.

> 
> > > The usage of kernel objects may not be cpuset specific. This is true for
> > > other objects than inode and dentries well.
> > >
> >
> > Yes, and that's why we require the cpuset hardwall on a configurable
> > per-cpuset basis.  If a cpuset has set this option for its workload, then
> > it is demanding object allocations from local memory.  Other cpusets that
> > do not have memory_slab_hardwall set can still allocate from any cpu slab
> > or partial slab, including those allocated for the hardwall cpuset.
> 
> You cannot hardwall something that is used in a shared way by processes in
> multiple cpusets.

He can enforce that every allocation made when a given task is current
conforms. His patch demonstrates that.

-- 
http://selenic.com : development and support for Mercurial and Linux


