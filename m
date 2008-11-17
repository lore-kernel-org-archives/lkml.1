Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYKQCag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYKQCag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYKQCa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:30:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:40875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbYKQCa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:30:26 -0500
Date: Mon, 17 Nov 2008 03:30:19 +0100
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
Message-ID: <20081117023019.GB1943@wotan.suse.de>
References: <20081112212647.259698000@intel.com> <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com> <20081113034425.GA23434@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC4642775AF2@orsmsx505.amr.corp.intel.com> <20081114020547.GA24414@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46427EC16C@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46427EC16C@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 01:35:38PM -0800, Pallipadi, Venkatesh wrote:
> 
> 
> >-----Original Message-----
> >From: Nick Piggin [mailto:npiggin@suse.de]
> >Sent: Thursday, November 13, 2008 6:06 PM
> >To: Pallipadi, Venkatesh
> >Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Hugh Dickins;
> >Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de
> >Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
> >Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
> >
> >On Thu, Nov 13, 2008 at 10:47:23AM -0800, Pallipadi, Venkatesh wrote:
> >>
> >> Yes. It does. But, it calls a lower level insert_pfn()
> >function. The lower
> >> level insert_pfn() does not have any bug checks. But the higher level
> >> vm_insert_pfn() checks for PFNMAP or MIXEDMAP.
> >
> >Yes, but is there anything extra you need to check for cache aliases in
> >MIXEDMAP mappings?
> >
> 
> Yes. We need additional things to track MIXEDMAP and we are looking at that.
> But, that is slightly more trickier than the general PFNMAP case. And
> only in-tree user of MIXEDMAP is xip and that too it only uses it for
> regular WB mapping. So, we thought we should fix the more common case
> first here.
> 
> With MIXEDMAP there is no way whether to distinguish whether insert_pfn
> Or insert_page was used while looking at VMA. We can probably use PFNMAP
> in addition to MIXEDMAP to indicate that, which will make things easier.

It's difficult because it can have either method for a single VMA, and
a given address in the vma may even change over time (not with current
code in kernel AFAIKS, but AXFS eventually might get to that point).


> But, we are still looking at that and trying to understand the change
> implication.

OK: now I understand correctly. Getting PFNMAP working is an important
first step. I agree.

Thanks,
Nick
