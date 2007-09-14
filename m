Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbXINOJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbXINOJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbXINOJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:09:32 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:39266 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXINOJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:09:31 -0400
Subject: Re: [PATCH -mm] mm: Fix memory hotplug + sparsemem build.
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Andy Whitcroft <apw@shadowen.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20070913194130.1611fd78.akpm@linux-foundation.org>
References: <20070911182546.F139.Y-GOTO@jp.fujitsu.com>
	 <20070913184456.16ff248e.akpm@linux-foundation.org>
	 <20070914105420.F2E9.Y-GOTO@jp.fujitsu.com>
	 <20070913194130.1611fd78.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 14 Sep 2007 10:09:27 -0400
Message-Id: <1189778967.5315.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 19:41 -0700, Andrew Morton wrote:
> On Fri, 14 Sep 2007 11:02:43 +0900 Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> 
> > > >  	/* call arch's memory hotadd */
> > > > 
> > > 
> > > OK, we're getting into a mess here.  This patch fixes
> > > update-n_high_memory-node-state-for-memory-hotadd.patch, but which patch
> > > does update-n_high_memory-node-state-for-memory-hotadd.patch fix?
> > > 
> > > At present I just whacked
> > > update-n_high_memory-node-state-for-memory-hotadd.patch at the end of
> > > everything, but that was lazy of me and it ends up making a mess.
> > 
> > It is enough. No more patch is necessary for these issues.
> > I already fixed about Andy-san's comment. :-)
> 
> Now I'm more confused.  I have two separeate questions:
> 
> a) Is the justr-added update-n_high_memory-node-state-for-memory-hotadd-fix.patch
>    still needed?
> 
> b) Which patch in 2.6.22-rc4-mm1 does
>    update-n_high_memory-node-state-for-memory-hotadd.patch fix?  In other
>    words, into which patch should I fold
>    update-n_high_memory-node-state-for-memory-hotadd.patch prior to sending
>    to Linus?

Andrew:  

I originally sent in the "update-n_high_memory..." patch against
23-rc3-mm1 on 27aug to fix a problem that I introduced when I moved the
populating of N_HIGH_MEMORY state to free_area_init_nodes().  This would
miss setting the "has memory" node state for hot added memory.  I never
saw any response, but then it ended up in 23-rc4-mm1.

This Tuesday, Paul Mundt sent in a patch to fix a build problem with
MEMORY_HOTPLUG_SPARSE introduced by my patch.  He replaced zone->node
with zone_to_nid(zone) in the node_set_state() arguments.

The latest patch, from Yasunori-san, I believe, starts kswapd for nodes
to which memory has been hot-added.  As I understand it, his is needed
because the memoryless nodes patch results in no kswapd for memoryless
nodes.

Does that help?

Lee


> 
>    (I (usually) get to work this out for myself.  Sometimes it is painful).
> 
> Generally, if people tell me which patch-in-mm their patch is fixing,
> it really helps.  Adrian does this all the time.
> 
> Thanks.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

