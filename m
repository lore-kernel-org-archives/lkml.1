Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYIZK31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYIZK31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYIZK3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:29:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37458 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYIZK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:29:15 -0400
Date: Fri, 26 Sep 2008 19:36:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 0/12] memcg updates v5
Message-Id: <20080926193602.6b397910.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48DCAC02.5050108@linux.vnet.ibm.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<48DC9AF2.1050101@linux.vnet.ibm.com>
	<20080926182253.a62cc2d0.kamezawa.hiroyu@jp.fujitsu.com>
	<48DCAC02.5050108@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 15:01:46 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Fri, 26 Sep 2008 13:48:58 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> KAMEZAWA Hiroyuki wrote:
> >>> Hi, I updated the stack and reflected comments.
> >>> Against the latest mmotm. (rc7-mm1)
> >>>
> >>> Major changes from previous one is 
> >>>   - page_cgroup allocation/lookup manner is changed.
> >>>     all FLATMEM/DISCONTIGMEM/SPARSEMEM and MEMORY_HOTPLUG is supported.
> >>>   - force_empty is totally rewritten. and a problem that "force_empty takes long time"
> >>>     in previous version is fixed (I think...)
> >>>   - reordered patches.
> >>>      - first half are easy ones.
> >>>      - second half are big ones.
> >>>
> >>> I'm still testing with full debug option. No problem found yet.
> >>> (I'm afraid of race condition which have not been caught yet.)
> >>>
> >>> [1/12]  avoid accounting special mappings not on LRU. (fix)
> >>> [2/12]  move charege() call to swapped-in page under lock_page() (clean up)
> >>> [3/12]  make root cgroup to be unlimited. (change semantics.)
> >>> [4/12]  make page->mapping NULL before calling uncharge (clean up)
> >>> [5/12]  make page->flags to use atomic ops. (changes in infrastructure)
> >>> [6/12]  optimize stat. (clean up)
> >>> [7/12]  add support function for moving account. (new function)
> >>> [8/12]  rewrite force_empty to use move_account. (change semantics.)
> >>> [9/12]  allocate all page_cgroup at boot. (changes in infrastructure)
> >>> [10/12] free page_cgroup from LRU in lazy way (optimize)
> >>> [11/12] add page_cgroup to LRU in lazy way (optimize)
> >>> [12/12] fix race at charging swap  (fix by new logic.)
> >>>
> >>> *Any* comment is welcome.
> >> Kame,
> >>
> >> I'm beginning to review test the patches now. It would be really nice to split
> >> the development patches from the maintenance ones. I think the full patchset has
> >> too many things and is confusing to look at.
> >>
> > I hope I can do....but maybe difficult.
> > If you give me ack, 1,2,4,6, can be pushed at early stage.
> 
> I think (1) might be OK, except for the accounting issues pointed out (change in
> behaviour visible to end user again, sigh! :( ).
But it was just a BUG from my point of view...

> Is (1) a serious issue? 
considering force_empty(), it's serious.

> (2) seems OK, except for the locking change for mark_page_accessed. I am looking at
> (4) and (6) currently.
> 
Thanks,
-Kmae

> -- 
> 	Balbir
> 

