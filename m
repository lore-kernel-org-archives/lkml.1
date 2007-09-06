Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXIFAxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXIFAxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 20:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXIFAxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 20:53:12 -0400
Received: from mga05.intel.com ([192.55.52.89]:32455 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756489AbXIFAxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 20:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,213,1186383600"; 
   d="scan'208";a="294434899"
Subject: Re: tbench regression - Why process scheduler has impact on tbench
	and why small per-cpu slab (SLUB) cache creates the scenario?
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0709050342520.8127@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang>
	 <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com>
	 <1188969725.26438.46.camel@ymzhang>
	 <Pine.LNX.4.64.0709042354290.7527@schroedinger.engr.sgi.com>
	 <1188983603.26438.55.camel@ymzhang>
	 <Pine.LNX.4.64.0709050342520.8127@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 06 Sep 2007 08:52:19 +0800
Message-Id: <1189039939.26438.65.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 03:45 -0700, Christoph Lameter wrote:
> On Wed, 5 Sep 2007, Zhang, Yanmin wrote:
> 
> > > > However, the approach treats the slabs in the same policy. Could we
> > > > implement a per-slab specific approach like direct b)?
> > > 
> > > I am not sure what you mean by same policy. Same configuration for all 
> > > slabs?
> > Yes.
> 
> Ok. I could add the ability to specify parameters for some slabs.
Thanks. That will be more flexible.

> 
> > > Would it be possible to try the two other approaches that I suggested? I 
> > > think both of those may also solve the issue. Try booting with
> > > slab_max_order=0
> > 1) I tried slab_max_order=0 and the regression becomes 12.5%. It's still 
> > not good.
> > 
> > 2) I apllied patch 
> > slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch to kernel 
> > 2.6.23-rc4. The new testing result is much better, only 1% less than 
> > 2.6.22.
I retested 2.6.22 and booted kernel with "slub_max_order=3 slub_min_objects=8".
The result is about 8.7% better than without booting parameters.

So all with booting parameter "slub_max_order=3 slub_min_objects=8", 2.6.22 is
about 5.8% better than 2.6.23-rc4. I suspect process scheduler is responsible
for the 5.8% regressions.

> 
> Ok. That seems to indicate that we should improve the alloc path in the 
> page allocator. The page allocator performance needs to be competitive on 
> page sized allocations. The problem will be largely going away when we 
> merge the pass through patch in 2.6.24.
