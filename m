Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961Ab0AWBVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0AWBVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0AWBVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:21:18 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54373 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0AWBVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=IkRVmWP+FtPufLAq6Gc/RbjitJk+VktQ0fJnGsplFDUvvyQYf5NMaxcE/p+iX00bP5
         /Gn+DO5chqtvFLWoSbHBU1LuJRYmw2JpgTT8NZbIoAIR0oMLIBos4UEgD1gRVAI4pIFT
         +r88HDZmKXYcQop+TlSYEjjWTZT1eOq+YrMBM=
MIME-Version: 1.0
Date: Sat, 23 Jan 2010 12:21:14 +1100
Message-ID: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com>
Subject: [REGRESSION] clockevents patch causes hang on power off
From: Nathan Williams <ngwilliams@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having trouble with my PC crashing just as it's attempting to power off.
I managed to git bisect to this commit:

clockevents: Prevent clockevent_devices list corruption on cpu hotplug
bb6eddf7676e1c1f3e637aa93c5224488d99036f

http://patchwork.kernel.org/patch/71157/

I've tested with 2.6.33-rc5 with and without this patch to confirm
everything works when I revert the patch.

I managed to copy down some of the output, but if need be I can try
hooking up the serial port.

Call Trace:
? hrtimer_cpu_notify+0x8a/0x152
? timer_cpu_notify+0x224/0x23b
notifier_call_chain+0x2b/0x4a
raw_notifier_call_chain+0xc/0xe
_cpu_down+0x16d/0x237
disable_nonboot_cpus+0x5f/0xe6
kernel_power_off+0x1d/0x34
sys_reboot+0xf2/0x150
sched_clock_local+0x17/0x104
set_next_entity+0x31/0x9c
finish_task_switch+0x33/0x68
schedule+0x76a/0x7b8
mntput_no_expire+0x19/0xb3
filp_close+0x51/0x5b
sysenter_do_call+0x12/0x22

EIP: clockevents_notify+0x97/0xd7 SS:ESP 0068:f6737de8

In case /proc/cpuinfo is useful, I've included that below:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping	: 9
cpu MHz		: 2793.365
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid
xtpr
bogomips	: 5586.73
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping	: 9
cpu MHz		: 2793.365
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid
xtpr
bogomips	: 5584.85
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

Regards,
Nathan
