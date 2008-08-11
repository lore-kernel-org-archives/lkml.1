Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYHKTJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYHKTJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYHKTJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:09:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:37326 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbYHKTJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,189,1217833200"; 
   d="scan'208";a="325277748"
Date: Mon, 11 Aug 2008 12:09:08 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [rfc][patch] x86: avoid highmem cache attribute aliasing
Message-ID: <20080811190908.GM13158@linux-os.sc.intel.com>
References: <20080801011521.GB20407@wotan.suse.de> <20080811171019.GK4524@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811171019.GK4524@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:10:19AM -0700, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Highmem code can leave ptes and tlb entries around for a given page
> > even after kunmap, and after it has been freed.
> >
> > From what I can gather, the PAT code may change the cache attributes
> > of arbitrary physical addresses (ie. including highmem pages), which
> > would result in aliases in the case that it operates on one of these
> > lazy tlb highmem pages.
> >
> > Flushing kmaps should solve the problem.
> >
> > I've also just added code for conditional flushing if we haven't got
> > any dangling highmem aliases -- this should help performance if we
> > change page attributes frequently or systems that aren't using much
> > highmem pages (eg. if < 4G RAM). Should be turned into 2 patches, but
> > just for RFC...
> 
> hm, such aliasing might happen in theory - and i guess in practice too
> if the AGP driver allocates/deallocates aperture in short succession.
> 
> Maybe this could corrupt the X framebuffer - or even generic kernel RAM.
> Mind resending the two split up patches? The fix we might want to take
> into v2.6.27, the speedup probably for v2.6.28.
> 
> But maybe i'm missing something obvious that prevents such problems on
> 32-bit systems - Venki, Suresh, what do you think?

Andi pointed out in another thread that we don't use GFP_HIGHMEM in the
AGP drivers. And hence we haven't encountered an issue so far. But yes,
this is a good fix to close the hole.

thanks,
suresh
