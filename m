Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944Ab0AFHCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0AFHCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367Ab0AFHB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:01:59 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35932 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0AFHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:01:59 -0500
Date: Wed, 6 Jan 2010 12:31:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-ID: <20100106070150.GL3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091229182743.GB12533@balbir.in.ibm.com>
 <20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
 <20100104000752.GC16187@balbir.in.ibm.com>
 <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
 <20100104005030.GG16187@balbir.in.ibm.com>
 <20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 13:02:58]:

> On Mon, 4 Jan 2010 06:20:31 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-04 09:35:28]:
> > 
> > > On Mon, 4 Jan 2010 05:37:52 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-04 08:51:08]:
> > > > 
> > > > > On Tue, 29 Dec 2009 23:57:43 +0530
> > > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > Hi, Everyone,
> > > > > > 
> > > > > > I've been working on heuristics for shared page accounting for the
> > > > > > memory cgroup. I've tested the patches by creating multiple cgroups
> > > > > > and running programs that share memory and observed the output.
> > > > > > 
> > > > > > Comments?
> > > > > 
> > > > > Hmm? Why we have to do this in the kernel ?
> > > > >
> > > > 
> > > > For several reasons that I can think of
> > > > 
> > > > 1. With task migration changes coming in, getting consistent data free of races
> > > > is going to be hard.
> > > 
> > > Hmm, Let's see real-worlds's "ps" or "top" command. Even when there are no guarantee
> > > of error range of data, it's still useful.
> > 
> > Yes, my concern is this
> > 
> > 1. I iterate through tasks and calculate RSS
> > 2. I look at memory.usage_in_bytes
> > 
> > If the time in user space between 1 and 2 is large I get very wrong
> > results, specifically if the workload is changing its memory usage
> > drastically.. no?
> > 
> No. If it takes long time, locking fork()/exit() for such long time is the bigger
> issue.
> I recommend you to add memacct subsystem to sum up RSS of all processes's RSS counting
> under a cgroup.  Althoght it may add huge costs in page fault path but implementation
> will be very simple and will not hurt realtime ops.
> There will be no terrible race, I guess.
>

But others hold that lock as well, simple thing like listing tasks and
moving tasks, etc. I expect the usage of shared to be in the same
range.

-- 
	Balbir
