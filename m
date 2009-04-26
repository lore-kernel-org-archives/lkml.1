Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZDZNoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZDZNoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZDZNoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:44:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZDZNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:44:08 -0400
Date: Sun, 26 Apr 2009 09:44:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] tracing: increase size of number of possible
 events
In-Reply-To: <49F404E4.6040907@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904260919370.24293@gandalf.stny.rr.com>
References: <20090424043005.338878133@goodmis.org> <20090424043111.983189535@goodmis.org> <49F15607.1090707@cn.fujitsu.com> <alpine.DEB.2.00.0904241004000.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904241004490.24293@gandalf.stny.rr.com>
 <49F404E4.6040907@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Li,


On Sun, 26 Apr 2009, Li Zefan wrote:

> Steven Rostedt wrote:
> > On Fri, 24 Apr 2009, Steven Rostedt wrote:
> > 
> >> On Fri, 24 Apr 2009, Li Zefan wrote:
> >>> console 1:
> >>>  # cat /debug/tracing/trace_pipe
> >>>
> >>> console 2:
> >>> while (1) {
> >>> 	insmod trace-events-sample.ko
> >>> 	echo foo_bar > /debug/tracing/set_event
> >>> 	rmmod trace-events-sample.ko
> >>> }
> >>>
> >>> I got this immediately:
> >>>
> >>> BUG: unable to handle kernel NULL pointer dereference at 0000006f
> >>> IP: [<c05210f3>] bstr_printf+0x2ce/0x302
> >>> ...
> >>> Call Trace:
> >>>  [<c0476d12>] ? trace_seq_bprintf+0x28/0x41
> >>>  [<c0477569>] ? trace_bprint_print+0x58/0x6c
> >>>  [<c0472ffc>] ? print_trace_line+0x2c5/0x2df
> >>>  [<c0428a41>] ? sub_preempt_count+0x85/0xa0
> >>>  [<c04758cf>] ? tracing_read_pipe+0x118/0x191
> >>>  [<c04757b7>] ? tracing_read_pipe+0x0/0x191
> >>>  [<c04b09f9>] ? vfs_read+0x8f/0x136
> >>>  [<c04b0da3>] ? sys_read+0x40/0x65
> >>>  [<c0402a68>] ? sysenter_do_call+0x12/0x36
> >>>
> >>> (We can even get other crashes..)
> >>>
> >> Can you send me your full bootlog and config. I'm not able to reproduce 
> >> this.
> > 
> > And the SHA1 of the HEAD of the git repo you are using.
> > 
> > Thanks,
> > 
> 
> the HEAD: 9ce5424d75e56891905b77d1589924765e62059a + this patch
> 
> (I commented out "hi" from the sample module)

I found that commenting out the "hi" too helped in causing races.

> 
> I think it's because "type" is wrapped back to 0. I changed the test script
> like this:
> 
> while (foo_bar.id < 65536)
> {
> 	insmod trace-events-sample.ko
> 	rmmod trace-events-sample.ko
> }
> 
> for ((; ;))
> {
>         insmod /home/lizf/linux-2.6-tip/samples/trace_events/*.ko
>         echo trace-events-sample:foo_bar > /mnt/tracing/set_event
>         sleep 1
>         cat /mnt/tracing/trace
>         rmmod /home/lizf/linux-2.6-tip/samples/trace_events/*.ko
> }
> 

Could you try my git repo with my latest changes?

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

 branch: rfc/debugfs

Thanks,

-- Steve

