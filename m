Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbXK2BeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbXK2BeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbXK2BeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:34:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbXK2BeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:34:07 -0500
Date: Thu, 29 Nov 2007 10:37:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
Message-Id: <20071129103702.cbc5cf73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1196284799.5318.34.camel@localhost>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
	<20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
	<1196284799.5318.34.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 16:19:59 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> As soon as this loop hits the first non-existent node on my platform, I
> get a NULL pointer deref down in __alloc_pages.  Stack trace below.
> 
> Perhaps N_POSSIBLE should be N_HIGH_MEMORY?  That would require handling
> of memory/node hotplug for each memory control group, right?  But, I'm
> going to try N_HIGH_MEMORY as a work around.
> 
Hmm, ok. (>_<


> Call Trace:
>  [<a000000100014de0>] show_stack+0x80/0xa0
>                                 sp=a0000001008e39c0 bsp=a0000001008dd1b0
>  [<a000000100015a70>] show_regs+0x870/0x8a0
>                                 sp=a0000001008e3b90 bsp=a0000001008dd158
>  [<a00000010003d130>] die+0x190/0x300
>                                 sp=a0000001008e3b90 bsp=a0000001008dd110
>  [<a000000100071b80>] ia64_do_page_fault+0x8e0/0xa20
>                                 sp=a0000001008e3b90 bsp=a0000001008dd0b8
>  [<a00000010000b5c0>] ia64_leave_kernel+0x0/0x270
>                                 sp=a0000001008e3c20 bsp=a0000001008dd0b8
>  [<a000000100132e10>] __alloc_pages+0x30/0x6e0
>                                 sp=a0000001008e3df0 bsp=a0000001008dcfe0
>  [<a000000100187370>] new_slab+0x610/0x6c0
>                                 sp=a0000001008e3e00 bsp=a0000001008dcf80
>  [<a000000100187470>] get_new_slab+0x50/0x200
>                                 sp=a0000001008e3e00 bsp=a0000001008dcf48
>  [<a000000100187900>] __slab_alloc+0x2e0/0x4e0
>                                 sp=a0000001008e3e00 bsp=a0000001008dcf00
>  [<a000000100187c80>] kmem_cache_alloc_node+0x180/0x200
>                                 sp=a0000001008e3e10 bsp=a0000001008dcec0
>  [<a0000001001945a0>] mem_cgroup_create+0x160/0x400
>                                 sp=a0000001008e3e10 bsp=a0000001008dce78
>  [<a0000001000f0940>] cgroup_init_subsys+0xa0/0x400
>                                 sp=a0000001008e3e20 bsp=a0000001008dce28
>  [<a0000001008521f0>] cgroup_init+0x90/0x160
>                                 sp=a0000001008e3e20 bsp=a0000001008dce00
>  [<a000000100831960>] start_kernel+0x700/0x820
>                                 sp=a0000001008e3e20 bsp=a0000001008dcd80
> 
Maybe zonelists of NODE_DATA() is not initialized. you are right.
I think N_HIGH_MEMORY will be suitable here...(I'll consider node-hotplug case later.)

Thank you for test!

Regards,
-Kame



