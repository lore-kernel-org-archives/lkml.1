Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXJBJ0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXJBJ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXJBJ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:26:27 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4908 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXJBJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:26:27 -0400
Date: Tue, 2 Oct 2007 10:26:01 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-ID: <20071002092601.GA30636@shadowen.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org> <20071002070110.GA30490@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002070110.GA30490@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 09:01:10AM +0200, Andi Kleen wrote:

> x86_64-sparsemem_vmemmap-2m-page-size-support.patch
> x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch          
> Look like these two should be merged together
>
> Also I'm concerned about a third variant of memmappery. Can we agree
> to only merge that when the old sparsemem support is removed from x86-64? 
> 
> Otherwise it looks good to me.

sparsemem vmemmap is a sparsemem variant.  By that I mean that it uses all
the same infrastructure as sparsemem.  That sparsemem code is generic code
and shared with the other architectures.  There essentially is no code to
remove which is not generic and currently in use by other architectures.
The patches as they stand select the vmemmap variant unconditionally
when sparsemem is selected, we are not adding a new option for x86_64
overall -- in that sense classic sparsemem is already removed for x86_64
by these patches.

The longer plan is to pull out the other memory models where they are
no longer beneficial with a view to ending up with only one.  A good
example is the private virtual memory map implemented on ia64, which
is an early target.  As discussed at VM summit, we are also looking at
removing discontigmem for x86.  That review will continue.

> > How come?  Memoryless node can and do occur in real-world machines.  Kernel
> > should support that?
> 
> But a node is just defined by its memory? 

I thought that a node was a unit of numa locality.  Cirtainly some
machines seem to express themselves as memory only nodes and cpu only
nodes; in the past I am sure we have also heard of IO only nodes
representing "io drawers" and the like.

-apw
