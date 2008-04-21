Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYDUAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYDUAbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYDUAbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:31:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41044 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYDUAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:31:31 -0400
Date: Mon, 21 Apr 2008 09:30:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Shi Weihua <shiwh@cn.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
Message-Id: <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0804210004470.1630@blonde.site>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0804210004470.1630@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 00:51:30 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:
> >  disable-the-memory-controller-by-default-v3.patch
> >  disable-the-memory-controller-by-default-v3-fix.patch
> 
> If those are to go in, then the sooner the better, yes.
> 
> But though I argued for cgroup_disable=memory (or some such),
> I think myself that taking it even further now (requiring an
> additional cgroup_enable=memory at boottime to get the memcg
> stuff you chose with CGROUP_MEM_RES_CTLR=y at build time) is
> confusing overkill, just messing around.
> 
> Others think differently.  A compromise would be to improve the
> helptext for CGROUP_MEM_RES_CTLR (some of it is presently nonsense,
> isn't it?  Certainly there's a significant overhead, but it's the
> 32-bit struct page not the 64-bit which then suffers from crossing
> cacheline boundaries).  Not much point in mentioning
> cgroup_disable=memory if those patches go in, but needs to say
> cgroup_enable=memory bootoption also needed.
> 
My concern around this is "default" action of cgroups may be different
from each otther. It's confusing...


> >  memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch
> 
> No, it was a good find from Shi, but you were right to think the patch
> fishy, and Kame put in lots of work (thank you!) to identify the actual
> culprit: he and Mel are discussing what the actual fix should be; and
> we might want to choose a different fix for stable than for 2.6.26.
> 
> I think you should drop that memmap_init_zone patch: the cgroup
> pointer is not the only field we assume is zeroed, both flags and
> mapping can cause trouble if they were not originally zeroed.
> Re-zero the whole struct page?  No, far better to fix the
> root of the corruption, that Kame and Mel are working on.
> 
I'll test and repodt Mel's patch later. I think Shi's patch will be
unnecessary.

Thanks,
-Kame



