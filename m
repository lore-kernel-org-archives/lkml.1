Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXECJQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXECJQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXECJQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:16:46 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46668 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbXECJQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:16:45 -0400
Date: Thu, 3 May 2007 10:15:55 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070503015729.7496edff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705031011020.9826@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
 <20070503011515.0d89082b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705030936120.5165@blonde.wat.veritas.com>
 <20070503015729.7496edff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 03 May 2007 09:16:13.0012 (UTC) FILETIME=[B1F30140:01C78D63]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Andrew Morton wrote:
> On Thu, 3 May 2007 09:46:32 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> > On Thu, 3 May 2007, Andrew Morton wrote:
> > > On Wed, 2 May 2007 10:25:47 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > > 
> > > > +config ARCH_USES_SLAB_PAGE_STRUCT
> > > > +	bool
> > > > +	default y
> > > > +	depends on SPLIT_PTLOCK_CPUS <= NR_CPUS
> > > > +
> > > 
> > > That all seems to work as intended.
> > > 
> > > However with NR_CPUS=8 SPLIT_PTLOCK_CPUS=4, enabling SLUB=y crashes the
> > > machine early in boot.  
> > 
> > I thought that if that worked as intended, you wouldn't even
> > get the chance to choose SLUB=y?  That was how it was working
> > for me (but I realize I didn't try more than make oldconfig).
> > 
> > That sounds like what happens when SLUB's pagestruct use meets
> > SPLIT_PTLOCK's pagestruct use.  Does your .config really show
> > CONFIG_SLUB=y together with CONFIG_ARCH_USES_SLAB_PAGE_STRUCT=y?
> 
> Nope.
> 
> g5:/usr/src/25> grep SLUB .config
> CONFIG_SLUB=y
> g5:/usr/src/25> grep SLAB .config
> # CONFIG_SLAB is not set
> g5:/usr/src/25> grep CPUS .config
> CONFIG_NR_CPUS=8
> # CONFIG_CPUSETS is not set
> # CONFIG_IRQ_ALL_CPUS is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> 
> It's in http://userweb.kernel.org/~akpm/config-g5.txt

Seems we're all wrong in thinking Christoph's Kconfiggery worked
as intended: maybe it just works some of the time.  I'm not going
to hazard a guess as to how to fix it up, will resume looking at
the powerpc's quicklist potential later.

Hugh
