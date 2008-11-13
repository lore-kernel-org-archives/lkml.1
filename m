Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYKMDom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYKMDom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYKMDoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:44:32 -0500
Received: from ns1.suse.de ([195.135.220.2]:57749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYKMDob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:44:31 -0500
Date: Thu, 13 Nov 2008 04:44:25 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Hugh Dickins <hugh@veritas.com>,
       Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Message-ID: <20081113034425.GA23434@wotan.suse.de>
References: <20081112212647.259698000@intel.com> <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:02:47PM -0800, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: Nick Piggin [mailto:npiggin@suse.de] 
> >Sent: Wednesday, November 12, 2008 3:23 PM
> >To: Pallipadi, Venkatesh
> >Cc: Ingo Molnar; Thomas Gleixner; H.Peter Anvin; Hugh Dickins; 
> >Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de 
> >Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
> >Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
> >
> >You have to be careful of this, because it can be called with mmap_sem
> >held for read only. Hmm, I guess vm_insert_page is doing the 
> >same thing.
> >Probably mostly works because all other modifiers of vm_flags 
> >are holding
> >mmap_sem.
> 
> Yes. I did the patch looking at vm_insert_page doing similar thing.
> 
> >
> >However, in some cases, code can do vm_insert_pfn and vm_insert_page
> >(actually hmm, no vm_insert_mixed actually should cover most of those
> >cases).
> >
> >Still, I'd be much happier if we could make these into BUG_ON, and then
> >teach callers to set it in their .mmap routines.
> 
> Actually, vm_insert_pfn() already has a BUG_ON() at the start for cases
> where neither (or both) MIXEDMAP and PFNMAP is not set. So, that should
> cover the case we are worried about it here and we can eliminate this
> patch altogether. Only part I am not sure about is why we are looking
> for MIXEDMAP here. Shouldn't they be using vm_insert_mixed instead?

They should, but it will do an inesrt_pfn in some cases, won't it?
