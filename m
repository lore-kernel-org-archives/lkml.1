Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYGOEEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYGOEEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYGOEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:04:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYGOEEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:04:46 -0400
Date: Mon, 14 Jul 2008 21:04:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <Pine.LNX.4.58.0807142342450.8137@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0807142057310.3017@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com> <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <Pine.LNX.4.58.0807142320180.4530@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0807142029280.3017@woody.linux-foundation.org> <Pine.LNX.4.58.0807142342450.8137@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Steven Rostedt wrote:
> 
> Oh, I'm not arguing. My mind is going off to an even bigger picture, where
> something in the future would need to stop migration to a particular CPU,
> and that it could simply clear the bit and call synchronize_sched. The run
> queue lock is only visible to the scheduler.  Sorry, I may have been day
> dreaming out loud ;-)

Well, you'd be stuck right now anyway. 

At least in my trivial patch, the cpu_active_map locking is protected by 
'cpu_add_remove_lock' which is static to cpu.c. The only thing that 
modifies it (apart from the initial setup before SMP has been brought up) 
is the hotplug code.

			Linus
