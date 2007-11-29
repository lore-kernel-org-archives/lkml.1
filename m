Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXK2DXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXK2DXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbXK2DXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:23:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52347 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXK2DXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:23:08 -0500
Date: Thu, 29 Nov 2007 12:25:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
Message-Id: <20071129122532.68ff4e75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071129031937.3C86F1CFE80@siro.lan>
References: <20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
	<20071129031937.3C86F1CFE80@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 12:19:37 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> > @@ -651,10 +758,11 @@
> >  		/* Avoid race with charge */
> >  		atomic_set(&pc->ref_cnt, 0);
> >  		if (clear_page_cgroup(page, pc) == pc) {
> > +			int active;
> >  			css_put(&mem->css);
> > +			active = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
> >  			res_counter_uncharge(&mem->res, PAGE_SIZE);
> > -			list_del_init(&pc->lru);
> > -			mem_cgroup_charge_statistics(mem, pc->flags, false);
> > +			__mem_cgroup_remove_list(pc);
> >  			kfree(pc);
> >  		} else 	/* being uncharged ? ...do relax */
> >  			break;
> 
> 'active' seems unused.
> 
ok, I will post clean-up against -mm2.

Thanks,
-Kame

