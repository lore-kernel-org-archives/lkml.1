Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbZAIBGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbZAIBGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760557AbZAIBGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:06:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60492 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549AbZAIBGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:06:35 -0500
Date: Fri, 9 Jan 2009 10:05:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       menage@google.com
Subject: Re: [RFC][PATCH 1/4] memcg: fix for
 mem_cgroup_get_reclaim_stat_from_page
Message-Id: <20090109100531.03cd998f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4966A117.9030201@cn.fujitsu.com>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
	<20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
	<4966A117.9030201@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009 08:57:59 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e2996b8..62e69d8 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -559,6 +559,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
> >  		return NULL;
> >  
> >  	pc = lookup_page_cgroup(page);
> > +	smp_rmb();
> 
> It is better to add a comment to explain this smp_rmb. I think it's recommended
> that every memory barrier has a comment.
> 
Ah, yes. good point.

Maybe text like this
/*
 * Used bit is set without atomic ops but after smp_wmb().
 * For making pc->mem_cgroup visible, insert smp_rmb() here.
 */

?
-Kame

