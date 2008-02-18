Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYBRByg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYBRByg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYBRByZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:54:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:1671 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbYBRByG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:54:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,368,1199692800"; 
   d="scan'208";a="341450412"
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080215070843.GA6975@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org>
	 <20080214161218.GA28152@elte.hu>
	 <1203050886.30010.19.camel@caritas-dev.intel.com>
	 <20080215070843.GA6975@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 09:53:56 +0800
Message-Id: <1203299636.27509.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 18 Feb 2008 01:53:43.0574 (UTC) FILETIME=[17758360:01C871D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 08:08 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > On Thu, 2008-02-14 at 17:12 +0100, Ingo Molnar wrote: 
> > > this is indeed a bug (we change the attributes for a larger area than 
> > > needed), but your fix is unclean. Find below a cleaner solution.
> > > 
> > > Ying, if you agree with this fix could you please test and ACK it before 
> > > we push it to Linus? (this fix is also in the latest x86.git#mm)
> > 
> > I think the patch following may be better, because it is possible that 
> > the EFI_PAGE_SHIFT and PAGE_SHIFT are different.
> 
> right now, EFI page size is 4096:
> 
>   include/linux/efi.h:#define EFI_PAGE_SHIFT          12
> 
> i doubt we'll ever change PAGE_SIZE on x86 - ia64's variable lowlevel 
> pagesizes are not particularly useful IMO. I think we'll at most have 
> some generic kernel feature that allows a larger PAGE_CACHE_SHIFT - but 
> on the lowlevel MMU level we'll always stay at 4K.
> 
> and i doubt EFI_PAGE_SHIFT would want to (ever) go away from 12 either. 

After looking up in UEFI specification, I found that it is specified by
UEFI specification 2.1 (section 6.2, page 124) that the NumberOfPages
(num_pages) of EFI_MEMORY_DESCRIPTOR (efi_memory_desc_t) must be "Number
of 4KB pages in the memory region". So we need not worry about potential
EFI_PAGE_SHIFT changes.

Best Regards,
Huang Ying

> So perhaps, at least as far as arch/x86/kernel/efi*.c files go, it would 
> be cleaner to just replace EFI_PAGE_SHIFT with PAGE_SHIFT and 
> EFI_PAGE_SIZE with PAGE_SIZE?

