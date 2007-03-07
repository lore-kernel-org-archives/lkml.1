Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXCGJd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXCGJd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422668AbXCGJd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:33:56 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:26734 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422663AbXCGJdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:33:55 -0500
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes
	nonlinear)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, mingo@elte.hu, npiggin@suse.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <20070307010756.b31c8190.akpm@linux-foundation.org>
References: <20070221023656.6306.246.sendpatchset@linux.site>
	 <20070221023735.6306.83373.sendpatchset@linux.site>
	 <20070306225101.f393632c.akpm@linux-foundation.org>
	 <20070307070853.GB15877@wotan.suse.de>
	 <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu>
	 <E1HOrfO-0008AW-00@dorka.pomaz.szeredi.hu>
	 <20070307004709.432ddf97.akpm@linux-foundation.org>
	 <E1HOrsL-0008Dv-00@dorka.pomaz.szeredi.hu>
	 <20070307010756.b31c8190.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 10:32:22 +0100
Message-Id: <1173259942.6374.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 01:07 -0800, Andrew Morton wrote:
> On Wed, 07 Mar 2007 09:51:57 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > > > Dirty page accounting doesn't work either on
> > > > non-linear mappings
> > > 
> > > It doesn't?  Confused - these things don't have anything to do with each
> > > other do they?
> > 
> > Look in page_mkclean().  Where does it handle non-linear mappings?
> > 
> 
> OK, I'd forgotten about that.  It won't break dirty memory accounting,
> but it'll potentially break dirty memory balancing.
> 
> If we have the wrong page (due to nonlinear), page_check_address() will
> fail and we'll leave the pte dirty.  That puts us back to the pre-2.6.17
> algorithms and I guess it'll break the msync guarantees.
> 
> Peter, I thought we went through the nonlinear problem ages ago and decided
> it was OK?

Can recollect as much, I modelled it after page_referenced() and can't
find any VM_NONLINEAR specific code in there either.

Will have a hard look, but if its broken, then page_referenced if
equally broken it seems, which would make page reclaim funny in the
light of nonlinear mappings.

