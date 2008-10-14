Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYJNHc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYJNHc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759430AbYJNHcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:32:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:34990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856AbYJNHcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:32:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,407,1220252400"; 
   d="scan'208";a="347808133"
Date: Tue, 14 Oct 2008 15:30:11 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch]x86: arch_add_memory round up address
Message-ID: <20081014073011.GA1556@sli10-desk.sh.intel.com>
References: <86802c440810082340r101f99aem3839d55360451851@mail.gmail.com> <20081009070634.GA12715@sli10-desk.sh.intel.com> <20081014140608.AD63.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014140608.AD63.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 01:16:46PM +0800, Yasunori Goto wrote:
> > On Thu, Oct 09, 2008 at 02:40:34PM +0800, Yinghai Lu wrote:
> > > On Wed, Oct 8, 2008 at 11:28 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > > > On Thu, Oct 09, 2008 at 02:22:50PM +0800, Yinghai Lu wrote:
> > > >> On Wed, Oct 8, 2008 at 11:08 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > > >> > On Thu, 2008-10-09 at 14:04 +0800, Yinghai Lu wrote:
> > > >> >> On Wed, Oct 8, 2008 at 10:31 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > > >> >> > Round up address to a page, otherwise the last page isn't mapped.
> > > >> >> >
> > > >> >> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > >> >> > ---
> > > >> >> >  arch/x86/mm/init_64.c |    3 ++-
> > > >> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >> >> >
> > > >> >> > Index: linux/arch/x86/mm/init_64.c
> > > >> >> > ===================================================================
> > > >> >> > --- linux.orig/arch/x86/mm/init_64.c    2008-10-09 11:42:33.000000000 +0800
> > > >> >> > +++ linux/arch/x86/mm/init_64.c 2008-10-09 11:43:22.000000000 +0800
> > > >> >> > @@ -721,7 +721,8 @@ int arch_add_memory(int nid, u64 start,
> > > >> >> >        unsigned long nr_pages = size >> PAGE_SHIFT;
> > > >> >> >        int ret;
> > > >> >> >
> > > >> >> > -       last_mapped_pfn = init_memory_mapping(start, start + size-1);
> > > >> >> > +       last_mapped_pfn = init_memory_mapping(start,
> > > >> >> > +               round_up(start + size-1, PAGE_SIZE));
> > > >> >> >        if (last_mapped_pfn > max_pfn_mapped)
> > > >> >> >                max_pfn_mapped = last_mapped_pfn;
> > > >> >>
> > > >> >> should use
> > > >> >>
> > > >> >> last_mapped_pfn = init_memory_mapping(start, start + size);
> > > >> > No, this still can't guarantee page aligned, though this works in my
> > > >> > test
> > > >>
> > > >> who will call arch_add_memory? that should be start and size already
> > > >> be page aligned.
> > > > It's memory hotplug. Doing a round up is always ok and safe even it might be already aligned.
> > > >
> > >
> > > it seems rounding up in that case is wrong...
> > >
> > > if the caller call that funtion with extra half page, you don't need
> > > map that half page, because you can not use it.
> > shouldn't we mark such page as reserved and so it will not be used? This is the way we handle hole.
> 
> Just curious,
> have you ever seen a real machine which needs this patch?
No, I just did some experiments on a desktop for memory hotplug and this bug
triggered a crash in my test.
Yinghai's suggestion also fixed the bug. I just want to have safer method. Anyway, either approach is ok to me.

Thanks,
Shaohua
