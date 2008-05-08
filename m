Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbYEHLXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbYEHLXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYEHLXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:23:16 -0400
Received: from laney.dpool.org ([78.47.134.123]:3864 "EHLO mail1.s.dpool.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYEHLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:23:15 -0400
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 07:23:15 EDT
Message-ID: <4822DDF1.5010500@elsdoerfer.info>
Date: Thu, 08 May 2008 13:03:13 +0200
From: =?ISO-8859-1?Q?Michael_Elsd=F6rfer?= <michael@elsdoerfer.info>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Cannot boot any HIGHMEM kernel (kernel panic - not syncing)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an etch server machine with 3GB of RAM, and I seem unable to
boot into any kernel (precompiled images from the Debian and OpenVZ 
repositories, I have so far avoided to compile one myself) that has 
HIGHMEM enabled, i.e.:

zoidberg:/# dmesg | head
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.

Specifically, the only kernel image that seems to work is
linux-image-2.6.18-6-486 (or the OpenVZ version fzakernel-2.6.18-486)

Everything else seems to fail with:

Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: PCI Root Bridge [PCI0] (0000:00)
CPU 0: Machine Check Exception: 0000000000000007
Bank 3: b40000000000083b at 000000fdfc000cfc
Kernel panic - not syncing: Unable to continue

Specifically, I tried at least the following images from the Debian and
OpenVZ repositories:

config-2.6.18-openvz-k7
linux-image-2.6.18-6-686
fzakernel-2.6.18-686
fzakernel-2.6.18-686-bigmem

Now, Machine Check Exception seems to point towards a hardware error,
but not only does the 486 kernel appear to work flawlessly, the server
was perfectly happy running a self-compiled sarge kernel (with HIGHMEM)
just a couple of days ago.

Here's the processor info:

zoidberg:/boot# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 244
stepping        : 10
cpu MHz         : 1794.546
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm
3dnowext 3dnow ts fid vid ttp
bogomips        : 3591.45

Does anybody know what the issue might be, e.g. what exactly in the 
non-486 kernels might cause the error?

Thanks,

Michael
