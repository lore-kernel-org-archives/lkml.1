Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZAICnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZAICnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZAICnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:43:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37151 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZAICm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:42:59 -0500
Date: Fri, 9 Jan 2009 11:41:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       menage@google.com
Subject: Re: [RFC][PATCH 1/4] memcg: fix for
 mem_cgroup_get_reclaim_stat_from_page
Message-Id: <20090109114155.75fd61fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090109113458.d9a1320d.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
	<20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
	<4966A117.9030201@cn.fujitsu.com>
	<20090109100531.03cd998f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090109113458.d9a1320d.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 11:34:58 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 9 Jan 2009 10:05:31 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 09 Jan 2009 08:57:59 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index e2996b8..62e69d8 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -559,6 +559,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
> > > >  		return NULL;
> > > >  
> > > >  	pc = lookup_page_cgroup(page);
> > > > +	smp_rmb();
> > > 
> > > It is better to add a comment to explain this smp_rmb. I think it's recommended
> > > that every memory barrier has a comment.
> > > 
> > Ah, yes. good point.
> > 
> > Maybe text like this
> > /*
> >  * Used bit is set without atomic ops but after smp_wmb().
> >  * For making pc->mem_cgroup visible, insert smp_rmb() here.
> >  */
> > 
> OK. I'll add this comment.
> 
> BTW, mem_cgroup_rotate_lru_list and mem_cgroup_add_lru_list have similar code.
> (mem_cgroup_add_lru_list has some comment already.)
> Should I update them too ?
> 
please :) it's helpful. Sorry for my too short comment on orignal patch.

-Kame

