Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0CHOyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:54:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0CHOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:54:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=drjUTJznMZEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=4g2zt8FA4mbU2Yk3Tz4A:9 a=AyRgXyd55YE23ay2Ou4A:7 a=PQ8Hz-HqeUvbbm97o2IPor733aYA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B94936B.8030409@cn.fujitsu.com>
References: <4B94936B.8030409@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 09:54:18 -0500
Message-ID: <1268060058.10871.1796.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 14:04 +0800, Li Zefan wrote:
> While running a ftrace test, a kernel warning showed up. The bug is not so
> easy to reproduce, normally it takes 30 mins to 2 hours.

What test are you running? Can you share it?

> 
> After revering 3c05d7482777f15e71bb4cb1ba78dee2800dfec6, I ran the test
> for 15 hours, and the bug seems disapeared.

So basically, you are reading both the trace and trace_pipe (or
trace_pipe_raw) at the same time?

-- Steve

> 
> ------------[ cut here ]------------
> WARNING: at kernel/trace/ring_buffer.c:3420 ring_buffer_reset_cpu+0x5a/0x9c()
> Hardware name: PRIMERGY                      
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat bridge stp llc deflate zlib_deflate ctr camellia cast5 rmd160 crypto_null ccm serpent blowfish twofish_x86_64 twofish_common ecb xcbc cbc sha256_generic sha512_generic des_generic cryptd aes_x86_64 aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_beet ipcomp ipcomp6 xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_multipath uinput i5k_amb hwmon e1000e i5000_edac edac_core iTCO_wdt iTCO_vendor_support shpchp i2c_i801 i2c_core serio_raw pcspkr pata_acpi ata_generic mptsas mptscsih ata_piix mptbase scsi_transport_sas dm_mod [last unloaded: speedstep_lib]
> Pid: 2108, comm: ftrace_current_ Tainted: G        W  2.6.33-tip+ #2
> Call Trace:
>  [<ffffffff8104ebd0>] warn_slowpath_common+0x7c/0x94
>  [<ffffffff8104ebfc>] warn_slowpath_null+0x14/0x16
>  [<ffffffff810a50f5>] ring_buffer_reset_cpu+0x5a/0x9c
>  [<ffffffff810aa3f0>] tracing_reset_online_cpus+0x4a/0x79
>  [<ffffffff810aa434>] tracer_init+0x15/0x20
>  [<ffffffff810aa601>] tracing_set_tracer+0x1c2/0x1e7
>  [<ffffffff810d9847>] ? might_fault+0x5c/0xac
>  [<ffffffff810aa6b2>] tracing_set_trace_write+0x8c/0xbc
>  [<ffffffff810a8e79>] ? trace_buffer_lock_reserve+0x21/0x56
>  [<ffffffff810a95ce>] ? trace_current_buffer_lock_reserve+0x16/0x18
>  [<ffffffff813ef135>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff81104618>] vfs_write+0xae/0x10b
>  [<ffffffff81104735>] sys_write+0x4a/0x6e
>  [<ffffffff81009da6>] tracesys+0xd0/0xd5
> ---[ end trace f7002f0890d5b023 ]---


