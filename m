Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXLNEbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXLNEbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbXLNEbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:31:23 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56377 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbXLNEbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:31:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <rdreier@cisco.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
References: <20071213235543.568682000@intel.com>
	<20071213235712.339088000@intel.com> <ada8x3x7vw5.fsf@cisco.com>
Date: Thu, 13 Dec 2007 21:28:23 -0700
In-Reply-To: <ada8x3x7vw5.fsf@cisco.com> (Roland Dreier's message of "Thu, 13
	Dec 2007 20:17:14 -0800")
Message-ID: <m1sl25q4rc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  > --- linux-2.6.24-rc4.orig/include/asm-x86/io_64.h 2007-12-11
> 14:24:56.000000000 -0800
>  > +++ linux-2.6.24-rc4/include/asm-x86/io_64.h 2007-12-11 15:49:52.000000000
> -0800
>  > @@ -142,7 +142,8 @@
>  > * it's useful if some control registers are in such an area and write
> combining
>  >   * or read caching is not desirable:
>  >   */
>  > -extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long
> size);
>  > +extern void __iomem * ioremap_nocache(unsigned long offset, unsigned long
> size);
>  > +extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
>
> I think ioremap_wc() needs to be available on all archs for this to be
> really useful to drivers.  It can be a fallback to ioremap_nocache()
> everywhere except 64-bit x86, but it's not nice for every driver that
> wants to use this to need an "#ifdef X86" or whatever.
>
> Also I didn't see anything like pgprot_wc() in the patchset (although
pgprot_writcombined.

> I just skimmed quickly for now).  The use case I actually have would
> be in a a driver's .mmap method, where I want to map device registers
> into userspace with write-combining turned on:
>
> 	vma->vm_page_prot = pgprot_wc(vma->vm_page_prot);
> 	io_remap_pfn_range(vma, vma->vm_start, pfn, PAGE_SIZE,
> vma->vm_page_prot);
>
> where the pfn points into a PCI BAR (which will only be mapped once,
> so no issues with conflicting PATs or anything like that).

Eric

