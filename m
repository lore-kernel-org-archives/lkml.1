Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYAIKWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYAIKWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYAIKWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:22:23 -0500
Received: from mail.vub.de ([213.149.66.40]:40579 "EHLO csc.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751354AbYAIKWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:22:13 -0500
X-Greylist: delayed 3596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 05:22:11 EST
X-Disclaimer: CSC-VirusScan KAV
X-Disclaimer: CSC-VirusScan ClamAv
Message-ID: <47849240.3040305@vub.de>
Date: Wed, 09 Jan 2008 10:22:08 +0100
From: VUB Stefan Seidel <sseidel@vub.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Not all logical processors activated on Dual Core Xeon (== no Hyperthreading)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the following system here: two dual-core Xeon 5130 on an Intel 
S5000V-SA motherboard. The kernel detects 4 CPUs, from what I learn 
through /proc/cpuinfo, these are the 4 cores (two per package). However, 
I think it should be 8 logical processors, because the Xeons should be 
able to do Hyperthreading (or Hyper-Threading). And after using 
acpidump, my suspicions grew. I have already downloaded the latest 
stable kernel and set the "Core2Duo/Newer Xeon" option.
Now the interesting thing is that I get some error messages in dmesg and 
only 4 CPUs are brought up:
===========================
pallas:/var/log# grep -i proc dmesg
Processor #0 6:15 APIC version 20
Processor #6 6:15 APIC version 20
Processor #1 6:15 APIC version 20
Processor #7 6:15 APIC version 20
Detected 1995.058 MHz processor.
Checking if this processor honours the WP bit even in supervisor mode... Ok.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Booting processor 1/1 eip 3000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Booting processor 2/6 eip 3000
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
Booting processor 3/7 eip 3000
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 1
Total of 4 processors activated (15962.55 BogoMIPS).
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
===========================
and what is strange too:
===========================
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x87] disabled)
===========================
but acpidump shows 8 CPUs in multiple locations:
===========================
pallas:/var/log# acpidump | egrep "CPU" -C 1
  0020: 13 00 00 01 10 4f 06 5c 5f 50 52 5f 5b 83 0b 43  .....O.\_PR_[..C
  0030: 50 55 30 00 10 04 00 00 06 5b 83 0b 43 50 55 31  PU0......[..CPU1
  0040: 01 10 04 00 00 06 5b 83 0b 43 50 55 32 02 10 04  ......[..CPU2...
  0050: 00 00 06 5b 83 0b 43 50 55 33 03 10 04 00 00 06  ...[..CPU3......
  0060: 5b 83 0b 43 50 55 34 04 10 04 00 00 06 5b 83 0b  [..CPU4......[..
  0070: 43 50 55 35 05 10 04 00 00 06 5b 83 0b 43 50 55  CPU5......[..CPU
  0080: 36 06 10 04 00 00 06 5b 83 0b 43 50 55 37 07 10  6......[..CPU7..
  0090: 04 00 00 06 08 5c 5f 53 30 5f 12 0a 04 0a 00 0a  .....\_S0_......
--
  0050: 44 43 01 8a 68 0a 08 43 41 50 30 70 43 41 50 30  DC..h..CAP0pCAP0
  0060: 50 44 43 46 10 45 13 5c 2e 5f 50 52 5f 43 50 55  PDCF.E.\._PR_CPU
  0070: 30 08 5f 50 43 54 12 2c 02 11 14 0a 11 82 0c 00  0._PCT.,........
--
  0190: 14 09 5f 50 50 43 00 a4 0a 00 10 45 13 5c 2e 5f  .._PPC.....E.\._
  01a0: 50 52 5f 43 50 55 31 08 5f 50 43 54 12 2c 02 11  PR_CPU1._PCT.,..
  01b0: 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00  ................
--
  02c0: 80 0c 00 00 00 80 14 09 5f 50 50 43 00 a4 0a 00  ........_PPC....
  02d0: 10 45 13 5c 2e 5f 50 52 5f 43 50 55 32 08 5f 50  .E.\._PR_CPU2._P
  02e0: 43 54 12 2c 02 11 14 0a 11 82 0c 00 7f 00 00 00  CT.,............
--
  0530: 00 80 14 09 5f 50 50 43 00 a4 0a 00 10 45 13 5c  ...._PPC.....E.\
  0540: 2e 5f 50 52 5f 43 50 55 34 08 5f 50 43 54 12 2c  ._PR_CPU4._PCT.,
  0550: 02 11 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00  ................
--
  0660: 00 00 80 0c 00 00 00 80 14 09 5f 50 50 43 00 a4  .........._PPC..
  0670: 0a 00 10 45 13 5c 2e 5f 50 52 5f 43 50 55 35 08  ...E.\._PR_CPU5.
  0680: 5f 50 43 54 12 2c 02 11 14 0a 11 82 0c 00 7f 00  _PCT.,..........
--
  07a0: 5f 50 50 43 00 a4 0a 00 10 45 13 5c 2e 5f 50 52  _PPC.....E.\._PR
  07b0: 5f 43 50 55 36 08 5f 50 43 54 12 2c 02 11 14 0a  _CPU6._PCT.,....
  07c0: 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00 00 00  ................
--
  08d0: 00 00 00 80 14 09 5f 50 50 43 00 a4 0a 00 10 45  ......_PPC.....E
  08e0: 13 5c 2e 5f 50 52 5f 43 50 55 37 08 5f 50 43 54  .\._PR_CPU7._PCT
  08f0: 12 2c 02 11 14 0a 11 82 0c 00 7f 00 00 00 00 00  .,..............
--
  0010: 43 53 54 20 20 20 20 20 00 40 00 00 49 4e 54 4c  CST     .@..INTL
  0020: 13 00 00 01 10 45 05 5c 2e 5f 50 52 5f 43 50 55  .....E.\._PR_CPU
  0030: 30 08 5f 43 53 54 12 43 04 03 0a 02 12 1e 04 11  0._CST.C........
--
  0070: 00 79 00 0a 02 0a 28 0b ee 02 10 0b 5c 2e 5f 50  .y....(.....\._P
  0080: 52 5f 43 50 55 31 10 0b 5c 2e 5f 50 52 5f 43 50  R_CPU1..\._PR_CP
  0090: 55 32 10 0b 5c 2e 5f 50 52 5f 43 50 55 33 10 0b  U2..\._PR_CPU3..
  00a0: 5c 2e 5f 50 52 5f 43 50 55 34 10 0b 5c 2e 5f 50  \._PR_CPU4..\._P
  00b0: 52 5f 43 50 55 35 10 0b 5c 2e 5f 50 52 5f 43 50  R_CPU5..\._PR_CP
  00c0: 55 36 10 0b 5c 2e 5f 50 52 5f 43 50 55 37        U6..\._PR_CPU7

===========================
So, what could be the problem here? /proc/cpuinfo says physical CPUs 0 
and 3 with their cores 0 and 1. I have already upgraded to the latest 
BIOS. Please CC me as I don't have subscribed to the LKML.

regards,

Stefan Seidel

Now, here is the full info:
# scripts/ver_linux
Linux pallas 2.6.23.12 #1 SMP PREEMPT Sun Jan 6 03:06:32 CET 2008 i686 
GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
xfsprogs               2.8.11
Linux C Library        3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
Modules Loaded         thermal processor nls_iso8859_1 isofs udf ppdev 
parport_pc lp parport ac battery ipv6 nfs lockd nfs_acl sunrpc 
dm_snapshot dm_mirror dm_mod loop tsdev shpchp psmouse i2c_i801 
pci_hotplug button serio_raw i2c_core evdev pcspkr rtc xfs ide_generic 
ide_cd cdrom ata_generic ata_piix piix sd_mod ehci_hcd uhci_hcd generic 
usbcore ide_core ahci e1000 fan

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1995.058
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse3 cx16 
xtpr dca lahf_lm
bogomips        : 3992.38
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1995.058
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse3 cx16 
xtpr dca lahf_lm
bogomips        : 3990.03
clflush size    : 64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1995.058
cache size      : 4096 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse3 cx16 
xtpr dca lahf_lm
bogomips        : 3990.06
clflush size    : 64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1995.058
cache size      : 4096 KB
physical id     : 3
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse3 cx16 
xtpr dca lahf_lm
bogomips        : 3990.06
clflush size    : 64

# acpidump
DSDT @ 0x9fb31000
  0000: 44 53 44 54 9a 4d 00 00 02 58 49 4e 54 45 4c 20  DSDT.M...XINTEL
  0010: 53 35 30 30 30 56 53 41 08 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 10 4f 06 5c 5f 50 52 5f 5b 83 0b 43  .....O.\_PR_[..C
  0030: 50 55 30 00 10 04 00 00 06 5b 83 0b 43 50 55 31  PU0......[..CPU1
  0040: 01 10 04 00 00 06 5b 83 0b 43 50 55 32 02 10 04  ......[..CPU2...
  0050: 00 00 06 5b 83 0b 43 50 55 33 03 10 04 00 00 06  ...[..CPU3......
  0060: 5b 83 0b 43 50 55 34 04 10 04 00 00 06 5b 83 0b  [..CPU4......[..
  0070: 43 50 55 35 05 10 04 00 00 06 5b 83 0b 43 50 55  CPU5......[..CPU
  0080: 36 06 10 04 00 00 06 5b 83 0b 43 50 55 37 07 10  6......[..CPU7..
  0090: 04 00 00 06 08 5c 5f 53 30 5f 12 0a 04 0a 00 0a  .....\_S0_......
  00a0: 00 0a 00 0a 00 08 5c 5f 53 31 5f 12 0a 04 0a 01  ......\_S1_.....
  00b0: 0a 00 0a 00 0a 00 08 5c 5f 53 34 5f 12 0a 04 0a  .......\_S4_....
  00c0: 06 0a 00 0a 00 0a 00 08 5c 5f 53 35 5f 12 0a 04  ........\_S5_...
  00d0: 0a 07 0a 00 0a 00 0a 00 10 41 2f 5f 53 42 5f 14  .........A/_SB_.
  00e0: 11 4d 49 4e 5f 02 a0 06 95 68 69 a4 68 a1 03 a4  .MIN_....hi.h...
  00f0: 69 14 09 53 4c 45 4e 01 a4 87 68 14 21 53 32 42  i..SLEN...h.!S2B
  0100: 46 09 72 53 4c 45 4e 68 01 60 08 42 55 46 46 11  F.rSLENh.`.BUFF.
  0110: 02 60 70 68 42 55 46 46 a4 42 55 46 46 14 46 06  .`phBUFF.BUFF.F.
  0120: 53 43 4d 50 02 70 53 4c 45 4e 68 65 70 53 4c 45  SCMP.pSLENhepSLE
  0130: 4e 69 66 70 4d 49 4e 5f 65 66 67 a0 10 92 93 65  NifpMIN_efg....e
  0140: 66 a0 06 94 65 66 a4 01 a1 03 a4 ff 70 53 32 42  f...ef......pS2B
  0150: 46 68 60 70 53 32 42 46 69 61 70 00 64 a2 24 95  Fh`pS2BFiap.d.$.
  0160: 64 67 70 83 88 60 64 00 62 70 83 88 61 64 00 63  dgp..`d.bp..ad.c
  0170: a0 06 94 62 63 a4 01 a1 08 a0 06 95 62 63 a4 ff  ...bc.......bc..
  0180: 75 64 a4 00 14 2e 42 49 54 53 03 a0 0e 92 94 69  ud....BITS.....i
  0190: 6a 7a 68 69 60 74 0a 1f 6a 61 a1 0a 7a 68 6a 60  jzhi`t..ja..zhj`
  01a0: 74 0a 1f 69 61 7a 0c ff ff ff ff 61 61 7b 60 61  t..iaz.....aa{`a
  01b0: 60 a4 60 08 5c 4f 53 46 4c 00 14 4f 20 5f 49 4e  `.`.\OSFL..O _IN
  01c0: 49 00 70 0a 00 5c 4f 53 46 4c a0 46 15 5b 12 5f  I.p..\OSFL.F.[._
  01d0: 4f 53 49 60 a0 1c 5c 5f 4f 53 49 0d 57 69 6e 64  OSI`..\_OSI.Wind
  01e0: 6f 77 73 20 32 30 30 38 00 70 0a 0a 5c 4f 53 46  ows 2008.p..\OSF
  01f0: 4c a1 4f 12 a0 1c 5c 5f 4f 53 49 0d 57 69 6e 64  L.O...\_OSI.Wind
  0200: 6f 77 73 20 32 30 30 37 00 70 0a 0a 5c 4f 53 46  ows 2007.p..\OSF
  0210: 4c a1 4f 10 a0 1e 5c 5f 4f 53 49 0d 57 69 6e 64  L.O...\_OSI.Wind
  0220: 6f 77 73 20 32 30 30 36 2e 31 00 70 0a 0a 5c 4f  ows 2006.1.p..\O
  0230: 53 46 4c a1 4d 0e a0 3b 5c 5f 4f 53 49 0d 57 69  SFL.M..;\_OSI.Wi
  0240: 6e 64 6f 77 73 20 32 30 30 36 00 70 0a 0b 5c 4f  ndows 2006.p..\O
  0250: 53 46 4c a0 1e 5c 5f 4f 53 49 0d 57 69 6e 64 6f  SFL..\_OSI.Windo
  0260: 77 73 20 32 30 30 36 2e 31 00 70 0a 0a 5c 4f 53  ws 2006.1.p..\OS
  0270: 46 4c a1 4e 0a a0 1e 5c 5f 4f 53 49 0d 57 69 6e  FL.N...\_OSI.Win
  0280: 64 6f 77 73 20 32 30 30 31 2e 31 00 70 0a 05 5c  dows 2001.1.p..\
  0290: 4f 53 46 4c a1 4c 08 a0 1c 5c 5f 4f 53 49 0d 57  OSFL.L...\_OSI.W
  02a0: 69 6e 64 6f 77 73 20 32 30 30 31 00 70 0a 04 5c  indows 2001.p..\
  02b0: 4f 53 46 4c a1 4c 06 a0 1c 5c 5f 4f 53 49 0d 57  OSFL.L...\_OSI.W
  02c0: 69 6e 64 6f 77 73 20 32 30 30 30 00 70 0a 03 5c  indows 2000.p..\
  02d0: 4f 53 46 4c a1 4c 04 a0 17 5c 5f 4f 53 49 0d 46  OSFL.L...\_OSI.F
  02e0: 72 65 65 42 53 44 00 70 0a 06 5c 4f 53 46 4c a1  reeBSD.p..\OSFL.
  02f0: 31 a0 15 5c 5f 4f 53 49 0d 48 50 2d 55 58 00 70  1..\_OSI.HP-UX.p
  0300: 0a 07 5c 4f 53 46 4c a1 19 a0 17 5c 5f 4f 53 49  ..\OSFL....\_OSI
  0310: 0d 4f 70 65 6e 56 4d 53 00 70 0a 08 5c 4f 53 46  .OpenVMS.p..\OSF
  0320: 4c a1 48 0a a0 45 0a 93 5c 4f 53 46 4c 0a 00 70  L.H..E..\OSFL..p
  0330: 5c 5f 4f 53 5f 60 70 53 43 4d 50 60 0d 4d 69 63  \_OS_`pSCMP`.Mic
  0340: 72 6f 73 6f 66 74 20 57 69 6e 64 6f 77 73 20 4e  rosoft Windows N
  0350: 54 00 61 a0 0c 80 61 00 70 0a 0a 5c 4f 53 46 4c  T.a...a.p..\OSFL
  0360: a1 49 06 70 53 43 4d 50 60 0d 4d 69 63 72 6f 73  .I.pSCMP`.Micros
  0370: 6f 66 74 20 57 69 6e 64 6f 77 73 4e 54 00 62 a0  oft WindowsNT.b.
  0380: 0c 80 62 00 70 0a 01 5c 4f 53 46 4c a1 3d 70 53  ..b.p..\OSFL.=pS
  0390: 43 4d 50 60 0d 4d 69 63 72 6f 73 6f 66 74 20 57  CMP`.Microsoft W
  03a0: 69 6e 64 6f 77 73 4d 45 3a 4d 69 6c 6c 65 6e 6e  indowsME:Millenn
  03b0: 69 75 6d 20 45 64 69 74 69 6f 6e 00 63 a0 0c 80  ium Edition.c...
  03c0: 63 00 70 0a 02 5c 4f 53 46 4c 08 5c 47 50 49 43  c.p..\OSFL.\GPIC
  03d0: 00 14 0e 5c 5f 50 49 43 01 70 68 5c 47 50 49 43  ...\_PIC.ph\GPIC
  03e0: 10 48 19 5c 5f 47 50 45 14 18 5f 4c 30 33 00 86  .H.\_GPE.._L03..
  03f0: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 48 43 31 0a  \/._SB_PCI0UHC1.
  0400: 02 14 18 5f 4c 30 34 00 86 5c 2f 03 5f 53 42 5f  ..._L04..\/._SB_
  0410: 50 43 49 30 55 48 43 32 0a 02 14 20 5f 4c 30 39  PCI0UHC2... _L09
  0420: 00 86 5c 2f 05 5f 53 42 5f 50 43 49 30 50 43 49  ..\/._SB_PCI0PCI
  0430: 45 50 43 49 57 50 43 49 51 0a 02 14 18 5f 4c 30  EPCIWPCIQ...._L0
  0440: 42 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 50 33  B..\/._SB_PCI0P3
  0450: 32 5f 0a 02 14 18 5f 4c 30 43 00 86 5c 2f 03 5f  2_...._L0C..\/._
  0460: 53 42 5f 50 43 49 30 55 48 43 33 0a 02 14 18 5f  SB_PCI0UHC3...._
  0470: 4c 30 44 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30  L0D..\/._SB_PCI0
  0480: 45 48 43 49 0a 02 14 18 5f 4c 30 45 00 86 5c 2f  EHCI...._L0E..\/
  0490: 03 5f 53 42 5f 50 43 49 30 55 48 43 34 0a 02 14  ._SB_PCI0UHC4...
  04a0: 41 05 5f 4c 31 38 00 86 5c 2f 04 5f 53 42 5f 50  A._L18..\/._SB_P
  04b0: 43 49 30 50 43 49 45 50 43 49 45 0a 02 86 5c 2f  CI0PCIEPCIE...\/
  04c0: 05 5f 53 42 5f 50 43 49 30 50 43 49 45 50 43 49  ._SB_PCI0PCIEPCI
  04d0: 57 50 43 49 4f 0a 02 86 5c 2f 05 5f 53 42 5f 50  WPCIO...\/._SB_P
  04e0: 43 49 30 50 43 49 45 50 43 49 57 50 43 49 50 0a  CI0PCIEPCIWPCIP.
  04f0: 02 14 13 5f 4c 31 42 00 86 5c 2e 5f 53 42 5f 53  ..._L1B..\._SB_S
  0500: 4c 50 42 0a 02 14 1c 5f 4c 33 30 00 86 5c 2f 04  LPB...._L30..\/.
  0510: 5f 53 42 5f 50 43 49 30 4c 50 43 5f 55 41 52 31  _SB_PCI0LPC_UAR1
  0520: 0a 02 14 1c 5f 4c 33 31 00 86 5c 2f 04 5f 53 42  ...._L31..\/._SB
  0530: 5f 50 43 49 30 4c 50 43 5f 55 41 52 32 0a 02 14  _PCI0LPC_UAR2...
  0540: 1c 5f 4c 33 41 00 86 5c 2f 04 5f 53 42 5f 50 43  ._L3A..\/._SB_PC
  0550: 49 30 4c 50 43 5f 50 53 32 4b 0a 02 14 1c 5f 4c  I0LPC_PS2K...._L
  0560: 33 42 00 86 5c 2f 04 5f 53 42 5f 50 43 49 30 4c  3B..\/._SB_PCI0L
  0570: 50 43 5f 50 53 32 4d 0a 02 5b 82 24 5c 2e 5f 53  PC_PS2M..[.$\._S
  0580: 42 5f 53 4c 50 42 08 5f 48 49 44 0c 41 d0 0c 0e  B_SLPB._HID.A...
  0590: 14 0e 5f 50 52 57 00 a4 12 06 02 0a 1b 0a 05 5b  .._PRW.........[
  05a0: 80 53 4d 4d 49 01 0a b2 0a 02 5b 81 10 53 4d 4d  .SMMI.....[..SMM
  05b0: 49 01 53 4d 4d 43 08 53 4d 4d 53 08 5b 01 57 41  I.SMMC.SMMS.[.WA
  05c0: 52 4e 0f 14 43 0a 5f 57 41 4b 09 5c 2f 04 5f 53  RN..C._WAK.\/._S
  05d0: 42 5f 50 43 49 30 4c 50 43 5f 57 41 4b 5f 68 70  B_PCI0LPC_WAK_hp
  05e0: 0a 00 5c 2f 04 5f 53 42 5f 50 43 49 30 50 43 49  ..\/._SB_PCI0PCI
  05f0: 45 50 47 45 4e 70 0a 00 5c 2f 04 5f 53 42 5f 50  EPGENp..\/._SB_P
  0600: 43 49 30 4c 50 43 5f 42 50 45 4e a0 12 92 93 68  CI0LPC_BPEN....h
  0610: 0a 04 5c 2e 5f 53 42 5f 53 57 41 46 0a 50 a0 0f  ..\._SB_SWAF.P..
  0620: 5b 12 5f 4f 53 49 60 70 0a 21 43 4f 53 46 86 5c  [._OSI`p.!COSF.\
  0630: 2f 03 5f 53 42 5f 50 43 49 30 55 48 43 31 0a 00  /._SB_PCI0UHC1..
  0640: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 48 43 32  .\/._SB_PCI0UHC2
  0650: 0a 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 48  ...\/._SB_PCI0EH
  0660: 43 49 0a 00 a4 0a 00 14 4d 0f 5f 50 54 53 01 5c  CI......M._PTS.\
  0670: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 50 54  /._SB_PCI0LPC_PT
  0680: 53 5f 68 08 4d 43 4e 54 0b e8 03 a0 43 0a 93 68  S_h.MCNT....C..h
  0690: 0a 01 70 0a 00 60 a2 4c 06 95 60 4d 43 4e 54 70  ..p..`.L..`MCNTp
  06a0: 0a 01 5c 2f 04 5f 53 42 5f 50 43 49 30 50 43 49  ..\/._SB_PCI0PCI
  06b0: 45 50 47 50 44 70 0a 01 5c 2f 04 5f 53 42 5f 50  EPGPDp..\/._SB_P
  06c0: 43 49 30 50 43 49 45 50 47 53 54 7d 5c 2f 04 5f  CI0PCIEPGST}\/._
  06d0: 53 42 5f 50 43 49 30 50 43 49 45 50 47 50 44 5c  SB_PCI0PCIEPGPD\
  06e0: 2f 04 5f 53 42 5f 50 43 49 30 50 43 49 45 50 47  /._SB_PCI0PCIEPG
  06f0: 53 54 61 a0 0b 93 61 0a 00 70 4d 43 4e 54 60 a1  STa...a..pMCNT`.
  0700: 03 75 60 70 0a 01 5c 2f 04 5f 53 42 5f 50 43 49  .u`p..\/._SB_PCI
  0710: 30 50 43 49 45 50 47 45 4e 70 0a 01 5c 2f 04 5f  0PCIEPGENp..\/._
  0720: 53 42 5f 50 43 49 30 4c 50 43 5f 42 50 45 4e a0  SB_PCI0LPC_BPEN.
  0730: 11 93 68 0a 01 5c 2e 5f 53 42 5f 53 57 41 46 0a  ..h..\._SB_SWAF.
  0740: 51 a0 11 93 68 0a 04 5c 2e 5f 53 42 5f 53 57 41  Q...h..\._SB_SWA
  0750: 46 0a 54 a0 11 93 68 0a 05 5c 2e 5f 53 42 5f 53  F.T...h..\._SB_S
  0760: 57 41 46 0a 55 5b 80 47 50 45 30 01 0b 28 04 0a  WAF.U[.GPE0..(..
  0770: 08 5b 81 1c 47 50 45 30 01 00 10 00 0b 47 31 31  .[..GPE0.....G11
  0780: 53 01 00 04 00 10 00 0b 47 31 31 45 01 00 04 5b  S.......G11E...[
  0790: 80 44 42 47 30 01 0a 80 0a 01 5b 81 0b 44 42 47  .DBG0.....[..DBG
  07a0: 30 01 49 4f 38 30 08 5b 80 41 43 4d 53 01 0a 72  0.IO80.[.ACMS..r
  07b0: 0a 02 5b 81 10 41 43 4d 53 01 49 4e 44 43 08 44  ..[..ACMS.INDC.D
  07c0: 41 54 43 08 5b 86 12 49 4e 44 43 44 41 54 43 01  ATC.[..INDCDATC.
  07d0: 00 48 37 43 4f 53 46 08 10 8d 52 04 5c 5f 53 42  .H7COSF...R.\_SB
  07e0: 5f 5b 80 49 4f 42 32 01 0a b2 0a 02 5b 81 10 49  _[.IOB2.....[..I
  07f0: 4f 42 32 01 53 4d 49 43 08 53 4d 49 53 08 14 34  OB2.SMIC.SMIS..4
  0800: 53 57 41 46 01 5b 01 4d 55 54 31 00 5b 23 4d 55  SWAF.[.MUT1.[#MU
  0810: 54 31 ff ff 70 68 5c 2e 5f 53 42 5f 53 4d 49 53  T1..ph\._SB_SMIS
  0820: 70 0a af 5c 2e 5f 53 42 5f 53 4d 49 43 5b 27 4d  p..\._SB_SMIC['M
  0830: 55 54 31 08 5c 50 43 41 50 0c 00 00 01 00 08 5c  UT1.\PCAP......\
  0840: 57 48 45 4e 0a 00 14 1f 53 57 57 45 01 70 0a 00  WHEN....SWWE.p..
  0850: 5c 2e 5f 53 42 5f 53 4d 49 53 70 68 5c 2e 5f 53  \._SB_SMISph\._S
  0860: 42 5f 53 4d 49 43 5b 82 3b 57 45 52 52 08 5f 48  B_SMIC[.;WERR._H
  0870: 49 44 0c 41 d0 0c 33 08 5f 55 49 44 0a 00 14 24  ID.A..3._UID...$
  0880: 5f 53 54 41 00 a0 1a 93 5c 4f 53 46 4c 0a 0a a0  _STA....\OSFL...
  0890: 10 7b 5c 50 43 41 50 0c 00 00 01 00 00 a4 0a 0f  .{\PCAP.........
  08a0: a4 0a 00 14 19 5c 2e 5f 47 50 45 5f 45 31 46 00  .....\._GPE_E1F.
  08b0: 86 5c 2e 5f 53 42 5f 57 45 52 52 0a 80 14 4a 06  .\._SB_WERR...J.
  08c0: 5f 4f 53 43 04 8a 6b 0a 00 43 50 42 31 8a 6b 0a  _OSC..k..CPB1.k.
  08d0: 04 43 50 42 32 8a 6b 0a 08 43 50 42 33 a0 35 93  .CPB2.k..CPB3.5.
  08e0: 68 11 13 0a 10 0c 5e 85 ed 90 6c bf 47 a6 2a 26  h.....^...l.G.*&
  08f0: de 0f c5 ad 5c a0 1d 7b 5c 50 43 41 50 0c 00 00  ....\..{\PCAP...
  0900: 01 00 00 53 57 57 45 0a 9e 70 0a 01 5c 57 48 45  ...SWWE..p..\WHE
  0910: 4e a4 6b 70 0a 00 5c 57 48 45 4e 7d 43 50 42 32  N.kp..\WHEN}CPB2
  0920: 0a 04 43 50 42 32 a4 6b 5b 82 8c 3d 04 50 43 49  ..CPB2.k[..=.PCI
  0930: 30 08 5f 48 49 44 0c 41 d0 0a 03 08 5f 41 44 52  0._HID.A...._ADR
  0940: 0a 00 14 16 5f 49 4e 49 00 a0 0f 5b 12 5f 4f 53  ...._INI...[._OS
  0950: 49 60 70 0a 21 43 4f 53 46 5b 82 49 07 50 42 49  I`p.!COSF[.I.PBI
  0960: 46 08 5f 41 44 52 0c 00 00 10 00 5b 80 50 42 49  F._ADR.....[.PBI
  0970: 43 02 0a 00 0a f0 5b 81 3d 50 42 49 43 03 00 40  C.....[.=PBIC..@
  0980: 32 00 0c 48 42 41 53 0c 00 08 00 40 34 50 41 44  2..HBAS....@4PAD
  0990: 30 20 50 41 44 31 20 50 41 44 32 20 50 41 44 33  0 PAD1 PAD2 PAD3
  09a0: 20 50 44 53 30 20 50 44 53 31 20 50 44 53 32 20   PDS0 PDS1 PDS2
  09b0: 50 44 53 33 20 5b 80 50 41 4d 58 02 0a 59 0a 07  PDS3 [.PAMX..Y..
  09c0: 5b 81 12 50 41 4d 58 01 00 04 42 53 45 47 04 50  [..PAMX...BSEG.P
  09d0: 41 4d 53 30 5b 82 4a 0a 41 4d 41 50 08 5f 41 44  AMS0[.J.AMAP._AD
  09e0: 52 0c 01 00 10 00 5b 80 4d 41 50 43 02 0a 00 0a  R.....[.MAPC....
  09f0: f8 5b 81 4d 08 4d 41 50 43 01 56 49 44 5f 10 44  .[.M.MAPC.VID_.D
  0a00: 49 44 5f 10 00 40 34 00 0c 54 4f 4c 4d 04 00 40  ID_..@4..TOLM..@
  0a10: 09 00 10 4c 49 4d 30 0c 00 04 00 10 4c 49 4d 31  ...LIM0.....LIM1
  0a20: 0c 00 04 00 10 4c 49 4d 32 0c 00 04 00 10 4c 49  .....LIM2.....LI
  0a30: 4d 33 0c 00 04 00 10 4c 49 4d 34 0c 00 04 00 10  M3.....LIM4.....
  0a40: 4c 49 4d 35 0c 00 04 00 40 04 4d 52 50 50 06 4e  LIM5....@.MRPP.N
  0a50: 54 44 56 06 4e 54 43 44 06 52 44 47 50 01 00 0d  TDV.NTCD.RDGP...
  0a60: 4f 58 53 5a 0c 4e 58 53 5a 0c 00 08 41 4d 52 32  OXSZ.NXSZ...AMR2
  0a70: 20 41 4d 52 33 20 41 4d 52 34 20 41 4d 52 35 20   AMR3 AMR4 AMR5
  0a80: 08 50 42 52 53 11 46 0c 0a c2 88 0d 00 02 0c 00  .PBRS.F.........
  0a90: 00 00 00 00 ff 00 00 00 00 01 47 01 a2 0c a2 0c  ..........G.....
  0aa0: 00 01 47 01 a3 0c a3 0c 00 01 47 01 f8 0c f8 0c  ..G.......G.....
  0ab0: 01 08 88 0d 00 01 0c 03 00 00 00 00 a1 0c 00 00  ................
  0ac0: a2 0c 88 0d 00 01 0c 03 00 00 a4 0c f7 0c 00 00  ................
  0ad0: 54 00 88 0d 00 01 0c 03 00 00 00 0d ff ff 00 00  T...............
  0ae0: 00 f3 87 17 00 00 0c 03 00 00 00 00 00 00 0a 00  ................
  0af0: ff ff 0b 00 00 00 00 00 00 00 02 00 87 17 00 00  ................
  0b00: 0c 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0b10: 00 00 00 00 00 00 87 17 00 00 0c 03 00 00 00 00  ................
  0b20: 00 00 00 a0 ff ff ff fd 00 00 00 00 00 00 00 5e  ...............^
  0b30: 87 17 00 00 0c 01 00 00 00 00 00 00 70 fe ff 03  ............p...
  0b40: 70 fe 00 00 00 00 00 04 00 00 79 00 08 4d 51 36  p.........y..MQ6
  0b50: 34 11 33 0a 30 8a 2b 00 00 0c 01 00 00 00 00 00  4.3.0.+.........
  0b60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0b70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0b80: 00 00 00 79 00 8a 50 42 52 53 0a 7c 52 4d 49 4e  ...y..PBRS.|RMIN
  0b90: 8a 50 42 52 53 0a 80 52 4d 41 58 8a 50 42 52 53  .PBRS..RMAX.PBRS
  0ba0: 0a 88 52 4c 45 4e 8a 50 42 52 53 0a 96 52 4d 4e  ..RLEN.PBRS..RMN
  0bb0: 33 8a 50 42 52 53 0a a2 52 4c 4e 33 8a 4d 51 36  3.PBRS..RLN3.MQ6
  0bc0: 34 0a 26 52 4c 4e 35 14 27 5f 43 52 53 00 45 52  4.&RLN5.'_CRS.ER
  0bd0: 4f 4d 47 4d 45 4d 4d 51 4d 4d a0 0d 93 52 4c 4e  OMGMEMMQMM...RLN
  0be0: 35 0a 00 a4 50 42 52 53 a1 06 a4 4d 51 30 31 08  5...PBRS...MQ01.
  0bf0: 45 52 4e 47 12 44 04 0d 0c 00 00 0c 00 0c 00 40  ERNG.D.........@
  0c00: 0c 00 0c 00 80 0c 00 0c 00 c0 0c 00 0c 00 00 0d  ................
  0c10: 00 0c 00 40 0d 00 0c 00 80 0d 00 0c 00 c0 0d 00  ...@............
  0c20: 0c 00 00 0e 00 0c 00 40 0e 00 0c 00 80 0e 00 0c  .......@........
  0c30: 00 c0 0e 00 0c 00 00 0f 00 08 50 41 4d 42 11 03  ..........PAMB..
  0c40: 0a 07 14 3f 47 4d 45 4d 00 70 5c 2f 04 5f 53 42  ...?GMEM.p\/._SB
  0c50: 5f 50 43 49 30 50 42 49 46 48 42 41 53 60 70 72  _PCI0PBIFHBAS`pr
  0c60: 60 0a 01 00 60 70 79 60 0a 1c 00 60 70 74 0c 00  `...`py`...`pt..
  0c70: 00 00 fe 60 00 61 70 60 52 4d 4e 33 70 61 52 4c  ...`.ap`RMN3paRL
  0c80: 4e 33 14 4a 11 45 52 4f 4d 00 8c 50 41 4d 42 0a  N3.J.EROM..PAMB.
  0c90: 06 42 52 45 47 70 5c 2f 04 5f 53 42 5f 50 43 49  .BREGp\/._SB_PCI
  0ca0: 30 50 42 49 46 50 41 4d 53 50 41 4d 42 70 5c 2f  0PBIFPAMSPAMBp\/
  0cb0: 04 5f 53 42 5f 50 43 49 30 50 42 49 46 42 53 45  ._SB_PCI0PBIFBSE
  0cc0: 47 42 52 45 47 70 0a 00 52 4d 49 4e 70 0a 00 52  GBREGp..RMINp..R
  0cd0: 4d 41 58 70 0a 00 52 4c 45 4e 70 0a 00 60 a2 4e  MAXp..RLENp..`.N
  0ce0: 0b 95 60 0a 0d 7a 60 0a 01 61 70 83 88 50 41 4d  ..`..z`..ap..PAM
  0cf0: 42 61 00 62 a0 0b 7b 60 0a 01 00 7a 62 0a 04 62  Ba.b..{`...zb..b
  0d00: 7b 62 0a 03 62 a0 47 04 52 4d 49 4e a0 3a 62 72  {b..b.G.RMIN.:br
  0d10: 83 88 45 52 4e 47 60 00 0b ff 3f 52 4d 41 58 a0  ..ERNG`...?RMAX.
  0d20: 15 93 52 4d 41 58 0c ff 3f 0f 00 70 0c ff ff 0f  ..RMAX..?..p....
  0d30: 00 52 4d 41 58 74 52 4d 41 58 52 4d 49 4e 52 4c  .RMAXtRMAXRMINRL
  0d40: 45 4e 75 52 4c 45 4e a1 05 70 0a 0c 60 a1 4d 04  ENuRLEN..p..`.M.
  0d50: a0 48 04 62 70 83 88 45 52 4e 47 60 00 52 4d 49  .H.bp..ERNG`.RMI
  0d60: 4e 72 83 88 45 52 4e 47 60 00 0b ff 3f 52 4d 41  Nr..ERNG`...?RMA
  0d70: 58 a0 15 93 52 4d 41 58 0c ff 3f 0f 00 70 0c ff  X...RMAX..?..p..
  0d80: ff 0f 00 52 4d 41 58 74 52 4d 41 58 52 4d 49 4e  ...RMAXtRMAXRMIN
  0d90: 52 4c 45 4e 75 52 4c 45 4e a1 01 75 60 08 4d 51  RLENuRLEN..u`.MQ
  0da0: 30 31 11 04 0b 00 02 14 41 05 4d 51 4d 4d 00 70  01......A.MQMM.p
  0db0: 50 42 52 53 4d 51 30 31 74 87 50 42 52 53 0a 03  PBRSMQ01t.PBRS..
  0dc0: 60 72 87 4d 51 36 34 60 60 70 0a 00 88 4d 51 30  `r.MQ64``p...MQ0
  0dd0: 31 60 00 74 87 4d 51 36 34 0a 01 61 a2 1c 94 61  1`.t.MQ64..a...a
  0de0: 0a 00 76 60 76 61 70 83 88 4d 51 36 34 61 00 62  ..v`vap..MQ64a.b
  0df0: 70 62 88 4d 51 30 31 60 00 14 43 74 5f 50 52 54  pb.MQ01`..Ct_PRT
  0e00: 00 a0 4d 4f 93 5c 47 50 49 43 00 a4 12 42 4f 29  ..MO.\GPIC...BO)
  0e10: 12 1c 04 0b ff ff 0a 00 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  0e20: 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00 12 1c 04  CI0LPC_LNKA.....
  0e30: 0b ff ff 0a 01 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  0e40: 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1c 04 0b ff ff  LPC_LNKB........
  0e50: 0a 02 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  0e60: 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff ff 0a 03 5c  _LNKC..........\
  0e70: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  0e80: 4b 44 0a 00 12 1e 04 0c ff ff 02 00 0a 00 5c 2f  KD............\/
  0e90: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  0ea0: 41 0a 00 12 1e 04 0c ff ff 02 00 0a 01 5c 2f 04  A............\/.
  0eb0: 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42  _SB_PCI0LPC_LNKB
  0ec0: 0a 00 12 1e 04 0c ff ff 02 00 0a 02 5c 2f 04 5f  ............\/._
  0ed0: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a  SB_PCI0LPC_LNKC.
  0ee0: 00 12 1e 04 0c ff ff 02 00 0a 03 5c 2f 04 5f 53  ...........\/._S
  0ef0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00  B_PCI0LPC_LNKD..
  0f00: 12 1e 04 0c ff ff 03 00 0a 00 5c 2f 04 5f 53 42  ..........\/._SB
  0f10: 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00 12  _PCI0LPC_LNKA...
  0f20: 1e 04 0c ff ff 03 00 0a 01 5c 2f 04 5f 53 42 5f  .........\/._SB_
  0f30: 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1e  PCI0LPC_LNKB....
  0f40: 04 0c ff ff 03 00 0a 02 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  0f50: 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a 00 12 1e 04  CI0LPC_LNKC.....
  0f60: 0c ff ff 03 00 0a 03 5c 2f 04 5f 53 42 5f 50 43  .......\/._SB_PC
  0f70: 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00 12 1e 04 0c  I0LPC_LNKD......
  0f80: ff ff 04 00 0a 00 5c 2f 04 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  0f90: 30 4c 50 43 5f 4c 4e 4b 41 0a 00 12 1e 04 0c ff  0LPC_LNKA.......
  0fa0: ff 04 00 0a 01 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  0fb0: 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1e 04 0c ff ff  LPC_LNKB........
  0fc0: 04 00 0a 02 5c 2f 04 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  0fd0: 50 43 5f 4c 4e 4b 43 0a 00 12 1e 04 0c ff ff 04  PC_LNKC.........
  0fe0: 00 0a 03 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50  ...\/._SB_PCI0LP
  0ff0: 43 5f 4c 4e 4b 44 0a 00 12 1e 04 0c ff ff 05 00  C_LNKD..........
  1000: 0a 00 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  1010: 5f 4c 4e 4b 41 0a 00 12 1e 04 0c ff ff 05 00 0a  _LNKA...........
  1020: 01 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f  .\/._SB_PCI0LPC_
  1030: 4c 4e 4b 42 0a 00 12 1e 04 0c ff ff 05 00 0a 02  LNKB............
  1040: 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c  \/._SB_PCI0LPC_L
  1050: 4e 4b 43 0a 00 12 1e 04 0c ff ff 05 00 0a 03 5c  NKC............\
  1060: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  1070: 4b 44 0a 00 12 1e 04 0c ff ff 06 00 0a 00 5c 2f  KD............\/
  1080: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  1090: 41 0a 00 12 1e 04 0c ff ff 06 00 0a 01 5c 2f 04  A............\/.
  10a0: 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42  _SB_PCI0LPC_LNKB
  10b0: 0a 00 12 1e 04 0c ff ff 06 00 0a 02 5c 2f 04 5f  ............\/._
  10c0: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a  SB_PCI0LPC_LNKC.
  10d0: 00 12 1e 04 0c ff ff 06 00 0a 03 5c 2f 04 5f 53  ...........\/._S
  10e0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00  B_PCI0LPC_LNKD..
  10f0: 12 1e 04 0c ff ff 07 00 0a 00 5c 2f 04 5f 53 42  ..........\/._SB
  1100: 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00 12  _PCI0LPC_LNKA...
  1110: 1e 04 0c ff ff 07 00 0a 01 5c 2f 04 5f 53 42 5f  .........\/._SB_
  1120: 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1e  PCI0LPC_LNKB....
  1130: 04 0c ff ff 07 00 0a 02 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  1140: 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a 00 12 1e 04  CI0LPC_LNKC.....
  1150: 0c ff ff 07 00 0a 03 5c 2f 04 5f 53 42 5f 50 43  .......\/._SB_PC
  1160: 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00 12 1e 04 0c  I0LPC_LNKD......
  1170: ff ff 08 00 0a 00 5c 2f 04 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  1180: 30 4c 50 43 5f 4c 4e 4b 41 0a 00 12 1e 04 0c ff  0LPC_LNKA.......
  1190: ff 1c 00 0a 00 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  11a0: 4c 50 43 5f 4c 4e 4b 41 0a 00 12 1e 04 0c ff ff  LPC_LNKA........
  11b0: 1c 00 0a 01 5c 2f 04 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  11c0: 50 43 5f 4c 4e 4b 42 0a 00 12 1e 04 0c ff ff 1c  PC_LNKB.........
  11d0: 00 0a 02 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50  ...\/._SB_PCI0LP
  11e0: 43 5f 4c 4e 4b 43 0a 00 12 1e 04 0c ff ff 1c 00  C_LNKC..........
  11f0: 0a 03 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  1200: 5f 4c 4e 4b 44 0a 00 12 1e 04 0c ff ff 1d 00 0a  _LNKD...........
  1210: 00 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f  .\/._SB_PCI0LPC_
  1220: 4c 4e 4b 48 0a 00 12 1e 04 0c ff ff 1d 00 0a 01  LNKH............
  1230: 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c  \/._SB_PCI0LPC_L
  1240: 4e 4b 47 0a 00 12 1e 04 0c ff ff 1d 00 0a 02 5c  NKG............\
  1250: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  1260: 4b 48 0a 00 12 1e 04 0c ff ff 1d 00 0a 03 5c 2f  KH............\/
  1270: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  1280: 47 0a 00 12 1e 04 0c ff ff 1f 00 0a 00 5c 2f 04  G............\/.
  1290: 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 45  _SB_PCI0LPC_LNKE
  12a0: 0a 00 12 1e 04 0c ff ff 1f 00 0a 01 5c 2f 04 5f  ............\/._
  12b0: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 45 0a  SB_PCI0LPC_LNKE.
  12c0: 00 12 1e 04 0c ff ff 1f 00 0a 02 5c 2f 04 5f 53  ...........\/._S
  12d0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 45 0a 00  B_PCI0LPC_LNKE..
  12e0: 12 1e 04 0c ff ff 1f 00 0a 03 5c 2f 04 5f 53 42  ..........\/._SB
  12f0: 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 45 0a 00 a1  _PCI0LPC_LNKE...
  1300: 4d 23 a4 12 49 23 29 12 0b 04 0b ff ff 0a 00 0a  M#..I#).........
  1310: 00 0a 10 12 0b 04 0b ff ff 0a 01 0a 00 0a 11 12  ................
  1320: 0b 04 0b ff ff 0a 02 0a 00 0a 12 12 0b 04 0b ff  ................
  1330: ff 0a 03 0a 00 0a 13 12 0d 04 0c ff ff 02 00 0a  ................
  1340: 00 0a 00 0a 10 12 0d 04 0c ff ff 02 00 0a 01 0a  ................
  1350: 00 0a 11 12 0d 04 0c ff ff 02 00 0a 02 0a 00 0a  ................
  1360: 12 12 0d 04 0c ff ff 02 00 0a 03 0a 00 0a 13 12  ................
  1370: 0d 04 0c ff ff 03 00 0a 00 0a 00 0a 10 12 0d 04  ................
  1380: 0c ff ff 03 00 0a 01 0a 00 0a 11 12 0d 04 0c ff  ................
  1390: ff 03 00 0a 02 0a 00 0a 12 12 0d 04 0c ff ff 03  ................
  13a0: 00 0a 03 0a 00 0a 13 12 0d 04 0c ff ff 04 00 0a  ................
  13b0: 00 0a 00 0a 10 12 0d 04 0c ff ff 04 00 0a 01 0a  ................
  13c0: 00 0a 11 12 0d 04 0c ff ff 04 00 0a 02 0a 00 0a  ................
  13d0: 12 12 0d 04 0c ff ff 04 00 0a 03 0a 00 0a 13 12  ................
  13e0: 0d 04 0c ff ff 05 00 0a 00 0a 00 0a 10 12 0d 04  ................
  13f0: 0c ff ff 05 00 0a 01 0a 00 0a 11 12 0d 04 0c ff  ................
  1400: ff 05 00 0a 02 0a 00 0a 12 12 0d 04 0c ff ff 05  ................
  1410: 00 0a 03 0a 00 0a 13 12 0d 04 0c ff ff 06 00 0a  ................
  1420: 00 0a 00 0a 10 12 0d 04 0c ff ff 06 00 0a 01 0a  ................
  1430: 00 0a 11 12 0d 04 0c ff ff 06 00 0a 02 0a 00 0a  ................
  1440: 12 12 0d 04 0c ff ff 06 00 0a 03 0a 00 0a 13 12  ................
  1450: 0d 04 0c ff ff 07 00 0a 00 0a 00 0a 10 12 0d 04  ................
  1460: 0c ff ff 07 00 0a 01 0a 00 0a 11 12 0d 04 0c ff  ................
  1470: ff 07 00 0a 02 0a 00 0a 12 12 0d 04 0c ff ff 07  ................
  1480: 00 0a 03 0a 00 0a 13 12 0d 04 0c ff ff 08 00 0a  ................
  1490: 00 0a 00 0a 10 12 0d 04 0c ff ff 1c 00 0a 00 0a  ................
  14a0: 00 0a 10 12 0d 04 0c ff ff 1c 00 0a 01 0a 00 0a  ................
  14b0: 11 12 0d 04 0c ff ff 1c 00 0a 02 0a 00 0a 12 12  ................
  14c0: 0d 04 0c ff ff 1c 00 0a 03 0a 00 0a 13 12 0d 04  ................
  14d0: 0c ff ff 1d 00 0a 00 0a 00 0a 17 12 0d 04 0c ff  ................
  14e0: ff 1d 00 0a 01 0a 00 0a 16 12 0d 04 0c ff ff 1d  ................
  14f0: 00 0a 02 0a 00 0a 17 12 0d 04 0c ff ff 1d 00 0a  ................
  1500: 03 0a 00 0a 16 12 0d 04 0c ff ff 1f 00 0a 00 0a  ................
  1510: 00 0a 14 12 0d 04 0c ff ff 1f 00 0a 01 0a 00 0a  ................
  1520: 14 12 0d 04 0c ff ff 1f 00 0a 02 0a 00 0a 14 12  ................
  1530: 0d 04 0c ff ff 1f 00 0a 03 0a 00 0a 14 5b 82 4c  .............[.L
  1540: 11 50 33 32 5f 08 5f 41 44 52 0c 00 00 1e 00 08  .P32_._ADR......
  1550: 5f 50 52 57 12 06 02 0a 0b 0a 05 14 4f 0f 5f 50  _PRW........O._P
  1560: 52 54 00 a0 49 0a 93 5c 47 50 49 43 00 a4 12 4e  RT..I..\GPIC...N
  1570: 09 05 12 1e 04 0c ff ff 0c 00 0a 00 5c 2f 04 5f  ............\/._
  1580: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a  SB_PCI0LPC_LNKB.
  1590: 00 12 1e 04 0c ff ff 0d 00 0a 00 5c 2f 04 5f 53  ...........\/._S
  15a0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00  B_PCI0LPC_LNKA..
  15b0: 12 1e 04 0c ff ff 0d 00 0a 01 5c 2f 04 5f 53 42  ..........\/._SB
  15c0: 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12  _PCI0LPC_LNKB...
  15d0: 1e 04 0c ff ff 0d 00 0a 02 5c 2f 04 5f 53 42 5f  .........\/._SB_
  15e0: 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a 00 12 1e  PCI0LPC_LNKC....
  15f0: 04 0c ff ff 0d 00 0a 03 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  1600: 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00 a1 4d 04  CI0LPC_LNKD...M.
  1610: a4 12 49 04 05 12 0d 04 0c ff ff 0c 00 0a 00 0a  ..I.............
  1620: 00 0a 11 12 0d 04 0c ff ff 0d 00 0a 00 0a 00 0a  ................
  1630: 10 12 0d 04 0c ff ff 0d 00 0a 01 0a 00 0a 11 12  ................
  1640: 0d 04 0c ff ff 0d 00 0a 02 0a 00 0a 12 12 0d 04  ................
  1650: 0c ff ff 0d 00 0a 03 0a 00 0a 13 5b 82 41 0d 50  ...........[.A.P
  1660: 45 58 30 08 5f 41 44 52 0c 00 00 1c 00 14 40 0c  EX0._ADR......@.
  1670: 5f 50 52 54 00 a0 42 08 93 5c 47 50 49 43 00 a4  _PRT..B..\GPIC..
  1680: 12 47 07 04 12 1c 04 0b ff ff 0a 00 5c 2f 04 5f  .G..........\/._
  1690: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a  SB_PCI0LPC_LNKA.
  16a0: 00 12 1c 04 0b ff ff 0a 01 5c 2f 04 5f 53 42 5f  .........\/._SB_
  16b0: 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1c  PCI0LPC_LNKB....
  16c0: 04 0b ff ff 0a 02 5c 2f 04 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  16d0: 30 4c 50 43 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff  0LPC_LNKC.......
  16e0: ff 0a 03 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50  ...\/._SB_PCI0LP
  16f0: 43 5f 4c 4e 4b 44 0a 00 a1 35 a4 12 32 04 12 0b  C_LNKD...5..2...
  1700: 04 0b ff ff 0a 00 0a 00 0a 10 12 0b 04 0b ff ff  ................
  1710: 0a 01 0a 00 0a 11 12 0b 04 0b ff ff 0a 02 0a 00  ................
  1720: 0a 12 12 0b 04 0b ff ff 0a 03 0a 00 0a 13 5b 82  ..............[.
  1730: 41 0d 50 45 58 31 08 5f 41 44 52 0c 01 00 1c 00  A.PEX1._ADR.....
  1740: 14 40 0c 5f 50 52 54 00 a0 42 08 93 5c 47 50 49  .@._PRT..B..\GPI
  1750: 43 00 a4 12 47 07 04 12 1c 04 0b ff ff 0a 00 5c  C...G..........\
  1760: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  1770: 4b 42 0a 00 12 1c 04 0b ff ff 0a 01 5c 2f 04 5f  KB..........\/._
  1780: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a  SB_PCI0LPC_LNKC.
  1790: 00 12 1c 04 0b ff ff 0a 02 5c 2f 04 5f 53 42 5f  .........\/._SB_
  17a0: 50 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00 12 1c  PCI0LPC_LNKD....
  17b0: 04 0b ff ff 0a 03 5c 2f 04 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  17c0: 30 4c 50 43 5f 4c 4e 4b 41 0a 00 a1 35 a4 12 32  0LPC_LNKA...5..2
  17d0: 04 12 0b 04 0b ff ff 0a 00 0a 00 0a 11 12 0b 04  ................
  17e0: 0b ff ff 0a 01 0a 00 0a 12 12 0b 04 0b ff ff 0a  ................
  17f0: 02 0a 00 0a 13 12 0b 04 0b ff ff 0a 03 0a 00 0a  ................
  1800: 10 5b 82 41 0d 50 45 58 32 08 5f 41 44 52 0c 02  .[.A.PEX2._ADR..
  1810: 00 1c 00 14 40 0c 5f 50 52 54 00 a0 42 08 93 5c  ....@._PRT..B..\
  1820: 47 50 49 43 00 a4 12 47 07 04 12 1c 04 0b ff ff  GPIC...G........
  1830: 0a 00 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  1840: 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff ff 0a 01 5c  _LNKC..........\
  1850: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  1860: 4b 44 0a 00 12 1c 04 0b ff ff 0a 02 5c 2f 04 5f  KD..........\/._
  1870: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a  SB_PCI0LPC_LNKA.
  1880: 00 12 1c 04 0b ff ff 0a 03 5c 2f 04 5f 53 42 5f  .........\/._SB_
  1890: 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 a1 35  PCI0LPC_LNKB...5
  18a0: a4 12 32 04 12 0b 04 0b ff ff 0a 00 0a 00 0a 12  ..2.............
  18b0: 12 0b 04 0b ff ff 0a 01 0a 00 0a 13 12 0b 04 0b  ................
  18c0: ff ff 0a 02 0a 00 0a 10 12 0b 04 0b ff ff 0a 03  ................
  18d0: 0a 00 0a 11 5b 82 41 0d 50 45 58 33 08 5f 41 44  ....[.A.PEX3._AD
  18e0: 52 0c 03 00 1c 00 14 40 0c 5f 50 52 54 00 a0 42  R......@._PRT..B
  18f0: 08 93 5c 47 50 49 43 00 a4 12 47 07 04 12 1c 04  ..\GPIC...G.....
  1900: 0b ff ff 0a 00 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  1910: 4c 50 43 5f 4c 4e 4b 44 0a 00 12 1c 04 0b ff ff  LPC_LNKD........
  1920: 0a 01 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  1930: 5f 4c 4e 4b 41 0a 00 12 1c 04 0b ff ff 0a 02 5c  _LNKA..........\
  1940: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  1950: 4b 42 0a 00 12 1c 04 0b ff ff 0a 03 5c 2f 04 5f  KB..........\/._
  1960: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a  SB_PCI0LPC_LNKC.
  1970: 00 a1 35 a4 12 32 04 12 0b 04 0b ff ff 0a 00 0a  ..5..2..........
  1980: 00 0a 13 12 0b 04 0b ff ff 0a 01 0a 00 0a 10 12  ................
  1990: 0b 04 0b ff ff 0a 02 0a 00 0a 11 12 0b 04 0b ff  ................
  19a0: ff 0a 03 0a 00 0a 12 5b 82 42 0b 49 4f 43 4d 08  .......[.B.IOCM.
  19b0: 5f 48 49 44 0c 41 d0 0c 02 08 43 52 53 5f 11 46  _HID.A....CRS_.F
  19c0: 06 0a 62 86 09 00 00 00 00 00 e0 00 00 00 10 86  ..b.............
  19d0: 09 00 00 00 c0 d1 fe 00 40 00 00 86 09 00 00 00  ........@.......
  19e0: 00 c0 ff 00 00 40 00 86 09 00 00 00 00 c0 fe 00  .....@..........
  19f0: 00 10 00 86 09 00 00 00 00 e0 fe 00 00 10 00 86  ................
  1a00: 09 00 00 00 00 60 fe 00 00 10 00 86 09 00 00 00  .....`..........
  1a10: 00 00 fe 00 00 02 00 86 09 00 01 00 00 00 00 00  ................
  1a20: 00 0a 00 79 00 14 35 5f 43 52 53 00 8a 43 52 53  ...y..5_CRS..CRS
  1a30: 5f 0a 04 48 42 53 45 70 5c 2f 04 5f 53 42 5f 50  _..HBSEp\/._SB_P
  1a40: 43 49 30 50 42 49 46 48 42 41 53 60 70 79 60 0a  CI0PBIFHBAS`py`.
  1a50: 1c 00 48 42 53 45 a4 43 52 53 5f 5b 82 4b f0 4c  ..HBSE.CRS_[.K.L
  1a60: 50 43 5f 08 5f 41 44 52 0c 00 00 1f 00 5b 80 4c  PC_._ADR.....[.L
  1a70: 50 43 43 02 0a 00 0a ff 5b 81 10 4c 50 43 43 00  PCC.....[..LPCC.
  1a80: 00 40 50 00 0a 42 50 45 4e 01 5b 80 50 52 52 30  .@P..BPEN.[.PRR0
  1a90: 02 0a 60 0a 04 5b 81 1a 50 52 52 30 01 50 49 52  ..`..[..PRR0.PIR
  1aa0: 41 08 50 49 52 42 08 50 49 52 43 08 50 49 52 44  A.PIRB.PIRC.PIRD
  1ab0: 08 5b 80 50 52 52 31 02 0a 68 0a 04 5b 81 1a 50  .[.PRR1..h..[..P
  1ac0: 52 52 31 01 50 49 52 45 08 50 49 52 46 08 50 49  RR1.PIRE.PIRF.PI
  1ad0: 52 47 08 50 49 52 48 08 5b 82 4a 0c 4c 4e 4b 41  RG.PIRH.[.J.LNKA
  1ae0: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  1af0: 01 14 18 5f 53 54 41 00 a0 0c 7b 50 49 52 41 0a  ..._STA...{PIRA.
  1b00: 80 00 a4 0a 09 a1 04 a4 0a 0b 14 11 5f 44 49 53  ............_DIS
  1b10: 00 7d 50 49 52 41 0a 80 50 49 52 41 14 46 04 5f  .}PIRA..PIRA.F._
  1b20: 43 52 53 00 08 42 55 46 30 11 09 0a 06 23 01 00  CRS..BUF0....#..
  1b30: 18 79 00 8b 42 55 46 30 0a 01 49 52 51 57 a0 0c  .y..BUF0..IRQW..
  1b40: 7b 50 49 52 41 0a 80 00 70 00 60 a1 04 70 01 60  {PIRA...p.`..p.`
  1b50: 79 60 7b 50 49 52 41 0a 0f 00 49 52 51 57 a4 42  y`{PIRA...IRQW.B
  1b60: 55 46 30 08 5f 50 52 53 11 09 0a 06 23 a0 0c 18  UF0._PRS....#...
  1b70: 79 00 14 31 5f 53 52 53 01 8b 68 0a 01 49 52 51  y..1_SRS..h..IRQ
  1b80: 57 82 49 52 51 57 60 a0 0f 92 93 49 52 51 57 00  W.IRQW`....IRQW.
  1b90: 7b 60 0a 7f 60 76 60 a1 06 7d 60 0a 80 60 70 60  {`..`v`..}`..`p`
  1ba0: 50 49 52 41 5b 82 4a 0c 4c 4e 4b 42 08 5f 48 49  PIRA[.J.LNKB._HI
  1bb0: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 02 14 18 5f  D.A...._UID...._
  1bc0: 53 54 41 00 a0 0c 7b 50 49 52 42 0a 80 00 a4 0a  STA...{PIRB.....
  1bd0: 09 a1 04 a4 0a 0b 14 11 5f 44 49 53 00 7d 50 49  ........_DIS.}PI
  1be0: 52 42 0a 80 50 49 52 42 14 46 04 5f 43 52 53 00  RB..PIRB.F._CRS.
  1bf0: 08 42 55 46 30 11 09 0a 06 23 01 00 18 79 00 8b  .BUF0....#...y..
  1c00: 42 55 46 30 0a 01 49 52 51 57 a0 0c 7b 50 49 52  BUF0..IRQW..{PIR
  1c10: 42 0a 80 00 70 00 60 a1 04 70 01 60 79 60 7b 50  B...p.`..p.`y`{P
  1c20: 49 52 42 0a 0f 00 49 52 51 57 a4 42 55 46 30 08  IRB...IRQW.BUF0.
  1c30: 5f 50 52 53 11 09 0a 06 23 a0 0c 18 79 00 14 31  _PRS....#...y..1
  1c40: 5f 53 52 53 01 8b 68 0a 01 49 52 51 57 82 49 52  _SRS..h..IRQW.IR
  1c50: 51 57 60 a0 0f 92 93 49 52 51 57 00 7b 60 0a 7f  QW`....IRQW.{`..
  1c60: 60 76 60 a1 06 7d 60 0a 80 60 70 60 50 49 52 42  `v`..}`..`p`PIRB
  1c70: 5b 82 4a 0c 4c 4e 4b 43 08 5f 48 49 44 0c 41 d0  [.J.LNKC._HID.A.
  1c80: 0c 0f 08 5f 55 49 44 0a 03 14 18 5f 53 54 41 00  ..._UID...._STA.
  1c90: a0 0c 7b 50 49 52 43 0a 80 00 a4 0a 09 a1 04 a4  ..{PIRC.........
  1ca0: 0a 0b 14 11 5f 44 49 53 00 7d 50 49 52 43 0a 80  ...._DIS.}PIRC..
  1cb0: 50 49 52 43 14 46 04 5f 43 52 53 00 08 42 55 46  PIRC.F._CRS..BUF
  1cc0: 30 11 09 0a 06 23 01 00 18 79 00 8b 42 55 46 30  0....#...y..BUF0
  1cd0: 0a 01 49 52 51 57 a0 0c 7b 50 49 52 43 0a 80 00  ..IRQW..{PIRC...
  1ce0: 70 00 60 a1 04 70 01 60 79 60 7b 50 49 52 43 0a  p.`..p.`y`{PIRC.
  1cf0: 0f 00 49 52 51 57 a4 42 55 46 30 08 5f 50 52 53  ..IRQW.BUF0._PRS
  1d00: 11 09 0a 06 23 a0 0c 18 79 00 14 31 5f 53 52 53  ....#...y..1_SRS
  1d10: 01 8b 68 0a 01 49 52 51 57 82 49 52 51 57 60 a0  ..h..IRQW.IRQW`.
  1d20: 0f 92 93 49 52 51 57 00 7b 60 0a 7f 60 76 60 a1  ...IRQW.{`..`v`.
  1d30: 06 7d 60 0a 80 60 70 60 50 49 52 43 5b 82 4a 0c  .}`..`p`PIRC[.J.
  1d40: 4c 4e 4b 44 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  LNKD._HID.A...._
  1d50: 55 49 44 0a 04 14 18 5f 53 54 41 00 a0 0c 7b 50  UID...._STA...{P
  1d60: 49 52 44 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 14 11  IRD.............
  1d70: 5f 44 49 53 00 7d 50 49 52 44 0a 80 50 49 52 44  _DIS.}PIRD..PIRD
  1d80: 14 46 04 5f 43 52 53 00 08 42 55 46 30 11 09 0a  .F._CRS..BUF0...
  1d90: 06 23 01 00 18 79 00 8b 42 55 46 30 0a 01 49 52  .#...y..BUF0..IR
  1da0: 51 57 a0 0c 7b 50 49 52 44 0a 80 00 70 00 60 a1  QW..{PIRD...p.`.
  1db0: 04 70 01 60 79 60 7b 50 49 52 44 0a 0f 00 49 52  .p.`y`{PIRD...IR
  1dc0: 51 57 a4 42 55 46 30 08 5f 50 52 53 11 09 0a 06  QW.BUF0._PRS....
  1dd0: 23 a0 0c 18 79 00 14 31 5f 53 52 53 01 8b 68 0a  #...y..1_SRS..h.
  1de0: 01 49 52 51 57 82 49 52 51 57 60 a0 0f 92 93 49  .IRQW.IRQW`....I
  1df0: 52 51 57 00 7b 60 0a 7f 60 76 60 a1 06 7d 60 0a  RQW.{`..`v`..}`.
  1e00: 80 60 70 60 50 49 52 44 5b 82 4a 0c 4c 4e 4b 45  .`p`PIRD[.J.LNKE
  1e10: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  1e20: 05 14 18 5f 53 54 41 00 a0 0c 7b 50 49 52 45 0a  ..._STA...{PIRE.
  1e30: 80 00 a4 0a 09 a1 04 a4 0a 0b 14 11 5f 44 49 53  ............_DIS
  1e40: 00 7d 50 49 52 45 0a 80 50 49 52 45 14 46 04 5f  .}PIRE..PIRE.F._
  1e50: 43 52 53 00 08 42 55 46 30 11 09 0a 06 23 01 00  CRS..BUF0....#..
  1e60: 18 79 00 8b 42 55 46 30 0a 01 49 52 51 57 a0 0c  .y..BUF0..IRQW..
  1e70: 7b 50 49 52 45 0a 80 00 70 00 60 a1 04 70 01 60  {PIRE...p.`..p.`
  1e80: 79 60 7b 50 49 52 45 0a 0f 00 49 52 51 57 a4 42  y`{PIRE...IRQW.B
  1e90: 55 46 30 08 5f 50 52 53 11 09 0a 06 23 a0 0c 18  UF0._PRS....#...
  1ea0: 79 00 14 31 5f 53 52 53 01 8b 68 0a 01 49 52 51  y..1_SRS..h..IRQ
  1eb0: 57 82 49 52 51 57 60 a0 0f 92 93 49 52 51 57 00  W.IRQW`....IRQW.
  1ec0: 7b 60 0a 7f 60 76 60 a1 06 7d 60 0a 80 60 70 60  {`..`v`..}`..`p`
  1ed0: 50 49 52 45 5b 82 4a 0c 4c 4e 4b 46 08 5f 48 49  PIRE[.J.LNKF._HI
  1ee0: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 06 14 18 5f  D.A...._UID...._
  1ef0: 53 54 41 00 a0 0c 7b 50 49 52 46 0a 80 00 a4 0a  STA...{PIRF.....
  1f00: 09 a1 04 a4 0a 0b 14 11 5f 44 49 53 00 7d 50 49  ........_DIS.}PI
  1f10: 52 46 0a 80 50 49 52 46 14 46 04 5f 43 52 53 00  RF..PIRF.F._CRS.
  1f20: 08 42 55 46 30 11 09 0a 06 23 01 00 18 79 00 8b  .BUF0....#...y..
  1f30: 42 55 46 30 0a 01 49 52 51 57 a0 0c 7b 50 49 52  BUF0..IRQW..{PIR
  1f40: 46 0a 80 00 70 00 60 a1 04 70 01 60 79 60 7b 50  F...p.`..p.`y`{P
  1f50: 49 52 46 0a 0f 00 49 52 51 57 a4 42 55 46 30 08  IRF...IRQW.BUF0.
  1f60: 5f 50 52 53 11 09 0a 06 23 a0 0c 18 79 00 14 31  _PRS....#...y..1
  1f70: 5f 53 52 53 01 8b 68 0a 01 49 52 51 57 82 49 52  _SRS..h..IRQW.IR
  1f80: 51 57 60 a0 0f 92 93 49 52 51 57 00 7b 60 0a 7f  QW`....IRQW.{`..
  1f90: 60 76 60 a1 06 7d 60 0a 80 60 70 60 50 49 52 46  `v`..}`..`p`PIRF
  1fa0: 5b 82 4a 0c 4c 4e 4b 47 08 5f 48 49 44 0c 41 d0  [.J.LNKG._HID.A.
  1fb0: 0c 0f 08 5f 55 49 44 0a 07 14 18 5f 53 54 41 00  ..._UID...._STA.
  1fc0: a0 0c 7b 50 49 52 47 0a 80 00 a4 0a 09 a1 04 a4  ..{PIRG.........
  1fd0: 0a 0b 14 11 5f 44 49 53 00 7d 50 49 52 47 0a 80  ...._DIS.}PIRG..
  1fe0: 50 49 52 47 14 46 04 5f 43 52 53 00 08 42 55 46  PIRG.F._CRS..BUF
  1ff0: 30 11 09 0a 06 23 01 00 18 79 00 8b 42 55 46 30  0....#...y..BUF0
  2000: 0a 01 49 52 51 57 a0 0c 7b 50 49 52 47 0a 80 00  ..IRQW..{PIRG...
  2010: 70 00 60 a1 04 70 01 60 79 60 7b 50 49 52 47 0a  p.`..p.`y`{PIRG.
  2020: 0f 00 49 52 51 57 a4 42 55 46 30 08 5f 50 52 53  ..IRQW.BUF0._PRS
  2030: 11 09 0a 06 23 a0 0c 18 79 00 14 31 5f 53 52 53  ....#...y..1_SRS
  2040: 01 8b 68 0a 01 49 52 51 57 82 49 52 51 57 60 a0  ..h..IRQW.IRQW`.
  2050: 0f 92 93 49 52 51 57 00 7b 60 0a 7f 60 76 60 a1  ...IRQW.{`..`v`.
  2060: 06 7d 60 0a 80 60 70 60 50 49 52 47 5b 82 4a 0c  .}`..`p`PIRG[.J.
  2070: 4c 4e 4b 48 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  LNKH._HID.A...._
  2080: 55 49 44 0a 08 14 18 5f 53 54 41 00 a0 0c 7b 50  UID...._STA...{P
  2090: 49 52 48 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 14 11  IRH.............
  20a0: 5f 44 49 53 00 7d 50 49 52 48 0a 80 50 49 52 48  _DIS.}PIRH..PIRH
  20b0: 14 46 04 5f 43 52 53 00 08 42 55 46 30 11 09 0a  .F._CRS..BUF0...
  20c0: 06 23 01 00 18 79 00 8b 42 55 46 30 0a 01 49 52  .#...y..BUF0..IR
  20d0: 51 57 a0 0c 7b 50 49 52 48 0a 80 00 70 00 60 a1  QW..{PIRH...p.`.
  20e0: 04 70 01 60 79 60 7b 50 49 52 48 0a 0f 00 49 52  .p.`y`{PIRH...IR
  20f0: 51 57 a4 42 55 46 30 08 5f 50 52 53 11 09 0a 06  QW.BUF0._PRS....
  2100: 23 a0 0c 18 79 00 14 31 5f 53 52 53 01 8b 68 0a  #...y..1_SRS..h.
  2110: 01 49 52 51 57 82 49 52 51 57 60 a0 0f 92 93 49  .IRQW.IRQW`....I
  2120: 52 51 57 00 7b 60 0a 7f 60 76 60 a1 06 7d 60 0a  RQW.{`..`v`..}`.
  2130: 80 60 70 60 50 49 52 48 5b 82 4e 04 44 4d 41 43  .`p`PIRH[.N.DMAC
  2140: 08 5f 48 49 44 0c 41 d0 02 00 08 5f 43 52 53 11  ._HID.A...._CRS.
  2150: 38 0a 35 47 01 00 00 00 00 00 10 47 01 81 00 81  8.5G.......G....
  2160: 00 00 03 47 01 87 00 87 00 00 01 47 01 89 00 89  ...G.......G....
  2170: 00 00 03 47 01 8f 00 8f 00 00 01 47 01 c0 00 c0  ...G.......G....
  2180: 00 00 20 2a 10 04 79 00 5b 82 2d 52 54 43 5f 08  .. *..y.[.-RTC_.
  2190: 5f 48 49 44 0c 41 d0 0b 00 08 5f 43 52 53 11 18  _HID.A...._CRS..
  21a0: 0a 15 47 01 70 00 70 00 01 02 47 01 74 00 74 00  ..G.p.p...G.t.t.
  21b0: 01 04 22 00 01 79 00 5b 82 33 50 49 43 5f 08 5f  .."..y.[.3PIC_._
  21c0: 48 49 44 0b 41 d0 08 5f 43 52 53 11 20 0a 1d 47  HID.A.._CRS. ..G
  21d0: 01 20 00 20 00 01 1e 47 01 a0 00 a0 00 01 1e 47  . . ...G.......G
  21e0: 01 d0 04 d0 04 01 02 22 04 00 79 00 5b 82 25 46  ......."..y.[.%F
  21f0: 50 55 5f 08 5f 48 49 44 0c 41 d0 0c 04 08 5f 43  PU_._HID.A...._C
  2200: 52 53 11 10 0a 0d 47 01 f0 00 f0 00 00 10 22 00  RS....G.......".
  2210: 20 79 00 5b 82 2d 54 4d 52 5f 08 5f 48 49 44 0c   y.[.-TMR_._HID.
  2220: 41 d0 01 00 08 5f 43 52 53 11 18 0a 15 47 01 40  A...._CRS....G.@
  2230: 00 40 00 01 04 47 01 50 00 50 00 01 04 22 01 00  .@...G.P.P..."..
  2240: 79 00 5b 82 22 53 50 4b 52 08 5f 48 49 44 0c 41  y.[."SPKR._HID.A
  2250: d0 08 00 08 5f 43 52 53 11 0d 0a 0a 47 01 61 00  ...._CRS....G.a.
  2260: 61 00 01 01 79 00 5b 82 4c 08 58 54 52 41 08 5f  a...y.[.L.XTRA._
  2270: 48 49 44 0c 41 d0 0c 02 08 5f 43 52 53 11 46 07  HID.A...._CRS.F.
  2280: 0a 72 47 01 00 05 00 05 01 40 47 01 00 04 00 04  .rG......@G.....
  2290: 01 80 47 01 92 00 92 00 01 01 47 01 00 08 00 08  ..G.......G.....
  22a0: 01 80 47 01 10 00 10 00 01 10 47 01 72 00 72 00  ..G.......G.r.r.
  22b0: 01 02 47 01 80 00 80 00 01 01 47 01 84 00 84 00  ..G.......G.....
  22c0: 01 03 47 01 88 00 88 00 01 01 47 01 8c 00 8c 00  ..G.......G.....
  22d0: 01 03 47 01 90 00 90 00 01 10 47 01 a0 0c a0 0c  ..G.......G.....
  22e0: 01 10 47 01 61 01 61 01 01 01 47 01 62 01 62 01  ..G.a.a...G.b.b.
  22f0: 01 01 79 00 5b 80 42 47 50 53 01 0b 4e 08 0a 01  ..y.[.BGPS..N...
  2300: 5b 81 0b 42 47 50 53 01 49 4f 53 54 08 5b 01 4d  [..BGPS.IOST.[.M
  2310: 55 54 30 00 14 14 45 4e 46 47 01 5b 23 4d 55 54  UT0...ENFG.[#MUT
  2320: 30 ff 0f 70 68 4c 44 4e 5f 14 0c 45 58 46 47 00  0..phLDN_..EXFG.
  2330: 5b 27 4d 55 54 30 14 2b 45 4d 50 41 00 70 5c 2f  ['MUT0.+EMPA.p\/
  2340: 04 5f 53 42 5f 50 43 49 30 50 42 49 46 50 44 53  ._SB_PCI0PBIFPDS
  2350: 30 60 7b 60 0a 01 60 a0 05 60 a4 0a 01 a1 04 a4  0`{`..`..`......
  2360: 0a 00 14 30 50 54 53 5f 01 45 4e 46 47 0a 06 7d  ...0PTS_.ENFG..}
  2370: 49 4e 54 52 0a 10 49 4e 54 52 45 58 46 47 45 4e  INTR..INTREXFGEN
  2380: 46 47 0a 05 7d 49 4e 54 52 0a 10 49 4e 54 52 45  FG..}INTR..INTRE
  2390: 58 46 47 14 30 57 41 4b 5f 01 45 4e 46 47 0a 06  XFG.0WAK_.ENFG..
  23a0: 7b 49 4e 54 52 0a ef 49 4e 54 52 45 58 46 47 45  {INTR..INTREXFGE
  23b0: 4e 46 47 0a 05 7b 49 4e 54 52 0a ef 49 4e 54 52  NFG..{INTR..INTR
  23c0: 45 58 46 47 5b 82 3d 50 53 32 4d 08 5f 48 49 44  EXFG[.=PS2M._HID
  23d0: 0c 41 d0 0f 03 08 5f 43 49 44 0c 41 d0 0f 13 08  .A...._CID.A....
  23e0: 5f 50 52 57 12 06 02 0a 3b 0a 01 14 09 5f 53 54  _PRW....;...._ST
  23f0: 41 00 a4 0a 0f 08 5f 43 52 53 11 08 0a 05 22 00  A....._CRS....".
  2400: 10 79 00 5b 82 4e 04 50 53 32 4b 08 5f 48 49 44  .y.[.N.PS2K._HID
  2410: 0c 41 d0 03 03 08 5f 43 49 44 0c 41 d0 03 0b 08  .A...._CID.A....
  2420: 5f 50 52 57 12 06 02 0a 3a 0a 01 14 09 5f 53 54  _PRW....:...._ST
  2430: 41 00 a4 0a 0f 08 5f 43 52 53 11 18 0a 15 47 01  A....._CRS....G.
  2440: 60 00 60 00 01 01 47 01 64 00 64 00 01 01 22 02  `.`...G.d.d...".
  2450: 00 79 00 5b 82 43 0c 55 41 52 31 08 5f 55 49 44  .y.[.C.UAR1._UID
  2460: 0a 01 08 5f 48 49 44 0c 41 d0 05 01 14 0d 5f 53  ..._HID.A....._S
  2470: 54 41 00 a4 44 53 54 41 0a 03 14 0e 5f 44 49 53  TA..DSTA...._DIS
  2480: 00 44 43 4e 54 0a 03 0a 00 14 0f 5f 43 52 53 00  .DCNT......_CRS.
  2490: a4 44 43 52 53 0a 03 0a 00 14 0d 5f 53 52 53 01  .DCRS......_SRS.
  24a0: 44 53 52 53 68 0a 03 14 0b 5f 50 52 53 00 a4 43  DSRSh...._PRS..C
  24b0: 4d 50 52 08 5f 50 52 57 12 06 02 0a 30 0a 05 08  MPR._PRW....0...
  24c0: 43 4d 50 52 11 43 05 0a 4f 31 00 47 01 f8 03 f8  CMPR.C..O1.G....
  24d0: 03 01 08 22 10 00 2a 00 00 30 47 01 f8 03 f8 03  ..."..*..0G.....
  24e0: 01 08 22 f8 1c 2a 00 00 30 47 01 f8 02 f8 02 01  .."..*..0G......
  24f0: 08 22 f8 1c 2a 00 00 30 47 01 e8 03 e8 03 01 08  ."..*..0G.......
  2500: 22 f8 1c 2a 00 00 30 47 01 e8 02 e8 02 01 08 22  "..*..0G......."
  2510: f8 1c 2a 00 00 38 79 00 5b 82 4c 0c 55 41 52 32  ..*..8y.[.L.UAR2
  2520: 08 5f 55 49 44 0a 02 08 5f 48 49 44 0c 41 d0 05  ._UID..._HID.A..
  2530: 01 14 16 5f 53 54 41 00 a0 08 45 4d 50 41 a4 0a  ..._STA...EMPA..
  2540: 00 a4 44 53 54 41 0a 02 14 0e 5f 44 49 53 00 44  ..DSTA...._DIS.D
  2550: 43 4e 54 0a 02 0a 00 14 0f 5f 43 52 53 00 a4 44  CNT......_CRS..D
  2560: 43 52 53 0a 02 0a 00 14 0d 5f 53 52 53 01 44 53  CRS......_SRS.DS
  2570: 52 53 68 0a 02 14 0b 5f 50 52 53 00 a4 43 4d 50  RSh...._PRS..CMP
  2580: 52 08 5f 50 52 57 12 06 02 0a 31 0a 05 08 43 4d  R._PRW....1...CM
  2590: 50 52 11 43 05 0a 4f 31 00 47 01 f8 02 f8 02 01  PR.C..O1.G......
  25a0: 08 22 08 00 2a 00 00 30 47 01 f8 03 f8 03 01 08  ."..*..0G.......
  25b0: 22 f8 1c 2a 00 00 30 47 01 f8 02 f8 02 01 08 22  "..*..0G......."
  25c0: f8 1c 2a 00 00 30 47 01 e8 03 e8 03 01 08 22 f8  ..*..0G.......".
  25d0: 1c 2a 00 00 30 47 01 e8 02 e8 02 01 08 22 f8 1c  .*..0G......."..
  25e0: 2a 00 00 38 79 00 5b 80 49 4f 49 44 01 0a 2e 0a  *..8y.[.IOID....
  25f0: 02 5b 81 10 49 4f 49 44 01 49 4e 44 58 08 44 41  .[..IOID.INDX.DA
  2600: 54 41 08 5b 86 42 05 49 4e 44 58 44 41 54 41 01  TA.[.B.INDXDATA.
  2610: 00 38 4c 44 4e 5f 08 00 40 14 41 43 54 52 08 00  .8LDN_..@.ACTR..
  2620: 48 17 49 4f 41 48 08 49 4f 41 4c 08 49 4f 48 32  H.IOAH.IOAL.IOH2
  2630: 08 49 4f 4c 32 08 00 40 06 49 4e 54 52 08 00 18  .IOL2..@.INTR...
  2640: 44 4d 43 48 08 00 48 3d 4f 50 54 30 08 4f 50 54  DMCH..H=OPT0.OPT
  2650: 31 08 4f 50 54 32 08 14 42 06 44 53 54 41 01 45  1.OPT2..B.DSTA.E
  2660: 4e 46 47 68 70 41 43 54 52 60 45 58 46 47 a0 08  NFGhpACTR`EXFG..
  2670: 93 60 0a ff a4 0a 00 7b 60 0a 01 60 a0 08 94 68  .`.....{`..`...h
  2680: 0a 07 a4 0a 00 7b 49 4f 53 54 0a 0c 49 4f 53 54  .....{IOST..IOST
  2690: 7d 49 4f 53 54 79 60 68 00 49 4f 53 54 a0 05 60  }IOSTy`h.IOST..`
  26a0: a4 0a 0f a1 16 a0 0f 7b 79 0a 01 68 00 49 4f 53  .......{y..h.IOS
  26b0: 54 00 a4 0a 0d a1 04 a4 0a 00 14 24 44 43 4e 54  T..........$DCNT
  26c0: 02 45 4e 46 47 68 79 49 4f 41 48 0a 08 61 7d 49  .ENFGhyIOAH..a}I
  26d0: 4f 41 4c 61 61 70 69 41 43 54 52 45 58 46 47 08  OALaapiACTREXFG.
  26e0: 43 52 53 31 11 13 0a 10 47 01 00 00 00 00 01 00  CRS1....G.......
  26f0: 22 00 00 2a 00 00 79 00 8b 43 52 53 31 0a 09 49  "..*..y..CRS1..I
  2700: 52 51 4d 8c 43 52 53 31 0a 0c 44 4d 41 4d 8b 43  RQM.CRS1..DMAM.C
  2710: 52 53 31 0a 02 49 4f 31 31 8b 43 52 53 31 0a 04  RS1..IO11.CRS1..
  2720: 49 4f 31 32 8c 43 52 53 31 0a 07 4c 45 4e 31 08  IO12.CRS1..LEN1.
  2730: 43 52 53 32 11 1b 0a 18 47 01 00 00 00 00 01 00  CRS2....G.......
  2740: 47 01 00 00 00 00 01 00 22 40 00 2a 04 00 79 00  G......."@.*..y.
  2750: 8b 43 52 53 32 0a 11 49 52 51 45 8c 43 52 53 32  .CRS2..IRQE.CRS2
  2760: 0a 14 44 4d 41 45 8b 43 52 53 32 0a 02 49 4f 32  ..DMAE.CRS2..IO2
  2770: 31 8b 43 52 53 32 0a 04 49 4f 32 32 8c 43 52 53  1.CRS2..IO22.CRS
  2780: 32 0a 07 4c 45 4e 32 8b 43 52 53 32 0a 0a 49 4f  2..LEN2.CRS2..IO
  2790: 33 31 8b 43 52 53 32 0a 0c 49 4f 33 32 8c 43 52  31.CRS2..IO32.CR
  27a0: 53 32 0a 0f 4c 45 4e 33 14 49 08 44 43 52 53 02  S2..LEN3.I.DCRS.
  27b0: 45 4e 46 47 68 79 49 4f 41 48 0a 08 49 4f 31 31  ENFGhyIOAH..IO11
  27c0: 7d 49 4f 41 4c 49 4f 31 31 49 4f 31 31 70 49 4f  }IOALIO11IO11pIO
  27d0: 31 31 49 4f 31 32 74 82 49 4f 31 31 00 0a 01 60  11IO12t.IO11...`
  27e0: 79 0a 01 60 4c 45 4e 31 a0 10 49 4e 54 52 79 0a  y..`LEN1..INTRy.
  27f0: 01 49 4e 54 52 49 52 51 4d a1 08 70 0a 00 49 52  .INTRIRQM..p..IR
  2800: 51 4d a0 14 91 94 44 4d 43 48 0a 03 93 69 0a 00  QM....DMCH...i..
  2810: 70 0a 00 44 4d 41 4d a1 11 7b 44 4d 43 48 0a 03  p..DMAM..{DMCH..
  2820: 61 79 0a 01 61 44 4d 41 4d 45 58 46 47 a4 43 52  ay..aDMAMEXFG.CR
  2830: 53 31 14 4f 07 44 53 52 53 02 8b 68 0a 09 49 52  S1.O.DSRS..h..IR
  2840: 51 4d 8c 68 0a 0c 44 4d 41 4d 8b 68 0a 02 49 4f  QM.h..DMAM.h..IO
  2850: 31 31 45 4e 46 47 69 7b 49 4f 31 31 0a ff 49 4f  11ENFGi{IO11..IO
  2860: 41 4c 7a 49 4f 31 31 0a 08 49 4f 41 48 a0 13 49  ALzIO11..IOAH..I
  2870: 52 51 4d 82 49 52 51 4d 60 74 60 0a 01 49 4e 54  RQM.IRQM`t`..INT
  2880: 52 a1 08 70 0a 00 49 4e 54 52 a0 13 44 4d 41 4d  R..p..INTR..DMAM
  2890: 82 44 4d 41 4d 60 74 60 0a 01 44 4d 43 48 a1 08  .DMAM`t`..DMCH..
  28a0: 70 0a 04 44 4d 43 48 45 58 46 47 44 43 4e 54 69  p..DMCHEXFGDCNTi
  28b0: 0a 01 5b 82 44 0b 48 50 45 54 08 5f 48 49 44 0c  ..[.D.HPET._HID.
  28c0: 41 d0 01 03 08 43 52 53 5f 11 11 0a 0e 86 09 00  A....CRS_.......
  28d0: 00 00 00 d0 fe 00 04 00 00 79 00 5b 80 48 50 54  .........y.[.HPT
  28e0: 4d 00 0c 04 f4 d1 fe 0a 01 5b 81 12 48 50 54 4d  M........[..HPTM
  28f0: 01 48 50 54 53 02 00 05 48 50 54 45 01 14 12 5f  .HPTS...HPTE..._
  2900: 53 54 41 00 a0 08 48 50 54 45 a4 0a 0f a4 0a 00  STA...HPTE......
  2910: 14 47 05 5f 43 52 53 00 a0 4a 04 48 50 54 45 8a  .G._CRS..J.HPTE.
  2920: 43 52 53 5f 0a 00 48 50 54 5f a0 12 93 48 50 54  CRS_..HPT_...HPT
  2930: 53 0a 01 70 0c 00 10 d0 fe 48 50 54 5f a0 12 93  S..p.....HPT_...
  2940: 48 50 54 53 0a 02 70 0c 00 20 d0 fe 48 50 54 5f  HPTS..p.. ..HPT_
  2950: a0 12 93 48 50 54 53 0a 03 70 0c 00 30 d0 fe 48  ...HPTS..p..0..H
  2960: 50 54 5f a4 43 52 53 5f 5b 82 26 41 50 49 43 08  PT_.CRS_[.&APIC.
  2970: 5f 48 49 44 0c 41 d0 00 03 08 5f 43 52 53 11 11  _HID.A...._CRS..
  2980: 0a 0e 86 09 00 00 00 00 c0 fe 00 01 00 00 79 00  ..............y.
  2990: 5b 82 4f 05 55 48 43 31 08 5f 41 44 52 0c 00 00  [.O.UHC1._ADR...
  29a0: 1d 00 08 55 50 53 31 12 06 02 0a 03 0a 01 14 0b  ...UPS1.........
  29b0: 5f 50 52 57 00 a4 55 50 53 31 5b 80 55 53 42 52  _PRW..UPS1[.USBR
  29c0: 02 0a c4 0a 01 5b 81 0b 55 53 42 52 01 55 52 45  .....[..USBR.URE
  29d0: 53 08 14 1e 5f 50 53 57 01 a0 0b 93 68 00 70 0a  S..._PSW....h.p.
  29e0: 00 55 52 45 53 a0 0b 93 68 01 70 0a 03 55 52 45  .URES...h.p..URE
  29f0: 53 5b 82 4f 05 55 48 43 32 08 5f 41 44 52 0c 01  S[.O.UHC2._ADR..
  2a00: 00 1d 00 08 55 50 53 31 12 06 02 0a 04 0a 01 14  ....UPS1........
  2a10: 0b 5f 50 52 57 00 a4 55 50 53 31 5b 80 55 53 42  ._PRW..UPS1[.USB
  2a20: 52 02 0a c4 0a 01 5b 81 0b 55 53 42 52 01 55 52  R.....[..USBR.UR
  2a30: 45 53 08 14 1e 5f 50 53 57 01 a0 0b 93 68 00 70  ES..._PSW....h.p
  2a40: 0a 00 55 52 45 53 a0 0b 93 68 01 70 0a 03 55 52  ..URES...h.p..UR
  2a50: 45 53 5b 82 4f 05 55 48 43 33 08 5f 41 44 52 0c  ES[.O.UHC3._ADR.
  2a60: 02 00 1d 00 08 55 50 53 31 12 06 02 0a 0c 0a 01  .....UPS1.......
  2a70: 14 0b 5f 50 52 57 00 a4 55 50 53 31 5b 80 55 53  .._PRW..UPS1[.US
  2a80: 42 52 02 0a c4 0a 01 5b 81 0b 55 53 42 52 01 55  BR.....[..USBR.U
  2a90: 52 45 53 08 14 1e 5f 50 53 57 01 a0 0b 93 68 00  RES..._PSW....h.
  2aa0: 70 0a 00 55 52 45 53 a0 0b 93 68 01 70 0a 03 55  p..URES...h.p..U
  2ab0: 52 45 53 5b 82 4f 05 55 48 43 34 08 5f 41 44 52  RES[.O.UHC4._ADR
  2ac0: 0c 03 00 1d 00 08 55 50 53 31 12 06 02 0a 0e 0a  ......UPS1......
  2ad0: 01 14 0b 5f 50 52 57 00 a4 55 50 53 31 5b 80 55  ..._PRW..UPS1[.U
  2ae0: 53 42 52 02 0a c4 0a 01 5b 81 0b 55 53 42 52 01  SBR.....[..USBR.
  2af0: 55 52 45 53 08 14 1e 5f 50 53 57 01 a0 0b 93 68  URES..._PSW....h
  2b00: 00 70 0a 00 55 52 45 53 a0 0b 93 68 01 70 0a 03  .p..URES...h.p..
  2b10: 55 52 45 53 5b 82 3f 45 48 43 49 08 5f 41 44 52  URES[.?EHCI._ADR
  2b20: 0c 07 00 1d 00 08 55 50 53 31 12 06 02 0a 0d 0a  ......UPS1......
  2b30: 01 14 0b 5f 50 52 57 00 a4 55 50 53 31 5b 80 55  ..._PRW..UPS1[.U
  2b40: 53 42 52 02 0a c4 0a 01 5b 81 0b 55 53 42 52 01  SBR.....[..USBR.
  2b50: 55 52 45 53 08 5b 82 47 d0 49 44 45 30 08 5f 41  URES.[.G.IDE0._A
  2b60: 44 52 0c 01 00 1f 00 08 52 45 47 46 0a 01 14 12  DR......REGF....
  2b70: 5f 52 45 47 02 a0 0b 93 68 0a 02 70 69 52 45 47  _REG....h..piREG
  2b80: 46 08 54 49 4d 30 12 48 06 08 12 0b 04 0a 78 0a  F.TIM0.H......x.
  2b90: b4 0a f0 0b 84 03 12 0a 04 0a 23 0a 21 0a 10 0a  ..........#.!...
  2ba0: 00 12 0a 04 0a 0b 0a 09 0a 04 0a 00 12 0e 06 0a  ................
  2bb0: 70 0a 49 0a 36 0a 27 0a 19 0a 11 12 0e 06 0a 00  p.I.6.'.........
  2bc0: 0a 01 0a 02 0a 01 0a 02 0a 01 12 0e 06 0a 00 0a  ................
  2bd0: 00 0a 00 0a 01 0a 01 0a 01 12 0a 04 0a 04 0a 03  ................
  2be0: 0a 02 0a 00 12 0a 04 0a 02 0a 01 0a 00 0a 00 08  ................
  2bf0: 54 4d 44 30 11 03 0a 14 8a 54 4d 44 30 0a 00 50  TMD0.....TMD0..P
  2c00: 49 4f 30 8a 54 4d 44 30 0a 04 44 4d 41 30 8a 54  IO0.TMD0..DMA0.T
  2c10: 4d 44 30 0a 08 50 49 4f 31 8a 54 4d 44 30 0a 0c  MD0..PIO1.TMD0..
  2c20: 44 4d 41 31 8a 54 4d 44 30 0a 10 43 48 4e 46 5b  DMA1.TMD0..CHNF[
  2c30: 80 43 46 47 32 02 0a 40 0a 20 5b 81 48 0a 43 46  .CFG2..@. [.H.CF
  2c40: 47 32 03 50 4d 50 54 04 50 53 50 54 04 50 4d 52  G2.PMPT.PSPT.PMR
  2c50: 49 06 00 02 53 4d 50 54 04 53 53 50 54 04 53 4d  I...SMPT.SSPT.SM
  2c60: 52 49 06 00 02 50 53 52 49 04 53 53 52 49 04 00  RI...PSRI.SSRI..
  2c70: 18 50 4d 33 45 01 50 53 33 45 01 53 4d 33 45 01  .PM3E.PS3E.SM3E.
  2c80: 53 53 33 45 01 00 0c 50 4d 55 54 02 00 02 50 53  SS3E...PMUT...PS
  2c90: 55 54 02 00 02 53 4d 55 54 02 00 02 53 53 55 54  UT...SMUT...SSUT
  2ca0: 02 00 02 00 40 04 50 4d 36 45 01 50 53 36 45 01  ....@.PM6E.PS6E.
  2cb0: 53 4d 36 45 01 53 53 36 45 01 50 4d 43 52 01 50  SM6E.SS6E.PMCR.P
  2cc0: 53 43 52 01 53 4d 43 52 01 53 53 43 52 01 00 04  SCR.SMCR.SSCR...
  2cd0: 50 4d 41 45 01 50 53 41 45 01 53 4d 41 45 01 53  PMAE.PSAE.SMAE.S
  2ce0: 53 41 45 01 08 47 4d 50 54 0a 00 08 47 4d 55 45  SAE..GMPT...GMUE
  2cf0: 0a 00 08 47 4d 55 54 0a 00 08 47 4d 43 52 0a 00  ...GMUT...GMCR..
  2d00: 08 47 53 50 54 0a 00 08 47 53 55 45 0a 00 08 47  .GSPT...GSUE...G
  2d10: 53 55 54 0a 00 08 47 53 43 52 0a 00 5b 82 47 24  SUT...GSCR..[.G$
  2d20: 43 48 4e 30 08 5f 41 44 52 0a 00 14 4c 07 5f 47  CHN0._ADR...L._G
  2d30: 54 4d 00 79 50 53 43 52 0a 01 61 7d 50 4d 43 52  TM.yPSCR..a}PMCR
  2d40: 61 60 79 50 4d 41 45 0a 02 63 79 50 4d 36 45 0a  a`yPMAE..cyPM6E.
  2d50: 01 64 7d 63 64 63 7d 50 4d 33 45 63 61 79 50 4d  .d}cdc}PM3EcayPM
  2d60: 50 54 0a 04 63 7d 61 63 61 79 50 53 41 45 0a 02  PT..c}acayPSAE..
  2d70: 63 79 50 53 36 45 0a 01 64 7d 63 64 63 7d 50 53  cyPS6E..d}cdc}PS
  2d80: 33 45 63 62 79 50 53 50 54 0a 04 63 7d 62 63 62  3EcbyPSPT..c}bcb
  2d90: a4 47 54 4d 5f 50 4d 52 49 61 50 4d 55 54 50 53  .GTM_PMRIaPMUTPS
  2da0: 52 49 62 50 53 55 54 60 14 40 18 5f 53 54 4d 03  RIbPSUT`.@._STM.
  2db0: 70 68 5b 31 70 68 54 4d 44 30 79 50 4d 41 45 0a  ph[1phTMD0yPMAE.
  2dc0: 02 63 79 50 4d 36 45 0a 01 64 7d 63 64 63 7d 50  .cyPM6E..d}cdc}P
  2dd0: 4d 33 45 63 60 79 50 4d 50 54 0a 04 63 7d 60 63  M3Ec`yPMPT..c}`c
  2de0: 60 79 50 53 41 45 0a 02 63 79 50 53 36 45 0a 01  `yPSAE..cyPS6E..
  2df0: 64 7d 63 64 63 7d 50 53 33 45 63 61 79 50 53 50  d}cdc}PS3EcayPSP
  2e00: 54 0a 04 63 7d 61 63 61 70 50 4d 52 49 47 4d 50  T..c}acapPMRIGMP
  2e10: 54 70 60 47 4d 55 45 70 50 4d 55 54 47 4d 55 54  Tp`GMUEpPMUTGMUT
  2e20: 70 50 4d 43 52 47 4d 43 52 70 50 53 52 49 47 53  pPMCRGMCRpPSRIGS
  2e30: 50 54 70 61 47 53 55 45 70 50 53 55 54 47 53 55  PTpaGSUEpPSUTGSU
  2e40: 54 70 50 53 43 52 47 53 43 52 53 54 4d 5f 70 47  TpPSCRGSCRSTM_pG
  2e50: 4d 50 54 50 4d 52 49 70 47 4d 55 45 60 70 47 4d  MPTPMRIpGMUE`pGM
  2e60: 55 54 50 4d 55 54 70 47 4d 43 52 50 4d 43 52 70  UTPMUTpGMCRPMCRp
  2e70: 47 53 55 45 61 70 47 53 55 54 50 53 55 54 70 47  GSUEapGSUTPSUTpG
  2e80: 53 43 52 50 53 43 52 a0 0d 7b 60 0a 01 00 70 0a  SCRPSCR..{`...p.
  2e90: 01 50 4d 33 45 a1 08 70 0a 00 50 4d 33 45 a0 0d  .PM3E..p..PM3E..
  2ea0: 7b 60 0a 02 00 70 0a 01 50 4d 36 45 a1 08 70 0a  {`...p..PM6E..p.
  2eb0: 00 50 4d 36 45 a0 0d 7b 60 0a 04 00 70 0a 01 50  .PM6E..{`...p..P
  2ec0: 4d 41 45 a1 08 70 0a 00 50 4d 41 45 a0 0d 7b 61  MAE..p..PMAE..{a
  2ed0: 0a 01 00 70 0a 01 50 53 33 45 a1 08 70 0a 00 50  ...p..PS3E..p..P
  2ee0: 53 33 45 a0 0d 7b 61 0a 02 00 70 0a 01 50 53 36  S3E..{a...p..PS6
  2ef0: 45 a1 08 70 0a 00 50 53 36 45 a0 0d 7b 61 0a 04  E..p..PS6E..{a..
  2f00: 00 70 0a 01 50 53 41 45 a1 08 70 0a 00 50 53 41  .p..PSAE..p..PSA
  2f10: 45 70 47 54 46 5f 0a 00 69 41 54 41 30 70 47 54  EpGTF_..iATA0pGT
  2f20: 46 5f 0a 01 6a 41 54 41 31 5b 82 1c 44 52 56 30  F_..jATA1[..DRV0
  2f30: 08 5f 41 44 52 0a 00 14 0f 5f 47 54 46 00 a4 52  ._ADR...._GTF..R
  2f40: 41 54 41 41 54 41 30 5b 82 1c 44 52 56 31 08 5f  ATAATA0[..DRV1._
  2f50: 41 44 52 0a 01 14 0f 5f 47 54 46 00 a4 52 41 54  ADR...._GTF..RAT
  2f60: 41 41 54 41 31 5b 82 47 24 43 48 4e 31 08 5f 41  AATA1[.G$CHN1._A
  2f70: 44 52 0a 01 14 4c 07 5f 47 54 4d 00 79 53 53 43  DR...L._GTM.ySSC
  2f80: 52 0a 01 61 7d 53 4d 43 52 61 60 79 53 4d 41 45  R..a}SMCRa`ySMAE
  2f90: 0a 02 63 79 53 4d 36 45 0a 01 64 7d 63 64 63 7d  ..cySM6E..d}cdc}
  2fa0: 53 4d 33 45 63 61 79 53 4d 50 54 0a 04 63 7d 61  SM3EcaySMPT..c}a
  2fb0: 63 61 79 53 53 41 45 0a 02 63 79 53 53 36 45 0a  caySSAE..cySS6E.
  2fc0: 01 64 7d 63 64 63 7d 53 53 33 45 63 62 79 53 53  .d}cdc}SS3EcbySS
  2fd0: 50 54 0a 04 63 7d 62 63 62 a4 47 54 4d 5f 53 4d  PT..c}bcb.GTM_SM
  2fe0: 52 49 61 53 4d 55 54 53 53 52 49 62 53 53 55 54  RIaSMUTSSRIbSSUT
  2ff0: 60 14 40 18 5f 53 54 4d 03 70 68 5b 31 70 68 54  `.@._STM.ph[1phT
  3000: 4d 44 30 79 53 4d 41 45 0a 02 63 79 53 4d 36 45  MD0ySMAE..cySM6E
  3010: 0a 01 64 7d 63 64 63 7d 53 4d 33 45 63 60 79 53  ..d}cdc}SM3Ec`yS
  3020: 4d 50 54 0a 04 63 7d 60 63 60 79 53 53 41 45 0a  MPT..c}`c`ySSAE.
  3030: 02 63 79 53 53 36 45 0a 01 64 7d 63 64 63 7d 53  .cySS6E..d}cdc}S
  3040: 53 33 45 63 61 79 53 53 50 54 0a 04 63 7d 61 63  S3EcaySSPT..c}ac
  3050: 61 70 53 4d 52 49 47 4d 50 54 70 60 47 4d 55 45  apSMRIGMPTp`GMUE
  3060: 70 53 4d 55 54 47 4d 55 54 70 53 4d 43 52 47 4d  pSMUTGMUTpSMCRGM
  3070: 43 52 70 53 53 52 49 47 53 50 54 70 61 47 53 55  CRpSSRIGSPTpaGSU
  3080: 45 70 53 53 55 54 47 53 55 54 70 53 53 43 52 47  EpSSUTGSUTpSSCRG
  3090: 53 43 52 53 54 4d 5f 70 47 4d 50 54 53 4d 52 49  SCRSTM_pGMPTSMRI
  30a0: 70 47 4d 55 45 60 70 47 4d 55 54 53 4d 55 54 70  pGMUE`pGMUTSMUTp
  30b0: 47 4d 43 52 53 4d 43 52 70 47 53 55 45 61 70 47  GMCRSMCRpGSUEapG
  30c0: 53 55 54 53 53 55 54 70 47 53 43 52 53 53 43 52  SUTSSUTpGSCRSSCR
  30d0: a0 0d 7b 60 0a 01 00 70 0a 01 53 4d 33 45 a1 08  ..{`...p..SM3E..
  30e0: 70 0a 00 53 4d 33 45 a0 0d 7b 60 0a 02 00 70 0a  p..SM3E..{`...p.
  30f0: 01 53 4d 36 45 a1 08 70 0a 00 53 4d 36 45 a0 0d  .SM6E..p..SM6E..
  3100: 7b 60 0a 04 00 70 0a 01 53 4d 41 45 a1 08 70 0a  {`...p..SMAE..p.
  3110: 00 53 4d 41 45 a0 0d 7b 61 0a 01 00 70 0a 01 53  .SMAE..{a...p..S
  3120: 53 33 45 a1 08 70 0a 00 53 53 33 45 a0 0d 7b 61  S3E..p..SS3E..{a
  3130: 0a 02 00 70 0a 01 53 53 36 45 a1 08 70 0a 00 53  ...p..SS6E..p..S
  3140: 53 36 45 a0 0d 7b 61 0a 04 00 70 0a 01 53 53 41  S6E..{a...p..SSA
  3150: 45 a1 08 70 0a 00 53 53 41 45 70 47 54 46 5f 0a  E..p..SSAEpGTF_.
  3160: 00 69 41 54 41 32 70 47 54 46 5f 0a 01 6a 41 54  .iATA2pGTF_..jAT
  3170: 41 33 5b 82 1c 44 52 56 30 08 5f 41 44 52 0a 00  A3[..DRV0._ADR..
  3180: 14 0f 5f 47 54 46 00 a4 52 41 54 41 41 54 41 32  .._GTF..RATAATA2
  3190: 5b 82 1c 44 52 56 31 08 5f 41 44 52 0a 01 14 0f  [..DRV1._ADR....
  31a0: 5f 47 54 46 00 a4 52 41 54 41 41 54 41 33 14 4d  _GTF..RATAATA3.M
  31b0: 13 47 54 4d 5f 0f 70 ff 50 49 4f 30 70 ff 50 49  .GTM_.p.PIO0p.PI
  31c0: 4f 31 70 ff 44 4d 41 30 70 ff 44 4d 41 31 70 0a  O1p.DMA0p.DMA1p.
  31d0: 10 43 48 4e 46 a0 05 52 45 47 46 a1 06 a4 54 4d  .CHNF..REGF...TM
  31e0: 44 30 a0 11 7b 69 0a 20 00 7d 43 48 4e 46 0a 02  D0..{i. .}CHNF..
  31f0: 43 48 4e 46 70 89 83 88 54 49 4d 30 0a 01 00 01  CHNFp...TIM0....
  3200: 68 00 0a 00 0a 00 66 70 83 88 83 88 54 49 4d 30  h.....fp....TIM0
  3210: 0a 00 00 66 00 67 70 67 44 4d 41 30 70 67 50 49  ...f.gpgDMA0pgPI
  3220: 4f 30 a0 11 7b 6c 0a 20 00 7d 43 48 4e 46 0a 08  O0..{l. .}CHNF..
  3230: 43 48 4e 46 70 89 83 88 54 49 4d 30 0a 02 00 01  CHNFp...TIM0....
  3240: 6b 00 0a 00 0a 00 66 70 83 88 83 88 54 49 4d 30  k.....fp....TIM0
  3250: 0a 00 00 66 00 67 70 67 44 4d 41 31 70 67 50 49  ...f.gpgDMA1pgPI
  3260: 4f 31 a0 3e 7b 69 0a 07 00 70 6a 65 a0 0b 7b 69  O1.>{i...pje..{i
  3270: 0a 02 00 72 65 0a 02 65 a0 0b 7b 69 0a 04 00 72  ...re..e..{i...r
  3280: 65 0a 04 65 70 83 88 83 88 54 49 4d 30 0a 03 00  e..ep....TIM0...
  3290: 65 00 44 4d 41 30 7d 43 48 4e 46 0a 01 43 48 4e  e.DMA0}CHNF..CHN
  32a0: 46 a0 3e 7b 6c 0a 07 00 70 6d 65 a0 0b 7b 6c 0a  F.>{l...pme..{l.
  32b0: 02 00 72 65 0a 02 65 a0 0b 7b 6c 0a 04 00 72 65  ..re..e..{l...re
  32c0: 0a 04 65 70 83 88 83 88 54 49 4d 30 0a 03 00 65  ..ep....TIM0...e
  32d0: 00 44 4d 41 31 7d 43 48 4e 46 0a 04 43 48 4e 46  .DMA1}CHNF..CHNF
  32e0: 70 54 4d 44 30 5b 31 a4 54 4d 44 30 14 4c 22 53  pTMD0[1.TMD0.L"S
  32f0: 54 4d 5f 08 a0 05 52 45 47 46 a1 4e 21 70 0a 00  TM_...REGF.N!p..
  3300: 47 4d 55 45 70 0a 00 47 4d 55 54 70 0a 00 47 53  GMUEp..GMUTp..GS
  3310: 55 45 70 0a 00 47 53 55 54 a0 44 07 7b 43 48 4e  UEp..GSUT.D.{CHN
  3320: 46 0a 01 00 70 89 83 88 54 49 4d 30 0a 03 00 02  F...p...TIM0....
  3330: 44 4d 41 30 00 0a 00 0a 00 60 a0 09 94 60 0a 05  DMA0.....`...`..
  3340: 70 0a 05 60 70 83 88 83 88 54 49 4d 30 0a 04 00  p..`p....TIM0...
  3350: 60 00 47 4d 55 54 7d 47 4d 55 45 0a 01 47 4d 55  `.GMUT}GMUE..GMU
  3360: 45 a0 10 94 60 0a 02 7d 47 4d 55 45 0a 02 47 4d  E...`..}GMUE..GM
  3370: 55 45 a0 1b 94 60 0a 04 7b 47 4d 55 45 0a fd 47  UE...`..{GMUE..G
  3380: 4d 55 45 7d 47 4d 55 45 0a 04 47 4d 55 45 a1 37  MUE}GMUE..GMUE.7
  3390: a0 35 7d 93 50 49 4f 30 ff 93 50 49 4f 30 0a 00  .5}.PIO0..PIO0..
  33a0: 00 a0 24 7b 95 44 4d 41 30 ff 94 44 4d 41 30 0a  ..${.DMA0..DMA0.
  33b0: 00 00 70 44 4d 41 30 50 49 4f 30 7d 47 4d 55 45  ..pDMA0PIO0}GMUE
  33c0: 0a 80 47 4d 55 45 a0 44 07 7b 43 48 4e 46 0a 04  ..GMUE.D.{CHNF..
  33d0: 00 70 89 83 88 54 49 4d 30 0a 03 00 02 44 4d 41  .p...TIM0....DMA
  33e0: 31 00 0a 00 0a 00 60 a0 09 94 60 0a 05 70 0a 05  1.....`...`..p..
  33f0: 60 70 83 88 83 88 54 49 4d 30 0a 04 00 60 00 47  `p....TIM0...`.G
  3400: 53 55 54 7d 47 53 55 45 0a 01 47 53 55 45 a0 10  SUT}GSUE..GSUE..
  3410: 94 60 0a 02 7d 47 53 55 45 0a 02 47 53 55 45 a0  .`..}GSUE..GSUE.
  3420: 1b 94 60 0a 04 7b 47 53 55 45 0a fd 47 53 55 45  ..`..{GSUE..GSUE
  3430: 7d 47 53 55 45 0a 04 47 53 55 45 a1 37 a0 35 7d  }GSUE..GSUE.7.5}
  3440: 93 50 49 4f 31 ff 93 50 49 4f 31 0a 00 00 a0 24  .PIO1..PIO1....$
  3450: 7b 95 44 4d 41 31 ff 94 44 4d 41 31 0a 00 00 70  {.DMA1..DMA1...p
  3460: 44 4d 41 31 50 49 4f 31 7d 47 53 55 45 0a 80 47  DMA1PIO1}GSUE..G
  3470: 53 55 45 a0 14 7b 43 48 4e 46 0a 02 00 7d 47 4d  SUE..{CHNF...}GM
  3480: 55 45 0a 20 47 4d 55 45 a0 14 7b 43 48 4e 46 0a  UE. GMUE..{CHNF.
  3490: 08 00 7d 47 53 55 45 0a 20 47 53 55 45 7b 89 83  ..}GSUE. GSUE{..
  34a0: 88 54 49 4d 30 0a 00 00 04 50 49 4f 30 00 0a 00  .TIM0....PIO0...
  34b0: 0a 00 0a 07 60 70 83 88 83 88 54 49 4d 30 0a 01  ....`p....TIM0..
  34c0: 00 60 00 61 70 61 47 4d 50 54 a0 10 95 60 0a 03  .`.apaGMPT...`..
  34d0: 7d 47 4d 55 45 0a 50 47 4d 55 45 7b 89 83 88 54  }GMUE.PGMUE{...T
  34e0: 49 4d 30 0a 00 00 04 50 49 4f 31 00 0a 00 0a 00  IM0....PIO1.....
  34f0: 0a 07 60 70 83 88 83 88 54 49 4d 30 0a 02 00 60  ..`p....TIM0...`
  3500: 00 61 70 61 47 53 50 54 a0 10 95 60 0a 03 7d 47  .apaGSPT...`..}G
  3510: 53 55 45 0a 50 47 53 55 45 08 41 54 30 31 11 0a  SUE.PGSUE.AT01..
  3520: 0a 07 03 00 00 00 00 00 ef 08 41 54 30 32 11 0a  ..........AT02..
  3530: 0a 07 00 00 00 00 00 00 90 08 41 54 30 33 11 0a  ..........AT03..
  3540: 0a 07 00 00 00 00 00 00 c6 08 41 54 30 34 11 0a  ..........AT04..
  3550: 0a 07 00 00 00 00 00 00 91 08 41 54 41 30 11 03  ..........ATA0..
  3560: 0a 1d 08 41 54 41 31 11 03 0a 1d 08 41 54 41 32  ...ATA1.....ATA2
  3570: 11 03 0a 1d 08 41 54 41 33 11 03 0a 1d 08 41 54  .....ATA3.....AT
  3580: 41 42 11 03 0a 1d 8c 41 54 41 42 0a 00 43 4d 44  AB.....ATAB..CMD
  3590: 43 14 4c 05 47 54 46 42 0b 77 43 4d 44 43 0a 38  C.L.GTFB.wCMDC.8
  35a0: 60 72 60 0a 08 61 5b 13 41 54 41 42 61 0a 38 43  `r`..a[.ATABa.8C
  35b0: 4d 44 58 77 43 4d 44 43 0a 07 60 8c 41 54 41 42  MDXwCMDC..`.ATAB
  35c0: 72 60 0a 02 00 41 30 30 31 8c 41 54 41 42 72 60  r`...A001.ATABr`
  35d0: 0a 06 00 41 30 30 35 70 68 43 4d 44 58 70 69 41  ...A005phCMDXpiA
  35e0: 30 30 31 70 6a 41 30 30 35 75 43 4d 44 43 14 42  001pjA005uCMDC.B
  35f0: 24 47 54 46 5f 0a 70 69 5b 31 70 0a 00 43 4d 44  $GTF_.pi[1p..CMD
  3600: 43 08 49 44 34 39 0b 00 0c 08 49 44 35 39 0a 00  C.ID49....ID59..
  3610: 08 49 44 35 33 0a 04 08 49 44 36 33 0b 00 0f 08  .ID53...ID63....
  3620: 49 44 38 38 0b 00 0f 08 49 52 44 59 0a 01 08 50  ID88....IRDY...P
  3630: 49 4f 54 0a 00 08 44 4d 41 54 0a 00 a0 4d 05 93  IOT...DMAT...M..
  3640: 87 69 0b 00 02 8b 69 0a 62 49 57 34 39 70 49 57  .i....i.bIW49pIW
  3650: 34 39 49 44 34 39 8b 69 0a 6a 49 57 35 33 70 49  49ID49.i.jIW53pI
  3660: 57 35 33 49 44 35 33 8b 69 0a 7e 49 57 36 33 70  W53ID53.i.~IW63p
  3670: 49 57 36 33 49 44 36 33 8b 69 0a 76 49 57 35 39  IW63ID63.i.vIW59
  3680: 70 49 57 35 39 49 44 35 39 8b 69 0a b0 49 57 38  pIW59ID59.i..IW8
  3690: 38 70 49 57 38 38 49 44 38 38 70 0a a0 67 a0 48  8pIW88ID88p..g.H
  36a0: 05 68 70 0a b0 67 7b 43 48 4e 46 0a 08 49 52 44  .hp..g{CHNF..IRD
  36b0: 59 a0 12 7b 43 48 4e 46 0a 10 00 70 50 49 4f 31  Y..{CHNF...pPIO1
  36c0: 50 49 4f 54 a1 0a 70 50 49 4f 30 50 49 4f 54 a0  PIOT..pPIO0PIOT.
  36d0: 27 7b 43 48 4e 46 0a 04 00 a0 12 7b 43 48 4e 46  '{CHNF.....{CHNF
  36e0: 0a 10 00 70 44 4d 41 31 44 4d 41 54 a1 0a 70 44  ...pDMA1DMAT..pD
  36f0: 4d 41 30 44 4d 41 54 a1 28 7b 43 48 4e 46 0a 02  MA0DMAT.({CHNF..
  3700: 49 52 44 59 70 50 49 4f 30 50 49 4f 54 a0 12 7b  IRDYpPIO0PIOT..{
  3710: 43 48 4e 46 0a 01 00 70 44 4d 41 30 44 4d 41 54  CHNF...pDMA0DMAT
  3720: a0 47 04 90 90 7b 49 44 35 33 0a 04 00 7b 49 44  .G...{ID53...{ID
  3730: 38 38 0b 00 ff 00 44 4d 41 54 70 89 83 88 54 49  88....DMATp...TI
  3740: 4d 30 0a 03 00 02 44 4d 41 54 00 0a 00 0a 00 61  M0....DMAT.....a
  3750: a0 09 94 61 0a 05 70 0a 05 61 47 54 46 42 41 54  ...a..p..aGTFBAT
  3760: 30 31 7d 0a 40 61 00 67 a1 46 04 a0 43 04 90 7b  01}.@a.g.F..C..{
  3770: 49 44 36 33 0b 00 ff 00 50 49 4f 54 7b 89 83 88  ID63....PIOT{...
  3780: 54 49 4d 30 0a 00 00 04 50 49 4f 54 00 0a 00 0a  TIM0....PIOT....
  3790: 00 0a 03 60 7d 0a 20 83 88 83 88 54 49 4d 30 0a  ...`}. ....TIM0.
  37a0: 07 00 60 00 61 47 54 46 42 41 54 30 31 61 67 a0  ..`.aGTFBAT01ag.
  37b0: 38 49 52 44 59 7b 89 83 88 54 49 4d 30 0a 00 00  8IRDY{...TIM0...
  37c0: 04 50 49 4f 54 00 0a 00 0a 00 0a 07 60 7d 0a 08  .PIOT.......`}..
  37d0: 83 88 83 88 54 49 4d 30 0a 06 00 60 00 61 47 54  ....TIM0...`.aGT
  37e0: 46 42 41 54 30 31 61 67 a1 17 a0 15 7b 49 44 34  FBAT01ag....{ID4
  37f0: 39 0b 00 04 00 47 54 46 42 41 54 30 31 0a 01 67  9....GTFBAT01..g
  3800: a0 24 90 7b 49 44 35 39 0b 00 01 00 7b 49 44 35  .$.{ID59....{ID5
  3810: 39 0a ff 00 47 54 46 42 41 54 30 33 7b 49 44 35  9...GTFBAT03{ID5
  3820: 39 0a ff 00 67 70 41 54 41 42 5b 31 a4 41 54 41  9...gpATAB[1.ATA
  3830: 42 14 2c 52 41 54 41 01 8c 68 0a 00 43 4d 44 4e  B.,RATA..h..CMDN
  3840: 77 43 4d 44 4e 0a 38 60 5b 13 68 0a 08 60 52 45  wCMDN.8`[.h..`RE
  3850: 54 42 70 52 45 54 42 5b 31 a4 52 45 54 42 5b 82  TBpRETB[1.RETB[.
  3860: 47 d0 49 44 45 31 08 5f 41 44 52 0c 02 00 1f 00  G.IDE1._ADR.....
  3870: 08 52 45 47 46 0a 01 14 12 5f 52 45 47 02 a0 0b  .REGF...._REG...
  3880: 93 68 0a 02 70 69 52 45 47 46 08 54 49 4d 30 12  .h..piREGF.TIM0.
  3890: 48 06 08 12 0b 04 0a 78 0a b4 0a f0 0b 84 03 12  H......x........
  38a0: 0a 04 0a 23 0a 21 0a 10 0a 00 12 0a 04 0a 0b 0a  ...#.!..........
  38b0: 09 0a 04 0a 00 12 0e 06 0a 70 0a 49 0a 36 0a 27  .........p.I.6.'
  38c0: 0a 19 0a 11 12 0e 06 0a 00 0a 01 0a 02 0a 01 0a  ................
  38d0: 02 0a 01 12 0e 06 0a 00 0a 00 0a 00 0a 01 0a 01  ................
  38e0: 0a 01 12 0a 04 0a 04 0a 03 0a 02 0a 00 12 0a 04  ................
  38f0: 0a 02 0a 01 0a 00 0a 00 08 54 4d 44 30 11 03 0a  .........TMD0...
  3900: 14 8a 54 4d 44 30 0a 00 50 49 4f 30 8a 54 4d 44  ..TMD0..PIO0.TMD
  3910: 30 0a 04 44 4d 41 30 8a 54 4d 44 30 0a 08 50 49  0..DMA0.TMD0..PI
  3920: 4f 31 8a 54 4d 44 30 0a 0c 44 4d 41 31 8a 54 4d  O1.TMD0..DMA1.TM
  3930: 44 30 0a 10 43 48 4e 46 5b 80 43 46 47 32 02 0a  D0..CHNF[.CFG2..
  3940: 40 0a 20 5b 81 48 0a 43 46 47 32 03 50 4d 50 54  @. [.H.CFG2.PMPT
  3950: 04 50 53 50 54 04 50 4d 52 49 06 00 02 53 4d 50  .PSPT.PMRI...SMP
  3960: 54 04 53 53 50 54 04 53 4d 52 49 06 00 02 50 53  T.SSPT.SMRI...PS
  3970: 52 49 04 53 53 52 49 04 00 18 50 4d 33 45 01 50  RI.SSRI...PM3E.P
  3980: 53 33 45 01 53 4d 33 45 01 53 53 33 45 01 00 0c  S3E.SM3E.SS3E...
  3990: 50 4d 55 54 02 00 02 50 53 55 54 02 00 02 53 4d  PMUT...PSUT...SM
  39a0: 55 54 02 00 02 53 53 55 54 02 00 02 00 40 04 50  UT...SSUT....@.P
  39b0: 4d 36 45 01 50 53 36 45 01 53 4d 36 45 01 53 53  M6E.PS6E.SM6E.SS
  39c0: 36 45 01 50 4d 43 52 01 50 53 43 52 01 53 4d 43  6E.PMCR.PSCR.SMC
  39d0: 52 01 53 53 43 52 01 00 04 50 4d 41 45 01 50 53  R.SSCR...PMAE.PS
  39e0: 41 45 01 53 4d 41 45 01 53 53 41 45 01 08 47 4d  AE.SMAE.SSAE..GM
  39f0: 50 54 0a 00 08 47 4d 55 45 0a 00 08 47 4d 55 54  PT...GMUE...GMUT
  3a00: 0a 00 08 47 4d 43 52 0a 00 08 47 53 50 54 0a 00  ...GMCR...GSPT..
  3a10: 08 47 53 55 45 0a 00 08 47 53 55 54 0a 00 08 47  .GSUE...GSUT...G
  3a20: 53 43 52 0a 00 5b 82 47 24 43 48 4e 30 08 5f 41  SCR..[.G$CHN0._A
  3a30: 44 52 0a 00 14 4c 07 5f 47 54 4d 00 79 50 53 43  DR...L._GTM.yPSC
  3a40: 52 0a 01 61 7d 50 4d 43 52 61 60 79 50 4d 41 45  R..a}PMCRa`yPMAE
  3a50: 0a 02 63 79 50 4d 36 45 0a 01 64 7d 63 64 63 7d  ..cyPM6E..d}cdc}
  3a60: 50 4d 33 45 63 61 79 50 4d 50 54 0a 04 63 7d 61  PM3EcayPMPT..c}a
  3a70: 63 61 79 50 53 41 45 0a 02 63 79 50 53 36 45 0a  cayPSAE..cyPS6E.
  3a80: 01 64 7d 63 64 63 7d 50 53 33 45 63 62 79 50 53  .d}cdc}PS3EcbyPS
  3a90: 50 54 0a 04 63 7d 62 63 62 a4 47 54 4d 5f 50 4d  PT..c}bcb.GTM_PM
  3aa0: 52 49 61 50 4d 55 54 50 53 52 49 62 50 53 55 54  RIaPMUTPSRIbPSUT
  3ab0: 60 14 40 18 5f 53 54 4d 03 70 68 5b 31 70 68 54  `.@._STM.ph[1phT
  3ac0: 4d 44 30 79 50 4d 41 45 0a 02 63 79 50 4d 36 45  MD0yPMAE..cyPM6E
  3ad0: 0a 01 64 7d 63 64 63 7d 50 4d 33 45 63 60 79 50  ..d}cdc}PM3Ec`yP
  3ae0: 4d 50 54 0a 04 63 7d 60 63 60 79 50 53 41 45 0a  MPT..c}`c`yPSAE.
  3af0: 02 63 79 50 53 36 45 0a 01 64 7d 63 64 63 7d 50  .cyPS6E..d}cdc}P
  3b00: 53 33 45 63 61 79 50 53 50 54 0a 04 63 7d 61 63  S3EcayPSPT..c}ac
  3b10: 61 70 50 4d 52 49 47 4d 50 54 70 60 47 4d 55 45  apPMRIGMPTp`GMUE
  3b20: 70 50 4d 55 54 47 4d 55 54 70 50 4d 43 52 47 4d  pPMUTGMUTpPMCRGM
  3b30: 43 52 70 50 53 52 49 47 53 50 54 70 61 47 53 55  CRpPSRIGSPTpaGSU
  3b40: 45 70 50 53 55 54 47 53 55 54 70 50 53 43 52 47  EpPSUTGSUTpPSCRG
  3b50: 53 43 52 53 54 4d 5f 70 47 4d 50 54 50 4d 52 49  SCRSTM_pGMPTPMRI
  3b60: 70 47 4d 55 45 60 70 47 4d 55 54 50 4d 55 54 70  pGMUE`pGMUTPMUTp
  3b70: 47 4d 43 52 50 4d 43 52 70 47 53 55 45 61 70 47  GMCRPMCRpGSUEapG
  3b80: 53 55 54 50 53 55 54 70 47 53 43 52 50 53 43 52  SUTPSUTpGSCRPSCR
  3b90: a0 0d 7b 60 0a 01 00 70 0a 01 50 4d 33 45 a1 08  ..{`...p..PM3E..
  3ba0: 70 0a 00 50 4d 33 45 a0 0d 7b 60 0a 02 00 70 0a  p..PM3E..{`...p.
  3bb0: 01 50 4d 36 45 a1 08 70 0a 00 50 4d 36 45 a0 0d  .PM6E..p..PM6E..
  3bc0: 7b 60 0a 04 00 70 0a 01 50 4d 41 45 a1 08 70 0a  {`...p..PMAE..p.
  3bd0: 00 50 4d 41 45 a0 0d 7b 61 0a 01 00 70 0a 01 50  .PMAE..{a...p..P
  3be0: 53 33 45 a1 08 70 0a 00 50 53 33 45 a0 0d 7b 61  S3E..p..PS3E..{a
  3bf0: 0a 02 00 70 0a 01 50 53 36 45 a1 08 70 0a 00 50  ...p..PS6E..p..P
  3c00: 53 36 45 a0 0d 7b 61 0a 04 00 70 0a 01 50 53 41  S6E..{a...p..PSA
  3c10: 45 a1 08 70 0a 00 50 53 41 45 70 47 54 46 5f 0a  E..p..PSAEpGTF_.
  3c20: 00 69 41 54 41 30 70 47 54 46 5f 0a 01 6a 41 54  .iATA0pGTF_..jAT
  3c30: 41 31 5b 82 1c 44 52 56 30 08 5f 41 44 52 0a 00  A1[..DRV0._ADR..
  3c40: 14 0f 5f 47 54 46 00 a4 52 41 54 41 41 54 41 30  .._GTF..RATAATA0
  3c50: 5b 82 1c 44 52 56 31 08 5f 41 44 52 0a 01 14 0f  [..DRV1._ADR....
  3c60: 5f 47 54 46 00 a4 52 41 54 41 41 54 41 31 5b 82  _GTF..RATAATA1[.
  3c70: 47 24 43 48 4e 31 08 5f 41 44 52 0a 01 14 4c 07  G$CHN1._ADR...L.
  3c80: 5f 47 54 4d 00 79 53 53 43 52 0a 01 61 7d 53 4d  _GTM.ySSCR..a}SM
  3c90: 43 52 61 60 79 53 4d 41 45 0a 02 63 79 53 4d 36  CRa`ySMAE..cySM6
  3ca0: 45 0a 01 64 7d 63 64 63 7d 53 4d 33 45 63 61 79  E..d}cdc}SM3Ecay
  3cb0: 53 4d 50 54 0a 04 63 7d 61 63 61 79 53 53 41 45  SMPT..c}acaySSAE
  3cc0: 0a 02 63 79 53 53 36 45 0a 01 64 7d 63 64 63 7d  ..cySS6E..d}cdc}
  3cd0: 53 53 33 45 63 62 79 53 53 50 54 0a 04 63 7d 62  SS3EcbySSPT..c}b
  3ce0: 63 62 a4 47 54 4d 5f 53 4d 52 49 61 53 4d 55 54  cb.GTM_SMRIaSMUT
  3cf0: 53 53 52 49 62 53 53 55 54 60 14 40 18 5f 53 54  SSRIbSSUT`.@._ST
  3d00: 4d 03 70 68 5b 31 70 68 54 4d 44 30 79 53 4d 41  M.ph[1phTMD0ySMA
  3d10: 45 0a 02 63 79 53 4d 36 45 0a 01 64 7d 63 64 63  E..cySM6E..d}cdc
  3d20: 7d 53 4d 33 45 63 60 79 53 4d 50 54 0a 04 63 7d  }SM3Ec`ySMPT..c}
  3d30: 60 63 60 79 53 53 41 45 0a 02 63 79 53 53 36 45  `c`ySSAE..cySS6E
  3d40: 0a 01 64 7d 63 64 63 7d 53 53 33 45 63 61 79 53  ..d}cdc}SS3EcayS
  3d50: 53 50 54 0a 04 63 7d 61 63 61 70 53 4d 52 49 47  SPT..c}acapSMRIG
  3d60: 4d 50 54 70 60 47 4d 55 45 70 53 4d 55 54 47 4d  MPTp`GMUEpSMUTGM
  3d70: 55 54 70 53 4d 43 52 47 4d 43 52 70 53 53 52 49  UTpSMCRGMCRpSSRI
  3d80: 47 53 50 54 70 61 47 53 55 45 70 53 53 55 54 47  GSPTpaGSUEpSSUTG
  3d90: 53 55 54 70 53 53 43 52 47 53 43 52 53 54 4d 5f  SUTpSSCRGSCRSTM_
  3da0: 70 47 4d 50 54 53 4d 52 49 70 47 4d 55 45 60 70  pGMPTSMRIpGMUE`p
  3db0: 47 4d 55 54 53 4d 55 54 70 47 4d 43 52 53 4d 43  GMUTSMUTpGMCRSMC
  3dc0: 52 70 47 53 55 45 61 70 47 53 55 54 53 53 55 54  RpGSUEapGSUTSSUT
  3dd0: 70 47 53 43 52 53 53 43 52 a0 0d 7b 60 0a 01 00  pGSCRSSCR..{`...
  3de0: 70 0a 01 53 4d 33 45 a1 08 70 0a 00 53 4d 33 45  p..SM3E..p..SM3E
  3df0: a0 0d 7b 60 0a 02 00 70 0a 01 53 4d 36 45 a1 08  ..{`...p..SM6E..
  3e00: 70 0a 00 53 4d 36 45 a0 0d 7b 60 0a 04 00 70 0a  p..SM6E..{`...p.
  3e10: 01 53 4d 41 45 a1 08 70 0a 00 53 4d 41 45 a0 0d  .SMAE..p..SMAE..
  3e20: 7b 61 0a 01 00 70 0a 01 53 53 33 45 a1 08 70 0a  {a...p..SS3E..p.
  3e30: 00 53 53 33 45 a0 0d 7b 61 0a 02 00 70 0a 01 53  .SS3E..{a...p..S
  3e40: 53 36 45 a1 08 70 0a 00 53 53 36 45 a0 0d 7b 61  S6E..p..SS6E..{a
  3e50: 0a 04 00 70 0a 01 53 53 41 45 a1 08 70 0a 00 53  ...p..SSAE..p..S
  3e60: 53 41 45 70 47 54 46 5f 0a 00 69 41 54 41 32 70  SAEpGTF_..iATA2p
  3e70: 47 54 46 5f 0a 01 6a 41 54 41 33 5b 82 1c 44 52  GTF_..jATA3[..DR
  3e80: 56 30 08 5f 41 44 52 0a 00 14 0f 5f 47 54 46 00  V0._ADR...._GTF.
  3e90: a4 52 41 54 41 41 54 41 32 5b 82 1c 44 52 56 31  .RATAATA2[..DRV1
  3ea0: 08 5f 41 44 52 0a 01 14 0f 5f 47 54 46 00 a4 52  ._ADR...._GTF..R
  3eb0: 41 54 41 41 54 41 33 14 4d 13 47 54 4d 5f 0f 70  ATAATA3.M.GTM_.p
  3ec0: ff 50 49 4f 30 70 ff 50 49 4f 31 70 ff 44 4d 41  .PIO0p.PIO1p.DMA
  3ed0: 30 70 ff 44 4d 41 31 70 0a 10 43 48 4e 46 a0 05  0p.DMA1p..CHNF..
  3ee0: 52 45 47 46 a1 06 a4 54 4d 44 30 a0 11 7b 69 0a  REGF...TMD0..{i.
  3ef0: 20 00 7d 43 48 4e 46 0a 02 43 48 4e 46 70 89 83   .}CHNF..CHNFp..
  3f00: 88 54 49 4d 30 0a 01 00 01 68 00 0a 00 0a 00 66  .TIM0....h.....f
  3f10: 70 83 88 83 88 54 49 4d 30 0a 00 00 66 00 67 70  p....TIM0...f.gp
  3f20: 67 44 4d 41 30 70 67 50 49 4f 30 a0 11 7b 6c 0a  gDMA0pgPIO0..{l.
  3f30: 20 00 7d 43 48 4e 46 0a 08 43 48 4e 46 70 89 83   .}CHNF..CHNFp..
  3f40: 88 54 49 4d 30 0a 02 00 01 6b 00 0a 00 0a 00 66  .TIM0....k.....f
  3f50: 70 83 88 83 88 54 49 4d 30 0a 00 00 66 00 67 70  p....TIM0...f.gp
  3f60: 67 44 4d 41 31 70 67 50 49 4f 31 a0 3e 7b 69 0a  gDMA1pgPIO1.>{i.
  3f70: 07 00 70 6a 65 a0 0b 7b 69 0a 02 00 72 65 0a 02  ..pje..{i...re..
  3f80: 65 a0 0b 7b 69 0a 04 00 72 65 0a 04 65 70 83 88  e..{i...re..ep..
  3f90: 83 88 54 49 4d 30 0a 03 00 65 00 44 4d 41 30 7d  ..TIM0...e.DMA0}
  3fa0: 43 48 4e 46 0a 01 43 48 4e 46 a0 3e 7b 6c 0a 07  CHNF..CHNF.>{l..
  3fb0: 00 70 6d 65 a0 0b 7b 6c 0a 02 00 72 65 0a 02 65  .pme..{l...re..e
  3fc0: a0 0b 7b 6c 0a 04 00 72 65 0a 04 65 70 83 88 83  ..{l...re..ep...
  3fd0: 88 54 49 4d 30 0a 03 00 65 00 44 4d 41 31 7d 43  .TIM0...e.DMA1}C
  3fe0: 48 4e 46 0a 04 43 48 4e 46 70 54 4d 44 30 5b 31  HNF..CHNFpTMD0[1
  3ff0: a4 54 4d 44 30 14 4c 22 53 54 4d 5f 08 a0 05 52  .TMD0.L"STM_...R
  4000: 45 47 46 a1 4e 21 70 0a 00 47 4d 55 45 70 0a 00  EGF.N!p..GMUEp..
  4010: 47 4d 55 54 70 0a 00 47 53 55 45 70 0a 00 47 53  GMUTp..GSUEp..GS
  4020: 55 54 a0 44 07 7b 43 48 4e 46 0a 01 00 70 89 83  UT.D.{CHNF...p..
  4030: 88 54 49 4d 30 0a 03 00 02 44 4d 41 30 00 0a 00  .TIM0....DMA0...
  4040: 0a 00 60 a0 09 94 60 0a 05 70 0a 05 60 70 83 88  ..`...`..p..`p..
  4050: 83 88 54 49 4d 30 0a 04 00 60 00 47 4d 55 54 7d  ..TIM0...`.GMUT}
  4060: 47 4d 55 45 0a 01 47 4d 55 45 a0 10 94 60 0a 02  GMUE..GMUE...`..
  4070: 7d 47 4d 55 45 0a 02 47 4d 55 45 a0 1b 94 60 0a  }GMUE..GMUE...`.
  4080: 04 7b 47 4d 55 45 0a fd 47 4d 55 45 7d 47 4d 55  .{GMUE..GMUE}GMU
  4090: 45 0a 04 47 4d 55 45 a1 37 a0 35 7d 93 50 49 4f  E..GMUE.7.5}.PIO
  40a0: 30 ff 93 50 49 4f 30 0a 00 00 a0 24 7b 95 44 4d  0..PIO0....${.DM
  40b0: 41 30 ff 94 44 4d 41 30 0a 00 00 70 44 4d 41 30  A0..DMA0...pDMA0
  40c0: 50 49 4f 30 7d 47 4d 55 45 0a 80 47 4d 55 45 a0  PIO0}GMUE..GMUE.
  40d0: 44 07 7b 43 48 4e 46 0a 04 00 70 89 83 88 54 49  D.{CHNF...p...TI
  40e0: 4d 30 0a 03 00 02 44 4d 41 31 00 0a 00 0a 00 60  M0....DMA1.....`
  40f0: a0 09 94 60 0a 05 70 0a 05 60 70 83 88 83 88 54  ...`..p..`p....T
  4100: 49 4d 30 0a 04 00 60 00 47 53 55 54 7d 47 53 55  IM0...`.GSUT}GSU
  4110: 45 0a 01 47 53 55 45 a0 10 94 60 0a 02 7d 47 53  E..GSUE...`..}GS
  4120: 55 45 0a 02 47 53 55 45 a0 1b 94 60 0a 04 7b 47  UE..GSUE...`..{G
  4130: 53 55 45 0a fd 47 53 55 45 7d 47 53 55 45 0a 04  SUE..GSUE}GSUE..
  4140: 47 53 55 45 a1 37 a0 35 7d 93 50 49 4f 31 ff 93  GSUE.7.5}.PIO1..
  4150: 50 49 4f 31 0a 00 00 a0 24 7b 95 44 4d 41 31 ff  PIO1....${.DMA1.
  4160: 94 44 4d 41 31 0a 00 00 70 44 4d 41 31 50 49 4f  .DMA1...pDMA1PIO
  4170: 31 7d 47 53 55 45 0a 80 47 53 55 45 a0 14 7b 43  1}GSUE..GSUE..{C
  4180: 48 4e 46 0a 02 00 7d 47 4d 55 45 0a 20 47 4d 55  HNF...}GMUE. GMU
  4190: 45 a0 14 7b 43 48 4e 46 0a 08 00 7d 47 53 55 45  E..{CHNF...}GSUE
  41a0: 0a 20 47 53 55 45 7b 89 83 88 54 49 4d 30 0a 00  . GSUE{...TIM0..
  41b0: 00 04 50 49 4f 30 00 0a 00 0a 00 0a 07 60 70 83  ..PIO0.......`p.
  41c0: 88 83 88 54 49 4d 30 0a 01 00 60 00 61 70 61 47  ...TIM0...`.apaG
  41d0: 4d 50 54 a0 10 95 60 0a 03 7d 47 4d 55 45 0a 50  MPT...`..}GMUE.P
  41e0: 47 4d 55 45 7b 89 83 88 54 49 4d 30 0a 00 00 04  GMUE{...TIM0....
  41f0: 50 49 4f 31 00 0a 00 0a 00 0a 07 60 70 83 88 83  PIO1.......`p...
  4200: 88 54 49 4d 30 0a 02 00 60 00 61 70 61 47 53 50  .TIM0...`.apaGSP
  4210: 54 a0 10 95 60 0a 03 7d 47 53 55 45 0a 50 47 53  T...`..}GSUE.PGS
  4220: 55 45 08 41 54 30 31 11 0a 0a 07 03 00 00 00 00  UE.AT01.........
  4230: 00 ef 08 41 54 30 32 11 0a 0a 07 00 00 00 00 00  ...AT02.........
  4240: 00 90 08 41 54 30 33 11 0a 0a 07 00 00 00 00 00  ...AT03.........
  4250: 00 c6 08 41 54 30 34 11 0a 0a 07 00 00 00 00 00  ...AT04.........
  4260: 00 91 08 41 54 41 30 11 03 0a 1d 08 41 54 41 31  ...ATA0.....ATA1
  4270: 11 03 0a 1d 08 41 54 41 32 11 03 0a 1d 08 41 54  .....ATA2.....AT
  4280: 41 33 11 03 0a 1d 08 41 54 41 42 11 03 0a 1d 8c  A3.....ATAB.....
  4290: 41 54 41 42 0a 00 43 4d 44 43 14 4c 05 47 54 46  ATAB..CMDC.L.GTF
  42a0: 42 0b 77 43 4d 44 43 0a 38 60 72 60 0a 08 61 5b  B.wCMDC.8`r`..a[
  42b0: 13 41 54 41 42 61 0a 38 43 4d 44 58 77 43 4d 44  .ATABa.8CMDXwCMD
  42c0: 43 0a 07 60 8c 41 54 41 42 72 60 0a 02 00 41 30  C..`.ATABr`...A0
  42d0: 30 31 8c 41 54 41 42 72 60 0a 06 00 41 30 30 35  01.ATABr`...A005
  42e0: 70 68 43 4d 44 58 70 69 41 30 30 31 70 6a 41 30  phCMDXpiA001pjA0
  42f0: 30 35 75 43 4d 44 43 14 42 24 47 54 46 5f 0a 70  05uCMDC.B$GTF_.p
  4300: 69 5b 31 70 0a 00 43 4d 44 43 08 49 44 34 39 0b  i[1p..CMDC.ID49.
  4310: 00 0c 08 49 44 35 39 0a 00 08 49 44 35 33 0a 04  ...ID59...ID53..
  4320: 08 49 44 36 33 0b 00 0f 08 49 44 38 38 0b 00 0f  .ID63....ID88...
  4330: 08 49 52 44 59 0a 01 08 50 49 4f 54 0a 00 08 44  .IRDY...PIOT...D
  4340: 4d 41 54 0a 00 a0 4d 05 93 87 69 0b 00 02 8b 69  MAT...M...i....i
  4350: 0a 62 49 57 34 39 70 49 57 34 39 49 44 34 39 8b  .bIW49pIW49ID49.
  4360: 69 0a 6a 49 57 35 33 70 49 57 35 33 49 44 35 33  i.jIW53pIW53ID53
  4370: 8b 69 0a 7e 49 57 36 33 70 49 57 36 33 49 44 36  .i.~IW63pIW63ID6
  4380: 33 8b 69 0a 76 49 57 35 39 70 49 57 35 39 49 44  3.i.vIW59pIW59ID
  4390: 35 39 8b 69 0a b0 49 57 38 38 70 49 57 38 38 49  59.i..IW88pIW88I
  43a0: 44 38 38 70 0a a0 67 a0 48 05 68 70 0a b0 67 7b  D88p..g.H.hp..g{
  43b0: 43 48 4e 46 0a 08 49 52 44 59 a0 12 7b 43 48 4e  CHNF..IRDY..{CHN
  43c0: 46 0a 10 00 70 50 49 4f 31 50 49 4f 54 a1 0a 70  F...pPIO1PIOT..p
  43d0: 50 49 4f 30 50 49 4f 54 a0 27 7b 43 48 4e 46 0a  PIO0PIOT.'{CHNF.
  43e0: 04 00 a0 12 7b 43 48 4e 46 0a 10 00 70 44 4d 41  ....{CHNF...pDMA
  43f0: 31 44 4d 41 54 a1 0a 70 44 4d 41 30 44 4d 41 54  1DMAT..pDMA0DMAT
  4400: a1 28 7b 43 48 4e 46 0a 02 49 52 44 59 70 50 49  .({CHNF..IRDYpPI
  4410: 4f 30 50 49 4f 54 a0 12 7b 43 48 4e 46 0a 01 00  O0PIOT..{CHNF...
  4420: 70 44 4d 41 30 44 4d 41 54 a0 47 04 90 90 7b 49  pDMA0DMAT.G...{I
  4430: 44 35 33 0a 04 00 7b 49 44 38 38 0b 00 ff 00 44  D53...{ID88....D
  4440: 4d 41 54 70 89 83 88 54 49 4d 30 0a 03 00 02 44  MATp...TIM0....D
  4450: 4d 41 54 00 0a 00 0a 00 61 a0 09 94 61 0a 05 70  MAT.....a...a..p
  4460: 0a 05 61 47 54 46 42 41 54 30 31 7d 0a 40 61 00  ..aGTFBAT01}.@a.
  4470: 67 a1 46 04 a0 43 04 90 7b 49 44 36 33 0b 00 ff  g.F..C..{ID63...
  4480: 00 50 49 4f 54 7b 89 83 88 54 49 4d 30 0a 00 00  .PIOT{...TIM0...
  4490: 04 50 49 4f 54 00 0a 00 0a 00 0a 03 60 7d 0a 20  .PIOT.......`}.
  44a0: 83 88 83 88 54 49 4d 30 0a 07 00 60 00 61 47 54  ....TIM0...`.aGT
  44b0: 46 42 41 54 30 31 61 67 a0 38 49 52 44 59 7b 89  FBAT01ag.8IRDY{.
  44c0: 83 88 54 49 4d 30 0a 00 00 04 50 49 4f 54 00 0a  ..TIM0....PIOT..
  44d0: 00 0a 00 0a 07 60 7d 0a 08 83 88 83 88 54 49 4d  .....`}......TIM
  44e0: 30 0a 06 00 60 00 61 47 54 46 42 41 54 30 31 61  0...`.aGTFBAT01a
  44f0: 67 a1 17 a0 15 7b 49 44 34 39 0b 00 04 00 47 54  g....{ID49....GT
  4500: 46 42 41 54 30 31 0a 01 67 a0 24 90 7b 49 44 35  FBAT01..g.$.{ID5
  4510: 39 0b 00 01 00 7b 49 44 35 39 0a ff 00 47 54 46  9....{ID59...GTF
  4520: 42 41 54 30 33 7b 49 44 35 39 0a ff 00 67 70 41  BAT03{ID59...gpA
  4530: 54 41 42 5b 31 a4 41 54 41 42 14 2c 52 41 54 41  TAB[1.ATAB.,RATA
  4540: 01 8c 68 0a 00 43 4d 44 4e 77 43 4d 44 4e 0a 38  ..h..CMDNwCMDN.8
  4550: 60 5b 13 68 0a 08 60 52 45 54 42 70 52 45 54 42  `[.h..`RETBpRETB
  4560: 5b 31 a4 52 45 54 42 5b 82 4d 79 50 43 49 45 08  [1.RETB[.MyPCIE.
  4570: 5f 41 44 52 0c 00 00 02 00 08 5f 55 49 44 0a d8  _ADR......_UID..
  4580: 5b 80 42 46 45 32 02 0a 00 0a ff 5b 81 1f 42 46  [.BFE2.....[..BF
  4590: 45 32 00 00 40 24 00 09 50 47 45 4e 01 00 46 21  E2..@$..PGEN..F!
  45a0: 00 10 50 47 53 54 01 50 47 50 44 01 14 40 0c 5f  ..PGST.PGPD..@._
  45b0: 50 52 54 00 a0 42 08 93 5c 47 50 49 43 00 a4 12  PRT..B..\GPIC...
  45c0: 47 07 04 12 1c 04 0b ff ff 0a 00 5c 2f 04 5f 53  G..........\/._S
  45d0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00  B_PCI0LPC_LNKA..
  45e0: 12 1c 04 0b ff ff 0a 01 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  45f0: 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1c 04  CI0LPC_LNKB.....
  4600: 0b ff ff 0a 02 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  4610: 4c 50 43 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff ff  LPC_LNKC........
  4620: 0a 03 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  4630: 5f 4c 4e 4b 44 0a 00 a1 35 a4 12 32 04 12 0b 04  _LNKD...5..2....
  4640: 0b ff ff 0a 00 0a 00 0a 10 12 0b 04 0b ff ff 0a  ................
  4650: 01 0a 00 0a 11 12 0b 04 0b ff ff 0a 02 0a 00 0a  ................
  4660: 12 12 0b 04 0b ff ff 0a 03 0a 00 0a 13 5b 82 47  .............[.G
  4670: 1a 50 43 49 45 08 5f 41 44 52 0a 03 08 5f 55 49  .PCIE._ADR..._UI
  4680: 44 0a e1 08 5f 50 52 57 12 06 02 0a 18 0a 05 14  D..._PRW........
  4690: 46 18 5f 50 52 54 00 a0 46 10 93 5c 47 50 49 43  F._PRT..F..\GPIC
  46a0: 00 a4 12 4b 0f 08 12 1e 04 0c ff ff 01 00 0a 00  ...K............
  46b0: 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c  \/._SB_PCI0LPC_L
  46c0: 4e 4b 41 0a 00 12 1e 04 0c ff ff 01 00 0a 01 5c  NKA............\
  46d0: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  46e0: 4b 42 0a 00 12 1e 04 0c ff ff 01 00 0a 02 5c 2f  KB............\/
  46f0: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  4700: 43 0a 00 12 1e 04 0c ff ff 01 00 0a 03 5c 2f 04  C............\/.
  4710: 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 44  _SB_PCI0LPC_LNKD
  4720: 0a 00 12 1e 04 0c ff ff 02 00 0a 00 5c 2f 04 5f  ............\/._
  4730: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a  SB_PCI0LPC_LNKD.
  4740: 00 12 1e 04 0c ff ff 02 00 0a 01 5c 2f 04 5f 53  ...........\/._S
  4750: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00  B_PCI0LPC_LNKA..
  4760: 12 1e 04 0c ff ff 02 00 0a 02 5c 2f 04 5f 53 42  ..........\/._SB
  4770: 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12  _PCI0LPC_LNKB...
  4780: 1e 04 0c ff ff 02 00 0a 03 5c 2f 04 5f 53 42 5f  .........\/._SB_
  4790: 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a 00 a1 47  PCI0LPC_LNKC...G
  47a0: 07 a4 12 43 07 08 12 0d 04 0c ff ff 01 00 0a 00  ...C............
  47b0: 0a 00 0a 18 12 0d 04 0c ff ff 01 00 0a 01 0a 00  ................
  47c0: 0a 19 12 0d 04 0c ff ff 01 00 0a 02 0a 00 0a 1a  ................
  47d0: 12 0d 04 0c ff ff 01 00 0a 03 0a 00 0a 1b 12 0d  ................
  47e0: 04 0c ff ff 02 00 0a 00 0a 00 0a 1b 12 0d 04 0c  ................
  47f0: ff ff 02 00 0a 01 0a 00 0a 18 12 0d 04 0c ff ff  ................
  4800: 02 00 0a 02 0a 00 0a 19 12 0d 04 0c ff ff 02 00  ................
  4810: 0a 03 0a 00 0a 1a 5b 82 4e 4e 50 43 49 57 08 5f  ......[.NNPCIW._
  4820: 41 44 52 0a 00 08 5f 55 49 44 0a e0 14 4a 22 5f  ADR..._UID...J"_
  4830: 50 52 54 00 a0 4a 17 93 5c 47 50 49 43 00 a4 12  PRT..J..\GPIC...
  4840: 4f 16 0c 12 1c 04 0b ff ff 0a 00 5c 2f 04 5f 53  O..........\/._S
  4850: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00  B_PCI0LPC_LNKA..
  4860: 12 1c 04 0b ff ff 0a 01 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  4870: 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1c 04  CI0LPC_LNKB.....
  4880: 0b ff ff 0a 02 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  4890: 4c 50 43 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff ff  LPC_LNKC........
  48a0: 0a 03 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  48b0: 5f 4c 4e 4b 44 0a 00 12 1e 04 0c ff ff 01 00 0a  _LNKD...........
  48c0: 00 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f  .\/._SB_PCI0LPC_
  48d0: 4c 4e 4b 42 0a 00 12 1e 04 0c ff ff 01 00 0a 01  LNKB............
  48e0: 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c  \/._SB_PCI0LPC_L
  48f0: 4e 4b 43 0a 00 12 1e 04 0c ff ff 01 00 0a 02 5c  NKC............\
  4900: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  4910: 4b 44 0a 00 12 1e 04 0c ff ff 01 00 0a 03 5c 2f  KD............\/
  4920: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  4930: 41 0a 00 12 1e 04 0c ff ff 02 00 0a 00 5c 2f 04  A............\/.
  4940: 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 43  _SB_PCI0LPC_LNKC
  4950: 0a 00 12 1e 04 0c ff ff 02 00 0a 01 5c 2f 04 5f  ............\/._
  4960: 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a  SB_PCI0LPC_LNKD.
  4970: 00 12 1e 04 0c ff ff 02 00 0a 02 5c 2f 04 5f 53  ...........\/._S
  4980: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00  B_PCI0LPC_LNKA..
  4990: 12 1e 04 0c ff ff 02 00 0a 03 5c 2f 04 5f 53 42  ..........\/._SB
  49a0: 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00 a1  _PCI0LPC_LNKB...
  49b0: 47 0a a4 12 43 0a 0c 12 0b 04 0b ff ff 0a 00 0a  G...C...........
  49c0: 00 0a 10 12 0b 04 0b ff ff 0a 01 0a 00 0a 11 12  ................
  49d0: 0b 04 0b ff ff 0a 02 0a 00 0a 12 12 0b 04 0b ff  ................
  49e0: ff 0a 03 0a 00 0a 13 12 0d 04 0c ff ff 01 00 0a  ................
  49f0: 00 0a 00 0a 11 12 0d 04 0c ff ff 01 00 0a 01 0a  ................
  4a00: 00 0a 12 12 0d 04 0c ff ff 01 00 0a 02 0a 00 0a  ................
  4a10: 13 12 0d 04 0c ff ff 01 00 0a 03 0a 00 0a 10 12  ................
  4a20: 0d 04 0c ff ff 02 00 0a 00 0a 00 0a 12 12 0d 04  ................
  4a30: 0c ff ff 02 00 0a 01 0a 00 0a 13 12 0d 04 0c ff  ................
  4a40: ff 02 00 0a 02 0a 00 0a 10 12 0d 04 0c ff ff 02  ................
  4a50: 00 0a 03 0a 00 0a 11 5b 82 41 0e 50 43 49 4f 08  .......[.A.PCIO.
  4a60: 5f 41 44 52 0a 00 08 5f 55 49 44 0a e4 08 5f 50  _ADR..._UID..._P
  4a70: 52 57 12 06 02 0a 18 0a 05 14 40 0c 5f 50 52 54  RW........@._PRT
  4a80: 00 a0 42 08 93 5c 47 50 49 43 00 a4 12 47 07 04  ..B..\GPIC...G..
  4a90: 12 1c 04 0b ff ff 0a 00 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  4aa0: 43 49 30 4c 50 43 5f 4c 4e 4b 41 0a 00 12 1c 04  CI0LPC_LNKA.....
  4ab0: 0b ff ff 0a 01 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  4ac0: 4c 50 43 5f 4c 4e 4b 42 0a 00 12 1c 04 0b ff ff  LPC_LNKB........
  4ad0: 0a 02 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43  ..\/._SB_PCI0LPC
  4ae0: 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff ff 0a 03 5c  _LNKC..........\
  4af0: 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e  /._SB_PCI0LPC_LN
  4b00: 4b 44 0a 00 a1 35 a4 12 32 04 12 0b 04 0b ff ff  KD...5..2.......
  4b10: 0a 00 0a 00 0a 10 12 0b 04 0b ff ff 0a 01 0a 00  ................
  4b20: 0a 11 12 0b 04 0b ff ff 0a 02 0a 00 0a 12 12 0b  ................
  4b30: 04 0b ff ff 0a 03 0a 00 0a 13 5b 82 44 0e 50 43  ..........[.D.PC
  4b40: 49 50 08 5f 41 44 52 0c 00 00 01 00 08 5f 55 49  IP._ADR......_UI
  4b50: 44 0a e5 08 5f 50 52 57 12 06 02 0a 18 0a 05 14  D..._PRW........
  4b60: 40 0c 5f 50 52 54 00 a0 42 08 93 5c 47 50 49 43  @._PRT..B..\GPIC
  4b70: 00 a4 12 47 07 04 12 1c 04 0b ff ff 0a 00 5c 2f  ...G..........\/
  4b80: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  4b90: 42 0a 00 12 1c 04 0b ff ff 0a 01 5c 2f 04 5f 53  B..........\/._S
  4ba0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 43 0a 00  B_PCI0LPC_LNKC..
  4bb0: 12 1c 04 0b ff ff 0a 02 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  4bc0: 43 49 30 4c 50 43 5f 4c 4e 4b 44 0a 00 12 1c 04  CI0LPC_LNKD.....
  4bd0: 0b ff ff 0a 03 5c 2f 04 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  4be0: 4c 50 43 5f 4c 4e 4b 41 0a 00 a1 35 a4 12 32 04  LPC_LNKA...5..2.
  4bf0: 12 0b 04 0b ff ff 0a 00 0a 00 0a 11 12 0b 04 0b  ................
  4c00: ff ff 0a 01 0a 00 0a 12 12 0b 04 0b ff ff 0a 02  ................
  4c10: 0a 00 0a 13 12 0b 04 0b ff ff 0a 03 0a 00 0a 10  ................
  4c20: 5b 82 44 0e 50 43 49 51 08 5f 41 44 52 0c 00 00  [.D.PCIQ._ADR...
  4c30: 02 00 08 5f 55 49 44 0a e6 08 5f 50 52 57 12 06  ..._UID..._PRW..
  4c40: 02 0a 09 0a 05 14 40 0c 5f 50 52 54 00 a0 42 08  ......@._PRT..B.
  4c50: 93 5c 47 50 49 43 00 a4 12 47 07 04 12 1c 04 0b  .\GPIC...G......
  4c60: ff ff 0a 00 5c 2f 04 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  4c70: 50 43 5f 4c 4e 4b 43 0a 00 12 1c 04 0b ff ff 0a  PC_LNKC.........
  4c80: 01 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f  .\/._SB_PCI0LPC_
  4c90: 4c 4e 4b 44 0a 00 12 1c 04 0b ff ff 0a 02 5c 2f  LNKD..........\/
  4ca0: 04 5f 53 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b  ._SB_PCI0LPC_LNK
  4cb0: 41 0a 00 12 1c 04 0b ff ff 0a 03 5c 2f 04 5f 53  A..........\/._S
  4cc0: 42 5f 50 43 49 30 4c 50 43 5f 4c 4e 4b 42 0a 00  B_PCI0LPC_LNKB..
  4cd0: a1 35 a4 12 32 04 12 0b 04 0b ff ff 0a 00 0a 00  .5..2...........
  4ce0: 0a 12 12 0b 04 0b ff ff 0a 01 0a 00 0a 13 12 0b  ................
  4cf0: 04 0b ff ff 0a 02 0a 00 0a 10 12 0b 04 0b ff ff  ................
  4d00: 0a 03 0a 00 0a 11 10 43 09 5c 5f 53 49 5f 5b 80  .......C.\_SI_[.
  4d10: 53 49 4f 52 01 0b 00 05 0a 30 5b 81 1a 53 49 4f  SIOR.....0[..SIO
  4d20: 52 01 00 40 06 00 19 50 4c 45 44 01 00 46 04 00  R..@...PLED..F..
  4d30: 19 42 4c 4e 4b 01 14 4b 05 5f 53 53 54 01 a0 45  .BLNK..K._SST..E
  4d40: 04 68 a0 11 93 68 0a 01 70 00 50 4c 45 44 70 00  .h...h..p.PLEDp.
  4d50: 42 4c 4e 4b a0 11 93 68 0a 02 70 00 50 4c 45 44  BLNK...h..p.PLED
  4d60: 70 00 42 4c 4e 4b a0 0b 93 68 0a 03 70 01 42 4c  p.BLNK...h..p.BL
  4d70: 4e 4b a0 11 93 68 0a 04 70 01 50 4c 45 44 70 00  NK...h..p.PLEDp.
  4d80: 42 4c 4e 4b a1 0d 70 01 50 4c 45 44 70 00 42 4c  BLNK..p.PLEDp.BL
  4d90: 4e 4b 14 07 5f 4d 53 47 01 a3                    NK.._MSG..

FACS @ 0x9facc000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0x9fb37000
  0000: 46 41 43 50 f4 00 00 00 03 1d 49 4e 54 45 4c 20  FACP......INTEL
  0010: 53 35 30 30 30 56 53 41 00 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 00 c0 ac 9f 00 10 b3 9f 01 04 09 00  ................
  0030: b2 00 00 00 a0 a1 00 00 00 04 00 00 00 00 00 00  ................
  0040: 04 04 00 00 00 00 00 00 00 00 00 00 08 04 00 00  ................
  0050: 28 04 00 00 78 08 00 00 04 02 00 04 08 08 20 00  (...x......... .
  0060: 65 00 e9 03 00 00 00 00 01 03 0d 00 32 03 00 00  e...........2...
  0070: a5 04 00 00 01 08 00 00 f9 0c 00 00 00 00 00 00  ................
  0080: 06 00 00 00 00 c0 ac 9f 00 00 00 00 00 10 b3 9f  ................
  0090: 00 00 00 00 01 20 00 00 00 04 00 00 00 00 00 00  ..... ..........
  00a0: 01 00 00 00 00 00 00 00 00 00 00 00 01 10 00 00  ................
  00b0: 04 04 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  00c0: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  00d0: 01 20 00 00 08 04 00 00 00 00 00 00 01 40 00 00  . ...........@..
  00e0: 28 04 00 00 00 00 00 00 01 40 20 00 78 08 00 00  (........@ .x...
  00f0: 00 00 00 00                                      ....

APIC @ 0x9fb36000
  0000: 41 50 49 43 c8 00 00 00 01 f2 49 4e 54 45 4c 20  APIC......INTEL
  0010: 53 35 30 30 30 56 53 41 00 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 00 00 e0 fe 01 00 00 00 00 08 00 00  ................
  0030: 01 00 00 00 00 08 01 06 01 00 00 00 00 08 02 01  ................
  0040: 01 00 00 00 00 08 03 07 01 00 00 00 00 08 04 84  ................
  0050: 00 00 00 00 00 08 05 85 00 00 00 00 00 08 06 86  ................
  0060: 00 00 00 00 00 08 07 87 00 00 00 00 01 0c 08 00  ................
  0070: 00 00 c0 fe 00 00 00 00 01 0c 09 00 00 00 c8 fe  ................
  0080: 18 00 00 00 02 0a 00 00 02 00 00 00 00 00 02 0a  ................
  0090: 00 09 09 00 00 00 0d 00 04 06 00 0d 00 01 04 06  ................
  00a0: 01 0d 00 01 04 06 02 0d 00 01 04 06 03 0d 00 01  ................
  00b0: 04 06 04 0d 00 01 04 06 05 0d 00 01 04 06 06 0d  ................
  00c0: 00 01 04 06 07 0d 00 01                          ........

SPCR @ 0x9fb30000
  0000: 53 50 43 52 50 00 00 00 01 77 49 4e 54 45 4c 20  SPCRP....wINTEL
  0010: 53 35 30 30 30 56 53 41 00 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 00 00 00 00 01 08 00 00 00 00 00 00  ................
  0030: 00 00 00 00 01 04 00 00 00 00 07 00 01 03 02 00  ................
  0040: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00  ................

HPET @ 0x9fb2f000
  0000: 48 50 45 54 38 00 00 00 01 b5 49 4e 54 45 4c 20  HPET8.....INTEL
  0010: 53 35 30 30 30 56 53 41 01 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 01 a2 86 80 00 00 00 00 00 00 d0 fe  ................
  0030: 00 00 00 00 00 80 00 00                          ........

MCFG @ 0x9fb2e000
  0000: 4d 43 46 47 3c 00 00 00 01 1d 49 4e 54 45 4c 20  MCFG<.....INTEL
  0010: 53 35 30 30 30 56 53 41 01 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 00 00 00 00 00 00 00 00 00 00 00 a0  ................
  0030: 00 00 00 00 00 00 00 ff 00 00 00 00              ............

SSDT @ 0x9fb2d000
  0000: 53 53 44 54 14 0a 00 00 02 4c 49 4e 54 45 4c 20  SSDT.....LINTEL
  0010: 45 49 53 54 20 20 20 20 00 40 00 00 49 4e 54 4c  EIST    .@..INTL
  0020: 13 00 00 01 10 3f 5c 00 08 43 46 47 44 0c 30 00  .....?\..CFGD.0.
  0030: 00 80 08 50 44 43 46 0c 00 00 00 80 08 50 44 46  ...PDCF......PDF
  0040: 4c 0c 00 00 00 80 10 1d 5f 50 52 5f 14 17 5f 50  L......._PR_.._P
  0050: 44 43 01 8a 68 0a 08 43 41 50 30 70 43 41 50 30  DC..h..CAP0pCAP0
  0060: 50 44 43 46 10 45 13 5c 2e 5f 50 52 5f 43 50 55  PDCF.E.\._PR_CPU
  0070: 30 08 5f 50 43 54 12 2c 02 11 14 0a 11 82 0c 00  0._PCT.,........
  0080: 7f 00 00 00 00 00 00 00 00 00 00 00 79 00 11 14  ............y...
  0090: 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00 00  ................
  00a0: 00 79 00 08 5f 50 53 44 12 18 01 12 15 05 0a 05  .y.._PSD........
  00b0: 0a 00 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  00c0: 80 08 5f 50 53 53 12 49 0c 06 12 20 06 0c 00 00  .._PSS.I... ....
  00d0: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  00e0: 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00  ............ ...
  00f0: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0100: 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c  ............. ..
  0110: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0120: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06  .............. .
  0130: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  0140: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20  ...............
  0150: 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0160: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12  ................
  0170: 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00   ...............
  0180: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0190: 14 09 5f 50 50 43 00 a4 0a 00 10 45 13 5c 2e 5f  .._PPC.....E.\._
  01a0: 50 52 5f 43 50 55 31 08 5f 50 43 54 12 2c 02 11  PR_CPU1._PCT.,..
  01b0: 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00  ................
  01c0: 00 00 79 00 11 14 0a 11 82 0c 00 7f 00 00 00 00  ..y.............
  01d0: 00 00 00 00 00 00 00 79 00 08 5f 50 53 44 12 18  .......y.._PSD..
  01e0: 01 12 15 05 0a 05 0a 00 0c 00 00 00 80 0c 00 00  ................
  01f0: 00 80 0c 00 00 00 80 08 5f 50 53 53 12 49 0c 06  ........_PSS.I..
  0200: 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  . ..............
  0210: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  0220: 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00  .. .............
  0230: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0240: 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c  ... ............
  0250: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0260: 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80  .... ...........
  0270: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  0280: 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00  ..... ..........
  0290: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  02a0: 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00  ...... .........
  02b0: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  02c0: 80 0c 00 00 00 80 14 09 5f 50 50 43 00 a4 0a 00  ........_PPC....
  02d0: 10 45 13 5c 2e 5f 50 52 5f 43 50 55 32 08 5f 50  .E.\._PR_CPU2._P
  02e0: 43 54 12 2c 02 11 14 0a 11 82 0c 00 7f 00 00 00  CT.,............
  02f0: 00 00 00 00 00 00 00 00 79 00 11 14 0a 11 82 0c  ........y.......
  0300: 00 7f 00 00 00 00 00 00 00 00 00 00 00 79 00 08  .............y..
  0310: 5f 50 53 44 12 18 01 12 15 05 0a 05 0a 00 0c 00  _PSD............
  0320: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 08 5f 50  .............._P
  0330: 53 53 12 49 0c 06 12 20 06 0c 00 00 00 80 0c 00  SS.I... ........
  0340: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0350: 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c  ........ .......
  0360: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0370: 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80  ......... ......
  0380: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  0390: 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00  .......... .....
  03a0: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  03b0: 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00  ........... ....
  03c0: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  03d0: 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00  ............ ...
  03e0: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  03f0: 00 80 0c 00 00 00 80 0c 00 00 00 80 14 09 5f 50  .............._P
  0400: 50 43 00 a4 0a 00 10 45 13 5c 2e 5f 50 52 5f 43  PC.....E.\._PR_C
  0410: 50 55 33 08 5f 50 43 54 12 2c 02 11 14 0a 11 82  PU3._PCT.,......
  0420: 0c 00 7f 00 00 00 00 00 00 00 00 00 00 00 79 00  ..............y.
  0430: 11 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00  ................
  0440: 00 00 00 79 00 08 5f 50 53 44 12 18 01 12 15 05  ...y.._PSD......
  0450: 0a 05 0a 00 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0460: 00 00 80 08 5f 50 53 53 12 49 0c 06 12 20 06 0c  ...._PSS.I... ..
  0470: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0480: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06  .............. .
  0490: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  04a0: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20  ...............
  04b0: 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  04c0: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12  ................
  04d0: 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00   ...............
  04e0: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  04f0: 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  . ..............
  0500: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  0510: 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00  .. .............
  0520: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0530: 00 80 14 09 5f 50 50 43 00 a4 0a 00 10 45 13 5c  ...._PPC.....E.\
  0540: 2e 5f 50 52 5f 43 50 55 34 08 5f 50 43 54 12 2c  ._PR_CPU4._PCT.,
  0550: 02 11 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00  ................
  0560: 00 00 00 00 79 00 11 14 0a 11 82 0c 00 7f 00 00  ....y...........
  0570: 00 00 00 00 00 00 00 00 00 79 00 08 5f 50 53 44  .........y.._PSD
  0580: 12 18 01 12 15 05 0a 05 0a 00 0c 00 00 00 80 0c  ................
  0590: 00 00 00 80 0c 00 00 00 80 08 5f 50 53 53 12 49  .........._PSS.I
  05a0: 0c 06 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c  ... ............
  05b0: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  05c0: 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80  .... ...........
  05d0: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  05e0: 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00  ..... ..........
  05f0: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0600: 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00  ...... .........
  0610: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  0620: 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00  ....... ........
  0630: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0640: 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c  ........ .......
  0650: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0660: 00 00 80 0c 00 00 00 80 14 09 5f 50 50 43 00 a4  .........._PPC..
  0670: 0a 00 10 45 13 5c 2e 5f 50 52 5f 43 50 55 35 08  ...E.\._PR_CPU5.
  0680: 5f 50 43 54 12 2c 02 11 14 0a 11 82 0c 00 7f 00  _PCT.,..........
  0690: 00 00 00 00 00 00 00 00 00 00 79 00 11 14 0a 11  ..........y.....
  06a0: 82 0c 00 7f 00 00 00 00 00 00 00 00 00 00 00 79  ...............y
  06b0: 00 08 5f 50 53 44 12 18 01 12 15 05 0a 05 0a 00  .._PSD..........
  06c0: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 08  ................
  06d0: 5f 50 53 53 12 49 0c 06 12 20 06 0c 00 00 00 80  _PSS.I... ......
  06e0: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  06f0: 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00  .......... .....
  0700: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0710: 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00  ........... ....
  0720: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  0730: 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00  ............ ...
  0740: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0750: 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06 0c  ............. ..
  0760: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  0770: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12 20 06  .............. .
  0780: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  0790: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 14 09  ................
  07a0: 5f 50 50 43 00 a4 0a 00 10 45 13 5c 2e 5f 50 52  _PPC.....E.\._PR
  07b0: 5f 43 50 55 36 08 5f 50 43 54 12 2c 02 11 14 0a  _CPU6._PCT.,....
  07c0: 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00 00 00  ................
  07d0: 79 00 11 14 0a 11 82 0c 00 7f 00 00 00 00 00 00  y...............
  07e0: 00 00 00 00 00 79 00 08 5f 50 53 44 12 18 01 12  .....y.._PSD....
  07f0: 15 05 0a 05 0a 00 0c 00 00 00 80 0c 00 00 00 80  ................
  0800: 0c 00 00 00 80 08 5f 50 53 53 12 49 0c 06 12 20  ......_PSS.I...
  0810: 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0820: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 12  ................
  0830: 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00   ...............
  0840: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0850: 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  . ..............
  0860: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  0870: 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c 00  .. .............
  0880: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  0890: 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80 0c  ... ............
  08a0: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  08b0: 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00 00 80  .... ...........
  08c0: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  08d0: 00 00 00 80 14 09 5f 50 50 43 00 a4 0a 00 10 45  ......_PPC.....E
  08e0: 13 5c 2e 5f 50 52 5f 43 50 55 37 08 5f 50 43 54  .\._PR_CPU7._PCT
  08f0: 12 2c 02 11 14 0a 11 82 0c 00 7f 00 00 00 00 00  .,..............
  0900: 00 00 00 00 00 00 79 00 11 14 0a 11 82 0c 00 7f  ......y.........
  0910: 00 00 00 00 00 00 00 00 00 00 00 79 00 08 5f 50  ...........y.._P
  0920: 53 44 12 18 01 12 15 05 0a 05 0a 00 0c 00 00 00  SD..............
  0930: 80 0c 00 00 00 80 0c 00 00 00 80 08 5f 50 53 53  ............_PSS
  0940: 12 49 0c 06 12 20 06 0c 00 00 00 80 0c 00 00 00  .I... ..........
  0950: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0960: 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00 00  ...... .........
  0970: 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00  ................
  0980: 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c 00  ....... ........
  0990: 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00  ................
  09a0: 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80 0c  ........ .......
  09b0: 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c 00  ................
  09c0: 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00 80  ......... ......
  09d0: 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80 0c  ................
  09e0: 00 00 00 80 0c 00 00 00 80 12 20 06 0c 00 00 00  .......... .....
  09f0: 80 0c 00 00 00 80 0c 00 00 00 80 0c 00 00 00 80  ................
  0a00: 0c 00 00 00 80 0c 00 00 00 80 14 09 5f 50 50 43  ............_PPC
  0a10: 00 a4 0a 00                                      ....

SSDT @ 0x9fb2c000
  0000: 53 53 44 54 93 01 00 00 02 36 49 4e 54 45 4c 20  SSDT.....6INTEL
  0010: 49 50 4d 49 20 20 20 20 00 40 00 00 49 4e 54 4c  IPMI    .@..INTL
  0020: 13 00 00 01 10 4e 16 5c 00 08 45 43 46 4c 0c 00  .....N.\..ECFL..
  0030: 00 00 80 08 4f 53 4e 56 ff 14 4d 07 4f 53 4e 46  ....OSNV..M.OSNF
  0040: 00 a0 0d 92 93 4f 53 4e 56 ff a4 4f 53 4e 56 70  .....OSNV..OSNVp
  0050: 0a 01 4f 53 4e 56 a0 42 05 5b 12 5c 5f 4f 53 49  ..OSNV.B.[.\_OSI
  0060: 61 a0 1b 5c 5f 4f 53 49 0d 57 69 6e 64 6f 77 73  a..\_OSI.Windows
  0070: 20 32 30 30 36 00 70 0a 00 4f 53 4e 56 a0 2b 5c   2006.p..OSNV.+\
  0080: 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30  _OSI.Windows 200
  0090: 31 2e 31 20 53 50 31 00 a0 10 7b 45 43 46 4c 0a  1.1 SP1...{ECFL.
  00a0: 01 00 70 0a 00 4f 53 4e 56 a1 08 70 0a 01 4f 53  ..p..OSNV..p..OS
  00b0: 4e 56 a4 4f 53 4e 56 5b 82 4a 0d 4d 49 30 5f 08  NV.OSNV[.J.MI0_.
  00c0: 5f 48 49 44 0c 26 09 00 01 08 5f 55 49 44 0a 00  _HID.&...._UID..
  00d0: 14 19 5f 53 54 41 00 70 0a 00 60 a0 0c 93 4f 53  .._STA.p..`...OS
  00e0: 4e 46 0a 00 70 0a 0f 60 a4 60 14 38 5f 50 53 30  NF..p..`.`.8_PS0
  00f0: 00 70 5c 2e 5f 53 42 5f 53 4d 49 53 60 70 0a 50  .p\._SB_SMIS`p.P
  0100: 5c 2e 5f 53 42 5f 53 4d 49 53 70 0a af 5c 2e 5f  \._SB_SMISp..\._
  0110: 53 42 5f 53 4d 49 43 70 60 5c 2e 5f 53 42 5f 53  SB_SMICp`\._SB_S
  0120: 4d 49 53 14 38 5f 50 53 33 00 70 5c 2e 5f 53 42  MIS.8_PS3.p\._SB
  0130: 5f 53 4d 49 53 60 70 0a 55 5c 2e 5f 53 42 5f 53  _SMIS`p.U\._SB_S
  0140: 4d 49 53 70 0a af 5c 2e 5f 53 42 5f 53 4d 49 43  MISp..\._SB_SMIC
  0150: 70 60 5c 2e 5f 53 42 5f 53 4d 49 53 14 06 5f 44  p`\._SB_SMIS.._D
  0160: 49 53 00 08 5f 43 52 53 11 15 0a 12 47 01 a2 0c  IS.._CRS....G...
  0170: a2 0c 00 01 47 01 a3 0c a3 0c 00 01 79 00 14 09  ....G.......y...
  0180: 5f 49 46 54 00 a4 0a 01 14 0a 5f 53 52 56 00 a4  _IFT......_SRV..
  0190: 0b 00 02                                         ...

SSDT @ 0x9fb2b000
  0000: 53 53 44 54 ce 00 00 00 02 f9 49 4e 54 45 4c 20  SSDT......INTEL
  0010: 43 53 54 20 20 20 20 20 00 40 00 00 49 4e 54 4c  CST     .@..INTL
  0020: 13 00 00 01 10 45 05 5c 2e 5f 50 52 5f 43 50 55  .....E.\._PR_CPU
  0030: 30 08 5f 43 53 54 12 43 04 03 0a 02 12 1e 04 11  0._CST.C........
  0040: 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00  ................
  0050: 00 00 79 00 0a 01 0a 14 0b e8 03 12 1e 04 11 14  ..y.............
  0060: 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00 00 00  ................
  0070: 00 79 00 0a 02 0a 28 0b ee 02 10 0b 5c 2e 5f 50  .y....(.....\._P
  0080: 52 5f 43 50 55 31 10 0b 5c 2e 5f 50 52 5f 43 50  R_CPU1..\._PR_CP
  0090: 55 32 10 0b 5c 2e 5f 50 52 5f 43 50 55 33 10 0b  U2..\._PR_CPU3..
  00a0: 5c 2e 5f 50 52 5f 43 50 55 34 10 0b 5c 2e 5f 50  \._PR_CPU4..\._P
  00b0: 52 5f 43 50 55 35 10 0b 5c 2e 5f 50 52 5f 43 50  R_CPU5..\._PR_CP
  00c0: 55 36 10 0b 5c 2e 5f 50 52 5f 43 50 55 37        U6..\._PR_CPU7

HEST @ 0x9fb2a000
  0000: 48 45 53 54 a8 00 00 00 01 ce 49 4e 54 45 4c 20  HEST......INTEL
  0010: 53 35 30 30 30 56 53 41 01 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 01 00 00 00 02 00 00 00 09 00 00 00 ff ff 00 01  ................
  0030: 01 00 00 00 01 00 00 00 00 10 00 00 00 40 00 04  .............@..
  0040: 10 d0 a5 9f 00 00 00 00 03 1c 00 00 00 00 00 00  ................
  0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0060: 00 00 00 00 00 10 00 00 09 00 01 00 ff ff 00 01  ................
  0070: 01 00 00 00 01 00 00 00 00 10 00 00 00 40 00 04  .............@..
  0080: 18 e0 a5 9f 00 00 00 00 04 1c 00 00 00 00 00 00  ................
  0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00a0: 00 00 00 00 00 10 00 00                          ........

BERT @ 0x9fb29000
  0000: 42 45 52 54 30 00 00 00 01 c6 49 4e 54 45 4c 20  BERT0.....INTEL
  0010: 53 35 30 30 30 56 53 41 01 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 01 00 00 00 00 80 00 00 10 30 a6 9f 00 00 00 00  .........0......

ERST @ 0x9fb28000
  0000: 45 52 53 54 30 02 00 00 01 12 49 4e 54 45 4c 20  ERST0.....INTEL
  0010: 53 35 30 30 30 56 53 41 01 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 01 00 00 00 30 00 00 00 00 00 00 00 10 00 00 00  ....0...........
  0030: 00 03 00 00 00 40 00 04 10 10 a6 9f 00 00 00 00  .....@..........
  0040: 02 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  0050: 01 03 00 00 00 40 00 04 10 10 a6 9f 00 00 00 00  .....@..........
  0060: 01 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  0070: 02 03 00 00 00 40 00 04 10 10 a6 9f 00 00 00 00  .....@..........
  0080: 03 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  0090: 03 04 01 00 00 40 00 04 10 10 a6 9f 00 00 00 00  .....@..........
  00a0: 00 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  00b0: 04 02 00 00 00 40 00 04 28 10 a6 9f 00 00 00 00  .....@..(.......
  00c0: 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
  00d0: 05 03 00 00 01 08 00 01 b2 00 00 00 00 00 00 00  ................
  00e0: 9c 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  00f0: 06 01 00 00 00 40 00 04 38 10 a6 9f 00 00 00 00  .....@..8.......
  0100: 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  0110: 07 00 00 00 00 40 00 04 30 10 a6 9f 00 00 00 00  .....@..0.......
  0120: 00 00 00 00 00 00 00 00 fe 01 00 00 00 00 00 00  ................
  0130: 08 00 00 00 00 40 00 04 68 10 a6 9f 00 00 00 00  .....@..h.......
  0140: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  0150: 09 02 00 00 00 40 00 04 18 10 a6 9f 00 00 00 00  .....@..........
  0160: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  0170: 0a 00 00 00 00 40 00 04 40 10 a6 9f 00 00 00 00  .....@..@.......
  0180: 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
  0190: 0b 03 00 00 00 40 00 04 10 10 a6 9f 00 00 00 00  .....@..........
  01a0: 0f 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  01b0: 0c 00 00 00 00 40 00 04 20 10 a6 9f 00 00 00 00  .....@.. .......
  01c0: 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
  01d0: 0d 00 00 00 00 40 00 04 48 10 a6 9f 00 00 00 00  .....@..H.......
  01e0: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  01f0: 0e 00 00 00 00 40 00 04 50 10 a6 9f 00 00 00 00  .....@..P.......
  0200: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  0210: 0f 00 00 00 00 40 00 04 58 10 a6 9f 00 00 00 00  .....@..X.......
  0220: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................

EINJ @ 0x9fb27000
  0000: 45 49 4e 4a 30 01 00 00 01 bf 49 4e 54 45 4c 20  EINJ0.....INTEL
  0010: 53 35 30 30 30 56 53 41 01 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 01 00 00 00 30 00 00 00 00 00 00 00 08 00 00 00  ....0...........
  0030: 00 03 01 00 00 40 00 04 10 b0 a4 9f 00 00 00 00  .....@..........
  0040: aa 55 aa 55 00 00 00 00 ff ff ff ff 00 00 00 00  .U.U............
  0050: 01 00 00 00 00 40 00 04 20 b0 a4 9f 00 00 00 00  .....@.. .......
  0060: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  0070: 02 02 01 00 00 40 00 04 18 b0 a4 9f 00 00 00 00  .....@..........
  0080: 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
  0090: 03 00 00 00 00 40 00 04 28 b0 a4 9f 00 00 00 00  .....@..(.......
  00a0: 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
  00b0: 04 03 01 00 00 40 00 04 10 b0 a4 9f 00 00 00 00  .....@..........
  00c0: 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
  00d0: 05 03 01 00 01 10 00 02 b2 00 00 00 00 00 00 00  ................
  00e0: 9a 00 00 00 00 00 00 00 ff ff 00 00 00 00 00 00  ................
  00f0: 06 01 00 00 00 40 00 04 30 b0 a4 9f 00 00 00 00  .....@..0.......
  0100: 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  0110: 07 00 01 00 00 40 00 04 38 b0 a4 9f 00 00 00 00  .....@..8.......
  0120: 00 00 00 00 00 00 00 00 fe 01 00 00 00 00 00 00  ................

XSDT @ 0x9fb39120
  0000: 58 53 44 54 84 00 00 00 01 80 49 4e 54 45 4c 20  XSDT......INTEL
  0010: 53 35 30 30 30 56 53 41 00 00 00 00 49 4e 54 4c  S5000VSA....INTL
  0020: 13 00 00 01 00 70 b3 9f 00 00 00 00 00 60 b3 9f  .....p.......`..
  0030: 00 00 00 00 00 00 b3 9f 00 00 00 00 00 f0 b2 9f  ................
  0040: 00 00 00 00 00 e0 b2 9f 00 00 00 00 00 d0 b2 9f  ................
  0050: 00 00 00 00 00 c0 b2 9f 00 00 00 00 00 b0 b2 9f  ................
  0060: 00 00 00 00 00 a0 b2 9f 00 00 00 00 00 90 b2 9f  ................
  0070: 00 00 00 00 00 80 b2 9f 00 00 00 00 00 70 b2 9f  .............p..
  0080: 00 00 00 00                                      ....

RSD PTR @ 0xf03c0
  0000: 52 53 44 20 50 54 52 20 29 49 4e 54 45 4c 20 02  RSD PTR )INTEL .
  0010: 38 90 b3 9f 24 00 00 00 20 91 b3 9f 00 00 00 00  8...$... .......
  0020: d9 00 00 00                                      ....

# dmesg
Linux version 2.6.23.12 (root@pallas) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 SMP PREEMPT Sun Jan 6 03:06:32 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000009e24c000 (usable)
 BIOS-e820: 000000009e24c000 - 000000009e30e000 (ACPI NVS)
 BIOS-e820: 000000009e30e000 - 000000009fa32000 (usable)
 BIOS-e820: 000000009fa32000 - 000000009fa9a000 (reserved)
 BIOS-e820: 000000009fa9a000 - 000000009facc000 (usable)
 BIOS-e820: 000000009facc000 - 000000009fb1a000 (ACPI NVS)
 BIOS-e820: 000000009fb1a000 - 000000009fb27000 (usable)
 BIOS-e820: 000000009fb27000 - 000000009fb3a000 (ACPI data)
 BIOS-e820: 000000009fb3a000 - 000000009fc00000 (usable)
 BIOS-e820: 000000009fc00000 - 00000000b0000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 00000000ffe0c000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000160000000 (usable)
4736MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fd190
NX (Execute Disable) protection: active
Entering add_active_range(0, 0, 1441792) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1441792
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1441792
On node 0 totalpages: 1441792
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 9472 pages used for memmap
  HighMem zone: 1202944 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
ACPI: RSDP 000F03C0, 0024 (r2 INTEL )
ACPI: XSDT 9FB39120, 0084 (r1 INTEL  S5000VSA        0 INTL  1000013)
ACPI: FACP 9FB37000, 00F4 (r3 INTEL  S5000VSA        0 INTL  1000013)
ACPI: DSDT 9FB31000, 4D9A (r2 INTEL  S5000VSA        8 INTL  1000013)
ACPI: FACS 9FACC000, 0040
ACPI: APIC 9FB36000, 00C8 (r1 INTEL  S5000VSA        0 INTL  1000013)
ACPI: SPCR 9FB30000, 0050 (r1 INTEL  S5000VSA        0 INTL  1000013)
ACPI: HPET 9FB2F000, 0038 (r1 INTEL  S5000VSA        1 INTL  1000013)
ACPI: MCFG 9FB2E000, 003C (r1 INTEL  S5000VSA        1 INTL  1000013)
ACPI: SSDT 9FB2D000, 0A14 (r2 INTEL  EIST         4000 INTL  1000013)
ACPI: SSDT 9FB2C000, 0193 (r2 INTEL  IPMI         4000 INTL  1000013)
ACPI: SSDT 9FB2B000, 00CE (r2 INTEL  CST          4000 INTL  1000013)
ACPI: HEST 9FB2A000, 00A8 (r1 INTEL  S5000VSA        1 INTL        1)
ACPI: BERT 9FB29000, 0030 (r1 INTEL  S5000VSA        1 INTL        1)
ACPI: ERST 9FB28000, 0230 (r1 INTEL  S5000VSA        1 INTL        1)
ACPI: EINJ 9FB27000, 0130 (r1 INTEL  S5000VSA        1 INTL        1)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x87] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at b8000000 (gap: b0000000:4fe00000)
Built 1 zonelists in Zone order.  Total pages: 1430528
Kernel command line: auto BOOT_IMAGE=Linux ro root=801
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec80000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1995.058 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 4133804k/5767168k available (1821k kernel code, 53788k reserved, 
768k data, 224k init, 3271124k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc038d000 - 0xc03c5000   ( 224 kB)
      .data : 0xc02c74e8 - 0xc0387604   ( 768 kB)
      .text : 0xc0100000 - 0xc02c74e8   (1821 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3992.38 BogoMIPS 
(lpj=19961941)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 
0004e33d 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0004e33d 
00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Xeon(R) CPU            5130  @ 2.00GHz stepping 06
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.03 BogoMIPS 
(lpj=19950166)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 
0004e33d 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0004e33d 
00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Xeon(R) CPU            5130  @ 2.00GHz stepping 06
SMP alternatives: switching to SMP code
Booting processor 2/6 eip 3000
Initializing CPU#2
Calibrating delay using timer specific routine.. 3990.06 BogoMIPS 
(lpj=19950322)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 
0004e33d 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0004e33d 
00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel(R) Xeon(R) CPU            5130  @ 2.00GHz stepping 06
SMP alternatives: switching to SMP code
Booting processor 3/7 eip 3000
Initializing CPU#3
Calibrating delay using timer specific routine.. 3990.06 BogoMIPS 
(lpj=19950331)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 
0004e33d 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0004e33d 
00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel(R) Xeon(R) CPU            5130  @ 2.00GHz stepping 06
Total of 4 processors activated (15962.55 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIQ._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NET: Registered protocol family 8
NET: Registered protocol family 20
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
pnp: 00:01: iomem range 0xa0000000-0xafffffff could not be reserved
pnp: 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
pnp: 00:01: iomem range 0xfec00000-0xfecfffff has been reserved
pnp: 00:06: ioport range 0x500-0x53f has been reserved
pnp: 00:06: ioport range 0x400-0x47f has been reserved
pnp: 00:06: ioport range 0x800-0x87f has been reserved
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:02.0
  IO window: 2000-2fff
  MEM window: b8000000-b88fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.0
  IO window: 2000-2fff
  MEM window: b8000000-b88fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: 2000-2fff
  MEM window: b8000000-b89fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 1000-1fff
  MEM window: b8a00000-b8afffff
  PREFETCH window: b0000000-b7ffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:01.0 to 64
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.3 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:03.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4606k freed
audit: initializing netlink socket (disabled)
audit(1199775357.440:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:09:0c.0
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie01]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:01:00.0 to 64
Allocate Port Service[0000:01:00.0:pcie10]
Allocate Port Service[0000:01:00.0:pcie11]
PCI: Setting latency timer of device 0000:02:00.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:00.0:pcie20]
Allocate Port Service[0000:02:00.0:pcie21]
PCI: Setting latency timer of device 0000:02:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:01.0:pcie20]
Allocate Port Service[0000:02:01.0:pcie21]
PCI: Setting latency timer of device 0000:02:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:02.0:pcie20]
Allocate Port Service[0000:02:02.0:pcie21]
AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:03.0:pcie01 - no _OSC support
vesafb: framebuffer at 0xb0000000, mapped to 0xf8880000, using 3072k, 
total 16384k
vesafb: mode is 1024x768x16, linelength=2048, pages=9
vesafb: protected mode interface info at c000:4ed4
vesafb: pmi: set display start = c00c4f68, set palette = c00c4fb4
vesafb: pmi: ports = 1010 1016 1054 1038 103c 105c 1000 1004 10b0 10b2 10b4
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
Freeing unused kernel memory: 224k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:05:00.0 to 64
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 20 (level, low) -> IRQ 19
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
e1000: 0000:05:00.0: e1000_validate_option: Transmit Descriptors set to 4096
e1000: 0000:05:00.0: e1000_validate_option: Receive Descriptors set to 4096
e1000: 0000:05:00.0: e1000_validate_option: Checksum Offload Enabled
e1000: 0000:05:00.0: e1000_validate_option: Flow Control Receive Only
e1000: 0000:05:00.0: e1000_check_options: Interrupt Throttling Rate 
(ints/sec) turned off
e1000: 0000:05:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:15:17:11:8a:b8
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:05:00.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:05:00.1 to 64
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
e1000: 0000:05:00.1: e1000_validate_option: Transmit Descriptors set to 4096
e1000: 0000:05:00.1: e1000_validate_option: Receive Descriptors set to 4096
e1000: 0000:05:00.1: e1000_validate_option: Checksum Offload Enabled
e1000: 0000:05:00.1: e1000_validate_option: Flow Control Receive Only
e1000: 0000:05:00.1: e1000_check_options: Interrupt Throttling Rate 
(ints/sec) turned off
e1000: 0000:05:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:15:17:11:8a:b9
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA 
mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xf883c100 ctl 0x00000000 bmdma 0x00000000 
irq 19
ata2: SATA max UDMA/133 cmd 0xf883c180 ctl 0x00000000 bmdma 0x00000000 
irq 19
ata3: SATA max UDMA/133 cmd 0xf883c200 ctl 0x00000000 bmdma 0x00000000 
irq 19
ata4: SATA max UDMA/133 cmd 0xf883c280 ctl 0x00000000 bmdma 0x00000000 
irq 19
ata5: SATA max UDMA/133 cmd 0xf883c300 ctl 0x00000000 bmdma 0x00000000 
irq 19
ata6: SATA max UDMA/133 cmd 0xf883c380 ctl 0x00000000 bmdma 0x00000000 
irq 19
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3250820NS, 3.AEE, max UDMA/133
ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3250820NS      3.AE PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xb8b00400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x000030a0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00003080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00003060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003040
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
ESB2: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ 19
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x30c0-0x30c7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x30c8-0x30cf, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
hda: HL-DT-STDVD-ROM GDR8164B, ATAPI CD/DVD-ROM drive
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 52X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Probing IDE interface ide1...
SGI XFS with ACLs, security attributes, realtime, large block numbers, 
no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input1
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 20 (level, low) -> IRQ 19
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PS/2 Logitech Mouse as /class/input/input4
loop: module loaded
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
Adding 8388600k swap on /swap.  Priority:-1 extents:1 across:8388600k
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
e1000: eth1: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: RX
NET: Registered protocol family 10
lo: Disabled Privacy Extensions

-- 
best regards, Stefan Seidel software developer ________________________ 
VUB Printmedia GmbH Chopinstraße 4 D-04103 Leipzig Germany tel. +49 
(341) 9 60 50 07 fax. +49 (341) 9 60 50 92 mail. sseidel@vub.de web. 
www.vub.de HRB Köln 24015 UStID DE 122 649 251 GF Dr. Achim Preuss 
Neudorf, Dr. Christian Preuss Neudorf
