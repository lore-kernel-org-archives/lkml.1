Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbYAYJ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbYAYJ3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYAYJ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:29:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:23061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYAYJ3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:29:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,249,1199692800"; 
   d="scan'208";a="507998897"
Subject: Re: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080125091655.GD23708@elte.hu>
References: <1201240501.15972.46.camel@caritas-dev.intel.com>
	 <20080125091655.GD23708@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 17:26:17 +0800
Message-Id: <1201253177.15972.57.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 09:25:34.0685 (UTC) FILETIME=[3D06C0D0:01C85F34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-25 at 10:16 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > This patch fixes some bugs of making EFI runtime code executable.
> > 
> > - Use change_page_attr in i386 too. Because the runtime code may be
> >   mapped not through ioremap.
> > 
> > - If there is no _PAGE_NX in __supported_pte_mask, the change_page_attr
> >   is not called.
> > 
> > - Make efi_ioremap map pages as PAGE_KERNEL_EXEC, because EFI runtime
> >   code may be mapped through efi_ioremap.
> 
> thanks, applied.
> 
> note that here:
> 
> > -		set_fixmap_nocache(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
> > -				   offset);
> > +		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
> > +			     offset, PAGE_KERNEL_EXEC);
> 
> you've changed it from nocache-noexec to cached-exec. I suspect that's 
> what we want - except if an early EFI area can be non-prefetchable 
> device memory. Can that ever happen? Would you like to have 
> PAGE_KERNEL_NOCACHE_EXEC perhaps? I implemented that yesterday but did 
> not commit it yet. (see the patch below)

Yes. EFI area can be non-prefetchable device memory. I should use
PAGE_KERNEL_NOCACHE_EXEC.

A question about this:

The MTRR on x86 should have set the memory area as un-cachable. Why do
we bother to set it in page table?

Best Regards,
Huang Ying

