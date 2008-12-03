Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbYLCOEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbYLCOEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYLCOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:04:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYLCOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:04:05 -0500
Date: Wed, 3 Dec 2008 09:04:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: function graph return for function entry
In-Reply-To: <c62985530812030523w3e5130cfg6db9d146c67e2d27@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812030902430.29045@gandalf.stny.rr.com>
References: <20081203045001.367443457@goodmis.org>  <20081203045044.002248353@goodmis.org>  <20081203081301.GF21006@elte.hu> <20081203100526.GA13096@elte.hu>  <alpine.DEB.1.10.0812030655360.29045@gandalf.stny.rr.com>
 <c62985530812030523w3e5130cfg6db9d146c67e2d27@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Fr?d?ric Weisbecker wrote:
> >>  ffff8800384d5df8 0000000000000040 ffff8800384d5c48 ffffffff8020c0fd
> >> Call Trace:
> >>  [<ffffffff8020c0d6>] ? ftrace_graph_caller+0x46/0x6d
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff8020ee9b>] dump_trace+0x26e/0x27f
> >>  [<ffffffff8057318d>] ? atomic_notifier_call_chain+0x13/0x15
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff8020f899>] show_trace_log_lvl+0x51/0x5d
> >>  [<ffffffff80572ff2>] do_page_fault+0x7af/0x8cd
> >>  [<ffffffff8027c00f>] ? rb_reserve_next_event+0x19b/0x2f2
> >>  [<ffffffff8027c4c4>] ? tracing_generic_entry_update+0x7f/0xab
> >>  [<ffffffff80570479>] ? trace_hardirqs_off_thunk+0x3a/0x6c
> >>  [<ffffffff80570adf>] page_fault+0x1f/0x30
> >>  [<ffffffff8028a7e1>] ? get_page_from_freelist+0x324/0x64a
> >>  [<ffffffff8028a7df>] ? get_page_from_freelist+0x322/0x64a
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff8020e9f2>] show_stack_log_lvl+0x100/0x10f
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff8020eab6>] show_registers+0xb5/0x22c
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff805714bf>] __die+0x99/0xe7
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff8020eab6>] show_registers+0xb5/0x22c
> >>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
> >>  [<ffffffff805714bf>] __die+0x99/0xe7
> >> Code: e8 4a fa 35 00 eb 08 f7 c3 ff 1f 00 00 74 42 45 85 e4 74 17 41 f6 c4 03 75 11 4c 89 fe 48 c7 c7 24 88 6a 80 31 c0 e8 24 fa 35 00 <48> 8b 33 48 c7 c7 28 88 6a 80 31 c0 48 83 c3 08 41 ff c4 e8 0c
> >> RIP  [<ffffffff8020e9a7>] show_stack_log_lvl+0xb5/0x10f
> >>  RSP <ffff8800384d5ba8>
> >> CR2: 0000000000000003
> >> ---[ end trace 68aa414552b98440 ]---
> 
> 
> I've never had such a thing (didn't tested yet with the last Steven's
> patches). But I had a strange
> warn_on_slowpath at the middle of a reboot which seems to rely on the
> function-graph-tracer, or perhaps ring-buffer,
> both where cited in the trace. But my stacktraces were dirty. It
> should be more understandable with the Steven latest patches
> which fix the nasty stacktraces....
> 
> I will test all of that this evening.

Note, I've only seen this bug when I had stack tracer running as well. And 
according to Ingo's config, he has it turned on too. Could you test with 
CONFIG_STACK_TRACER as well.

Thanks,

-- Steve

