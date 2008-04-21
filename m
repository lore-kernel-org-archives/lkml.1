Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYDUJmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYDUJmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYDUJmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:42:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46437 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYDUJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:42:35 -0400
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, shiwh@cn.fujitsu.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org
In-Reply-To: <20080421064725.GA32214@balbir.in.ibm.com>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0804210004470.1630@blonde.site>
	 <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080420232427.1b399104.akpm@linux-foundation.org>
	 <480C347C.6060702@linux.vnet.ibm.com>
	 <20080421064725.GA32214@balbir.in.ibm.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 11:42:05 +0200
Message-Id: <1208770925.7115.167.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 12:17 +0530, Balbir Singh wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> [2008-04-21 12:14:28]:
> 
> > Andrew Morton wrote:
> > >> On Mon, 21 Apr 2008 09:30:59 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > >> On Mon, 21 Apr 2008 00:51:30 +0100 (BST)
> > >> Hugh Dickins <hugh@veritas.com> wrote:
> > >>>>  disable-the-memory-controller-by-default-v3.patch
> > >>>>  disable-the-memory-controller-by-default-v3-fix.patch
> > >>> If those are to go in, then the sooner the better, yes.
> > >>>
> > >>> But though I argued for cgroup_disable=memory (or some such),
> > >>> I think myself that taking it even further now (requiring an
> > >>> additional cgroup_enable=memory at boottime to get the memcg
> > >>> stuff you chose with CGROUP_MEM_RES_CTLR=y at build time) is
> > >>> confusing overkill, just messing around.
> > > 
> > > Yes, it does sound a bit silly.  I'd say just enable it, and provide a
> > > cgroup_disable.
> > > 
> > 
> OK, fair enough. Andi Kleen spoke about the overhead and how distros would
> be impacted if they enabled CONFIG_MEM_RES_CTLR and it was not disabled by
> default. I think the enable/disable is good. I just need to turn on/off
> mem_cgroup_subsys.disabled. The patch is as simple as
>  
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  mm/memcontrol.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff -puN mm/memcontrol.c~memcg-dont-disable-by-default mm/memcontrol.c
> --- linux-2.6.25/mm/memcontrol.c~memcg-dont-disable-by-default	2008-04-21 12:11:31.000000000 +0530
> +++ linux-2.6.25-balbir/mm/memcontrol.c	2008-04-21 12:11:40.000000000 +0530
> @@ -1108,5 +1108,4 @@ struct cgroup_subsys mem_cgroup_subsys =
>  	.populate = mem_cgroup_populate,
>  	.attach = mem_cgroup_move_task,
>  	.early_init = 0,
> -	.disabled = 1,
>  };
> _
> 
> This would enable the memory controller by default, it can be disabled
> using cgroup_disable=memory at boot time.

how about working on a runtime switch that only enables the whole
memcgroup machinery when an actual cgroup gets created - and disable it
again once the last cgroup goes.

