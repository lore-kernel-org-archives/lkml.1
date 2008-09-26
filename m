Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYIZDW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYIZDW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 23:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYIZDWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 23:22:48 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41905 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYIZDWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 23:22:48 -0400
Date: Fri, 26 Sep 2008 12:00:19 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 0/12] memcg updates v5
Message-Id: <20080926120019.33d58ca4.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080926120408.39187294.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926113228.ee377330.nishimura@mxp.nes.nec.co.jp>
	<20080926115810.b5fbae51.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926120408.39187294.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 12:04:08 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 26 Sep 2008 11:58:10 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Thank you.
> > 
> > How about following ?
> > -Kame
> > ==
> > Index: mmotm-2.6.27-rc7+/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-2.6.27-rc7+.orig/mm/memcontrol.c
> > +++ mmotm-2.6.27-rc7+/mm/memcontrol.c
> > @@ -597,8 +597,8 @@ __set_page_cgroup_lru(struct memcg_percp
> >  			spin_lock(&mz->lru_lock);
> >  		}
> >  		if (PageCgroupUsed(pc) && !PageCgroupLRU(pc)) {
> > -			SetPageCgroupLRU(pc);
> >  			__mem_cgroup_add_list(mz, pc);
> > +			SetPageCgroupLRU(pc);
> >  		}
> >  	}
> >  
> Of course, remove side should be..
> -Kame
> ==
> Index: mmotm-2.6.27-rc7+/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.27-rc7+.orig/mm/memcontrol.c
> +++ mmotm-2.6.27-rc7+/mm/memcontrol.c
> @@ -564,8 +564,8 @@ __release_page_cgroup(struct memcg_percp
>  			spin_lock(&mz->lru_lock);
>  		}
>  		if (!PageCgroupUsed(pc) && PageCgroupLRU(pc)) {
> -			__mem_cgroup_remove_list(mz, pc);
>  			ClearPageCgroupLRU(pc);
> +			__mem_cgroup_remove_list(mz, pc);
>  		}
>  	}
>  	if (prev_mz)
> @@ -597,8 +597,8 @@ __set_page_cgroup_lru(struct memcg_percp
>  			spin_lock(&mz->lru_lock);
>  		}
>  		if (PageCgroupUsed(pc) && !PageCgroupLRU(pc)) {
> -			SetPageCgroupLRU(pc);
>  			__mem_cgroup_add_list(mz, pc);
> +			SetPageCgroupLRU(pc);
>  		}
>  	}
>  
> 

I'll test it with updated version of 9-11 and report you back.


Thanks,
Daisuke Nishimura.
