Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0BTBeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:34:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33645 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab0BTBeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:34:20 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=Xjkw-1Tqs455y-exlzIA:9 a=6CWm8o_R27Xwtm1ApL2L_Eng4lIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: ftrace faulted on writing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jack Steiner <steiner@sgi.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100219223642.GA24993@sgi.com>
References: <20100219223642.GA24993@sgi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 19 Feb 2010 20:34:17 -0500
Message-ID: <1266629657.24271.719.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 16:36 -0600, Jack Steiner wrote:
> Is this a known problem???

No it's not known, but the cause is because some kernel stayed as write
only. There have been issues with this in the past. What kernel is this
exactly? a 32 distro beta doesn't help. Is it 32 with kernel patches?
perhaps one of the patches caused this.


> 
> This is from a 2.6.32 distro beta kernel running on a nehalem processor (SGI UV system):
> 
> 
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477841] WARNING: at kernel/trace/ftrace.c:1007 ftrace_bug+0x264/0x2a0()
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477844] Hardware name: Stoutland Platform
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477846] Modules linked in: autofs4 binfmt_misc microcode fuse dm_mod
>    						   pcspkr iTCO_wdt sg ioatdma iTCO_vendor_support button i2c_i801 dca
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477861] Pid: 12438, comm: kstop/0 Not tainted 2.6.32.7-jfs-static-sles11-sp1 #11
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477866] Call Trace:
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477874]  [<ffffffff810bed94>] ? ftrace_bug+0x264/0x2a0
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477885]  [<ffffffff81055410>] warn_slowpath_common+0x80/0xd0
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477904]  [<ffffffff810001a4>] ? _stext+0xc/0x18
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477908]  [<ffffffff81055474>] warn_slowpath_null+0x14/0x20
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477912]  [<ffffffff810bed94>] ftrace_bug+0x264/0x2a0
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477917]  [<ffffffff810bef10>] ftrace_replace_code+0x140/0x1b0
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477929]  [<ffffffff810a48b0>] ? stop_cpu+0x0/0x100
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477933]  [<ffffffff810bf00a>] __ftrace_modify_code+0x8a/0x90
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477938]  [<ffffffff810a4959>] stop_cpu+0xa9/0x100
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477950]  [<ffffffff8106ef43>] worker_thread+0x183/0x260
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477958]  [<ffffffff81073900>] ? autoremove_wake_function+0x0/0x40
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477963]  [<ffffffff8106edc0>] ? worker_thread+0x0/0x260
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477967]  [<ffffffff81073546>] kthread+0x96/0xb0
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477973]  [<ffffffff8100407a>] child_rip+0xa/0x20
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477977]  [<ffffffff810734b0>] ? kthread+0x0/0xb0
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477981]  [<ffffffff81004070>] ? child_rip+0x0/0x20
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477985] ---[ end trace 3058770ec83b6e0e ]---
>    Feb 19 10:30:49 uv17-sys kernel: [  157.477988] ftrace faulted on writing [<ffffffff810001a4>] _stext+0xc/0x18

Can you disassemble that to see what funcion this is?

  objdump -dr --start-addr 0xffffffff81000000

Thanks,

-- Steve

> 
> It occurs right after:
> 	# export DB="/sys/kernel/debug/tracing"
> 	# echo 1 >/proc/sys/kernel/ftrace_enabled
> 	# echo function > $DB/current_tracer
> 
> 
> --- jack


