Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYI3MFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYI3MFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYI3ME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:04:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYI3ME6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:04:58 -0400
Date: Tue, 30 Sep 2008 08:04:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/6] ftrace: port to the new ring_buffer
In-Reply-To: <20080930083051.GA10127@elte.hu>
Message-ID: <alpine.DEB.1.10.0809300804390.30533@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930074514.GB2838@elte.hu> <20080930082302.GA2852@elte.hu> <20080930083051.GA10127@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Ingo Molnar wrote:

> 
> > -tip testing found that tip/tracing/ring-buffer causes a new lockdep 
> > splat:
> 
> FYI, triggered on a number of 32-bit test-systems as well - see the log 
> below.
> 
> 	Ingo
> 
> [    0.564008] calling  tracer_alloc_buffers+0x0/0x16b @ 1
> [    0.574504] ------------[ cut here ]------------
> [    0.576002] WARNING: at kernel/lockdep.c:2880 check_flags+0x5a/0x155()
> [    0.576002] Modules linked in:
> [    0.576002] Pid: 1, comm: swapper Not tainted 2.6.27-rc8-tip-00915-g8cb18a9-dirty #37502
> [    0.576002]  [<c01536c4>] warn_on_slowpath+0x46/0x6a
> [    0.576002]  [<c0170b14>] ? trace_hardirqs_off+0xb/0xd
> [    0.576002]  [<c0173294>] ? __lock_acquire+0xa91/0xaad
> [    0.576002]  [<c01a6470>] ? get_page_from_freelist+0x37b/0x455
> [    0.576002]  [<c0170044>] ? __raw_spin_is_locked+0x15/0x18
> [    0.576002]  [<c0171cf8>] ? find_usage_backwards+0x21/0xe1
> [    0.576002]  [<c019f852>] ? time_hardirqs_off+0xe/0x1f
> [    0.576002]  [<c0170a66>] ? trace_hardirqs_off_caller+0x15/0xb8
> [    0.576002]  [<c0170b14>] ? trace_hardirqs_off+0xb/0xd

Again, I think this is the same issue with the raws?

-- Steve

