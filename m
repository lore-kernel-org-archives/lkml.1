Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbZFPMVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbZFPMVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZFPMU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:20:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55336 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZFPMU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:20:56 -0400
Date: Tue, 16 Jun 2009 13:20:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       fengguang.wu@intel.com, linuxram@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring
	behaviour more in line with expectations V3
Message-ID: <20090616122056.GC14241@csn.ul.ie>
References: <alpine.DEB.1.10.0906151057270.23995@gentwo.org> <20090615152543.GF23198@csn.ul.ie> <20090616202210.99B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090616202210.99B2.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:08:47PM +0900, KOSAKI Motohiro wrote:
> > On Mon, Jun 15, 2009 at 11:01:41AM -0400, Christoph Lameter wrote:
> > > On Mon, 15 Jun 2009, Mel Gorman wrote:
> > > 
> > > > > May I ask your worry?
> > > > >
> > > >
> > > > Simply that I believe the intention of PF_SWAPWRITE here was to allow
> > > > zone_reclaim() to aggressively reclaim memory if the reclaim_mode allowed
> > > > it as it was a statement that off-node accesses are really not desired.
> > > 
> > > Right.
> > > 
> > > > Ok. I am not fully convinced but I'll not block it either if believe it's
> > > > necessary. My current understanding is that this patch only makes a difference
> > > > if the server is IO congested in which case the system is struggling anyway
> > > > and an off-node access is going to be relatively small penalty overall.
> > > > Conceivably, having PF_SWAPWRITE set makes things worse in that situation
> > > > and the patch makes some sense.
> > > 
> > > We could drop support for RECLAIM_SWAP if that simplifies things.
> > > 
> > 
> > I don't think that is necessary. While I expect it's very rarely used, I
> > imagine a situation where it would be desirable on a system that had large
> > amounts of tmpfs pages but where it wasn't critical they remain in-memory.
> > 
> > Removing PF_SWAPWRITE would make it less aggressive and if you were
> > happy with that, then that would be good enough for me.
> 
> I surprised this a bit. I've imazined Christoph never agree to remove it.
> Currently, trouble hitting user of mine don't use this feature. Thus, if it can be
> removed, I don't need to worry abusing this again and I'm happy.
> 
> Mel, Have you seen actual user of this?
> 

No, but then again the usage for it is quite specific. Namely for use on
systems that uses a large amount of tmpfs where the remote NUMA penalty is
high and it's acceptable to swap tmpfs pages to avoid remote accesses. I
don't see the harm in having the option available.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
