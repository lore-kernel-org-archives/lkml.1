Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXC3HgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXC3HgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 03:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXC3HgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 03:36:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:25589 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbXC3HgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 03:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OHei1cqdLjqutVO1eySgiQ9NJzM6h9vzP1T89Qk7xpEZNFfqxwpIpdSxRryWV4LEA0wCpaTc8fuocJSWIBWa5AYLJLB6WjwjAnAvXpCiq2IzFETgm+3RLYrNDQ976caJNq5BoqG6Qcl8HTp8El1Et5Bvsa8L/neibsUeh2op30E=
Message-ID: <ecfa260c0703300036u5d82389apaaa735ba7de5a3bb@mail.gmail.com>
Date: Fri, 30 Mar 2007 03:36:02 -0400
From: Zach <netrek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: spurious kernel error
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed this weird kernel message while looking through
/var/log/ , I have never noticed this error to occur before and below
is the only mention of it I could find in my log files:

netrek:/var/log# grep IRQ7 *
kern.log:Mar 29 23:44:36 netrek kernel: spurious 8259A interrupt: IRQ7.
kernel:Mar 29 23:44:36 netrek kernel: spurious 8259A interrupt: IRQ7.
messages:Mar 29 23:44:36 netrek kernel: spurious 8259A interrupt: IRQ7.
syslog:Mar 29 23:44:36 netrek kernel: spurious 8259A interrupt: IRQ7.

I next looked at output of lspci but as you can see I do not have IRQ7
assigned to anything:

netrek:~# lspci -v
0000:00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX -
82443BX/ZX/DX Host bridge (rev 03)
       Flags: bus master, medium devsel, latency 32
       Memory at f4000000 (32-bit, prefetchable) [size=64M]
       Capabilities: [a0] AGP version 1.0

0000:00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX
AGP bridge (rev 03) (prog-if 00 [Normal decode])
       Flags: bus master, 66MHz, medium devsel, latency 32
       Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
       I/O behind bridge: 0000e000-0000efff
       Memory behind bridge: fd000000-feffffff
       Prefetchable memory behind bridge: f8000000-fbffffff

0000:00:03.0 CardBus bridge: Texas Instruments PCI1420
       Subsystem: Dell Latitude C600
       Flags: bus master, medium devsel, latency 32, IRQ 11
       Memory at 10000000 (32-bit, non-prefetchable) [size=4K]
       Bus: primary=00, secondary=02, subordinate=05, sec-latency=32
       I/O window 0: 00000000-00000003
       I/O window 1: 00000000-00000003
       16-bit legacy interface ports at 0001

0000:00:03.1 CardBus bridge: Texas Instruments PCI1420
       Subsystem: Dell Latitude C600
       Flags: bus master, medium devsel, latency 32, IRQ 11
       Memory at 10001000 (32-bit, non-prefetchable) [size=4K]
       Bus: primary=00, secondary=06, subordinate=09, sec-latency=32
       I/O window 0: 00000000-00000003
       I/O window 1: 00000000-00000003
       16-bit legacy interface ports at 0001

0000:00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
       Flags: bus master, medium devsel, latency 0

0000:00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE
(rev 01) (prog-if 80 [Master])
       Flags: bus master, medium devsel, latency 32
       I/O ports at 0860 [size=16]

0000:00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB
(rev 01) (prog-if 00 [UHCI])
       Flags: bus master, medium devsel, latency 32, IRQ 11
       I/O ports at dce0 [size=32]

0000:00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
       Flags: medium devsel, IRQ 9

0000:00:08.0 Multimedia audio controller: ESS Technology ES1983S
Maestro-3i PCI Audio Accelerator (rev 10)
       Subsystem: Dell Latitude C600
       Flags: bus master, medium devsel, latency 32, IRQ 5
       I/O ports at d800 [size=256]
       Memory at f3ffe000 (32-bit, non-prefetchable) [size=8K]
       Capabilities: [c0] Power Management version 2

0000:00:10.0 Ethernet controller: 3Com Corporation 3c556 Hurricane
CardBus [Cyclone] (rev 10)
       Subsystem: 3Com Corporation: Unknown device 6456
       Flags: bus master, medium devsel, latency 32, IRQ 11
       I/O ports at d400 [size=256]
       Memory at f3ffdc00 (32-bit, non-prefetchable) [size=128]
       Memory at f3ffd800 (32-bit, non-prefetchable) [size=128]
       Expansion ROM at fc000000 [disabled] [size=128K]
       Capabilities: [50] Power Management version 2

0000:00:10.1 Communication controller: 3Com Corporation Mini PCI 56k
Winmodem (rev 10)
       Subsystem: 3Com Corporation: Unknown device 615b
       Flags: bus master, medium devsel, latency 32, IRQ 11
       I/O ports at d000 [size=256]
       Memory at f3ffd400 (32-bit, non-prefetchable) [size=256]
       Memory at f3ffd000 (32-bit, non-prefetchable) [size=128]
       Capabilities: [50] Power Management version 2

0000:01:00.0 VGA compatible controller: ATI Technologies Inc Rage
Mobility M3 AGP 2x (rev 02) (prog-if 00 [VGA])
       Subsystem: Dell Latitude C600
       Flags: bus master, stepping, 66MHz, medium devsel, latency 32, IRQ 11
       Memory at f8000000 (32-bit, prefetchable) [size=64M]
       I/O ports at ec00 [size=256]
       Memory at fdffc000 (32-bit, non-prefetchable) [size=16K]
       Expansion ROM at <unassigned> [disabled] [size=128K]
       Capabilities: [50] AGP version 2.0
       Capabilities: [5c] Power Management version 2

/proc/pci similarly shows no IRQ 7 being assigned in accordance with
the lspci output above:

netrek:~# cat /proc/pci |grep IRQ
     IRQ 11.
     IRQ 11.
     IRQ 11.
     IRQ 9.
     IRQ 5.
     IRQ 11.
     IRQ 11.
     IRQ 11.

My external serial modem (Supre Express 56 Sp) is on /dev/ttyS0 could
this be using IRQ 7? By the way is there a way I can probe/scan my
external modem so I can get information about it too?

My kernel:

netrek:~# uname -a
Linux netrek 2.4.27-2-686 #1 Wed Nov 30 21:55:37 JST 2005 i686 GNU/Linux

I am using the kernel image for Debian testing release (Debian 4.0):

netrek:~# dpkg -l | grep kernel-image-2.4.27
ii  kernel-image-2.4.27-2-686        2.4.27-12
Linux kernel image for version 2.4.27 on PPr

netrek:~# apt-cache show  kernel-image-2.4.27-2-686
Package: kernel-image-2.4.27-2-686
Status: install ok installed
Priority: optional
Section: base
Installed-Size: 31844
Maintainer: Debian Kernel Team <debian-kernel@lists.debian.org>
Architecture: i386
Source: kernel-image-2.4.27-i386
Version: 2.4.27-12
Provides: kernel-image, kernel-image-2.4
Depends: initrd-tools (>= 0.1.48), coreutils | fileutils (>= 4.0),
modutils (>= 2.4.19)
Suggests: lilo (>= 19.1) | grub, fdutils, kernel-doc-2.4.27 |
kernel-source-2.4.27, kernel-pcmcia-modules-2.4.27-2-686 |
pcmcia-modules-2.4.27-2-686
Description: Linux kernel image for version 2.4.27 on PPro/Celeron/PII/PIII/P4
 This package contains the Linux kernel image for version 2.4.27 on
 Pentium Pro/Celeron/Pentium II/Pentium III/Pentium 4,
 the corresponding System.map file, and the modules built by the packager.
 It also contains scripts that try to ensure that the system is not left in
 a unbootable state after an update.
 .
 If you wish to update a bootdisk, or to use a bootloader to make
 installing and using the image easier, we suggest you install the latest
 fdutils (for formatting a floppy to be used as boot disk), and LILO, for a
 powerful bootloader. Of course, both these are optional.
 .
 Kernel image packages are generally produced using kernel-package,
 and it is suggested that you install that package if you wish to
 create a custom kernel from the sources.

The machine is a notebook, Dell Latitude C600, BIOS version A23.

I do not use the built-in ethernet card since for now I just access
the net through dialup modem nor do I use the built-in Winmodem.

netrek:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 6
cpu MHz         : 751.716
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 mmx fxsr sse
bogomips        : 1500.77

Any suggestions on what caused this error, how I can debug it to get
more information or ideally how to prevent this from happening again
would be appreciated.

Regards,
Zach
