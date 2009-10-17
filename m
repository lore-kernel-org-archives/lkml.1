Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZJQKBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZJQKBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZJQKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:01:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:36435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbZJQKBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:01:47 -0400
Date: Sat, 17 Oct 2009 10:01:00 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <4AB1077F.6020107@redhat.com>
References: <4AB1077F.6020107@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] ftrace: Fix trace_add_event_call() to initialize list
Message-ID: <tip-588bebb74fe87270f94c2810652bd683d63c4b54@git.kernel.org>
Git-Commit-ID: 588bebb74fe87270f94c2810652bd683d63c4b54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:01:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  588bebb74fe87270f94c2810652bd683d63c4b54
Gitweb:     http://git.kernel.org/tip/588bebb74fe87270f94c2810652bd683d63c4b54
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 16 Sep 2009 11:42:55 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:03:46 +0200

ftrace: Fix trace_add_event_call() to initialize list

Handle failure path in trace_add_event_call() to fix the below bug
which occurred when I tried to add invalid event twice.

Could not create debugfs 'kmalloc' directory
Failed to register kprobe event: kmalloc
Faild to register probe event(-1)
------------[ cut here ]------------
WARNING: at /home/mhiramat/ksrc/random-tracing/lib/list_debug.c:26
__list_add+0x27/0x5c()
Hardware name:
list_add corruption. next->prev should be prev (c07d78cc), but was
00001000. (next=d854236c).
Modules linked in: sunrpc uinput virtio_net virtio_balloon i2c_piix4 pcspkr
i2c_core virtio_blk virtio_pci virtio_ring virtio [last unloaded:
scsi_wait_scan]
Pid: 1394, comm: tee Not tainted 2.6.31-rc9 #51
Call Trace:
 [<c0438424>] warn_slowpath_common+0x65/0x7c
 [<c05371b3>] ? __list_add+0x27/0x5c
 [<c043846f>] warn_slowpath_fmt+0x24/0x27
 [<c05371b3>] __list_add+0x27/0x5c
 [<c047f050>] list_add+0xa/0xc
 [<c047f8f5>] trace_add_event_call+0x60/0x97
 [<c0483133>] command_trace_probe+0x42c/0x51b
 [<c044a1b3>] ? remove_wait_queue+0x22/0x27
 [<c042a9c0>] ? __wake_up+0x32/0x3b
 [<c04832f6>] probes_write+0xd4/0x10a
 [<c0483222>] ? probes_write+0x0/0x10a
 [<c04b27a9>] vfs_write+0x80/0xdf
 [<c04b289c>] sys_write+0x3b/0x5d
 [<c0670d41>] syscall_call+0x7/0xb
---[ end trace 2b962b5dc1fdc07d ]---

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4AB1077F.6020107@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ba34920..83cc2c0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1010,9 +1010,12 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 		return -ENOENT;
 
 	list_add(&call->list, &ftrace_events);
-	return event_create_dir(call, d_events, &ftrace_event_id_fops,
+	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
 				&ftrace_enable_fops, &ftrace_event_filter_fops,
 				&ftrace_event_format_fops);
+	if (ret < 0)
+		list_del(&call->list);
+	return ret;
 }
 
 /* Add an additional event_call dynamically */
