Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYGCIc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYGCIc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYGCIRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:17:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49293 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937033AbYGCHxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:53:25 -0400
Date: Thu, 3 Jul 2008 16:56:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: change shmem handler.
Message-Id: <20080703165604.a9be04bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <486C7C82.4020600@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290120270.21758@blonde.site>
	<20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
	<486C7C82.4020600@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2008 12:45:14 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > This patch fixes some mess by
> >   - PAGE_CGROUP_FLAG_CACHE is deleted (and replaced by FLAG_FILE)
> >   - PAGE_CGROUP_FLAG_SHMEM is added.
> >   - add_to_page_cache_nocharge() is added.
> >     This avoids mem_cgroup_charge_cache_page(). This is useful when page is
> >     pre-charged.
> >   - uses add_to_page_cache_nocharge() also in hugemem.
> >     (I think hugemem controller should be independent from memcg.
> >      Balbir, how do you think ?)
> 
> I am not 100% sure of that right now. I definitely want different control
> parameters (not included as a part of memory.limit_in_bytes). If there is
> leverage from memory controller, we could consider adding that to it or a
> separate controller if that makes more sense.
> 
Checking PG_compound in mem_cgroup_charge_cache_page() is enough, maybe.
(If multi-page-file-cache is added, need rework ;)

> >   - PageSwapBacked() is checked.
> >     (A imported patch from Hugh Dickins)
> > 
> > As result.
> >   - shmem will be in SwapBacked/Active list at first.
> 
> Good
> 
> >   - memcg has "shmem/tmpfs" counter.
> > 
> 
> I think this will be useful too (but I need to play with it)
> 
I've been argued that "if you want to add such a stupid counter, add the
same parameter to global lru without any overhead."

I'll postpone this ;) I have many other thing to do.

But the total number of pages used for shmem is already counted by
address_space->nr_pages. So, not very difficult for global lru if we can
walk all inodes of shmem. The problem will be "whether it's worth to do or not"

Thanks,
-Kame


