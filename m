Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbXJBHTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbXJBHTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXJBHTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:19:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbXJBHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:19:30 -0400
Date: Tue, 2 Oct 2007 00:18:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com,
       "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-Id: <20071002001809.0a814d0b.akpm@linux-foundation.org>
In-Reply-To: <20071002070110.GA30490@one.firstfloor.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<p733awu6nva.fsf@bingen.suse.de>
	<20071001233225.88c67e8b.akpm@linux-foundation.org>
	<20071002070110.GA30490@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 09:01:10 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > > These are fine to me, but should not all go through my tree
> > > because most changes are in other architectures.
> > 
> > I assume you're referring to just
> > convert-cpu_sibling_map-to-be-a-per-cpu-variable* here.
> 
> All the *-to-*per-cpu* patches from Mike yes

OK, I'll merge those directly.

> > 
> > > I have nothing pending currently. I rejected
> > > also quite a few of these.
> > 
> > You did?  I'd have dropped them if you had.
> > 
> > Oh well, I was planning on a maintainer patch-bombing tomorrow - let's go
> > through them again.
> 
> I'll send you a detailed list after the patch bomb.

Thanks

> > > 
> > > Hmm, need to recheck the x86_64 bits I think.
> > 
> > Thanks.
> 
> Done now (adding ccs) 
> 
> x86_64-sparsemem_vmemmap-2m-page-size-support.patch
> x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch          
> Look like these two should be merged together

Shall do.

> Also I'm concerned about a third variant of memmappery. Can we agree
> to only merge that when the old sparsemem support is removed from x86-64? 

How much work would that be?

> Otherwise it looks good to me.
> 
> > How come?  Memoryless node can and do occur in real-world machines.  Kernel
> > should support that?
> 
> But a node is just defined by its memory? 

Don't think so.  A node is a lump of circuitry which can have zero or more
CPUs, IO and memory.

It may initially have been conceived as a memory-only concept in the Linux
kernel, but that doesn't fully map onto reality (does it?)

There was a real-world need for this, I think from the Fujitsu guys.  That
should be spelled out in the changelog but isn't.

> > If so, that might be OK - the app just needs a reliable way of working out
> > whether it's on a 32- or 64-bit kernel?
> 
> That would be ugly and a little error prone (would this case really be 
> tested in user space normally?) but might work.

I guess it wouldn't be too hard for a 64-bit kernel to fake up 32-bit data
for 32-bit userspace.  For each architecture :( But let's see what Matt
thinks.

> > 
> > > > x86_64-efi-boot-support-efi-frame-buffer-driver.patch
> > > > x86_64-efi-boot-support-efi-boot-document.patch
> > > 
> > > This required changes from review I think. And the previous patch is useless
> > > without a boot protocol.
> > 
> > So should I drop them?
> 
> Yes for now please.

Done.

> e.g. we at least need a patch to actually check the version number
> of the boot protocol.

