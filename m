Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbXHWUWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbXHWUWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXHWUWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:22:16 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:55304 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbXHWUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:22:15 -0400
Date: Thu, 23 Aug 2007 22:21:15 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Tony Luck <tony.luck@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070823222115.122a37ca@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	since commit:

commit 0aa366f351d044703e25c8425e508170e80d83b1
Author: Tony Luck <tony.luck@intel.com>
Date:   Fri Jul 20 11:22:30 2007 -0700

    [IA64] Convert to generic timekeeping/clocksource

    This is a merge of Peter Keilty's initial patch (which was
    revived by Bob Picco) for this with Hidetoshi Seto's fixes
    and scaling improvements.


I have a double "hpet" entry in "available_clocksource":
	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
	tsc hpet hpet acpi_pm jiffies


And, more interesting, if I select hpet as clocksource (tsc is used by
default here) I get an hard freeze some time later (few minutes)...
SysRQ don't work ;)


config & dmesg attached


Motherboard is a Intel DG965SS

CPU:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping	: 6
cpu MHz		: 1864.804
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3731.75
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping	: 6
cpu MHz		: 1864.804
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3729.63
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

-- 
	Paolo Ornati
	Linux 2.6.22-g5bae7ac9 on x86_64
