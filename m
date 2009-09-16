Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZIPPna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZIPPna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZIPPn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:43:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZIPPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:43:27 -0400
Subject: Re: [PATCH tracing/kprobes 2/6] ftrace: Fix trace_add_event_call()
 to initialize list take 2
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <4AB1077F.6020107@redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090914204904.18779.59422.stgit@dhcp-100-2-132.bos.redhat.com>
	 <1253058681.20020.147.camel@gandalf.stny.rr.com>
	 <4AB0F366.6080000@redhat.com>
	 <1253111371.20020.198.camel@gandalf.stny.rr.com>
	 <4AB1077F.6020107@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 11:43:28 -0400
Message-Id: <1253115808.20020.199.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 11:42 -0400, Masami Hiramatsu wrote:

> Oh, I see, I misunderstood. Thank you for pointing it out. :)
> Here, I updated the patch.

Thanks!

Acked-by: Steven Rostedt <rostedt@goodmis.org> for the whole series.

-- Steve

> 
> ---
> ftrace: Fix trace_add_event_call() to initialize list
> 
> From: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Handle failuer path in trace_add_event_call() for fixing below bug
> which occurred when I tried to add invalid event twice.
> 
> Could not create debugfs 'kmalloc' directory
> Failed to register kprobe event: kmalloc
> Faild to register probe event(-1)
> ------------[ cut here ]------------
> WARNING: at /home/mhiramat/ksrc/random-tracing/lib/list_debug.c:26
> __list_add+0x27/0x5c()
> Hardware name:
> list_add corruption. next->prev should be prev (c07d78cc), but was
> 00001000. (next=d854236c).
> Modules linked in: sunrpc uinput virtio_net virtio_balloon i2c_piix4 pcspkr
> i2c_core virtio_blk virtio_pci virtio_ring virtio [last unloaded:
> scsi_wait_scan]
> Pid: 1394, comm: tee Not tainted 2.6.31-rc9 #51
> Call Trace:
>  [<c0438424>] warn_slowpath_common+0x65/0x7c
>  [<c05371b3>] ? __list_add+0x27/0x5c
>  [<c043846f>] warn_slowpath_fmt+0x24/0x27
>  [<c05371b3>] __list_add+0x27/0x5c
>  [<c047f050>] list_add+0xa/0xc
>  [<c047f8f5>] trace_add_event_call+0x60/0x97
>  [<c0483133>] command_trace_probe+0x42c/0x51b
>  [<c044a1b3>] ? remove_wait_queue+0x22/0x27
>  [<c042a9c0>] ? __wake_up+0x32/0x3b
>  [<c04832f6>] probes_write+0xd4/0x10a
>  [<c0483222>] ? probes_write+0x0/0x10a
>  [<c04b27a9>] vfs_write+0x80/0xdf
>  [<c04b289c>] sys_write+0x3b/0x5d
>  [<c0670d41>] syscall_call+0x7/0xb
> ---[ end trace 2b962b5dc1fdc07d ]---
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>


