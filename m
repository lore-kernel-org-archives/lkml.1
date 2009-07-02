Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZGBF7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZGBF7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZGBF7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:59:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60251 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZGBF7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:59:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 02 Jul 2009 14:59:19 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: yakui <yakui.zhao@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: + memory-hotplug-alloc-page-from-other-node-in-memory-online.patch added to -mm tree
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090702102208.ff480a2d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1246497073.18688.28.camel@localhost.localdomain> <20090702102208.ff480a2d.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090702144415.8B21.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 02 Jul 2009 09:11:13 +0800
> yakui <yakui.zhao@intel.com> wrote:
> 
> > On Thu, 2009-07-02 at 01:22 +0800, Christoph Lameter wrote:
> > > On Wed, 1 Jul 2009, yakui wrote:
> > > 
> > > > If we can't allocate memory from other node when there is no memory on
> > > > this node, we will have to do something like the bootmem allocator.
> > > > After the memory page is added to the system memory, we will have to
> > > > free the memory space used by the memory allocator. At the same time we
> > > > will have to assure that the hot-plugged memory exists physically.
> > > 
> > > The bootmem allocator must stick around it seems. Its more like a node
> > > bootstrap allocator then.
> > > 
> > > Maybe we can generalize that. The bootstrap allocator may only need to be
> > > able boot one node (which simplifies design). During system bringup only
> > > the boot node is brought up.
> > > 
> > > Then the other nodes are hotplugged later all in turn using the bootstrap
> > > allocator for their node setup?
> > Your idea looks fragrant. But it seems that it is difficult to realize.
> > In the boot phase the bootmem allocator is initialized. And after the
> > page buddy mechanism is enabled, the memory space used by bootmem
> > allocator will be freed.
> > 
> > If we also do the similar thing for the hotplugged node, how and when to
> > free the memory space used by the bootstrap allocator? It seems that we
> > will have to wait before all the memory sections are onlined for this
> > hotplugged node. And before all the memory sections are onlined, the
> > bootstrap allocator and buddy page allocator will co-exist.
> > 
> 
> When I was an eager developper of memory hotplug, I planned that.
> A special page allocater which works from allocating pgdat until memmap setup.
> But there were problems.
> example)
>   1. We wanted to reuse bootmem.c but it was difficult.
>   2. IBM guys uses 16MB section. Then, they cannot allocate local pgdat/memmap
>     as other platform which have larger section size.
>   3. At memory hotplug, "memory section which includes pgdat for a node should be
>      removed after all other sections on the node are removed"
>      There is the same problem to memmap.
> 
> Because current memory hotplug works sane and above problem was too complicated for
> me, I stopped. But there are more NUMAs than we implemented memory hotplug initially.
> I hope someone fixes this mis-allocation problem.
> 
> IIUC, "3" is the worst problem. It creates dependency among memory.

I made tiny basic functions to make it 1 or 2 years ago.
get_page_bootmem() record section/node id or counting up
how many other pages use it. It would be used for dependency
checking when removing memory.
I was going to make new allocator with those information.
(put_page_bootmem() is to free them.)

However, I don't enough time for memory hotplug now, 
and they are just redundant functions now.
If someone create new allocator (and unifying bootmem allocator),
I'm very glad. :-)


Bye.


-- 
Yasunori Goto 


