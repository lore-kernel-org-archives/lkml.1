Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYHRHwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYHRHwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYHRHwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:52:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53613 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYHRHwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:52:37 -0400
Date: Mon, 18 Aug 2008 16:58:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
Message-Id: <20080818165856.0faeb0bb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080813071505.930965A75@siro.lan>
References: <1218116168.8625.38.camel@twins>
	<20080813071505.930965A75@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 16:15:05 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> hi,
> 
> > > @@ -485,7 +502,10 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
> > >  		if (PageUnevictable(page) ||
> > >  		    (PageActive(page) && !active) ||
> > >  		    (!PageActive(page) && active)) {
> > > -			__mem_cgroup_move_lists(pc, page_lru(page));
> > > +			if (try_lock_page_cgroup(page)) {
> > > +				__mem_cgroup_move_lists(pc, page_lru(page));
> > > +				unlock_page_cgroup(page);
> > > +			}
> > >  			continue;
> > >  		}
> > 
> > This chunk seems unrelated and lost....
> 
> it's necessary to protect from mem_cgroup_{set,clear}_dirty
> which modify pc->flags without holding mz->lru_lock.
> 

I'm now writing a patch to make page_cgroup->flags to be atomic_ops.
Don't worry about this.
(With remove-page-lock-cgroup patch, atomic_ops patch's performace is
 quite well.)

Thanks,
-Kame

