Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYIPMOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYIPMOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYIPMOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:14:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46621 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbYIPMOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:14:42 -0400
Date: Tue, 16 Sep 2008 21:13:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Dave Hansen <haveblue@us.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: memcg: lazy_lru (was Re: [RFC] [PATCH 8/9] memcg: remove
 page_cgroup pointer from memmap)
Message-Id: <20080916211355.277b625d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48CA9500.5060309@linux.vnet.ibm.com>
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
	<48CA9500.5060309@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 09:12:48 -0700
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Kamezawa,
> 
> I feel we can try the following approaches
> 
> 1. Try per-node per-zone radix tree with dynamic allocation
> 2. Try the approach you have
> 3. Integrate with sparsemem (last resort for performance), Dave Hansen suggested
> adding a mem_section member and using that.
> 
> I am going to try #1 today and see what the performance looks like
> 

I'm now writing *lazy* lru handing via per-cpu struct like pagevec.
It seems works well (but not so fast as expected on 2cpu box....)
I need more tests but it's not so bad to share the logic at this stage.

I added 3 patches on to this set. (my old set need bug fix.)
==
[1] patches/page_count.patch    ....get_page()/put_page() via page_cgroup.
[2] patches/lazy_lru_free.patch ....free page_cgroup from LRU in lazy way.
[3] patches/lazy_lru_add.patch  ....add page_cgroup to LRU in lazy way.

3 patches will follow this mail.

Because of speculative radix-tree lookup, page_count patch seems a bit
difficult. 

Anyway, I'll make this patch readable and post again.

Thanks,
-Kame

