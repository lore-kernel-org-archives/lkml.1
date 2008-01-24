Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYAXAnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYAXAnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYAXAnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:43:08 -0500
Received: from static.88-198-5-81.clients.your-server.de ([88.198.5.81]:55857
	"EHLO static.88-198-5-81.clients.your-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbYAXAnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:43:06 -0500
X-Greylist: delayed 1700 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2008 19:43:05 EST
Message-ID: <4797D86B.3060202@linuxdingsda.de>
Date: Thu, 24 Jan 2008 01:14:35 +0100
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel bug report 2.6.24-rc8 on core2quad q6600 with debian unstable
 amd64
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi folks, I'm sending the bug report here, since i have no idea where
else to send it. I hope it is helping.


[1.] One line summary of the problem:
The kernel panics under high CPU/IO load, compilers segfault, mdadm
used to do so, too.

[2.] Full description of the problem/report:
I upgraded my system to fairly new hardware and find myself unable to
compile any kernel source and the system panics under high load e.g.
resyncing a RAID or building a kernel. Building kernel is 100% sure to
result in a kernel panic.

[3.] Keywords (i.e., modules, networking, kernel):
kernel, panic, gcc, load, high, high load

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
Linux version 2.6.24-rc8-wintix (root@saugstation) (gcc version 4.2.3
20080114 (prerelease) (Debian 4.2.2-7)) #1 SMP Tue Jan 22 21:17:40 CET
2008

[4.2.] Kernel .config file:
http://linuxdingsda.de/~wintix/temp/config.gz

[5.] Most recent kernel version which did not have the bug:
I tried 2.6.23 but doesn't work there, too

[6.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt)
# make-kpkg kernel_image --initrd
[..]
  CC      net/core/net-sysfs.o
  CC      drivers/char/agp/amd64-agp.o
  CC      lib/vsprintf.o
drivers/acpi/pci_bind.c: In function 'acpi_pci_unbind':<built-in>:0:
internal compiler error: Segmentation fault
Depending on which kernel i build, it fails on different things.

[7.] A small shell script or example program which triggers the
problem (if possible)
See 6.

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)

Linux saugcenter 2.6.24-rc8-wintix #1 SMP Tue Jan 22 21:17:40 CET 2008
x86_64 GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1
mount                  2.13
module-init-tools      3.3-pre11
e2fsprogs              1.40.3
reiserfsprogs          3.6.19
xfsprogs               2.9.5
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   114
Modules Loaded         nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs
ac battery acpi_cpufreq ipv6 fuse dm_crypt lm85 hwmon_vid budget_av
saa7146_vv videobuf_dma_sg videobuf_core videodev v4l2_common
v4l1_compat tua6100 budget_core saa7146 ttpci_eeprom dvb_pll tda10021
tda10023 tda1004x firmware_class stv0299 dvb_core serio_raw i2c_i801
evdev e1000e intel_agp button psmouse i2c_core ext3 jbd mbcache
dm_mirror dm_snapshot dm_mod raid456 async_xor async_memcpy async_tx
xor pata_marvell pata_acpi usbhid 3c59x mii generic ahci libata
ide_core ehci_hcd uhci_hcd sg sr_mod cdrom thermal processor fan


[8.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 1596.000
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4803.76
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

4 times. only core-id and prozessor# differs. the frequency is due to
clock-down on idle.


[8.3.] Module information (from /proc/modules):
ipt_REJECT 5632 1 - Live 0xffffffff8835f000
xt_state 3200 3 - Live 0xffffffff8835d000
xt_tcpudp 4160 9 - Live 0xffffffff8835a000
nf_conntrack_ftp 10856 0 - Live 0xffffffff88356000
nf_conntrack_ipv4 21136 3 - Live 0xffffffff8834f000
nf_conntrack 78384 3 xt_state,nf_conntrack_ftp,nf_conntrack_ipv4, Live
0xffffffff8833a000
iptable_filter 3776 1 - Live 0xffffffff880a5000
ip_tables 23304 1 iptable_filter, Live 0xffffffff88333000
x_tables 22600 4 ipt_REJECT,xt_state,xt_tcpudp,ip_tables, Live
0xffffffff8832c000
nfsd 279272 1 - Live 0xffffffff882e6000
lockd 75248 1 nfsd, Live 0xffffffff882d2000
nfs_acl 4416 1 nfsd, Live 0xffffffff882cf000
auth_rpcgss 52512 1 nfsd, Live 0xffffffff882c1000
sunrpc 212168 6 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xffffffff8828c000
exportfs 6144 1 nfsd, Live 0xffffffff88289000
ac 7368 0 - Live 0xffffffff88286000
battery 15880 0 - Live 0xffffffff88281000
acpi_cpufreq 10032 0 - Live 0xffffffff8827d000
ipv6 309640 20 - Live 0xffffffff88230000
fuse 54960 1 - Live 0xffffffff88221000
dm_crypt 15752 0 - Live 0xffffffff8821c000
lm85 35620 0 - Live 0xffffffff88212000
hwmon_vid 4288 1 lm85, Live 0xffffffff8820f000
budget_av 21888 4 - Live 0xffffffff88208000
saa7146_vv 55296 1 budget_av, Live 0xffffffff881f9000
videobuf_dma_sg 16068 1 saa7146_vv, Live 0xffffffff881f4000
videobuf_core 21188 2 saa7146_vv,videobuf_dma_sg, Live 0xffffffff881ed000
videodev 29888 1 saa7146_vv, Live 0xffffffff881e4000
v4l2_common 21056 2 saa7146_vv,videodev, Live 0xffffffff881dd000
v4l1_compat 14660 2 saa7146_vv,videodev, Live 0xffffffff881d8000
tua6100 4096 1 budget_av, Live 0xffffffff8806e000
budget_core 13636 1 budget_av, Live 0xffffffff881d3000
saa7146 21384 3 budget_av,saa7146_vv,budget_core, Live 0xffffffff881cc000
ttpci_eeprom 3136 1 budget_core, Live 0xffffffff88047000
dvb_pll 14820 1 budget_av, Live 0xffffffff881c7000
tda10021 7940 1 budget_av, Live 0xffffffff881c4000
tda10023 7428 1 budget_av, Live 0xffffffff881c1000
tda1004x 17924 1 budget_av, Live 0xffffffff881bb000
firmware_class 11648 2 budget_av,tda1004x, Live 0xffffffff881b7000
stv0299 12424 1 budget_av, Live 0xffffffff881b2000
dvb_core 93164 3 budget_av,budget_core,stv0299, Live 0xffffffff8819a000
serio_raw 8260 0 - Live 0xffffffff88196000
i2c_i801 10332 0 - Live 0xffffffff88192000
evdev 14144 0 - Live 0xffffffff8818d000
e1000e 106724 0 - Live 0xffffffff88171000
intel_agp 29600 0 - Live 0xffffffff88168000
button 10016 0 - Live 0xffffffff88164000
psmouse 45468 0 - Live 0xffffffff88157000
i2c_core 27584 11
lm85,budget_av,tua6100,budget_core,ttpci_eeprom,dvb_pll,tda10021,tda10023,tda1004x,stv0299,i2c_i801,
Live 0xffffffff8814f000
ext3 138832 2 - Live 0xffffffff8812c000
jbd 55848 1 ext3, Live 0xffffffff8811d000
mbcache 10560 1 ext3, Live 0xffffffff88119000
dm_mirror 25408 0 - Live 0xffffffff88111000
dm_snapshot 19848 0 - Live 0xffffffff8810b000
dm_mod 66480 3 dm_crypt,dm_mirror,dm_snapshot, Live 0xffffffff880f9000
raid456 131104 1 - Live 0xffffffff880d7000
async_xor 5312 1 raid456, Live 0xffffffff880d4000
async_memcpy 3648 1 raid456, Live 0xffffffff8803a000
async_tx 9588 3 raid456,async_xor,async_memcpy, Live 0xffffffff880d0000
xor 6352 2 raid456,async_xor, Live 0xffffffff880cd000
pata_marvell 8576 2 - Live 0xffffffff880c9000
pata_acpi 9024 0 - Live 0xffffffff880c5000
usbhid 34080 1 - Live 0xffffffff880bb000
3c59x 50740 0 - Live 0xffffffff880ad000
mii 6656 1 3c59x, Live 0xffffffff880aa000
generic 5892 0 [permanent], Live 0xffffffff880a7000
ahci 32196 6 - Live 0xffffffff8809c000
libata 174608 3 pata_marvell,pata_acpi,ahci, Live 0xffffffff88070000
ide_core 146448 1 generic, Live 0xffffffff88049000
ehci_hcd 39244 0 - Live 0xffffffff8803c000
uhci_hcd 28632 0 - Live 0xffffffff88032000
sg 41112 0 - Live 0xffffffff88026000
sr_mod 20452 0 - Live 0xffffffff88020000
cdrom 40680 1 sr_mod, Live 0xffffffff88015000
thermal 18848 0 - Live 0xffffffff8800f000
processor 41304 2 acpi_cpufreq,thermal, Live 0xffffffff88003000
fan 5704 0 - Live 0xffffffff88000000

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
02f8-02ff : serial
03c0-03df : vesafb
03f8-03ff : serial
0400-047f : 0000:00:1f.0
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0450-0450 : ACPI PM2_CNT_BLK
0500-053f : 0000:00:1f.0
  0500-053f : pnp 00:06
0680-06ff : pnp 00:06
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #07
  1000-10ff : 0000:07:02.0
  1400-147f : 0000:07:00.0
2000-2fff : PCI Bus #03
  2000-200f : 0000:03:00.0
    2000-200f : libata
  2010-2017 : 0000:03:00.0
  2018-201f : 0000:03:00.0
    2018-201f : libata
  2020-2023 : 0000:03:00.0
  2024-2027 : 0000:03:00.0
    2024-2027 : libata
3000-301f : 0000:00:1f.3
  3000-301f : i801_smbus
3020-303f : 0000:00:1f.2
3040-305f : 0000:00:1d.2
  3040-305f : uhci_hcd
3060-307f : 0000:00:1d.1
  3060-307f : uhci_hcd
3080-309f : 0000:00:1d.0
  3080-309f : uhci_hcd
30a0-30bf : 0000:00:1a.2
  30a0-30bf : uhci_hcd
30c0-30df : 0000:00:1a.1
  30c0-30df : uhci_hcd
30e0-30ff : 0000:00:1a.0
  30e0-30ff : uhci_hcd
3400-341f : 0000:00:19.0
  3400-341f : e1000e
3420-3427 : 0000:00:1f.2
3428-342f : 0000:00:1f.2
3430-3433 : 0000:00:1f.2
3434-3437 : 0000:00:1f.2

/proc/iomem:
00000000-0009e7ff : System RAM
0009e800-0009ffff : reserved
000c0000-000dffff : pnp 00:01
000e0000-000fffff : reserved
00100000-cfa16fff : System RAM
  00200000-005438f9 : Kernel code
  005438fa-006804af : Kernel data
  006de000-0076c5ef : Kernel bss
cfa17000-cfa18fff : reserved
cfa19000-cfaf4fff : System RAM
cfaf5000-cfbe4fff : ACPI Non-volatile Storage
cfbe5000-cfbe9fff : System RAM
cfbea000-cfbf2fff : ACPI Tables
cfbf3000-cfbf3fff : System RAM
cfbf4000-cfbfefff : ACPI Tables
cfbff000-cfbfffff : System RAM
cfc00000-cfffffff : reserved
d0000000-dfffffff : PCI Bus #01
  d0000000-dfffffff : 0000:01:00.0
    d0000000-d3ffffff : vesafb
e0000000-e1ffffff : PCI Bus #01
  e0000000-e0ffffff : 0000:01:00.0
  e1000000-e1ffffff : 0000:01:00.0
e2000000-e20fffff : PCI Bus #07
  e2000000-e2000fff : 0000:07:02.0
    e2000000-e2000fff : aic7xxx
  e2001000-e20011ff : 0000:07:01.0
    e2001000-e20011ff : saa7146
  e2001200-e200127f : 0000:07:00.0
  e2020000-e203ffff : 0000:07:00.0
  e2040000-e205ffff : 0000:07:02.0
e2100000-e21fffff : PCI Bus #03
  e2100000-e21001ff : 0000:03:00.0
e2200000-e221ffff : 0000:00:19.0
  e2200000-e221ffff : e1000e
e2220000-e2220fff : 0000:00:19.0
  e2220000-e2220fff : e1000e
e2221000-e22217ff : 0000:00:1f.2
  e2221000-e22217ff : ahci
e2221800-e2221bff : 0000:00:1d.7
  e2221800-e2221bff : ehci_hcd
e2221c00-e2221fff : 0000:00:1a.7
  e2221c00-e2221fff : ehci_hcd
e2222000-e22220ff : 0000:00:1f.3
e2222100-e222210f : 0000:00:03.0
f0000000-f7ffffff : PCI MMCONFIG 0
  f0000000-f7ffffff : reserved
feb00000-feb03fff : pnp 00:01
fec00000-fec00fff : IOAPIC 0
fed13000-fed13fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:01
fed20000-fed3ffff : pnp 00:01
fed45000-fed99fff : pnp 00:01
fee00000-fee00fff : Local APIC
fff00000-ffffffff : reserved
100000000-12bffffff : System RAM


[8.5.] PCI information ('lspci -vvv' as root)
http://linuxdingsda.de/~wintix/temp/lspci_vvv

[8.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM-PCCO Model: DDRS-34560W   !# Rev: S97B
  Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: NEC      Model: CD-ROM DRIVE:464 Rev: 1.14
  Type:   CD-ROM                           ANSI  SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6L250R0   Rev: BAJ4
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi7 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: Maxtor 6L250R0   Rev: BAH4
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[8.7.] Other information that might be relevant to the problem (please
look in /proc and include all information that you think to be relevant):
root@saugcenter:/proc# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active(auto-read-only) raid5 sdg[0] sdh[7] sdf[6] sdi[5] sde[4]
sdb[3] sdd[2] sdc[1]
      1715821184 blocks level 5, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]

unused devices: <none>

I tried disabling HPET and VT in the BIOS but that didn't help. I also
ruled out any memory problems with memtest86+.Don't know what else to do.

[X.] Other notes, patches, fixes, workarounds:
Please let me know if you need any additional information or need
access to the box. I could provide Debian on some USB stick.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHl9hqZhAcjSIb10ERCm27AJ0SqT3G5gyJZEoYV5ZXwWZv+Y+KAwCeN9nO
lZhXQaYTYKgZwH1pWT4l+II=
=VcKz
-----END PGP SIGNATURE-----

