Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZJMM5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZJMM5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZJMM5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:57:41 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61231 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbZJMM5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:57:40 -0400
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091007155142.GB6743@linux.vnet.ibm.com>
	<200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
	<1255005738.6715.6.camel@pc1117.cambridge.arm.com>
	<200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	<1255435201.9987.22.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1255435201.9987.22.camel@pc1117.cambridge.arm.com>
Message-Id: <200910132157.FDF13518.OQHLtVFFJMSFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 13 Oct 2009 21:57:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> Could you send me your .config file and I'll try to reproduce this as
> well?
Yes. It is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.32-rc3 .
Above log is obtained using Debian Sarge.

Below log is obtained using CentOS 5.
Adding "kmemleak=off" in CentOS 5 avoids this error.
Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.32-rc4-centos5.txt .

[    0.000000] Linux version 2.6.32-rc4 (root@tomoyo) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-44)) #2 SMP Tue Oct 13 20:23:13 JST 2009
(...snipped...)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/lockdep.c:3161 check_flags+0xf1/0x180()
[    0.000000] Hardware name: VMware Virtual Platform
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32-rc4 #2
[    0.000000] Call Trace:
[    0.000000]  [<c1064cc1>] ? check_flags+0xf1/0x180
[    0.000000] BUG: unable to handle kernel paging request at 54205ab1
[    0.000000] IP: [<c1006e88>] print_context_stack+0x58/0xe0
[    0.000000] *pde = 00000000 
[    0.000000] Thread overran stack, or stack corrupted
[    0.000000] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] last sysfs file: 
[    0.000000] Modules linked in:
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted (2.6.32-rc4 #2) VMware Virtual Platform
[    0.000000] EIP: 0060:[<c1006e88>] EFLAGS: 00010016 CPU: 0
[    0.000000] EIP is at print_context_stack+0x58/0xe0
[    0.000000] EAX: c1421000 EBX: c1421fb0 ECX: c103c7f5 EDX: 54204649
[    0.000000] ESI: c1064cc1 EDI: c131d6e0 EBP: c1421f24 ESP: c1421f10
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] Process swapper (pid: 0, ti=c1421000 task=c146ff60 task.ti=c145d000)
[    0.000000] Stack:
[    0.000000]  c1421fb8 c1421000 c1421000 c1421fac c1421fb8 c1421f50 c1005e76 c131d6e0
[    0.000000] <0> c13d29de 00000000 c1421f40 c1421f50 00000000 c13d29de c1421fac 00000000
[    0.000000] <0> c1421f74 c1006dac c1421fb8 c131d6e0 c13d29de 00000000 c1421fb8 c1421fb8
[    0.000000] Call Trace:
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000] BUG: unable to handle kernel paging request at 54205ab1
[    0.000000] IP: [<c1006e88>] print_context_stack+0x58/0xe0
[    0.000000] *pde = 00000000 
[    0.000000] Thread overran stack, or stack corrupted
[    0.000000] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[    0.000000] last sysfs file: 
[    0.000000] Modules linked in:
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted (2.6.32-rc4 #2) VMware Virtual Platform
[    0.000000] EIP: 0060:[<c1006e88>] EFLAGS: 00010006 CPU: 0
[    0.000000] EIP is at print_context_stack+0x58/0xe0
[    0.000000] EAX: c1421000 EBX: c1421f28 ECX: c103c7f5 EDX: 54204649
[    0.000000] ESI: c1005e76 EDI: c131d6e0 EBP: c1421d64 ESP: c1421d50
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] Process swapper (pid: 0, ti=c1421000 task=c146ff60 task.ti=c145d000)
[    0.000000] Stack:
[    0.000000]  c1421d90 c1421000 c1421000 c1421f10 c1421d90 c1421d90 c1005e76 c131d6e0
[    0.000000] <0> c13d34df 00000000 c1421d80 c1421d90 00000000 c13d34df c1421f10 c1421ed4
[    0.000000] <0> c1421db4 c1006dac 00000000 c131d6e0 c13d34df 00000000 c1421f73 00000018
[    0.000000] Call Trace:
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
(...snipped...)
[    0.000000] Thread overran stack, or stack corrupted
[    0.000000] Oops: 0000 [#8] SMP DEBUG_PAGEALLOC
[    0.000000] last sysfs file: 
[    0.000000] Modules linked in:
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted (2.6.32-rc4 #2) VMware Virtual Platform
[    0.000000] EIP: 0060:[<c1006e88>] EFLAGS: 00010006 CPU: 0
[    0.000000] EIP is at print_context_stack+0x58/0xe0
[    0.000000] EAX: c1421000 EBX: c14214a8 ECX: c103c7f5 EDX: ffffffff
[    0.000000] ESI: c1005e76 EDI: c131d6e0 EBP: c14212e4 ESP: c14212d0
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] Process swapper (pid: 0, ti=c1421000 task=c146ff60 task.ti=c145d000)
[    0.000000] Stack:
[    0.000000]  c1421310 c1421000 c1421000 c1421490 c1421310 c1421310 c1005e76 c131d6e0
[    0.000000] <0> c13d34df 00000000 c1421300 c1421310 00000000 c13d34df c1421490 c1421454
[    0.000000] <0> c1421334 c1006dac 00000000 c131d6e0 c13d34df 00000000 c14214f3 00000018
[    0.000000] Call Trace:
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1005dc8>] ? show_stack_log_lvl+0xb8/0xe0
[    0.000000]  [<c1005f8a>] ? show_registers+0xca/0x1c0
[    0.000000]  [<c1007121>] ? __die+0xa1/0x100
[    0.000000]  [<c101f5af>] ? no_context+0xff/0x150
[    0.000000]  [<c101f708>] ? __bad_area_nosemaphore+0x58/0x130
[    0.000000]  [<c131abac>] ? _spin_unlock_irqrestore+0x3c/0x60
[    0.000000]  [<c101f887>] ? bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c101fbaf>] ? do_page_fault+0x17f/0x2a0
[    0.000000]  [<c1064cc1>] ? check_flags+0xf1/0x180
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c131b4d3>] ? error_code+0x6b/0x70
[    0.000000]  [<c103c7f5>] ? release_console_sem+0x1c5/0x1f0
[    0.000000]  [<c1064cc1>] ? check_flags+0xf1/0x180
[    0.000000]  [<c101fa30>] ? do_page_fault+0x0/0x2a0
[    0.000000]  [<c1006e88>] ? print_context_stack+0x58/0xe0
[    0.000000]  [<c1005e76>] ? dump_trace+0x86/0xd0
[    0.000000]  [<c1006dac>] ? show_trace_log_lvl+0x4c/0x60
[    0.000000]  [<c1006ddf>] ? show_trace+0x1f/0x30
[    0.000000]  [<c1006f83>] ? dump_stack+0x73/0x80
[    0.000000]  [<c1064cc1>] ? check_flags+0xf1/0x180
[    0.000000]  [<c103ba41>] ? warn_slowpath_common+0x81/0xa0
[    0.000000]  [<c1064cc1>] ? check_flags+0xf1/0x180
[    0.000000]  [<c103ba7a>] ? warn_slowpath_null+0x1a/0x20
[    0.000000]  [<c1064cc1>] ? check_flags+0xf1/0x180
[    0.000000]  [<c106934c>] ? lock_acquire+0x3c/0xf0
[    0.000000]  <IRQ> 
(...snipped...)

Regards.
