Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXIMBK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXIMBK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXIMBKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:10:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:37230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbXIMBKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,247,1186383600"; 
   d="scan'208";a="134770528"
Subject: Re: [BUGFIX] x86_64: NX bit handling in change_page_attr
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200709121535.31550.ak@suse.de>
References: <1187328518.28497.6.camel@caritas-dev.intel.com>
	 <20070911202332.c539f1fe.akpm@linux-foundation.org>
	 <200709121535.31550.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Sep 2007 09:12:02 +0800
Message-Id: <1189645922.7341.11.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 13 Sep 2007 01:10:16.0943 (UTC) FILETIME=[D884AFF0:01C7F5A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 15:35 +0200, Andi Kleen wrote:
> > > Index: linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c
> > > ===================================================================
> > > --- linux-2.6.23-rc2-mm2.orig/arch/x86_64/mm/pageattr.c	2007-08-17
> > > 12:50:25.000000000 +0800 +++
> > > linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c	2007-08-17
> > > 12:50:48.000000000 +0800 @@ -147,6 +147,7 @@
> > >  			split = split_large_page(address, prot, ref_prot2);
> > >  			if (!split)
> > >  				return -ENOMEM;
> > > +			pgprot_val(ref_prot2) &= ~_PAGE_NX;
> > >  			set_pte(kpte, mk_pte(split, ref_prot2));
> > >  			kpte_page = split;
> > >  		}
> >
> > What happened with this?  Still valid?
> 
> The bug is probably latent there, but I don't think it can affect anything
> in the kernel because nothing in the kernel should change NX status
> as far as I know.
> 
> Where did you see it? 

I found the problem for EFI runtime service supporting. Where the EFI
runtime code (from firmware) need to be mapped without NX bit set.

> Anyways I would prefer to only clear the PMD NX when NX status actually 
> changes on the PTE.Can you do that change? 

This change is sufficient for Intel CPU. Because the NX bit of PTE is
still there, no page will be made executable if not been set explicitly
through PTE. For AMD CPU, will the page be made executable if the NX bit
of PMD is cleared and the NX bit of PTE is set? If so, I will do the
change as you said.

> Anyways; it's really not very important.

It is needed by EFI runtime service supporting.

Best Regards,
Huang Ying
