Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbZEGCrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbZEGCrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZEGCrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:47:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:40139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZEGCrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,306,1239001200"; 
   d="scan'208";a="140054788"
Date: Thu, 7 May 2009 10:46:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/7] proc: export more page flags in /proc/kpageflags
Message-ID: <20090507024656.GA12828@localhost>
References: <20090507012116.996644836@intel.com> <20090507014914.364045992@intel.com> <20090507114016.40ee6577.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507114016.40ee6577.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 10:40:16AM +0800, Minchan Kim wrote:
> On Thu, 07 May 2009 09:21:21 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > +	 * pseudo flags for the well known (anonymous) memory mapped pages
> > +	 */
> > +	if (!PageSlab(page) && page_mapped(page))
> > +		u |= 1 << KPF_MMAP;
> > +	if (PageAnon(page))
> > +		u |= 1 << KPF_ANON;
> 
> Why do you check PageSlab on user pages ?
> Is there any case that PageSlab == true && page_mapped == true ?

Yes at least for SLUB: it reuses page->_mapcount, so page_mapped() is
meaningless for slab pages.
