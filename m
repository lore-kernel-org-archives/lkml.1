Return-Path: <linux-kernel-owner+w=401wt.eu-S1031032AbXDYUsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031032AbXDYUsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031131AbXDYUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:48:12 -0400
Received: from ns.suse.de ([195.135.220.2]:36892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031032AbXDYUsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:48:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Date: Wed, 25 Apr 2007 22:48:03 +0200
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net> <462FB8E6.9070501@googlemail.com> <462FBD44.2040103@goop.org>
In-Reply-To: <462FBD44.2040103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252248.03243.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 22:42:44 Jeremy Fitzhardinge wrote:
> Michal Piotrowski wrote:
> > Timing information is broken
> >   
> 
> This looks like Andi's sched_clock stuff hitting: it returns an
> inherently per-cpu result, so using it for printk timestamps isn't very
> useful.

It should actually roughly work. There can be some drift, but there shouldn't
be that much error. All CPUs should tick at roughly the same rate because
it's scaled to nanoseconds

If the drift is a big issue it would also be possible to resync every minute
or so, but I haven't implemented that.

There will be always some minor monotonicities because it won't try
to stop the CPU from reordering instructions.

I don't know why it is that off in your case.

 
> > [4294667.511000] BUG: at arch/i386/kernel/sched-clock.c:175 init_sched_clock()
> > [4294667.511000]  [<c01052e0>] dump_trace+0x63/0x1eb
> > [4294667.511000]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
> > [4294667.511000]  [<c01060c4>] show_trace+0x12/0x14
> > [4294667.511000]  [<c0106161>] dump_stack+0x16/0x18
> > [4294667.511000]  [<c04fd968>] init_sched_clock+0x6d/0xcc
> > [4294667.512000]  [<c04f8505>] kernel_init+0x14e/0x2bf
> > [4294667.512000]  [<c0104ec3>] kernel_thread_helper+0x7/0x10
> > [4294667.512000]  =======================
> 
> This also seems to be the sched_clock change; the WARN_ON is asserting
> that it got initialized early enough, but it isn't. 

That's already fixed.

-Andi


