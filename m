Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbYDCFxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbYDCFxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760281AbYDCFxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:53:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:32150 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754351AbYDCFxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:53:12 -0400
Date: Thu, 3 Apr 2008 14:52:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       wli@holomorphy.com, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: HugeTLB vs. SH3 cpu
Message-ID: <20080403055235.GC4171@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Nish Aravamudan <nish.aravamudan@gmail.com>,
	Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20080401225809.GC32269@cs181133002.pp.htv.fi> <29495f1d0804011626n2399d69aj7566df7f78953458@mail.gmail.com> <20080402080448.GA4171@linux-sh.org> <20080402101538.GA18564@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402101538.GA18564@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:15:38AM +0100, Mel Gorman wrote:
> On (02/04/08 17:04), Paul Mundt didst pronounce:
> > The problem is that the hugetlb Kconfig stuff is a complete mess. There's
> > a semi-decoupling between HUGETLBFS and HUGETLB_PAGE, though they both
> > depend on each other.
> 
> I believe the original intention was that HUGETLB_PAGE would build the
> hugepage pool and the arch-specific code and HUGETLBFS would be the userspace
> interface but not necessarily the only one. Whatever the original intention,
> it's no longer the case as they have become inter-dependant. Fixing it is
> not straight-forward but I don't think we want to collapse HUGETLB_PAGE and
> HUGETLBFS just yet either.
> 
That makes more sense, perhaps it's worth beating in to shape so there
can also be non hugetlbfs users, this needs a bit of use-case thinking,
though.

> > diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> > index 0c3face..7c937ad 100644
> > --- a/arch/powerpc/platforms/Kconfig.cputype
> > +++ b/arch/powerpc/platforms/Kconfig.cputype
> > @@ -1,5 +1,6 @@
> >  config PPC64
> >  	bool "64-bit kernel"
> > +	select HAVE_HUGETLB_PAGE
> >  	default n
> >  	help
> >  	  This option selects whether a 32-bit or a 64-bit kernel
> 
> hmm... This is what Kconfig is currently doing but by rights, it should be
> set on a per-processor basis. I guess it's outside the scope of this patch as
> there isn't an obvious way to tell what processor versions support huge pages.
> 
Yes, I had the same thoughts, perhaps the PPC64 folks can shed some light
on this.
