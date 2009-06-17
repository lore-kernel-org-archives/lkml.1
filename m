Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbZFQMDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbZFQMDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbZFQMDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:03:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39734 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbZFQMDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:03:42 -0400
Date: Wed, 17 Jun 2009 13:03:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       fengguang.wu@intel.com, linuxram@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring
	behaviour more in line with expectations V3
Message-ID: <20090617120342.GB28529@csn.ul.ie>
References: <20090616134423.GD14241@csn.ul.ie> <alpine.DEB.1.10.0906161049180.26093@gentwo.org> <20090617190204.99C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090617190204.99C6.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 07:06:46PM +0900, KOSAKI Motohiro wrote:
> > On Tue, 16 Jun 2009, Mel Gorman wrote:
> > 
> > > I don't have a particular workload in mind to be perfectly honest. I'm just not
> > > convinced of the wisdom of trying to unmap pages by default in zone_reclaim()
> > > just because the NUMA distances happen to be large.
> > 
> > zone reclaim = 1 is supposed to be light weight with minimal impact. The
> > intend was just to remove potentially unused pagecache pages so that node
> > local allocations can succeed again. So lets not unmap pages.
> 
> hm, At least major two zone reclaim developer disagree my patch. Thus I have to
> agree with you, because I really don't hope to ignore other developer's opnion.
> 
> So, as far as I understand, the conclusion of this thread are
>   - Drop my patch
>   - instead, implement improvement patch of (may_unmap && page_mapped()) case
>   - the documentation should be changed
>   - it's my homework(?)
> 
> Can you agree this?
> 

Yes.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
