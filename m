Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYIZUXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYIZUXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYIZUW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:22:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYIZUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:22:56 -0400
Date: Fri, 26 Sep 2008 16:22:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Travis <travis@sgi.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: num_possible_cpus() giving more than possible.
Message-ID: <alpine.DEB.1.10.0809261613070.21618@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mike,

Peter told me that I should report this to you. I have two socket
single core hyper threaded box (must be hell). Peter told me that the 
num_possible_cpus() should return the number possible on this box. The 
explanation of my box tells us it should be 4. But it in fact returns 8.

nr_cpu_ids also returns 8.

here's the /proc/cpuinfo:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	:                   Intel(R) Xeon(TM) CPU 2.80GHz
stepping	: 1
cpu MHz		: 2793.151
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 3
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
lm constant_tsc pebs bts nopl pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5586.30
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	:                   Intel(R) Xeon(TM) CPU 2.80GHz
stepping	: 1
cpu MHz		: 2793.151
cache size	: 1024 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 3
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
lm constant_tsc pebs bts nopl pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5586.20
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	:                   Intel(R) Xeon(TM) CPU 2.80GHz
stepping	: 1
cpu MHz		: 2793.151
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 3
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
lm constant_tsc pebs bts nopl pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5586.23
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	:                   Intel(R) Xeon(TM) CPU 2.80GHz
stepping	: 1
cpu MHz		: 2793.151
cache size	: 1024 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 3
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
lm constant_tsc pebs bts nopl pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5586.27
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:


Perhaps since my physical ids show 0 and 3, it thinks it can also have 
a 1 and 2?

Thanks,

-- Steve



