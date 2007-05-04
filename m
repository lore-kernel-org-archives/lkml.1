Return-Path: <linux-kernel-owner+w=401wt.eu-S1161224AbXEDRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbXEDRYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161228AbXEDRYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:24:25 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:53231 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXEDRYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:24:24 -0400
Subject: Re: [PATCH] change global zonelist order v4 [0/2]
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0705040913340.21436@schroedinger.engr.sgi.com>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070503224730.3bc6f8a8.akpm@linux-foundation.org>
	 <200705040826.23687.jbarnes@virtuousgeek.org>
	 <Pine.LNX.4.64.0705040913340.21436@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 04 May 2007 13:24:19 -0400
Message-Id: <1178299460.5236.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 09:18 -0700, Christoph Lameter wrote:
> On Fri, 4 May 2007, Jesse Barnes wrote:
> 
> > I think the idea is to avoid exhausting ZONE_DMA on some NUMA boxes by 
> > ordering the fallback list first by zone, then by node distance (e.g. 
> > ZONE_NORMAL of local node, then ZONE_NORMAL of next nearest node etc., 
> > followed by ZONE_DMA of local node, ZONE_DMA of next nearest node, etc.).
> 
> Maybe it would be cleaner to setup a DMA and DMA32 "node" up and define 
> them at a certain distance to the rest of the nodes that only contain 
> ZONE_NORMAL (or the zone that is replicated on all nodes). Then we would 
> have that effect without reworking zone list generation. Plus in the long 
> run we may then be able to get to 1 zone per node avoiding the 
> difficulties coming zone fallback altogether.
> 
> > Another option would be to make this behavior automatic if both ZONE_DMA 
> > and ZONE_NORMAL had pages.  I initially wrote this stuff with the idea 
> > that machines that really needed it would have all their memory in 
> > ZONE_DMA, but obviously that's not the case, so some more smarts are 
> > needed.
> 
> I think what would work is to first setup nodes that use the highest zone. 
> Then add virtual nodes for the lower zones that may only exist on a single 
> node.
> 
> I.e. a 4 node x86_64 box may have
> 
> Node
> 0	ZONE_NORMAL
> 1	ZONE_NORMAL
> 2	ZONE_NORMAL
> 3	ZONE_NORMAL
> 4	ZONE_DMA32
> 5	[additional ZONE_DMA32 if zone DMA32 is split over multiple nodes]
> 6	ZONE_DMA
> 
> The SLIT information can be used to control how the nodes fallback to the 
> DMA32 nodes on 4 and 5. Node 6 would be given a very high SLIT distance so 
> that it would be used only if an actual __GFP_DMA occurs or the system 
> really runs into memory difficulties.

Hmmm...  "serious hackery", indeed!  ;-)

Lee

