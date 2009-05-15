Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZEOSXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZEOSXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZEOSXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:23:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35780 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZEOSXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:23:34 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0905151358070.26559@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
	 <1242333519.15391.210.camel@nimitz>
	 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
	 <1242335120.15391.242.camel@nimitz>
	 <alpine.DEB.1.10.0905141729180.30187@qirst.com>
	 <1242337042.28440.34.camel@nimitz>
	 <alpine.DEB.2.00.0905141459370.624@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905151358070.26559@qirst.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 11:23:27 -0700
Message-Id: <1242411807.28257.44.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 13:58 -0400, Christoph Lameter wrote:
> On Thu, 14 May 2009, David Rientjes wrote:
> > > To me it at least adds the fact that more should be made *available* and
> > > not just that you're out of it.  So, definitely not perfect, but better
> > > than "out".
> > >
> >
> > I think "no allowable memory" followed by information on what is and is
> > not allowed in that specific context would remove any ambiguity.
> 
> Useful information to have. If a NUMA or cgroup restriction caused the
> failure then we should print that out.

We get a wee bit of info out for the cgroups case at least:

void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
{
...
        if (oom_kill_process(p, gfp_mask, 0, points, mem,
                                "Memory cgroup out of memory"))
                goto retry;

That can surely be improved, but it's a decent start.

-- Dave

