Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbXJBHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbXJBHBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXJBHBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:01:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbXJBHBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:01:13 -0400
Date: Tue, 2 Oct 2007 09:01:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-ID: <20071002070110.GA30490@one.firstfloor.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001233225.88c67e8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > These are fine to me, but should not all go through my tree
> > because most changes are in other architectures.
> 
> I assume you're referring to just
> convert-cpu_sibling_map-to-be-a-per-cpu-variable* here.

All the *-to-*per-cpu* patches from Mike yes

> 
> > I have nothing pending currently. I rejected
> > also quite a few of these.
> 
> You did?  I'd have dropped them if you had.
> 
> Oh well, I was planning on a maintainer patch-bombing tomorrow - let's go
> through them again.

I'll send you a detailed list after the patch bomb.

> > 
> > Hmm, need to recheck the x86_64 bits I think.
> 
> Thanks.

Done now (adding ccs) 

x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch          
Look like these two should be merged together

Also I'm concerned about a third variant of memmappery. Can we agree
to only merge that when the old sparsemem support is removed from x86-64? 

Otherwise it looks good to me.

> How come?  Memoryless node can and do occur in real-world machines.  Kernel
> should support that?

But a node is just defined by its memory? 
 
> If so, that might be OK - the app just needs a reliable way of working out
> whether it's on a 32- or 64-bit kernel?

That would be ugly and a little error prone (would this case really be 
tested in user space normally?) but might work.

> 
> > > x86_64-efi-boot-support-efi-frame-buffer-driver.patch
> > > x86_64-efi-boot-support-efi-boot-document.patch
> > 
> > This required changes from review I think. And the previous patch is useless
> > without a boot protocol.
> 
> So should I drop them?

Yes for now please.

e.g. we at least need a patch to actually check the version number
of the boot protocol.

-Andi

