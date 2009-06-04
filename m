Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZFDMum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZFDMum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbZFDMuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:50:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:7775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbZFDMue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,305,1241420400"; 
   d="scan'208";a="150615714"
Date: Thu, 4 Jun 2009 20:50:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [6/16] HWPOISON: Add various poison checks in
	mm/memory.c
Message-ID: <20090604125026.GA29026@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184639.1933B1D028F@basil.firstfloor.org> <20090604042603.GA15682@localhost> <20090604051915.GN1065@one.firstfloor.org> <20090604115533.GB22118@localhost> <20090604125228.GZ1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604125228.GZ1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:52:28PM +0800, Andi Kleen wrote:
> On Thu, Jun 04, 2009 at 07:55:33PM +0800, Wu Fengguang wrote:
> > On Thu, Jun 04, 2009 at 01:19:15PM +0800, Andi Kleen wrote:
> > > On Thu, Jun 04, 2009 at 12:26:03PM +0800, Wu Fengguang wrote:
> > > > On Thu, Jun 04, 2009 at 02:46:38AM +0800, Andi Kleen wrote:
> > > > >
> > > > > Bail out early when hardware poisoned pages are found in page fault handling.
> > > >
> > > > I suspect this patch is also not absolutely necessary: the poisoned
> > > > page will normally have been isolated already.
> > >
> > > It's needed to prevent new pages comming in when there is a parallel
> > > fault while the memory failure handling is in process.
> > > Otherwise the pages could get remapped in that small window.
> > 
> > This patch makes no difference at least for file pages, including tmpfs.
> 
> I was more thinking of anonymous pages with multiple mappers (e.g.
> COW after fork)

I guess they are handled by do_anonymous_page() or do_wp_page(),
instead of do_linear_fault()/do_nonlinear_fault()?

Thanks,
Fengguang

