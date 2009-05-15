Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZEQDmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZEQDmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 23:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZEQDmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 23:42:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49061 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEQDmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 23:42:38 -0400
Date: Sat, 16 May 2009 00:27:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Misleading OOM messages
Message-ID: <20090515185745.GJ4451@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <1242337042.28440.34.camel@nimitz> <alpine.DEB.2.00.0905141459370.624@chino.kir.corp.google.com> <alpine.DEB.1.10.0905151358070.26559@qirst.com> <1242411807.28257.44.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242411807.28257.44.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2009-05-15 11:23:27]:

> On Fri, 2009-05-15 at 13:58 -0400, Christoph Lameter wrote:
> > On Thu, 14 May 2009, David Rientjes wrote:
> > > > To me it at least adds the fact that more should be made *available* and
> > > > not just that you're out of it.  So, definitely not perfect, but better
> > > > than "out".
> > > >
> > >
> > > I think "no allowable memory" followed by information on what is and is
> > > not allowed in that specific context would remove any ambiguity.
> > 
> > Useful information to have. If a NUMA or cgroup restriction caused the
> > failure then we should print that out.
> 
> We get a wee bit of info out for the cgroups case at least:
> 
> void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
> {
> ...
>         if (oom_kill_process(p, gfp_mask, 0, points, mem,
>                                 "Memory cgroup out of memory"))
>                 goto retry;
> 
> That can surely be improved, but it's a decent start.
>

Also look at mem_cgroup_print_oom_info(). 

-- 
	Balbir
