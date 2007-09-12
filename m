Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXILGRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXILGRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 02:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXILGRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 02:17:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:41701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbXILGRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 02:17:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,242,1186383600"; 
   d="scan'208";a="277173608"
Subject: Re: [BUGFIX] x86_64: NX bit handling in change_page_attr
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070911202332.c539f1fe.akpm@linux-foundation.org>
References: <1187328518.28497.6.camel@caritas-dev.intel.com>
	 <20070911202332.c539f1fe.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Sep 2007 14:18:43 +0800
Message-Id: <1189577923.23838.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 12 Sep 2007 06:17:00.0303 (UTC) FILETIME=[875CD1F0:01C7F504]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 20:23 -0700, Andrew Morton wrote:
> On Fri, 17 Aug 2007 13:28:38 +0800 "Huang, Ying" <ying.huang@intel.com> wrote:
> 
> > This patch fixes a bug of change_page_attr/change_page_attr_addr on
> > Intel x86_64 CPU. After changing page attribute to be executable with
> > these functions, the page remains un-executable on Intel x86_64
> > CPU. Because on Intel x86_64 CPU, only if the "NX" bits of all four
> > level page tables are cleared, the corresponding page is executable
> > (refer to section 4.13.2 of Intel 64 and IA-32 Architectures Software
> > Developer's Manual). So, the bug is fixed through clearing the "NX"
> > bit of PMD when splitting the huge PMD.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > ---
> > 
> > Index: linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c
> > ===================================================================
> > --- linux-2.6.23-rc2-mm2.orig/arch/x86_64/mm/pageattr.c	2007-08-17 12:50:25.000000000 +0800
> > +++ linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c	2007-08-17 12:50:48.000000000 +0800
> > @@ -147,6 +147,7 @@
> >  			split = split_large_page(address, prot, ref_prot2);
> >  			if (!split)
> >  				return -ENOMEM;
> > +			pgprot_val(ref_prot2) &= ~_PAGE_NX;
> >  			set_pte(kpte, mk_pte(split, ref_prot2));
> >  			kpte_page = split;
> >  		}
> 
> What happened with this?  Still valid?

I am waiting for reviewing or merging. And I think it is still valid.

Best Regards,
Huang Ying
