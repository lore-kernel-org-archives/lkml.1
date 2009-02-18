Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZBRJTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZBRJTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZBRJTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:19:24 -0500
Received: from mga12.intel.com ([143.182.124.36]:5677 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492AbZBRJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:19:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,228,1233561600"; 
   d="scan'208";a="111783323"
Subject: Re: [patch] SLQB slab allocator (try 2)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <1234947664.24030.39.camel@penberg-laptop>
References: <20090123154653.GA14517@wotan.suse.de>
	 <200902041748.41801.nickpiggin@yahoo.com.au>
	 <20090204152709.GA4799@csn.ul.ie>
	 <200902051459.30064.nickpiggin@yahoo.com.au>
	 <20090216184200.GA31264@csn.ul.ie> <4999BBE6.2080003@cs.helsinki.fi>
	 <alpine.DEB.1.10.0902171120040.27813@qirst.com>
	 <1234890096.11511.6.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902171204070.15929@qirst.com>
	 <1234919143.2604.417.camel@ymzhang>
	 <1234943296.24030.2.camel@penberg-laptop>
	 <1234946582.2604.423.camel@ymzhang>
	 <1234947664.24030.39.camel@penberg-laptop>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 17:19:04 +0800
Message-Id: <1234948744.2604.426.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 11:01 +0200, Pekka Enberg wrote:
> On Wed, 2009-02-18 at 16:43 +0800, Zhang, Yanmin wrote:
> > > > Code: be 3f 06 00 00 48 c7 c7 c7 96 80 80 e8 b8 e2 f9 ff e8 c5 c2
> > 45 00 9c 5b fa 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c4 e8  
> > > > RIP  [<ffffffff8028fae3>] kmem_cache_alloc+0x43/0x97
> > > >  RSP <ffff88022f865e20>
> > > > CR2: 0000000000000000
> > > > ---[ end trace a7919e7f17c0a725 ]---
> > > > swapper used greatest stack depth: 5376 bytes left
> > > > Kernel panic - not syncing: Attempted to kill init!
> > > 
> > > Aah, we need to fix up some more PAGE_SHIFTs in the code.
> > The new patch fixes hang issue. netperf UDP-U-4k (start CPU_NUM clients) result is pretty good.
> 
> Do you have your patch on top of it as well?
Yes.

>  Btw, can I add a Tested-by
> tag from you to the patch?
Ok. Another testing with UDP-U-4k (start 1 client and bind client and server to different
cpu) result is improved, but is not so good as SLQB's. But we can increase slub_max_order
to get the similiar result like SLQB.


