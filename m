Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZFHOjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZFHOjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZFHOi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:38:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45862 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZFHOi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:38:57 -0400
Date: Mon, 8 Jun 2009 15:38:57 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       yanmin.zhang@intel.com, Wu Fengguang <fengguang.wu@intel.com>,
       linuxram@us.ibm.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when
	zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Message-ID: <20090608143857.GG15070@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <4A2D129D.3020309@redhat.com> <20090608135433.GD15070@csn.ul.ie> <alpine.DEB.1.10.0906081033060.21954@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906081033060.21954@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 10:33:41AM -0400, Christoph Lameter wrote:
> On Mon, 8 Jun 2009, Mel Gorman wrote:
> 
> > Yes, they're on separate LRU lists but they are not the only pages on those
> > lists. The tmpfs pages are mixed in together with anonymous pages so we
> > cannot use NR_*_ANON.
> 
> The tmpfs pages are unreclaimable and therefore should not be on the anon
> lru.
> 

tmpfs pages can be swap-backed so can be reclaimable. Regardless of what
list they are on, we still need to know how many of them there are if
this patch is to be avoided.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
