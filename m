Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYCQDI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYCQDI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYCQDIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:08:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:6082 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705AbYCQDIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:08:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,510,1199692800"; 
   d="scan'208";a="534899734"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
	 <1205463842.3215.188.camel@ymzhang>
	 <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
	 <1205478861.3215.279.camel@ymzhang>
	 <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 17 Mar 2008 11:05:36 +0800
Message-Id: <1205723136.3215.300.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 14:08 -0700, Christoph Lameter wrote:
> On Fri, 14 Mar 2008, Zhang, Yanmin wrote:
> 
> > > Ahhh... Okay those slabs did not change for 2.6.25-rc. Is there
> > > really a difference to 2.6.24?
> > As oprofile shows slub functions spend more than 80% cpu time, I would like
> > to focus on optimizing SLUB before going back to 2.6.24.
> 
> I thought you wanted to address a regression vs 2.6.24?
Initially I wanted to do so, but oprofile data showed both 2.6.24 and 2.6.25-rc
aren't good with hachbench on tigerton.

The slub_min_objects boot parameter could boost performance largely. So I think
we need optimize it before addressing the regression.

> 
> > kmalloc-512: No NUMA information available.
> > 
> > Slab Perf Counter       Alloc     Free %Al %Fr
> > --------------------------------------------------
> > Fastpath             55039159  5006829  68   6
> > Slowpath             24975754 75007769  31  93
> > Page Alloc              73840    73779   0   0
> > Add partial                 0 24341085   0  30
> > Remove partial       24267297    73779  30   0
> 
> ^^^ add partial/remove partial is likely the cause for 
> trouble here. 30% is unacceptably high. The larger allocs will reduce the 
> partial handling overhead. That is likely the effect that we see here.
> 
> > Refill 24975738
> 
> Duh refills at 50%? We could try to just switch to another slab instead of 
> reusing the existing one. May also affect the add/remove partial 
> situation.
> 
> 
> 

