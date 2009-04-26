Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbZDZKaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbZDZKaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZDZK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:29:56 -0400
Received: from bar.sig21.net ([80.81.252.164]:55070 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZDZK3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:29:55 -0400
X-Greylist: delayed 2311 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 06:29:55 EDT
Date: Sun, 26 Apr 2009 11:51:21 +0200
From: Martin Mueller <mm@sig21.net>
To: linux-kernel@vger.kernel.org
Subject: Kernel locks up when idle on VIA-nano U2300 with VIA VX800 on
	Jetway JNF76-N1GL-LF mainboard
Message-ID: <20090426095121.GS26701@catull.sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-21-Score: -1.5 (-)
X-Spam-21-Report: No, score=-1.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.287,BAYES_50=0.001 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

last Thursday my mini-ITX board in my home-server died and I had to
get a replacement board. I got an fanless Jetway JNF76-N1GL-LF from a
local Dealer. The board uses a 1GHz U2300 VIA-nano CPU[1] and an VIA
VX800 chipset. After replacing the board, the adventure actually
started:

Booting my installed debian with kernel 2.6.29-1-686 (debian kernel) failed.
The system just hang when detecting the harddisks during the boot
process, no oops, no messages, just no reaction any more. 

Fortunatelly I had an old 2.6.23-1-686 (debian kernel) still hanging around
in the grub menu. This kernel works flawlessly on the board (aside
from not recognizing the VIA HD-audio, which doesn't bother me at the
moment).

Next, I downloaded linux-2.6.30-rc3, compiled a minimal version with
just initrd. I left out PCI-support, ACPI and almost everything else
menuconfig allowed me to unselect except the VGA text console. This
kernel locked up after giving me the initial prompt from busybox in
the initrd.

When adding the following lines in the script executed by the kernel
after booting in the initrd, the system actually works:

  while true; do true; done &
  /bin/sh

As soon as I kill the shell loop, the system freezes again.

So my conclusion is: the kernel locks up the first time the CPU
is idle.

Any hints on how to proceed from here?

Thanks.

bye 
  MM


[1] cato:~# cat /proc/cpuinfo 
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 15
model name      : VIA Nano processor U2300@1000MHz
stepping        : 2
cpu MHz         : 997.535
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm syscall nx fxsr_opt rdtscp lm up pni monitor vmx est tm2 ssse3 cx16 xtpr rng rng_en ace ace_en ace2 phe phe_en lahf_lm
bogomips        : 1996.78
clflush size    : 64
 
