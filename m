Return-Path: <linux-kernel-owner+w=401wt.eu-S967828AbXEHE5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967828AbXEHE5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967814AbXEHE5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:57:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60738 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967802AbXEHE5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:57:35 -0400
Date: Mon, 7 May 2007 21:57:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: RE: Regression with SLUB on Netperf and Volanomark
In-Reply-To: <1178584834.15701.18.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705072150490.4939@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
  <Pine.LNX.4.64.0705031839480.16296@schroedinger.engr.sgi.com> 
 <1178322083.23795.217.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0705041800070.28492@schroedinger.engr.sgi.com>
 <1178584834.15701.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Tim Chen wrote:

> However, the output from TCP_STREAM is quite stable.  
> I am still seeing a 4% difference between the SLAB and SLUB kernel.
> Looking at the L2 cache miss rate with emon, I saw 6% more cache miss on
> the client side with SLUB.  The server side has the same amount of cache
> miss.  This is test under SMP mode with client and server bound to
> different core on separate package.

If this is cache miss related then a larger page order may take are 
of this. Boot with (assume you got 2.6.21-mm1 at least...)

slub_min_order=6 slub_max_order=7

which will give you an allocation unit of 256k. Just tried it. It 
actually works but has no effect here whatsoever on UP netperf 
performance. netperf performance dropped from 6MB(slab)/6.2MB(slub) on 
2.6.21-rc7-mm1 to 4.5MB (both) on 2.6.21-mm1. So I guess there is 
something also going on with the networking layer.

Still have not found a machine here where I could repeat your 
results.
