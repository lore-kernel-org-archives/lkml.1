Return-Path: <linux-kernel-owner+w=401wt.eu-S965175AbXGSRB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175AbXGSRB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965170AbXGSRBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:01:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965138AbXGSRBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:01:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: kmalloc zero size changes break i386
Date: Thu, 19 Jul 2007 19:01:06 +0200
User-Agent: KMail/1.9.6
Cc: "Christoph Lameter" <clameter@sgi.com>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
References: <200707191201.35777.ak@suse.de> <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
In-Reply-To: <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191901.06492.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 16:08:34 Pekka Enberg wrote:
> Hi Andi,
> 
> On 7/19/07, Andi Kleen <ak@suse.de> wrote:
> > qemu testing and booting test machines with i386 kernels wasn't very successfull
> > with recent git kernels. I got either BUGs because of failing sysfs initialization
> > or oopses in kmalloc, but no user land.
> >
> > I bisected it down to this commit.
> >
> > To reproduce: try to boot a 386 defconfig kernel, compiled with gcc 4.1, in qemu
> 
> [snip]
> 
> > 6cb8f91320d3e720351c21741da795fed580b21b is first bad commit
> > commit 6cb8f91320d3e720351c21741da795fed580b21b
> > Author: Christoph Lameter <clameter@sgi.com>
> > Date:   Tue Jul 17 04:03:22 2007 -0700
> >
> >     Slab allocators: consistent ZERO_SIZE_PTR support and NULL result semantics
> 
> I have i386 defconfig kernel + qemu + busybox userland image + GCC
> 4.1.2 booting ok here. Did you manage to capture the oops? 

The sysfs crashes are all over; the first I saw is the BUG_ON() in
kernel_param_sysfs_setup(); but it was changing during the bisect
and in other similar sysfs BUG_ON()s too.

During one bisect state I also had a crash in kmalloc itself. I right
now don't have it anymore; do you want me to restart the bisect go
recreate it?

x86-64 kernels BTW work just fine; just something seems to be broken
with i386.

Unfortunately newsetup seems to have broken argument passing to qemu
so it's a bit difficult to get more out of it.

> Is the 
> userland image available somewhere?

Userland is not reached yet. You can just use a dummy dd if=/dev/zero of=.... bs=1M count=1
file. 

-Andi
