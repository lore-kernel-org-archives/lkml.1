Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZGMDEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZGMDEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZGMDEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:04:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:52622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbZGMDEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:04:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,388,1243839600"; 
   d="scan'208";a="707203632"
Date: Mon, 13 Jul 2009 11:04:44 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] switch free memory back to MIGRATE_MOVABLE
Message-ID: <20090713030444.GA2582@sli10-desk.sh.intel.com>
References: <20090713023030.GA27269@sli10-desk.sh.intel.com> <20090713113326.624F.A69D9226@jp.fujitsu.com> <20090713115803.b78a4f4f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713115803.b78a4f4f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 10:58:03AM +0800, KAMEZAWA Hiroyuki wrote:
> On Mon, 13 Jul 2009 11:47:46 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > When page is back to buddy and its order is bigger than pageblock_order, we can
> > > switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
> > > has obvious effect when read a block device and then drop caches.
> > > 
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > This patch change hot path, but there is no performance mesurement description.
> > Also, I don't like modification buddy core for only drop caches.
> > 
> Li, does this patch imply fallback of migration type doesn't work well ?
> What is the bad case ?
The page is initialized as migrate_movable, and then switch to reclaimable or
something else when fallback occurs, but its type remains even the page gets
freed. When the page gets freed, its type actually can be switch back to movable,
this is what the patch does.

Thanks,
Shaohua
