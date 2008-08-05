Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYHEXsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYHEXsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYHEXsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:48:01 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55138 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYHEXsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:48:00 -0400
Date: Wed, 6 Aug 2008 09:47:58 +1000
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kdump, ia64: always reserve elfcore header memory in crash
	kernel
Message-ID: <20080805234754.GA8627@verge.net.au>
References: <20080805094825.GA9712@verge.net.au> <20080805125634.GA15193@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805125634.GA15193@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 08:56:34AM -0400, Vivek Goyal wrote:
> On Tue, Aug 05, 2008 at 07:48:27PM +1000, Simon Horman wrote:
> > elfcore header memory needs to be reserved in a crash kernel.
> > This means that the relevant code should be protected
> > by CONFIG_CRASH_DUMP rather than CONFIG_PROC_VMCORE.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > --- 
> > Andrew, this patch fixes bug in the (unlikely) case where
> > an ia64 crashdump kernel does not have CONFIG_PROC_FS set.
> > I think it is worth including in 2.6.27. But breakage cases are
> > likely to be minimal to non-existent, so I am comfortable
> > with post 2.6.27 too.
> > 
> > This patch should be appended to the series,
> > "is_kdump_kernel() cleanup and related patches".
> > 
> > http://lists.infradead.org/pipermail/kexec/2008-July/002270.html
> > 
> > Index: linux-2.6/arch/ia64/kernel/efi.c
> > ===================================================================
> > --- linux-2.6.orig/arch/ia64/kernel/efi.c	2008-08-05 18:31:13.000000000 +1000
> > +++ linux-2.6/arch/ia64/kernel/efi.c	2008-08-05 18:31:21.000000000 +1000
> > @@ -1334,7 +1334,7 @@ kdump_find_rsvd_region (unsigned long si
> >  }
> >  #endif
> >  
> > -#ifdef CONFIG_PROC_VMCORE
> > +#ifdef CONFIG_CRASH_DUMP
> >  /* locate the size find a the descriptor at a certain address */
> >  unsigned long __init
> >  vmcore_find_descriptor_size (unsigned long address)
> > Index: linux-2.6/arch/ia64/kernel/setup.c
> > ===================================================================
> > --- linux-2.6.orig/arch/ia64/kernel/setup.c	2008-08-05 18:31:20.000000000 +1000
> > +++ linux-2.6/arch/ia64/kernel/setup.c	2008-08-05 18:31:21.000000000 +1000
> > @@ -352,7 +352,7 @@ reserve_memory (void)
> >  	}
> >  #endif
> >  
> > -#ifdef CONFIG_PROC_VMCORE
> > +#ifdef CONFIG_CRASH_KERNEL
> >  	if (reserve_elfcorehdr(&rsvd_region[n].start,
> >  			       &rsvd_region[n].end) == 0)
> >  		n++;
> 
> Hi Simon,
> 
> Thanks for the patch. One minor nit. I think compilation will fail
> in the case of CONFIG_PROC_VMCORE=n. Because reserve_elfcorehdr will
> try to use vmcore_unusabe() which is not available now?

Yes, sorry. I forgot to send a revised version of the patch that
creates vmcore_unusabe() so that it is present if CONFIG_PROC_VMCORE=n.
I will do so.

