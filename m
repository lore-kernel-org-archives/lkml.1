Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbXH0Tr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbXH0Tr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXH0TrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:47:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36558 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757589AbXH0TrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:47:18 -0400
Date: Mon, 27 Aug 2007 19:47:14 +0000
From: Mike Travis <travis@cthulhu.engr.sgi.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: travis@sgi.com, Andi Kleen <ak@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/6] x86: fix cpu_to_node references (v2)
In-Reply-To: <20070825002349.GB1894@linux-os.sc.intel.com>
Message-ID: <Pine.SGI.4.56.0708271940550.4346753@kluge.engr.sgi.com>
References: <20070824222654.687510000@sgi.com> <20070824222948.587159000@sgi.com>
 <20070825002349.GB1894@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Aug 2007, Siddha, Suresh B wrote:

> On Fri, Aug 24, 2007 at 03:26:55PM -0700, travis@sgi.com wrote:
> > Fix four instances where cpu_to_node is referenced
> > by array instead of via the cpu_to_node macro.  This
> > is preparation to moving it to the per_cpu data area.
> >
> ...
>
> >  unsigned long __init numa_free_all_bootmem(void)
> > --- a/arch/x86_64/mm/srat.c
> > +++ b/arch/x86_64/mm/srat.c
> > @@ -431,9 +431,9 @@
> >  			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
> >
> >  	for (i = 0; i < NR_CPUS; i++) {
> > -		if (cpu_to_node[i] == NUMA_NO_NODE)
> > +		if (cpu_to_node(i) == NUMA_NO_NODE)
> >  			continue;
> > -		if (!node_isset(cpu_to_node[i], node_possible_map))
> > +		if (!node_isset(cpu_to_node(i), node_possible_map))
> >  			numa_set_node(i, NUMA_NO_NODE);
> >  	}
> >  	numa_init_array();
>
> During this particular routine execution, per cpu areas are not yet setup. In
> future, when we make cpu_to_node(i) use per cpu area, then this code will break.
>
> And actually setup_per_cpu_areas() uses cpu_to_node(). So...
>

I have a scheme to use an __initdata array during __init processing which
is removed after the per cpu data area is setup.  I'm looking more closely
at all the various node <--> cpu tables.

Thanks,
Mike
