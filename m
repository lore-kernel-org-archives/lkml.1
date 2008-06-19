Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYFSVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYFSVg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbYFSVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:35817 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbYFSVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:47 -0400
Subject: Re: [BUG] CFS vs cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
References: <20080619161949.GA11062@osiris.ibm.com>
	 <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 23:32:29 +0200
Message-Id: <1213911149.3223.135.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-19 at 20:05 +0200, Peter Zijlstra wrote:
> On Thu, 2008-06-19 at 18:19 +0200, Heiko Carstens wrote:

> > The sched_entity that belongs to the cfs_rq:
> > 
> > >> px *(sched_entity *) 0x759300
> > struct sched_entity {
> >         load = struct load_weight {
> >                 weight = 0x800
> >                 inv_weight = 0x1ffc01
> >         }
> >         run_node = struct rb_node {
> >                 rb_parent_color = 0x1
> >                 rb_right = (nil)
> >                 rb_left = (nil)
> >         }
> >         group_node = struct list_head {
> >                 next = 0x75a3b8
> >                 prev = 0x75a3b8
> >         }
> >         on_rq = 0x1
> >         exec_start = 0x189685acb4aa46
> >         sum_exec_runtime = 0x188a2b84c
> >         vruntime = 0xd036bd29
> >         prev_sum_exec_runtime = 0x1672e3f62
> >         last_wakeup = 0x0
> >         avg_overlap = 0x0
> >         parent = (nil)
> >         cfs_rq = 0x75a380
> >         my_q = 0x759400
> > }

If you still have this dump, could you give the output of:

px *(struct cfs_rq *) 0x759400

And possibly walk down the chain getting its curr and then my_q again
etc..


