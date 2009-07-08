Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZGHDug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZGHDug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbZGHDu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:50:27 -0400
Received: from web36707.mail.mud.yahoo.com ([209.191.85.41]:27377 "HELO
	web36707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755321AbZGHDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:50:26 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2009 23:50:25 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=3vZmLibb0SV2TZiINoUBBrGdb8Kk/RYHU7JcXH3zlss9nb4xuPj8/c2TCuB21BwTeLb4QGOSx90eN+aFxHfE0Zcxqy3JJXRAxkXUU5dXKiBQvV0TI8qBy4KQCRPMz43I4GVZguwM9rBTWD3L7JWOzIFBeiUC7hRwlkEI4ckUExc=;
Message-ID: <322837.89052.qm@web36707.mail.mud.yahoo.com>
X-YMail-OSG: iSs3LU4VM1lMvIxXW4bRU.qWoZTwDx6Vhng7v0p.XdUMNfhnGw_NI.oke2TVrQEML8sJQUN3UIrpUVLSNU8GcxiZno5nWkF3rLb807N1eaZyJe50gNwXmXVR1eaWu70i1hSwVsIBvNYg0LjSd31PYYbmJv7kxPH1BUhMyyUILJemnP6vD6LCfZNqKAx3CjzdSVJ6J4lew3RhHFpg_TW39Qi1rUfVFbC8oHeL06kC1E2wWIfi7a7j_vsWM6Wu4aYj6X.yTu7aJJAyS25QQjJG3B9nM4HFD63pNw6h4mkFqHxLgsRJHVzYy35qCDYNfuuF.7OVyA--
X-Mailer: YahooMailClassic/5.4.17 YahooMailWebService/0.7.289.15
Date: Tue, 7 Jul 2009 20:43:44 -0700 (PDT)
From: Zibeli Aton <zibeli@yahoo.com>
Subject: PROBLEM: 2.6.30 and later kernel no longer boots using encrypted filesystem setup
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've done a lot of searching and can't figure out what might be going on here, so wondering if anyone here can suggest any possible causes.  Please cc: me with any responses if at all possible.

I'll attempt to follow the suggest format from http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html.

[1.] 2.6.30 and later kernel no longer boots using encrypted root filesystem setup

[2.] Neither the 2.6.30 and 2.6.30.1 kernels will boot under my encrypted root filesystem setup on an x86 box, though the 2.6.29.x kernels still boot fine and the newer kernels boot fine if I do not use the encrypted filesystem setup.

When I attempt to boot the 2.6.30.x kernels (via grub), the boot fails immediately, apparently in decompressing the kernel, giving the message "Destination address too large", which from grepping the kernel source tree, apparently comes from arch/x86/boot/compressed/misc.c

My encrypted filesystem works by first booting from a very small (ca 30 MB), unencrypted, ext2 partition on sda1.  This partition is passed to the kernel as the root partition by grub.  This small partition contains only the kernel image plus a few binaries needed to run an init script that mounts the encrypted partition (sda2) via losetup and dmsetup, then pivots_root to it.  However, since the 2.6.30.x kernels apparently never even decompress themselves, the process never gets this far.

I can boot the same kernel successfully on the same machine by booting it from another, larger partition (sda4) which, if relevant, is an ext3 partition.  I can also still boot the original encrypted system by using the 2.6.29.4 kernel with the exact same parameters and configuration as the 2.6.30.x kernels that fail.

The only differences I see that seem relevant so early in the boot process is that the initial root filesystem (on sda1) for the encrypted boot setup is ext2 instead of the ext3 on the larger partition that boots successfully and that the size of the sda1 partition is much, much smaller.

[3.] KEYWORDS: x86 boot decompression "Destination address too large"

[4.] KERNEL VERSION: Linux version 2.6.30.1-20090704 (me@elfs) (gcc version 4.4.0 (GCC) ) #1 SMP

[5.] MESSAGES SEEN ON FAILED BOOT:

  Booting command-list
root (hd0,0)
  Filesystem type is ext2fs, partition type 0x83
kernel /boot/bzImage-2.6.30.1-20090704 ro root=/dev/sda1
  [Linux-bzImage, setup=0x2c00, size=0x26e0a0]

Destination address too large

 -- System halted

[6.] n/a

[7.] Environment

[7.1] ver_linux script output (after booting from larger partition):
Linux elfs 2.6.30.1-20090706 #1 SMP Mon Jul 6 18:47:42 CST 2009 i686 pentium3 i386 GNU/Linux
 
Gnu C                  4.4.0
Gnu make               3.81
binutils               2.19.1
util-linux             ./ver_linux: line 23: fdformat: command not found
mount                  support
module-init-tools      found
Linux C Library        2.10.1
Dynamic linker (ldd)   2.10.1
Linux C++ Library      6.0.11
Procps                 3.2.8
Kbd                    1.15
Sh-utils               7.4
Modules Loaded         snd_hda_codec_idt nvidia snd_hda_intel snd_hda_codec snd_hwdep


[7.2.]  cat /proc/cpuinfo output:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     P7450  @ 2.13GHz
stepping        : 6
cpu MHz         : 2127.937
cache size      : 3072 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips        : 4255.87
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     P7450  @ 2.13GHz
stepping        : 6
cpu MHz         : 2127.937
cache size      : 3072 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips        : 4255.91
clflush size    : 64
power management:



[7.3.] n/a as modules never loaded

[7.4.] cat /proc/ioports output (on 2.6.30.1 kernel from larger ext3 partition):
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vesafb
0400-047f : pnp 00:01
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
  0450-0450 : ACPI PM2_CNT_BLK
0500-053f : pnp 00:01
0600-060f : pnp 00:01
0610-0610 : pnp 00:01
0800-080f : pnp 00:01
0810-0817 : pnp 00:01
0820-0823 : pnp 00:01
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:06
2000-2fff : PCI Bus 0000:05
3000-3fff : PCI Bus 0000:04
  3000-30ff : 0000:04:00.0
    3000-30ff : r8169
4000-4fff : PCI Bus 0000:03
5000-5fff : PCI Bus 0000:02
6000-6fff : PCI Bus 0000:01
  6000-607f : 0000:01:00.0
7000-701f : 0000:00:1f.3
  7000-701f : i801_smbus
7020-703f : 0000:00:1f.2
  7020-703f : ahci
7040-705f : 0000:00:1d.2
  7040-705f : uhci_hcd
7060-707f : 0000:00:1d.1
  7060-707f : uhci_hcd
7080-709f : 0000:00:1d.0
  7080-709f : uhci_hcd
70a0-70bf : 0000:00:1a.1
  70a0-70bf : uhci_hcd
70c0-70df : 0000:00:1a.0
  70c0-70df : uhci_hcd
70e0-70e7 : 0000:00:1f.2
  70e0-70e7 : ahci
70e8-70ef : 0000:00:1f.2
  70e8-70ef : ahci
70f0-70f3 : 0000:00:1f.2
  70f0-70f3 : ahci
70f4-70f7 : 0000:00:1f.2
  70f4-70f7 : ahci

cat /proc/iomem output (on 2.6.30.1 kernel from larger ext3 partition):
00000000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ce5ff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7fc6afff : System RAM
  00100000-004855d8 : Kernel code
  004855d9-005e8413 : Kernel data
  0063a000-0068fbf3 : Kernel bss
7fc6b000-7fcbefff : reserved
7fcbf000-7fd82fff : System RAM
7fd83000-7fdbefff : ACPI Non-volatile Storage
7fdbf000-7fddefff : System RAM
7fddf000-7fdf6fff : ACPI Tables
7fdf7000-7fdfffff : System RAM
7fe00000-7fffffff : reserved
80000000-8fffffff : PCI Bus 0000:01
  80000000-8fffffff : 0000:01:00.0
90000000-92ffffff : PCI Bus 0000:01
  90000000-91ffffff : 0000:01:00.0
    91000000-91dfffff : vesafb
  92000000-92ffffff : 0000:01:00.0
    92000000-92ffffff : nvidia
93000000-93ffffff : PCI Bus 0000:02
94000000-94ffffff : PCI Bus 0000:03
95000000-95ffffff : PCI Bus 0000:04
  95000000-9500ffff : 0000:04:00.0
    95000000-9500ffff : r8169
  95010000-95010fff : 0000:04:00.0
    95010000-95010fff : r8169
  95020000-9502ffff : 0000:04:00.0
96000000-96ffffff : PCI Bus 0000:05
97000000-97ffffff : PCI Bus 0000:06
98000000-98ffffff : PCI Bus 0000:06
99000000-99ffffff : PCI Bus 0000:05
  99000000-990000ff : 0000:05:00.4
  99000100-990001ff : 0000:05:00.3
  99000200-990002ff : 0000:05:00.2
  99000300-990003ff : 0000:05:00.0
    99000300-990003ff : mmc0
9a000000-9affffff : PCI Bus 0000:04
9b000000-9bffffff : PCI Bus 0000:03
  9b000000-9b001fff : 0000:03:00.0
    9b000000-9b001fff : iwlagn
9c000000-9cffffff : PCI Bus 0000:02
9d000000-9d003fff : 0000:00:1b.0
  9d000000-9d003fff : ICH HD audio
9d004000-9d0047ff : 0000:00:1f.2
  9d004000-9d0047ff : ahci
9d004800-9d004bff : 0000:00:1d.7
  9d004800-9d004bff : ehci_hcd
9d004c00-9d004fff : 0000:00:1a.7
  9d004c00-9d004fff : ehci_hcd
9d005000-9d0050ff : 0000:00:1f.3
f8000000-fbffffff : PCI MMCONFIG 0 [00-3f]
  f8000000-fbffffff : reserved
    f8000000-fbffffff : pnp 00:01
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : reserved
    fec00000-fec00fff : pnp 00:01
fed00000-fed003ff : HPET 0
fed10000-fed13fff : reserved
  fed10000-fed13fff : pnp 00:01
fed18000-fed19fff : reserved
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:01
fed20000-fed8ffff : pnp 00:01
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:01
fff00000-ffffffff : reserved

[7.5.] PCI information 
  lspci not installed - can install if deemed relevant

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: FUJITSU MHZ2320B Rev: 8909
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-T50N  Rev: RC04
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: USB Flash Disk   Rev: 0.00
  Type:   Direct-Access                    ANSI  SCSI revision: 02


      
