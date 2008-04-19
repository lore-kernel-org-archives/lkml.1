Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYDSVwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYDSVwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761176AbYDSVwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:52:23 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:47187 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbYDSVwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:52:22 -0400
Date: Sun, 20 Apr 2008 00:52:08 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Paalanen <pq@iki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [BUG] CPU hotplug reboots machine (Re: [PATCH] Fix SMP alternatives
 : use mutex instead of spinlock, text_poke is sleepable)
Message-ID: <20080420005208.12ad32fd@daedalus.pq.iki.fi>
In-Reply-To: <20080420000657.20ba6b4b@daedalus.pq.iki.fi>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
	<20080413230552.33ca587a@daedalus.pq.iki.fi>
	<20080414065713.GB16163@elte.hu>
	<20080419184137.79957a07@daedalus.pq.iki.fi>
	<20080419161956.GA24685@Krystal>
	<20080420000657.20ba6b4b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 00:06:57 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> Mathieu,
> 
> thank you for the quick reply. Your patch did not apply on sched-devel/latest
> so I made the changes by hand, resulting patch here. The change was in the
> context lines, which made `patch' fail, e.g. __FUNCTION__ -> __func__.
> Now my enter_uniprocessor(), that disables all but the first cpu, works fine.
> 
> My next quest is, why attempting to re-enable the cpus makes the whole
> machine reboot after a short hang.

Uhh, I don't have the faintest idea why this happens or how to debug it.

A simple
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online

produces the following kernel log (netconsole) and then after a couple
second hang the machine reboots:

[   84.678357] console [netcon0] enabled
[   84.679568] netconsole: network logging started
[  232.812335] CPU 1 is now offline
[  232.812678] lockdep: fixing up alternatives.
[  232.813051] SMP alternatives: switching to UP code
[  268.447582] lockdep: fixing up alternatives.
[  268.447903] SMP alternatives: switching to SMP code
[  268.459462] Booting processor 1/1 ip 6000

My kernel is sched-devel/latest git tree with Desnoyers' patch, and my
patches that touch only arch/x86/mm/mmio-mod.c.
The machine is Thinkpad T61 with:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping	: 10
cpu MHz		: 2001.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
tm2 ssse3 cx16 xtpr lahf_lm ida
bogomips	: 3997.03
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping	: 10
cpu MHz		: 2001.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
tm2 ssse3 cx16 xtpr lahf_lm ida
bogomips	: 3991.26
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

Any help would be appreciated.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
