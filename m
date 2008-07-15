Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYGODXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYGODXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYGODXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:23:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYGODXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:23:12 -0400
Date: Mon, 14 Jul 2008 23:23:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0807142320180.4530@gandalf.stny.rr.com>
References: <20080712031736.GA3040@damson.getinternet.no> 
 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> 
 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> 
 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Jul 2008, Linus Torvalds wrote:
> So by doing the test for cpu_active_map not at queuing time, but at the
> time when we actually try to do the migration, we can now also make that
> cpu_active_map be totally serialized.
>
> (Of course, anybody who clears the bit does need to take the runqueue lock
> of that CPU too, but cpu_down() will have to do that as it does the
> "migrate away live tasks" anyway, so that's not a problem)

Wouldn't simply doing a synchronize_sched() after clearing the bit also
make sure that no new task will be scheduled on that CPU?

-- Steve

