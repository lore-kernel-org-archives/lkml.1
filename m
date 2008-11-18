Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYKRViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYKRViK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYKRVh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:37:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYKRVh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:37:56 -0500
Date: Tue, 18 Nov 2008 22:37:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Message-ID: <20081118213735.GB28825@elte.hu>
References: <20081112212647.259698000@intel.com> <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com> <20081113034425.GA23434@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC4642775AF2@orsmsx505.amr.corp.intel.com> <20081114020547.GA24414@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46427EC16C@orsmsx505.amr.corp.intel.com> <20081117023019.GB1943@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117023019.GB1943@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Fri, Nov 14, 2008 at 01:35:38PM -0800, Pallipadi, Venkatesh wrote:
> > 
> > 
> > >-----Original Message-----
> > >From: Nick Piggin [mailto:npiggin@suse.de]
> > >Sent: Thursday, November 13, 2008 6:06 PM
> > >To: Pallipadi, Venkatesh
> > >Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Hugh Dickins;
> > >Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de
> > >Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
> > >Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
> > >
> > >On Thu, Nov 13, 2008 at 10:47:23AM -0800, Pallipadi, Venkatesh wrote:
> > >>
> > >> Yes. It does. But, it calls a lower level insert_pfn()
> > >function. The lower
> > >> level insert_pfn() does not have any bug checks. But the higher level
> > >> vm_insert_pfn() checks for PFNMAP or MIXEDMAP.
> > >
> > >Yes, but is there anything extra you need to check for cache aliases in
> > >MIXEDMAP mappings?
> > >
> > 
> > Yes. We need additional things to track MIXEDMAP and we are looking at that.
> > But, that is slightly more trickier than the general PFNMAP case. And
> > only in-tree user of MIXEDMAP is xip and that too it only uses it for
> > regular WB mapping. So, we thought we should fix the more common case
> > first here.
> > 
> > With MIXEDMAP there is no way whether to distinguish whether insert_pfn
> > Or insert_page was used while looking at VMA. We can probably use PFNMAP
> > in addition to MIXEDMAP to indicate that, which will make things easier.
> 
> It's difficult because it can have either method for a single VMA, and
> a given address in the vma may even change over time (not with current
> code in kernel AFAIKS, but AXFS eventually might get to that point).
> 
> 
> > But, we are still looking at that and trying to understand the change
> > implication.
> 
> OK: now I understand correctly. Getting PFNMAP working is an important
> first step. I agree.

Venki, a patch logistics sidenote: the final mm/* bits of this 
patchset need acks from MM folks - Andrew, Nick or Hugh - we cannot 
just queue them up in the x86/pat tree without agreement from MM 
maintainers.

	Ingo
