Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228Ab0AFEGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0AFEGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 23:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247Ab0AFEGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 23:06:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57396 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0AFEGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 23:06:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jan 2010 13:02:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100104005030.GG16187@balbir.in.ibm.com>
References: <20091229182743.GB12533@balbir.in.ibm.com>
	<20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104000752.GC16187@balbir.in.ibm.com>
	<20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104005030.GG16187@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 06:20:31 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-04 09:35:28]:
> 
> > On Mon, 4 Jan 2010 05:37:52 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-04 08:51:08]:
> > > 
> > > > On Tue, 29 Dec 2009 23:57:43 +0530
> > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > Hi, Everyone,
> > > > > 
> > > > > I've been working on heuristics for shared page accounting for the
> > > > > memory cgroup. I've tested the patches by creating multiple cgroups
> > > > > and running programs that share memory and observed the output.
> > > > > 
> > > > > Comments?
> > > > 
> > > > Hmm? Why we have to do this in the kernel ?
> > > >
> > > 
> > > For several reasons that I can think of
> > > 
> > > 1. With task migration changes coming in, getting consistent data free of races
> > > is going to be hard.
> > 
> > Hmm, Let's see real-worlds's "ps" or "top" command. Even when there are no guarantee
> > of error range of data, it's still useful.
> 
> Yes, my concern is this
> 
> 1. I iterate through tasks and calculate RSS
> 2. I look at memory.usage_in_bytes
> 
> If the time in user space between 1 and 2 is large I get very wrong
> results, specifically if the workload is changing its memory usage
> drastically.. no?
> 
No. If it takes long time, locking fork()/exit() for such long time is the bigger
issue.
I recommend you to add memacct subsystem to sum up RSS of all processes's RSS counting
under a cgroup.  Althoght it may add huge costs in page fault path but implementation
will be very simple and will not hurt realtime ops.
There will be no terrible race, I guess.

Thanks,
-Kame

