Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYHTKfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYHTKfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYHTKfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:35:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50458 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYHTKfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:35:22 -0400
Date: Wed, 20 Aug 2008 19:41:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH -mm 0/7] memcg: lockless page_cgroup v1
Message-Id: <20080820194108.e76b20b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 18:53:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hi, this is a patch set for lockless page_cgroup.
> 
> dropped patches related to mem+swap controller for easy review.
> (I'm rewriting it, too.)
> 
> Changes from current -mm is.
>   - page_cgroup->flags operations is set to be atomic.
>   - lock_page_cgroup() is removed.
>   - page->page_cgroup is changed from unsigned long to struct page_cgroup*
>   - page_cgroup is freed by RCU.
>   - For avoiding race, charge/uncharge against mm/memory.c::insert_page() is
>     omitted. This is ususally used for mapping device's page. (I think...)
> 
> In my quick test, perfomance is improved a little. But the benefit of this
> patch is to allow access page_cgroup without lock. I think this is good 
> for Yamamoto's Dirty page tracking for memcg.
> For I/O tracking people, I added a header file for allowing access to
> page_cgroup from out of memcontrol.c
> 
> The base kernel is recent mmtom. Any comments are welcome.
> This is still under test. I have to do long-run test before removing "RFC".
> 
Known problem: force_emtpy is broken...so rmdir will struck into nightmare.
It's because of patch 2/7.
will be fixed in the next version.

Thanks,
-Kame

