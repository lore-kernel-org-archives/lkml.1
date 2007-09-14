Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbXINUwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbXINUwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXINUwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:52:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbXINUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:52:43 -0400
Date: Fri, 14 Sep 2007 13:51:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Andy Whitcroft <apw@shadowen.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] mm: Fix memory hotplug + sparsemem build.
Message-Id: <20070914135154.bc60742e.akpm@linux-foundation.org>
In-Reply-To: <1189778967.5315.11.camel@localhost>
References: <20070911182546.F139.Y-GOTO@jp.fujitsu.com>
	<20070913184456.16ff248e.akpm@linux-foundation.org>
	<20070914105420.F2E9.Y-GOTO@jp.fujitsu.com>
	<20070913194130.1611fd78.akpm@linux-foundation.org>
	<1189778967.5315.11.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 10:09:27 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> I originally sent in the "update-n_high_memory..." patch against
> 23-rc3-mm1 on 27aug to fix a problem that I introduced when I moved the
> populating of N_HIGH_MEMORY state to free_area_init_nodes().  This would
> miss setting the "has memory" node state for hot added memory.  I never
> saw any response, but then it ended up in 23-rc4-mm1.
> 
> This Tuesday, Paul Mundt sent in a patch to fix a build problem with
> MEMORY_HOTPLUG_SPARSE introduced by my patch.  He replaced zone->node
> with zone_to_nid(zone) in the node_set_state() arguments.
> 
> The latest patch, from Yasunori-san, I believe, starts kswapd for nodes
> to which memory has been hot-added.  As I understand it, his is needed
> because the memoryless nodes patch results in no kswapd for memoryless
> nodes.
> 
> Does that help?

not really ;)

See, when I get some rinky-dink little fix for a patch in -mm I will
position that patch immediately after the patch which it is fixing, with a
filename which is derived from the fixed patch's name.  So when
send-to-Linus time comes, I can fold the fixes into the base patch.  This
practice also keeps the patches in a sensible presentation order, with
minimum interdependencies and good git-bisect friendliness.

However it sometimes (rarely) takes considerable effort to work out which
patch in -mm a particular fix is fixing.  That was the case with
update-n_high_memory-node-state-for-memory-hotadd.patch.

It helps me quite a bit if people tell me which patch they're fixing. 
Usually they don't and I get to work it out.  Usually it's fairly obvious.

