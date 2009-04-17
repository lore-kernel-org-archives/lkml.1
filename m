Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZDQG5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZDQG5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZDQG5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:57:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40015 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZDQG5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:57:42 -0400
Date: Fri, 17 Apr 2009 15:56:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
 controller (v2)
Message-Id: <20090417155608.eeed1f02.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090417064726.GB3896@balbir.in.ibm.com>
References: <20090416164036.03d7347a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416171535.cfc4ca84.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416120316.GG7082@balbir.in.ibm.com>
	<20090417091459.dac2cc39.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417014042.GB18558@balbir.in.ibm.com>
	<20090417110350.3144183d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417034539.GD18558@balbir.in.ibm.com>
	<20090417124951.a8472c86.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417045623.GA3896@balbir.in.ibm.com>
	<20090417141726.a69ebdcc.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417064726.GB3896@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 12:17:26 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > *But* we still have following code.
> > ==
> > 820 static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  821                         gfp_t gfp_mask, struct mem_cgroup **memcg,
> >  822    
> >  834         /*
> >  835          * We always charge the cgroup the mm_struct belongs to.
> >  836          * The mm_struct's mem_cgroup changes on task migration if the
> >  837          * thread group leader migrates. It's possible that mm is not
> >  838          * set, if so charge the init_mm (happens for pagecache usage).
> >  839          */
> >  840         mem = *memcg;
> >  841         if (likely(!mem)) {
> >  842                 mem = try_get_mem_cgroup_from_mm(mm);
> >  843                 *memcg = mem;
> >  844         } else {
> >  845                 css_get(&mem->css);
> >  846         }
> >  847         if (unlikely(!mem))
> >  848                 return 0;
> > ==
> > 
> > So, for _now_, we should use this style of checking page_cgroup is used or not.
> > Until we fix/confirm try_charge() does.
> >
> 
> Hmm... I think we need to fix this loop hole, if not mem, we should
> look at charging the root cgroup. I suspect !mem cases should be 0,
> I'll keep that as a TODO. 
> 
yes, I'd like to keep this in my mind, too.


Thanks,
-Kame

