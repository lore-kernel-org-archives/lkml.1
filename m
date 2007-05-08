Return-Path: <linux-kernel-owner+w=401wt.eu-S1032033AbXEHVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032033AbXEHVyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967451AbXEHVyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:54:20 -0400
Received: from mga06.intel.com ([134.134.136.21]:24844 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967147AbXEHVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:54:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,507,1170662400"; 
   d="scan'208";a="240897489"
Subject: RE: Regression with SLUB on Netperf and Volanomark
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Christoph Lameter <clameter@sgi.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0705071848300.1378@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
	 <Pine.LNX.4.64.0705031839480.16296@schroedinger.engr.sgi.com>
	 <1178322083.23795.217.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705041800070.28492@schroedinger.engr.sgi.com>
	 <1178584834.15701.18.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705071848300.1378@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel
Date: Tue, 08 May 2007 14:02:04 -0700
Message-Id: <1178658124.15701.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 18:49 -0700, Christoph Lameter wrote:
> On Mon, 7 May 2007, Tim Chen wrote:
> 
> > However, the output from TCP_STREAM is quite stable.  
> > I am still seeing a 4% difference between the SLAB and SLUB kernel.
> > Looking at the L2 cache miss rate with emon, I saw 6% more cache miss on
> > the client side with SLUB.  The server side has the same amount of cache
> > miss.  This is test under SMP mode with client and server bound to
> > different core on separate package.
> 
> Could you try the following patch on top of 2.6.21-mm1 with the patches
> from http://ftp.kernel.org/pub/linux/kernel/people/christoph/slub-patches?
> 
> I sent it to you before. This is one is an updated version
> 
> 
> 
> Avoid atomic overhead in slab_alloc and slab_free
> 

I tried the slub-patches and the avoid atomic overhead patch against
2.6.21-mm1.  It brings the TCP_STREAM performance for SLUB to the SLAB
level.  The patches not mentioned in the "series" file did not apply
cleanly to 2.6.21-mm1 and I skipped most of those.  

Patches applied are: 
http://ftp.kernel.org/pub/linux/kernel/people/christoph/slub-
patches/series + dentry_target_reclaimed + kmem_cache_ops + slub_stats +
skip_atomic_overhead

Without skip atomic overhead patch, the throughput drops by 1 to 1.5%.

The change from slub_min_order=0 slub_max_order=4 
to slub_min_order=6 slub_max_order=7 did not make much difference in
my tests.


Tim
