Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbYBOGXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbYBOGXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbYBOGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:23:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:20707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYBOGXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:23:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,356,1199692800"; 
   d="scan'208";a="258032025"
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
From: "Huang, Ying" <ying.huang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0802142139260.4255@woody.linux-foundation.org>
References: <20080214131317.GA27769@basil.nowhere.org>
	 <20080214161218.GA28152@elte.hu>
	 <1203050886.30010.19.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.00.0802142139260.4255@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 14:24:40 +0800
Message-Id: <1203056680.30010.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 06:23:38.0663 (UTC) FILETIME=[4D3EBB70:01C86F9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 21:44 -0800, Linus Torvalds wrote:
> 
> On Fri, 15 Feb 2008, Huang, Ying wrote:
> > 
> > I think the patch following may be better, because it is possible that
> > the EFI_PAGE_SHIFT and PAGE_SHIFT are different.
> 
> If this is a problem in practice, we'd be better off having a helper 
> function to do it, to avoid overflows. Right now, doing
> 
> > +		unsigned long num_pages;
> > +		num_pages = (md->num_pages << EFI_PAGE_SHIFT) >> PAGE_SHIFT;
> 
> overflows at 4GB on x86-32. And maybe you never have areas that big, and 
> people are moving over to 64-bit anyway, it still sounds like a bug 
> waiting to happen.
> 
> So *if* we care (I doubt we do, since EFI_PAGE_SHIFT at least right now 
> matches PAGE_SHIFT on x86), you'd probably want to do something like
> 
>   static inline unsigned long efi_pages_to_native_pages(unsigned long efi_pages)
>   {
>   #if EFI_PAGE_SHIFT > PAGE_SHIFT
> 	return efi_pages << (EFI_PAGE_SHIFT - PAGE_SHIFT);
>   #else
> 	return efi_pages >> (PAGE_SHIFT - EFI_PAGE_SHIFT);
>   #endif
>   }
> 
> or whatever.
> 
> Otherwise, trying to avoid a bug with different page sizes is actually 
> more likely to *introduce* one rather than fix one..

Yes, I will fix this.

Best Regards,
Huang Ying

