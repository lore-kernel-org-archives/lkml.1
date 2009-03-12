Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZCLRZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZCLRZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZCLRZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:25:22 -0400
Received: from waste.org ([66.93.16.53]:36568 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbZCLRZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:25:21 -0400
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0903121206250.5493@qirst.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>
	 <20090309181756.CF66.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903091706540.1861@qirst.com>
	 <alpine.DEB.2.00.0903091422510.5410@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903101649330.20363@qirst.com>
	 <1236719283.3205.24.camel@calx>
	 <alpine.DEB.1.10.0903121206250.5493@qirst.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 12:23:24 -0500
Message-Id: <1236878604.3213.57.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 12:08 -0400, Christoph Lameter wrote:
> On Tue, 10 Mar 2009, Matt Mackall wrote:
> 
> > > > Yes, and that's why we require the cpuset hardwall on a configurable
> > > > per-cpuset basis.  If a cpuset has set this option for its workload, then
> > > > it is demanding object allocations from local memory.  Other cpusets that
> > > > do not have memory_slab_hardwall set can still allocate from any cpu slab
> > > > or partial slab, including those allocated for the hardwall cpuset.
> > >
> > > You cannot hardwall something that is used in a shared way by processes in
> > > multiple cpusets.
> >
> > He can enforce that every allocation made when a given task is current
> > conforms. His patch demonstrates that.
> 
> Of course. But that may just be a subset of the data used by a task. If an
> inode, dentry and so on was already allocated in the context of another
> process then the locality of that allocation will not be changed. The
> hardwall will have no effect.

It will if he's also using a namespace. This is part of a larger puzzle.

-- 
http://selenic.com : development and support for Mercurial and Linux


