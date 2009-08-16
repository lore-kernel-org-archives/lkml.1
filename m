Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZHPGAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZHPGAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 02:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZHPGAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 02:00:05 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37517 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZHPGAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 02:00:04 -0400
Date: Sun, 16 Aug 2009 11:29:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090816055957.GS5087@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <4A7AD79E.4020604@redhat.com> <20090816032822.GB6888@localhost> <4A878377.70502@redhat.com> <20090816045522.GA13740@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090816045522.GA13740@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang <fengguang.wu@intel.com> [2009-08-16 12:55:22]:

> On Sun, Aug 16, 2009 at 11:56:39AM +0800, Rik van Riel wrote:
> > Wu Fengguang wrote:
> > 
> > > Right, but I meant busty page allocations and accesses on them, which
> > > can make a large continuous segment of referenced pages in LRU list,
> > > say 50MB.  They may or may not be valuable as a whole, however a local
> > > algorithm may keep the first 4MB and drop the remaining 46MB.
> > 
> > I wonder if the problem is that we simply do not keep a large
> > enough inactive list in Jeff's test.  If we do not, pages do
> > not have a chance to be referenced again before the reclaim
> > code comes in.
> 
> Exactly, that's the case I call the list FIFO.
> 
> > The cgroup stats should show how many active anon and inactive
> > anon pages there are in the cgroup.
> 
> Jeff, can you have a look at these stats? Thanks!

Another experiment would be to toy with memory.swappiness (although
defaults should work well). Could you compare the in-guest values of
nr_*active* with the cgroup values as seen by the host?

-- 
	Balbir
