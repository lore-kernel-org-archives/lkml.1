Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbYDSWmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbYDSWmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYDSWmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:42:16 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:52903 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYDSWmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:42:15 -0400
Date: Sun, 20 Apr 2008 01:42:06 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Check for breakpoint in text_poke to eliminate bug_on
Message-ID: <20080420014206.5cd61d4a@daedalus.pq.iki.fi>
In-Reply-To: <20080419215826.GC2831@Krystal>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
	<20080413230552.33ca587a@daedalus.pq.iki.fi>
	<20080414065713.GB16163@elte.hu>
	<20080419184137.79957a07@daedalus.pq.iki.fi>
	<20080419161956.GA24685@Krystal>
	<20080420000657.20ba6b4b@daedalus.pq.iki.fi>
	<20080420005208.12ad32fd@daedalus.pq.iki.fi>
	<20080419215826.GC2831@Krystal>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 17:58:26 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Pekka Paalanen (pq@iki.fi) wrote:
> > 
> > A simple
> > echo 0 > /sys/devices/system/cpu/cpu1/online
> > echo 1 > /sys/devices/system/cpu/cpu1/online
> > 
> > produces the following kernel log (netconsole) and then after a couple
> > second hang the machine reboots:
> > 
> > [   84.678357] console [netcon0] enabled
> > [   84.679568] netconsole: network logging started
> > [  232.812335] CPU 1 is now offline
> > [  232.812678] lockdep: fixing up alternatives.
> > [  232.813051] SMP alternatives: switching to UP code
> > [  268.447582] lockdep: fixing up alternatives.
> > [  268.447903] SMP alternatives: switching to SMP code
> > [  268.459462] Booting processor 1/1 ip 6000
> > 
> > My kernel is sched-devel/latest git tree with Desnoyers' patch, and my
> > patches that touch only arch/x86/mm/mmio-mod.c.
> > The machine is Thinkpad T61 with:
> > 
> > processor	: 0
> > vendor_id	: GenuineIntel
> > cpu family	: 6
> > model		: 15
> > model name	: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
> > stepping	: 10
> > cpu MHz		: 2001.000
> > cache size	: 4096 KB
> > physical id	: 0
> > siblings	: 2
> > core id		: 0
> > cpu cores	: 2
> > apicid		: 0
> > initial apicid	: 0
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 10
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> > cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> > lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
> > tm2 ssse3 cx16 xtpr lahf_lm ida
> > bogomips	: 3997.03
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 36 bits physical, 48 bits virtual
> > power management:
> > 
> > processor	: 1
> > vendor_id	: GenuineIntel
> > cpu family	: 6
> > model		: 15
> > model name	: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
> > stepping	: 10
> > cpu MHz		: 2001.000
> > cache size	: 4096 KB
> > physical id	: 0
> > siblings	: 2
> > core id		: 1
> > cpu cores	: 2
> > apicid		: 1
> > initial apicid	: 1
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 10
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> > cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> > lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
> > tm2 ssse3 cx16 xtpr lahf_lm ida
> > bogomips	: 3991.26
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 36 bits physical, 48 bits virtual
> > power management:
> > 
> > Any help would be appreciated.
> > 
> > 
> > Thanks.
> 
> This patch should bring more consistency checks to text_poke, can you
> give it a try ?
> 
> Hm, actually, I think it contains the fix you are looking for.
> 
> kernel_text_address -> core_kernel_text will probably make everything go
> smoothly.
> 
> Mathieu
> 
> 
> Check for breakpoint in text_poke to eliminate bug_on
> 
> It's ok to modify an instruction non-atomically (multiple memory accesses to a
> large and/or non aligned instruction) *if and only if* we have inserted a
> breakpoint at the beginning of the instruction.
> 
> Also change kernel_text_address (bogus) check to core_kernel_text.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/x86/kernel/alternative.c |   49 ++++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)

Sorry, no change.

[   93.315242] netconsole: network logging started
[   95.797496] eth0: no IPv6 routers present
[  127.472213] CPU 1 is now offline
[  127.472547] lockdep: fixing up alternatives.
[  127.472923] SMP alternatives: switching to UP code
[  134.709384] lockdep: fixing up alternatives.
[  134.709701] SMP alternatives: switching to SMP code
[  134.721344] Booting processor 1/1 ip 6000

few seconds pause and it reboots. A working patch in six minutes would
have been quite awesome :-)


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
