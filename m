Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZFSJcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZFSJcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZFSJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:32:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:17255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZFSJcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:32:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,251,1243839600"; 
   d="scan'208";a="156369825"
Date: Fri, 19 Jun 2009 17:32:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "Wang, Roger" <roger.wang@intel.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
	citizen
Message-ID: <20090619093224.GA30898@localhost>
References: <20090516090005.916779788@intel.com> <1242485776.32543.834.camel@laptop> <20090617141135.0d622bfe@jbarnes-g45> <20090618012532.GB19732@localhost> <20090619090011.GA30561@localhost> <1245402289.13761.24606.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245402289.13761.24606.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 05:04:49PM +0800, Peter Zijlstra wrote:
> On Fri, 2009-06-19 at 17:00 +0800, Wu, Fengguang wrote:
> > [add CC]
> > 
> > This OOM case looks like the same bug encountered by David Howells.
> > 
> > > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426766] Active_anon:290797 active_file:28 inactive_anon:97034
> > > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426767]  inactive_file:61 unevictable:11322 dirty:0 writeback:0 unstable:0
> > > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426768]  free:3341 slab:13776 mapped:5880 pagetables:6851 bounce:0
> > 
> > active/inactive_anon pages take up 4/5 memory.  Are you using TMPFS a lot?
> 
> I suspect its his GEM thingy ;-)

Very likely - GEM allocates drm objects from the internal tmpfs,
and libdrm_intel seems to never free drm objects from its cache.

Thanks,
Fengguang

