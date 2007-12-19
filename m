Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbXLSUYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbXLSUYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbXLSUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:23:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:6737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbXLSUXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:23:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,186,1196668800"; 
   d="scan'208";a="450297994"
Date: Wed, 19 Dec 2007 12:23:36 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219202335.GB13605@linux-os.sc.intel.com>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu> <476972A0.3050105@zytor.com> <20071219194032.GA8849@elte.hu> <4769757E.306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4769757E.306@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:48:14AM -0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >
> >i dont think it's required for C3 to even turn off any portion of the 
> >CPU - if an interrupt arrives after the C3 sequence is initiated but 
> >just before dirty cachelines have been flushed then the CPU can just 
> >return without touching anything (such as the TLB) - right? So i dont 
> >think there's any implicit guarantee of TLB flushing (nor should there 
> >be), but in practice, a good C3 sequence would (statistically) turn off 
> >large portions of the CPU and hence the TLB as well.
> >
> 
> I think C3 guarantees that the cache contents stay intact, and thus it 
> might make sense in some technology to preserve the TLB as well (being a 
> kind of cache.)
> 
> Otherwise, what you say here of course is absolutely correct.
> 

C3 does not guarantee all cache contents. Infact, atleast on Intel, 
L1 will be almost always flushed. Newer more power efficient CPUs does dynamic
cache sizing [1]

C3 just guarantees that the caches are coherent. That is, if they are intact,
then DMA will keep cache consistent.

Thanks,
Venki

[1] - http://download.intel.com/products/processor/core2duo/mobile_prod_brief.pdf

