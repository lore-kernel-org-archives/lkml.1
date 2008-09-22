Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYIVLXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYIVLXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYIVLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:22:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56170 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYIVLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:22:57 -0400
Date: Mon, 22 Sep 2008 20:28:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/13] memory cgroup updates v4
Message-Id: <20080922202858.14525857.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 19:51:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Brief description.
> 
> 1/13 .... special mapping fix. (NEW)
>      => avoid accounting pages not on LRU...which we cannot reclaim.
> 
> 2/13 .... account swap-cache under lock.
>      => move accounting of swap-cache under lock for avoiding unnecessary race.
>          
> 3/13 .... make root cgroup to be unlimited.
>      => fix root cgroup's memory limit to unlimited.
> 
> 4/13 .... atomic-flags for page_cgroup
>      => make page_cgroup->flags to be atomic.
> 
> 5/13 .... implement move_account function.
>      => add a function for moving page_cgroup's account to other cgroup.
> 
> 6/13 ... force_empty to migrate account
>      => move all account to root cgroup rather than forget all.
> 
> 7/13 ...make mapping NULL (clean up)
>      => ensure page->mapping to be NULL before calling mem_cgroup_uncharge_cache().
> 
> 8/13 ...optimize cpustat
>      => optimize access to per-cpu statistics for memcg.
> 
> 9/13 ...lookup page_cgroup (CHANGED)
>      => preallocate all page_cgroup at boot and remove page->page_cgroup pointer.
> 
> 10/13...page_cgroup lookaside buffer 
>      => helps looking up page_cgroup from page.
> 
> 11/13...lazy lru freeing page_cgroup (NEW)
>      => do removal from LRU in bached manner like pagevec.
> 
> 12/13...lazy lru add page_cgroup (NEW)
>      => do addition to LRU in bached manner like pagevec.
> 
> 13/13...swap accountig fix. (NEW)
>      => fix race in swap accounting (can be happen)
>         and this intrduce new protocal as precharge/commit/cancel.
> 
> Some patches are big but not complicated I think.
> 
Sorry for crazy patch numbering...

1   -> 1
2   -> 2
3   -> 3
3.5 -> 4
3.6 -> 5
4   -> 6
5   -> 7
6   -> 8
9   -> 9
10  -> 10
11  -> 11
12  -> 12

I may not able to do quick responce, sorry.

Thanks,
-Kame



