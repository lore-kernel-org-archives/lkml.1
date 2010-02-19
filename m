Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0BSWgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 17:36:45 -0500
Received: from relay3.sgi.com ([192.48.152.1]:54584 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754980Ab0BSWgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 17:36:44 -0500
Date: Fri, 19 Feb 2010 16:36:42 -0600
From: Jack Steiner <steiner@sgi.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: ftrace faulted on writing
Message-ID: <20100219223642.GA24993@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this a known problem???

This is from a 2.6.32 distro beta kernel running on a nehalem processor (SGI UV system):


   Feb 19 10:30:49 uv17-sys kernel: [  157.477841] WARNING: at kernel/trace/ftrace.c:1007 ftrace_bug+0x264/0x2a0()
   Feb 19 10:30:49 uv17-sys kernel: [  157.477844] Hardware name: Stoutland Platform
   Feb 19 10:30:49 uv17-sys kernel: [  157.477846] Modules linked in: autofs4 binfmt_misc microcode fuse dm_mod
   						   pcspkr iTCO_wdt sg ioatdma iTCO_vendor_support button i2c_i801 dca
   Feb 19 10:30:49 uv17-sys kernel: [  157.477861] Pid: 12438, comm: kstop/0 Not tainted 2.6.32.7-jfs-static-sles11-sp1 #11
   Feb 19 10:30:49 uv17-sys kernel: [  157.477866] Call Trace:
   Feb 19 10:30:49 uv17-sys kernel: [  157.477874]  [<ffffffff810bed94>] ? ftrace_bug+0x264/0x2a0
   Feb 19 10:30:49 uv17-sys kernel: [  157.477885]  [<ffffffff81055410>] warn_slowpath_common+0x80/0xd0
   Feb 19 10:30:49 uv17-sys kernel: [  157.477904]  [<ffffffff810001a4>] ? _stext+0xc/0x18
   Feb 19 10:30:49 uv17-sys kernel: [  157.477908]  [<ffffffff81055474>] warn_slowpath_null+0x14/0x20
   Feb 19 10:30:49 uv17-sys kernel: [  157.477912]  [<ffffffff810bed94>] ftrace_bug+0x264/0x2a0
   Feb 19 10:30:49 uv17-sys kernel: [  157.477917]  [<ffffffff810bef10>] ftrace_replace_code+0x140/0x1b0
   Feb 19 10:30:49 uv17-sys kernel: [  157.477929]  [<ffffffff810a48b0>] ? stop_cpu+0x0/0x100
   Feb 19 10:30:49 uv17-sys kernel: [  157.477933]  [<ffffffff810bf00a>] __ftrace_modify_code+0x8a/0x90
   Feb 19 10:30:49 uv17-sys kernel: [  157.477938]  [<ffffffff810a4959>] stop_cpu+0xa9/0x100
   Feb 19 10:30:49 uv17-sys kernel: [  157.477950]  [<ffffffff8106ef43>] worker_thread+0x183/0x260
   Feb 19 10:30:49 uv17-sys kernel: [  157.477958]  [<ffffffff81073900>] ? autoremove_wake_function+0x0/0x40
   Feb 19 10:30:49 uv17-sys kernel: [  157.477963]  [<ffffffff8106edc0>] ? worker_thread+0x0/0x260
   Feb 19 10:30:49 uv17-sys kernel: [  157.477967]  [<ffffffff81073546>] kthread+0x96/0xb0
   Feb 19 10:30:49 uv17-sys kernel: [  157.477973]  [<ffffffff8100407a>] child_rip+0xa/0x20
   Feb 19 10:30:49 uv17-sys kernel: [  157.477977]  [<ffffffff810734b0>] ? kthread+0x0/0xb0
   Feb 19 10:30:49 uv17-sys kernel: [  157.477981]  [<ffffffff81004070>] ? child_rip+0x0/0x20
   Feb 19 10:30:49 uv17-sys kernel: [  157.477985] ---[ end trace 3058770ec83b6e0e ]---
   Feb 19 10:30:49 uv17-sys kernel: [  157.477988] ftrace faulted on writing [<ffffffff810001a4>] _stext+0xc/0x18

It occurs right after:
	# export DB="/sys/kernel/debug/tracing"
	# echo 1 >/proc/sys/kernel/ftrace_enabled
	# echo function > $DB/current_tracer


--- jack
