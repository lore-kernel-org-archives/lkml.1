Return-Path: <linux-kernel-owner+w=401wt.eu-S966432AbXILNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966432AbXILNhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXILNhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:37:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:43033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846AbXILNhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:37:06 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUGFIX] x86_64: NX bit handling in change_page_attr
Date: Wed, 12 Sep 2007 15:35:31 +0200
User-Agent: KMail/1.9.1
Cc: "Huang, Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
References: <1187328518.28497.6.camel@caritas-dev.intel.com> <20070911202332.c539f1fe.akpm@linux-foundation.org>
In-Reply-To: <20070911202332.c539f1fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121535.31550.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Index: linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c
> > ===================================================================
> > --- linux-2.6.23-rc2-mm2.orig/arch/x86_64/mm/pageattr.c	2007-08-17
> > 12:50:25.000000000 +0800 +++
> > linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c	2007-08-17
> > 12:50:48.000000000 +0800 @@ -147,6 +147,7 @@
> >  			split = split_large_page(address, prot, ref_prot2);
> >  			if (!split)
> >  				return -ENOMEM;
> > +			pgprot_val(ref_prot2) &= ~_PAGE_NX;
> >  			set_pte(kpte, mk_pte(split, ref_prot2));
> >  			kpte_page = split;
> >  		}
>
> What happened with this?  Still valid?

The bug is probably latent there, but I don't think it can affect anything
in the kernel because nothing in the kernel should change NX status
as far as I know.

Where did you see it? 

Anyways I would prefer to only clear the PMD NX when NX status actually 
changes on the PTE.Can you do that change? 

Anyways; it's really not very important.

-Andi
