Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbXIMJB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbXIMJB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXIMJBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:01:19 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27860 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbXIMJBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:01:17 -0400
X-IronPort-AV: i="4.20,248,1186372800"; 
   d="scan'208"; a="39531121:sNHT31598098"
Subject: Re: [PATCH] Blackfin arch: add some missing syscall
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>, bernd.schmidt@analog.com
Cc: Matthew Wilcox <matthew@wil.cx>, Paul Mundt <lethal@linux-sh.org>,
       Bryan Wu <bryan.wu@analog.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
In-Reply-To: <8bd0f97a0709130137l55977c28w95cf8527ae8b9e24@mail.gmail.com>
References: <1189670203.30686.15.camel@roc-desktop>
	 <20070913081852.GC17367@parisc-linux.org>
	 <8bd0f97a0709130137l55977c28w95cf8527ae8b9e24@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 13 Sep 2007 16:57:29 +0800
Message-Id: <1189673849.30686.28.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Sep 2007 09:01:16.0249 (UTC) FILETIME=[A4609490:01C7F5E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 04:37 -0400, Mike Frysinger wrote:
> On 9/13/07, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Thu, Sep 13, 2007 at 03:56:43PM +0800, Bryan Wu wrote:
> > > +/* Not relevant on no-mmu */
> >
> > I thought this list seemed a little long, so I investigated a couple
> > of them.  mbind makes sense (it's only implemented for NUMA ... a NUMA
> > embedded platform?  not the kind which runs applications that use mbind),
> 
> sorry, i dont quite follow ... you're saying it does or doesnt make
> sense to have NUMA syscalls on a no-mmu platform ?  my [limited]
> understanding of NUMA is that it, by definition, requires a MMU in
> order to shunt pages around
> 

I think Matt means mbind can be ignored because it is for NUMA.

> > but mremap doesn't -- there's even an implementation in mm/nommu.c.
> > Could you check the rest of these over to see if they truly don't need
> > to be implemented for no-mmu?
> 
> you're right we want mremap, my fault
> 

Yes, I do think so, both sys_mremap and sys_munmap are implemented in
mm/nommu.c. How do think of this, Bernd?

> > I think you'll want the *robust_list syscalls too.
> 
> lack of man pages on these made be lazy and dump em into the mmu pile
> when in reality they have nothing to do with it ... we do want these
> 

No man pages for this fancy syscalls. I found some info here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e9056f13bfcdd054a0c3d730e4e096748d8a363a
I am not sure for these. Need some investigation.

> > > +#define __IGNORE_swapon
> > > +#define __IGNORE_swapoff
> 
> a no brainer -- not usable on no-mmu
> 
> > > +#define __IGNORE_msync
> > > +#define __IGNORE_remap_file_pages
> > > +#define __IGNORE_mlock
> > > +#define __IGNORE_munlock
> > > +#define __IGNORE_mlockall
> > > +#define __IGNORE_munlockall
> > > +#define __IGNORE_mincore
> > > +#define __IGNORE_madvise
> 
> implementation only exists for mmu
> 
> > > +#define __IGNORE_mbind
> > > +#define __IGNORE_get_mempolicy
> > > +#define __IGNORE_set_mempolicy
> > > +#define __IGNORE_migrate_pages
> > > +#define __IGNORE_move_pages
> 
> NUMA only
> 
> > > +#define __IGNORE_mremap
> > > +#define __IGNORE_set_robust_list
> > > +#define __IGNORE_get_robust_list
> 
> we want these
> 
> > > +#define __IGNORE_getcpu
> 
> useful only with SMP so i guess we should do it

also the brand new syscall fallocate should be added as Paul said:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97ac73506c0ba93f30239bb57b4cfc5d73e68a62

Thanks a lot
-Bryan


