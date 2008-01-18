Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbYARK1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbYARK1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYARK11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:27:27 -0500
Received: from www.tglx.de ([62.245.132.106]:56756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066AbYARK10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:27:26 -0500
Date: Fri, 18 Jan 2008 11:26:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Paprocki <andrew@ishiboo.com>
cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       clemens@ladisch.de, venkatesh.pallipadi@intel.com, bob.picco@hp.com
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
In-Reply-To: <76366b180801161139o24599152obb01cd6e9cc6148@mail.gmail.com>
Message-ID: <alpine.LFD.0.99999.0801181111430.4642@localhost.localdomain>
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>  <20080113120337.GA5548@linux.vnet.ibm.com>  <76366b180801130510w2af714fevf03f59164f90806f@mail.gmail.com>  <20080113140620.GA22507@linux.vnet.ibm.com> 
 <alpine.LFD.0.99999.0801161458470.3764@localhost.localdomain>  <alpine.LFD.0.99999.0801161524250.3764@localhost.localdomain>  <alpine.LFD.0.99999.0801161618380.3764@localhost.localdomain> <76366b180801161139o24599152obb01cd6e9cc6148@mail.gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Andrew Paprocki wrote:

> I applied the patch and I am still locking up after
> Time: hpet clocksource has been installed.

That was expected :)
 
> I rebooted with "clocksource=tsc" to get the logs of the trace which
> was added. I'm assuming the grep below gets all the interesting parts.
> I enabled the HPET character device as mentioned before, which is why
> the hpet0 lines appear now.
> 
> # dmesg | egrep -i "(hpet|time|clock)"
> ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
> ATI board detected. Disabling timer routing over 8254.
> ACPI: PM-Timer IO Port: 0x4008
> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> Kernel command line: vga=0x31a root=/dev/sda1 ro clocksource=tsc
> HPET check: t1=5 t2=1139 s=56226339975 n=56226539985

Ok, the counter works when we initialize the HPET.

t2-t1 = 1134 ticks ~= 79us
s-n = 200010 ~= 2525MHz --> That should be the frequency of your CPU.

> Jan 16 14:44:43 am2 kernel: Call Trace:
> Jan 16 14:44:48 am2 kernel:  [<c01371be>] enqueue_hrtimer+0xd7/0xe2
> Jan 16 14:44:48 am2 kernel:  [<c0137803>] hrtimer_start+0xe8/0xf4
> Jan 16 14:44:48 am2 kernel:  [<c03ac8d3>] do_nanosleep+0x48/0x73
> Jan 16 14:44:48 am2 kernel:  [<c03ac932>] hrtimer_nanosleep_restart+0x34/0xa1
> Jan 16 14:44:48 am2 kernel:  [<c013735d>] hrtimer_wakeup+0x0/0x18
> Jan 16 14:44:48 am2 kernel:  [<c012e837>] sys_restart_syscall+0xe/0xf
> Jan 16 14:44:48 am2 kernel:  [<c0103d0a>] sysenter_past_esp+0x5f/0x85

When the system is hung, can you please hit SysRq-Q wait a bit and hit
SysRq-Q again. Please provide the output.

Thanks,
	tglx
