Return-Path: <linux-kernel-owner+w=401wt.eu-S937922AbZAPW1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937922AbZAPW1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760285AbZAPW13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:27:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60968 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759857AbZAPW11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:27:27 -0500
Subject: WARNING: at kernel/trace/ftrace.c:434 ftrace_bug+0xdb/0x2b1() in
 2.6.29-rc1-next-20090116
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Fri, 16 Jan 2009 17:27:23 -0500
Message-Id: <1232144843.6614.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 2.6.29-rc1-next-20090116 on vmware server x86_64 I see this at
boot up.  Doesn't appear to cause any problem, no idea what kind of
thermal problem this is causing me on my VM  :)

The last linux-next kernel I ran was 2.6.29-rc1-next-20090114 and I do
not remember seeing this.  But me not remembering doesn't mean it wasn't
there.....

Any information I can collect or what I can do just let me know.

-Eric

[    0.036825] ACPI: Core revision 20081204
[    0.098568] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.099101] ftrace: allocating 21076 entries in 166 pages
[    0.105983] ------------[ cut here ]------------
[    0.105983] WARNING: at kernel/trace/ftrace.c:434 ftrace_bug+0xdb/0x2b1()
[    0.105983] Hardware name: VMware Virtual Platform
[    0.105983] Modules linked in:
[    0.105983] Pid: 0, comm: swapper Not tainted 2.6.29-rc1-next-20090116 #252
[    0.105983] Call Trace:
[    0.105983]  [<ffffffff810515bc>] warn_slowpath+0xd8/0xf7
[    0.105983]  [<ffffffff8101562d>] ? dump_trace+0x26b/0x27a
[    0.105983]  [<ffffffff810763c7>] ? find_usage_backwards+0x2c/0xf2
[    0.105983]  [<ffffffff810777e0>] ? check_usage_backwards+0x2e/0x52
[    0.105983]  [<ffffffff810762d0>] ? graph_unlock+0x6b/0x77
[    0.105983]  [<ffffffff81077d33>] ? mark_lock+0x34b/0x35b
[    0.105983]  [<ffffffff81077d95>] ? mark_held_locks+0x52/0x72
[    0.105983]  [<ffffffff813ba274>] ? __mutex_lock_common+0x41a/0x43f
[    0.105983]  [<ffffffff81018e63>] ? sched_clock+0x9/0xc
[    0.105983]  [<ffffffff810bc8ab>] ? pagefault_enable+0x9/0x1a
[    0.105983]  [<ffffffff810bc90a>] ? probe_kernel_write+0x4e/0x74
[    0.105983]  [<ffffffff810bc8ab>] ? pagefault_enable+0x9/0x1a
[    0.105983]  [<ffffffff810bc97e>] ? probe_kernel_read+0x4e/0x78
[    0.105983]  [<ffffffff8122346e>] ? acpi_thermal_notify+0x7/0xc1
[    0.105983]  [<ffffffff81029a9f>] ? ftrace_modify_code+0x46/0x75
[    0.105983]  [<ffffffff8122346e>] ? acpi_thermal_notify+0x7/0xc1
[    0.105983]  [<ffffffff810aaecb>] ftrace_bug+0xdb/0x2b1
[    0.105983]  [<ffffffff8122346e>] ? acpi_thermal_notify+0x7/0xc1
[    0.105983]  [<ffffffff810acc10>] ftrace_convert_nops+0x23d/0x2da
[    0.105983]  [<ffffffff81713fd3>] ftrace_init+0x116/0x121
[    0.105983]  [<ffffffff81213a84>] ? acpi_enable_subsystem+0x3c/0x90
[    0.105983]  [<ffffffff816f5d99>] start_kernel+0x40e/0x41e
[    0.105983]  [<ffffffff816f5140>] ? early_idt_handler+0x0/0x71
[    0.105983]  [<ffffffff816f52c3>] x86_64_start_reservations+0xae/0xb2
[    0.105983]  [<ffffffff816f53d3>] x86_64_start_kernel+0xe9/0xf4
[    0.105983] ---[ end trace a7919e7f17c0a725 ]---
[    0.105983] ftrace failed to modify [<ffffffff8122346e>] acpi_thermal_notify+0x7/0xc1
[    0.105983]  actual: 0f:1f:44:00:00


