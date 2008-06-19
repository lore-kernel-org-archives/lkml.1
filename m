Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYFSVPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYFSVPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYFSVPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:15:36 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:16923 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYFSVPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:15:36 -0400
Date: Thu, 19 Jun 2008 23:14:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080619211447.GA6180@osiris.ibm.com>
References: <20080619161949.GA11062@osiris.ibm.com> <1213898711.3223.107.camel@lappy.programming.kicks-ass.net> <1213899242.3223.110.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213899242.3223.110.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 08:14:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-06-19 at 20:05 +0200, Peter Zijlstra wrote:
> > On Thu, 2008-06-19 at 18:19 +0200, Heiko Carstens wrote:
> 
> > > The sched_entity that belongs to the cfs_rq:
> > > 
> > > >> px *(sched_entity *) 0x759300
> > > struct sched_entity {
> > >         load = struct load_weight {
> > >                 weight = 0x800
> > >                 inv_weight = 0x1ffc01
> > >         }
> > >         run_node = struct rb_node {
> > >                 rb_parent_color = 0x1
> > >                 rb_right = (nil)
> > >                 rb_left = (nil)
> > >         }
> > >         group_node = struct list_head {
> > >                 next = 0x75a3b8
> > >                 prev = 0x75a3b8
> > >         }
> > >         on_rq = 0x1
> > >         exec_start = 0x189685acb4aa46
> > >         sum_exec_runtime = 0x188a2b84c
> > >         vruntime = 0xd036bd29
> > >         prev_sum_exec_runtime = 0x1672e3f62
> > >         last_wakeup = 0x0
> > >         avg_overlap = 0x0
> > >         parent = (nil)
> > >         cfs_rq = 0x75a380
> > >         my_q = 0x759400
> > > }
> 
> Ooh, this thing is with CONFIG_GROUP_SCHED... does it still happen when
> you disable that?

Indeed, when CONFIG_GROUP_SCHED is disabled I cannot reproduce it anymore.
