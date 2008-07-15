Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYGOEQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYGOEQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYGOEQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:16:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYGOEQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:16:09 -0400
Date: Tue, 15 Jul 2008 00:16:07 -0400 (EDT)
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
In-Reply-To: <alpine.LFD.1.10.0807142057310.3017@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0807150013020.8553@gandalf.stny.rr.com>
References: <20080712031736.GA3040@damson.getinternet.no> 
 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> 
 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> 
 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
 <Pine.LNX.4.58.0807142320180.4530@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0807142029280.3017@woody.linux-foundation.org>
 <Pine.LNX.4.58.0807142342450.8137@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0807142057310.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Linus Torvalds wrote:
> >
> > Oh, I'm not arguing. My mind is going off to an even bigger picture, where
> > something in the future would need to stop migration to a particular CPU,
> > and that it could simply clear the bit and call synchronize_sched. The run
> > queue lock is only visible to the scheduler.  Sorry, I may have been day
> > dreaming out loud ;-)
>
> Well, you'd be stuck right now anyway.
>
> At least in my trivial patch, the cpu_active_map locking is protected by
> 'cpu_add_remove_lock' which is static to cpu.c. The only thing that
> modifies it (apart from the initial setup before SMP has been brought up)
> is the hotplug code.

Yeah, I see that now. I was thinking back to a time I was doing some crazy
kernel hacking and would have liked this feature (stop new tasks from
migrating to a CPU). cpusets today are probably a better answer, and what
I was thinking with using the cpu_active_map is more of a hack.

Sorry for the noise, I'll go back to updating ftrace.txt

-- Steve

