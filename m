Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048Ab0AGHQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0AGHQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366Ab0AGHQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:16:03 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56032 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0AGHQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:16:01 -0500
Date: Thu, 7 Jan 2010 12:45:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-ID: <20100107071554.GO3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091229182743.GB12533@balbir.in.ibm.com>
 <20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
 <20100104000752.GC16187@balbir.in.ibm.com>
 <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
 <20100104005030.GG16187@balbir.in.ibm.com>
 <20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
 <20100106070150.GL3059@balbir.in.ibm.com>
 <20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 16:12:11]:

> On Wed, 6 Jan 2010 12:31:50 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > No. If it takes long time, locking fork()/exit() for such long time is the bigger
> > > issue.
> > > I recommend you to add memacct subsystem to sum up RSS of all processes's RSS counting
> > > under a cgroup.  Althoght it may add huge costs in page fault path but implementation
> > > will be very simple and will not hurt realtime ops.
> > > There will be no terrible race, I guess.
> > >
> > 
> > But others hold that lock as well, simple thing like listing tasks and
> > moving tasks, etc. I expect the usage of shared to be in the same
> > range.
> > 
> 
> And piles up costs ? I think cgroup guys should pay attention to fork/exit
> costs more. Now, it gets slower and slower.
> In that point, I never like migrate-at-task-move work in cpuset and memcg.
> 
> My 1st objection to this patch is this "shared" doesn't mean "shared between
> cgroup" but means "shared between processes".
> I think it's of no use and no help to users.
>

So what in your opinion would help end users? My concern is that as
we make progress with memcg, we account only for privately used pages
with no hint/data about the real usage (shared within or with other
cgroups). How do we decide if one cgroup is really heavy?
 
> And implementation is 2nd thing.
> 

More details on your concern, please!

-- 
	Balbir
