Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZKMNzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZKMNzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZKMNzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:55:36 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53931 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbZKMNzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:55:35 -0500
Date: Fri, 13 Nov 2009 13:55:38 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 1/5] page allocator: Always wake kswapd when restarting
	an allocation attempt after direct reclaim failed
Message-ID: <20091113135538.GG29804@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <1258054235-3208-2-git-send-email-mel@csn.ul.ie> <20091113142026.33AD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091113142026.33AD.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:23:21PM +0900, KOSAKI Motohiro wrote:
> > If a direct reclaim makes no forward progress, it considers whether it
> > should go OOM or not. Whether OOM is triggered or not, it may retry the
> > application afterwards. In times past, this would always wake kswapd as well
> > but currently, kswapd is not woken up after direct reclaim fails. For order-0
> > allocations, this makes little difference but if there is a heavy mix of
> > higher-order allocations that direct reclaim is failing for, it might mean
> > that kswapd is not rewoken for higher orders as much as it did previously.
> > 
> > This patch wakes up kswapd when an allocation is being retried after a direct
> > reclaim failure. It would be expected that kswapd is already awake, but
> > this has the effect of telling kswapd to reclaim at the higher order as well.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> > Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Umm,
> My mail box have the carbon copy of akpm sent this patch to linus.
> (bellow subject and data)
> 
> Does this have any update?
> 

No, it doesn't. I included it in the series for the benefit of testers.

> -----------------------------------------------------------------
> Subject: [patch 07/35] page allocator: always wake kswapd when restarting an allocation attempt after direct reclaim failed
> To: torvalds@linux-foundation.org
> Cc: akpm@linux-foundation.org,
>  mel@csn.ul.ie,
>  cl@linux-foundation.org,
>  kosaki.motohiro@jp.fujitsu.com,
>  penberg@cs.helsinki.fi,
>  stable@kernel.org
> From: akpm@linux-foundation.org
> Date: Wed, 11 Nov 2009 14:26:14 -0800
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
