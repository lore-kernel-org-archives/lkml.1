Return-Path: <linux-kernel-owner+w=401wt.eu-S1765888AbYBOHkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765888AbYBOHkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYBOHkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:40:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:29284 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYBOHkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,357,1199692800"; 
   d="scan'208";a="340321024"
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
Date: Fri, 15 Feb 2008 15:32:40 +0800
Message-Id: <1203060760.30010.29.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 07:31:37.0996 (UTC) FILETIME=[CCB78CC0:01C86FA4]
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

Yes. I think so too.

> So perhaps, at least as far as arch/x86/kernel/efi*.c files go, it would 
> be cleaner to just replace EFI_PAGE_SHIFT with PAGE_SHIFT and 
> EFI_PAGE_SIZE with PAGE_SIZE?

Maybe. On x86, the only usage of EFI memory map (and
EFI_PAGE_SHIFT/EFI_PAGE_SIZE) is to map the EFI runtime memory area. So
I think either dealing with potential difference now or doing it in the
future when necessary is easy.

Best Regards,
Huang Ying

