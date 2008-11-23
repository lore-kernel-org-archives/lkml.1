Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYKWPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYKWPwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 10:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYKWPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 10:52:09 -0500
Received: from mailgate2.eduhi.at ([193.170.67.94]:50853 "EHLO
	mailgate2.eduhi.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYKWPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 10:52:05 -0500
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Nov 2008 10:52:03 EST
Message-ID: <49297820.9040406@edumail.at>
Date: Sun, 23 Nov 2008 16:34:56 +0100
From: =?ISO-8859-15?Q?Johann_W=F6ckinger?= <j.woeckinger@edumail.at>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel bug: unable to handle kernel NULL pointer dereference
 at ...
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.122; host: mg2-av)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

1. on resume my machine vom S3, I got a kernel Oops (see below)

2. On resume from suspend (S3), I had to reboot my machine - in 
kern.log, I found the message sequence listed below

3.

4. Kernel version:  Linux version 2.6.26-1-686-bigmem (Debian 2.6.26-8) 
(waldi@debian.org) (gcc version 4.1.3 20080623 (prerelease) (Debian 
4.1.2-23)) #1 SMP Thu Oct 9 16:07:43 UTC 2008

5. kern.log messages concerning the problem:
Nov 23 08:43:11 orion kernel: [72021.370670] BUG: unable to handle 
kernel NULL pointer dereference at 00000002
Nov 23 08:43:11 orion kernel: [72021.370674] IP: [<c018caab>] 
__d_lookup+0xb9/0xd7
Nov 23 08:43:11 orion kernel: [72021.370680] *pdpt = 0000000032005001 
*pde = 0000000000000000
Nov 23 08:43:11 orion kernel: [72021.370684] Oops: 0000 [#1] SMP
Nov 23 08:43:11 orion kernel: [72021.370687] Modules linked in: nls_utf8 
isofs zlib_inflate udf nls_base crc_itu_t tcp_diag inet_diag usblp vmnet 
vmblock v
mci vmmon fglrx(P) binfmt_misc ppdev lp video output ac battery 
acpi_cpufreq cpufreq_conservative cpufreq_powersave cpufreq_stats 
cpufreq_userspace cpufreq
_ondemand freq_table nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc 
ipv6 sha256_generic aes_i586 aes_generic cbc dm_crypt crypto_blkcipher 
coretemp it8
7 hwmon_vid loop parport_pc parport psmouse serio_raw pcspkr iTCO_wdt 
i2c_i801 i2c_core snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm 
snd_seq_dummy snd_s
eq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd button 
soundcore snd_page_alloc intel_agp agpgart evdev ext3 jbd mbcache 
dm_mirror dm_log dm
_snapshot dm_mod raid1 md_mod ide_floppy ide_pci_generic sg jmicron 
ide_core sr_mod cdrom sd_mod usbhid hid ff_memless floppy aic7xxx 
scsi_transport_spi oh
ci1394 ieee1394 r8169 ata_generic ahci ehci_hcd libata scsi_mod uhci_hcd 
dock usbcore thermal p
Nov 23 08:43:11 orion kernel: ocessor fan thermal_sys [last unloaded: vmci]
Nov 23 08:43:11 orion kernel: [72021.370765]
Nov 23 08:43:11 orion kernel: [72021.370767] Pid: 9938, comm: gkrellm 
Tainted: P          (2.6.26-1-686-bigmem #1)
Nov 23 08:43:11 orion kernel: [72021.370770] EIP: 0060:[<c018caab>] 
EFLAGS: 00010202 CPU: 1
Nov 23 08:43:11 orion kernel: [72021.370773] EIP is at __d_lookup+0xb9/0xd7
Nov 23 08:43:11 orion kernel: [72021.370775] EAX: 00e0a928 EBX: db90f3a8 
ECX: 00000011 EDX: 00004d0e
Nov 23 08:43:11 orion kernel: [72021.370778] ESI: c365ff60 EDI: 00000002 
EBP: f70016c0 ESP: c365fefc
Nov 23 08:43:11 orion kernel: [72021.370780]  DS: 007b ES: 007b FS: 00d8 
GS: 0000 SS: 0068
Nov 23 08:43:11 orion kernel: [72021.370783] Process gkrellm (pid: 9938, 
ti=c365e000 task=f60af100 task.ti=c365e000)
Nov 23 08:43:11 orion kernel: [72021.370785] Stack: c365ff60 00000004 
00e0a928 c365ff53 0000159e c365ff60 f70016c0 f7822b40
Nov 23 08:43:11 orion kernel: [72021.370791]        c018caed 00000020 
00000000 f74216c0 c01ac84b c365ff53 0000000d c032d3a5
Nov 23 08:43:11 orion kernel: [72021.370798]        000026d2 00000000 
00000000 000026d2 00000000 39c3f900 00383339 c01270a2
Nov 23 08:43:11 orion kernel: [72021.370804] Call Trace:
Nov 23 08:43:11 orion kernel: [72021.370825]  [<c018caed>] 
d_lookup+0x24/0x39
Nov 23 08:43:11 orion kernel: [72021.370836]  [<c01ac84b>] 
proc_flush_task+0x81/0x217
Nov 23 08:43:11 orion kernel: [72021.370857]  [<c01270a2>] 
mm_release+0x5e/0x64
Nov 23 08:43:11 orion kernel: [72021.370872]  [<c012aabb>] 
release_task+0x16/0x2c4
Nov 23 08:43:11 orion kernel: [72021.370881]  [<c012bd6f>] 
do_exit+0x56f/0x5c9
Nov 23 08:43:11 orion kernel: [72021.370894]  [<c012be70>] 
complete_and_exit+0x0/0x13
Nov 23 08:43:11 orion kernel: [72021.370898]  [<c01088ce>] 
syscall_call+0x7/0xb
Nov 23 08:43:11 orion kernel: [72021.370921]  =======================
Nov 23 08:43:11 orion kernel: [72021.370923] Code: 04 8b 54 24 0c e8 2c 
db 05 00 85 c0 75 13 31 c0 f6 43 04 10 75 05 f0 ff 03 89 d8 f0 fe 43 08 
eb 20 f0 fe
 43 08 8b 3f 85 ff 74 14 <8b> 07 0f 18 00 90 8d 5f f0 8b 44 24 08 39 43 
1c 75 e8 eb 86 31
Nov 23 08:43:11 orion kernel: [72021.370956] EIP: [<c018caab>] 
__d_lookup+0xb9/0xd7 SS:ESP 0068:c365fefc
Nov 23 08:43:11 orion kernel: [72021.370962] ---[ end trace 
365fd3202ec67799 ]---
Nov 23 08:43:11 orion kernel: [72021.370964] Fixing recursive fault but 
reboot is needed!
Nov

7.
7.1:processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping    : 10
cpu MHz        : 2000.000
cache size    : 6144 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx smx est tm2 
ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips    : 6004.23
clflush size    : 64
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping    : 10
cpu MHz        : 2000.000
cache size    : 6144 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx smx est tm2 
ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips    : 5999.94
clflush size    : 64
power management:

7.3
Module information:
fglrx 1851052 29 - Live 0xf9105000 (P)
binfmt_misc 8296 1 - Live 0xf8dbd000
ppdev 7236 0 - Live 0xf8dc1000
lp 8932 0 - Live 0xf8db4000
vmnet 34368 3 - Live 0xf8e6b000
vmblock 12388 4 - Live 0xf8dcb000
vmci 44756 0 - Live 0xf8e5f000
vmmon 62064 0 - Live 0xf8e4e000
video 17168 0 - Live 0xf8dc5000
output 3680 1 video, Live 0xf8dbb000
ac 4964 0 - Live 0xf8db8000
battery 10948 0 - Live 0xf8d92000
acpi_cpufreq 7564 0 - Live 0xf8d97000
cpufreq_conservative 6728 0 - Live 0xf8d8d000
cpufreq_powersave 2624 0 - Live 0xf8d90000
cpufreq_stats 4640 0 - Live 0xf8d87000
cpufreq_userspace 4420 0 - Live 0xf8d8a000
cpufreq_ondemand 7244 2 - Live 0xf8b3d000
freq_table 5088 3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand, Live 
0xf8b71000
nfsd 187472 17 - Live 0xf8eb8000
auth_rpcgss 34752 1 nfsd, Live 0xf8daa000
exportfs 4672 1 nfsd, Live 0xf8b6e000
nfs 214664 0 - Live 0xf8e82000
lockd 55016 2 nfsd,nfs, Live 0xf8d9b000
nfs_acl 3680 2 nfsd,nfs, Live 0xf8b40000
sunrpc 162912 13 nfsd,auth_rpcgss,nfs,lockd,nfs_acl, Live 0xf8e11000
ipv6 235876 35 - Live 0xf8dd6000
sha256_generic 12128 0 - Live 0xf8b82000
aes_i586 8512 4 - Live 0xf8b7e000
aes_generic 30024 1 aes_i586, Live 0xf8b75000
cbc 4032 2 - Live 0xf8b6c000
dm_crypt 11940 1 - Live 0xf89c9000
crypto_blkcipher 16004 4 cbc,dm_crypt, Live 0xf8b67000
coretemp 6272 0 - Live 0xf8b3a000
it87 18544 0 - Live 0xf8b61000
hwmon_vid 3488 1 it87, Live 0xf8a25000
loop 13516 0 - Live 0xf8b24000
parport_pc 23396 1 - Live 0xf8b5a000
parport 31756 3 ppdev,lp,parport_pc, Live 0xf8b51000
psmouse 33104 0 - Live 0xf8b47000
serio_raw 5508 0 - Live 0xf8a27000
pcspkr 3200 0 - Live 0xf88b3000
i2c_i801 8688 0 - Live 0xf8b20000
i2c_core 20596 1 i2c_i801, Live 0xf8abd000
snd_pcm_oss 33568 0 - Live 0xf8ac5000
snd_mixer_oss 13088 1 snd_pcm_oss, Live 0xf8a3c000
iTCO_wdt 10276 0 - Live 0xf8a2b000
snd_hda_intel 325112 1 - Live 0xf8acf000
snd_seq_dummy 3428 0 - Live 0xf89a1000
snd_pcm 63428 2 snd_pcm_oss,snd_hda_intel, Live 0xf8a52000
snd_seq_oss 25760 0 - Live 0xf8a02000
snd_seq_midi_event 7200 1 snd_seq_oss, Live 0xf89e3000
snd_seq 42224 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 
0xf8a30000
snd_timer 18568 2 snd_pcm,snd_seq, Live 0xf8a0a000
snd_seq_device 7148 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xf89e0000
snd 46372 10 
snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_pcm,snd_seq_oss,snd_seq,snd_timer,snd_seq_device, 
Live 0xf8a13000
soundcore 7136 1 snd, Live 0xf89dd000
snd_page_alloc 8648 2 snd_hda_intel,snd_pcm, Live 0xf89c2000
button 6832 0 - Live 0xf89c6000
intel_agp 23236 0 - Live 0xf89d6000
agpgart 29576 2 fglrx,intel_agp, Live 0xf89cd000
evdev 8768 4 - Live 0xf896e000
ext3 106024 3 - Live 0xf89e7000
jbd 40212 1 ext3, Live 0xf8996000
mbcache 7876 1 ext3, Live 0xf8866000
dm_mirror 15872 0 - Live 0xf8958000
dm_log 9220 1 dm_mirror, Live 0xf895d000
dm_snapshot 15108 0 - Live 0xf8991000
dm_mod 46952 15 dm_crypt,dm_mirror,dm_log,dm_snapshot, Live 0xf89b5000
raid1 18784 2 - Live 0xf898b000
md_mod 67804 3 raid1, Live 0xf89a3000
ide_floppy 13472 0 - Live 0xf8969000
ide_pci_generic 4676 0 [permanent], Live 0xf8955000
sg 27732 0 - Live 0xf8961000
sr_mod 14084 0 - Live 0xf8932000
cdrom 30944 1 sr_mod, Live 0xf88a2000
sd_mod 22968 6 - Live 0xf88ac000
jmicron 2976 0 [permanent], Live 0xf882f000
ide_core 97000 3 ide_floppy,ide_pci_generic,jmicron, Live 0xf8972000
usbhid 36736 0 - Live 0xf8925000
hid 33952 1 usbhid, Live 0xf891b000
ff_memless 5160 1 usbhid, Live 0xf889f000
floppy 48516 0 - Live 0xf890e000
aic7xxx 118776 0 - Live 0xf8937000
scsi_transport_spi 20608 1 aic7xxx, Live 0xf8898000
ohci1394 26000 0 - Live 0xf8890000
ieee1394 76600 1 ohci1394, Live 0xf88fa000
r8169 24612 0 - Live 0xf8888000
ahci 24008 6 - Live 0xf885f000
ata_generic 5444 0 - Live 0xf8851000
libata 141248 2 ahci,ata_generic, Live 0xf88d6000
scsi_mod 130124 6 sg,sr_mod,sd_mod,aic7xxx,scsi_transport_spi,libata, 
Live 0xf88b5000
dock 9040 1 libata, Live 0xf882b000
ehci_hcd 29420 0 - Live 0xf8846000
uhci_hcd 19504 0 - Live 0xf8840000
usbcore 119184 4 usbhid,ehci_hcd,uhci_hcd, Live 0xf8869000
thermal 15996 0 - Live 0xf883b000
processor 33536 2 acpi_cpufreq,thermal, Live 0xf8831000
fan 4932 0 - Live 0xf8820000
thermal_sys 11624 4 video,thermal,processor,fan, Live 0xf881c000

7.4: Drivers and Hardware:
/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0290-029f : pnp 00:01
  0290-0294 : pnp 00:01
  0295-0296 : it87
    0295-0296 : it87
0378-037a : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f7-03f7 : floppy DIR
03f8-03ff : serial
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
  0460-047f : iTCO_wdt
0480-04bf : 0000:00:1f.0
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
9000-9fff : PCI Bus 0000:02
a000-afff : PCI Bus 0000:01
  a000-a0ff : 0000:01:00.0
b000-bfff : PCI Bus 0000:03
  b000-b007 : 0000:03:00.1
    b000-b007 : JMB
  b100-b103 : 0000:03:00.1
    b100-b103 : JMB
  b200-b207 : 0000:03:00.1
    b200-b207 : JMB
  b300-b303 : 0000:03:00.1
    b300-b303 : JMB
  b400-b40f : 0000:03:00.1
    b400-b40f : JMB
c000-cfff : PCI Bus 0000:04
  c000-c0ff : 0000:04:00.0
    c000-c0ff : r8169
d000-dfff : PCI Bus 0000:05
  d000-d0ff : 0000:05:01.0
e000-e01f : 0000:00:1a.0
  e000-e01f : uhci_hcd
e100-e11f : 0000:00:1a.1
  e100-e11f : uhci_hcd
e200-e21f : 0000:00:1d.0
  e200-e21f : uhci_hcd
e300-e31f : 0000:00:1d.1
  e300-e31f : uhci_hcd
e400-e41f : 0000:00:1d.2
  e400-e41f : uhci_hcd
e500-e51f : 0000:00:1a.2
  e500-e51f : uhci_hcd
e600-e607 : 0000:00:1f.2
  e600-e607 : ahci
e700-e703 : 0000:00:1f.2
  e700-e703 : ahci
e800-e807 : 0000:00:1f.2
  e800-e807 : ahci
e900-e903 : 0000:00:1f.2
  e900-e903 : ahci
ea00-ea1f : 0000:00:1f.2
  ea00-ea1f : ahci

/proc/iomem:
00000000-0009e7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000d5000-000d57ff : Adapter ROM
000d5800-000d7fff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : System ROM
00100000-dfedffff : System RAM
  00100000-002ca47a : Kernel code
  002ca47b-0038fabf : Kernel data
  003d7000-00443cff : Kernel bss
dfee0000-dfee2fff : ACPI Non-volatile Storage
dfee3000-dfeeffff : ACPI Tables
dfef0000-dfefffff : reserved
e0000000-efffffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:00.0
f0000000-f3ffffff : PCI MMCONFIG 0
  f0000000-f3ffffff : reserved
f4000000-f5ffffff : PCI Bus 0000:01
  f4000000-f401ffff : 0000:01:00.0
  f5000000-f500ffff : 0000:01:00.0
  f5010000-f5013fff : 0000:01:00.1
    f5010000-f5013fff : ICH HD audio
f6000000-f7ffffff : PCI Bus 0000:04
  f7000000-f7000fff : 0000:04:00.0
    f7000000-f7000fff : r8169
f8000000-f9ffffff : PCI Bus 0000:05
  f9000000-f9000fff : 0000:05:01.0
    f9000000-f9000fff : aic7xxx
  f9001000-f9001fff : 0000:05:00.0
    f9001000-f90017ff : ohci1394
fa000000-fa0fffff : PCI Bus 0000:03
  fa000000-fa001fff : 0000:03:00.0
    fa000000-fa001fff : ahci
fa100000-fa103fff : 0000:00:1b.0
  fa100000-fa103fff : ICH HD audio
fa104000-fa1043ff : 0000:00:1d.7
  fa104000-fa1043ff : ehci_hcd
fa105000-fa1053ff : 0000:00:1a.7
  fa105000-fa1053ff : ehci_hcd
fa106000-fa1067ff : 0000:00:1f.2
  fa106000-fa1067ff : ahci
fa107000-fa1070ff : 0000:00:1f.3
fa200000-fa2fffff : PCI Bus 0000:04
  fa200000-fa21ffff : 0000:04:00.0
fa300000-fa3fffff : PCI Bus 0000:05
  fa300000-fa30ffff : 0000:05:01.0
fec00000-ffffffff : reserved
  fed00000-fed003ff : HPET 0
100000000-11fffffff : System RAM

output of lspci -vvv:
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM 
Controller (rev 02)
    Subsystem: Giga-byte Technology Device 5000
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information <?>
    Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI 
Express Root Port (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 0000a000-0000afff
    Memory behind bridge: f4000000-f5ffffff
    Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [88] Subsystem: Giga-byte Technology Device 5000
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Address: fee0300c  Data: 41b9
    Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, Latency 
L0 <256ns, L1 <64us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
            Slot # 20, PowerLimit 75.000000; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
            Changed: MRL- PresDet+ LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [140] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Giga-byte Technology Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 4: I/O ports at e000 [size=32]
    Capabilities: [50] PCIe advanced features <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Giga-byte Technology Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 21
    Region 4: I/O ports at e100 [size=32]
    Capabilities: [50] PCIe advanced features <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Giga-byte Technology Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 4: I/O ports at e500 [size=32]
    Capabilities: [50] PCIe advanced features <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 02) (prog-if 20 [EHCI])
    Subsystem: Giga-byte Technology Device 5006
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at fa105000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 02)
    Subsystem: Giga-byte Technology Device a002
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 22
    Region 0: Memory at fa100000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE- FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [130] Root Complex Link <?>
    Kernel driver in use: HDA Intel
    Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 <1us, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot # 10, PowerLimit 10.000000; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Address: fee0300c  Data: 41c1
    Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 4 (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 0000b000-0000bfff
    Memory behind bridge: fa000000-fa0fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
        LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 <256ns, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot # 13, PowerLimit 10.000000; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
            Changed: MRL- PresDet+ LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Address: fee0300c  Data: 41c9
    Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 5 (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 0000c000-0000cfff
    Memory behind bridge: f6000000-f7ffffff
    Prefetchable memory behind bridge: 00000000fa200000-00000000fa2fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
        LnkCap:    Port #5, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 <256ns, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot # 14, PowerLimit 10.000000; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
            Changed: MRL- PresDet+ LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Address: fee0300c  Data: 41d1
    Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Giga-byte Technology Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 4: I/O ports at e200 [size=32]
    Capabilities: [50] PCIe advanced features <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Giga-byte Technology Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 19
    Region 4: I/O ports at e300 [size=32]
    Capabilities: [50] PCIe advanced features <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Giga-byte Technology Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 4: I/O ports at e400 [size=32]
    Capabilities: [50] PCIe advanced features <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 02) (prog-if 20 [EHCI])
    Subsystem: Giga-byte Technology Device 5006
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at fa104000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 
01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
    I/O behind bridge: 0000d000-0000dfff
    Memory behind bridge: f8000000-f9ffffff
    Prefetchable memory behind bridge: 00000000fa300000-00000000fa3fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Subsystem: Giga-byte Technology GA-EP45-DS5 
Motherboard

00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface 
Controller (rev 02)
    Subsystem: Giga-byte Technology Device 5001
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information <?>
    Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 82801IB (ICH9) 4 port SATA 
AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
    Subsystem: Giga-byte Technology Device b005
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 219
    Region 0: I/O ports at e600 [size=8]
    Region 1: I/O ports at e700 [size=4]
    Region 2: I/O ports at e800 [size=8]
    Region 3: I/O ports at e900 [size=4]
    Region 4: I/O ports at ea00 [size=32]
    Region 5: Memory at fa106000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable+
        Address: fee0300c  Data: 4132
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA <?>
    Capabilities: [b0] PCIe advanced features <?>
    Kernel driver in use: ahci
    Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller 
(rev 02)
    Subsystem: Giga-byte Technology Device 5001
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at fa107000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at 0500 [size=32]
    Kernel driver in use: i801_smbus
    Kernel modules: i2c-i801

01:00.0 VGA compatible controller: ATI Technologies Inc RV630 [Radeon HD 
2600 Series] (prog-if 00 [VGA controller])
    Subsystem: Micro-Star International Co., Ltd. Device 0930
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
    Region 2: Memory at f5000000 (64-bit, non-prefetchable) [size=64K]
    Region 4: I/O ports at a000 [size=256]
    [virtual] Expansion ROM at f4000000 [disabled] [size=128K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [100] Vendor Specific Information <?>
    Kernel driver in use: fglrx_pci
    Kernel modules: fglrx

01:00.1 Audio device: ATI Technologies Inc RV630/M76 audio device 
[Radeon HD 2600 Series]
    Subsystem: Micro-Star International Co., Ltd. Device aa08
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin B routed to IRQ 17
    Region 0: Memory at f5010000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [100] Vendor Specific Information <?>
    Kernel driver in use: HDA Intel
    Kernel modules: snd-hda-intel

03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
    Subsystem: Giga-byte Technology Device b000
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 19
    Region 5: Memory at fa000000 (32-bit, non-prefetchable) [size=8K]
    Capabilities: [68] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
    Kernel driver in use: ahci
    Kernel modules: ahci

03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 02) (prog-if 85 [Master SecO PriO])
    Subsystem: Giga-byte Technology Device b000
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin B routed to IRQ 16
    Region 0: I/O ports at b000 [size=8]
    Region 1: I/O ports at b100 [size=4]
    Region 2: I/O ports at b200 [size=8]
    Region 3: I/O ports at b300 [size=4]
    Region 4: I/O ports at b400 [size=16]
    Capabilities: [68] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: JMicron IDE
    Kernel modules: jmicron

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
    Subsystem: Giga-byte Technology Device e000
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 218
    Region 0: I/O ports at c000 [size=256]
    Region 2: Memory at f7000000 (64-bit, non-prefetchable) [size=4K]
    [virtual] Expansion ROM at fa200000 [disabled] [size=128K]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [48] Vital Product Data <?>
    Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Address: 00000000fee0300c  Data: 413a
    Capabilities: [60] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 1024 bytes, PhantFunc 0, Latency L0s 
<128ns, L1 unlimited
            ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 4096 bytes
        DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [84] Vendor Specific Information <?>
    Capabilities: [100] Advanced Error Reporting <?>
    Capabilities: [12c] Virtual Channel <?>
    Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
    Capabilities: [154] Power Budgeting <?>
    Kernel driver in use: r8169
    Kernel modules: r8169

05:00.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 04) (prog-if 10 
[OHCI])
    Subsystem: Agere Systems FW323
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (3000ns min, 6000ns max), Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 20
    Region 0: Memory at f9001000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME+
    Kernel driver in use: ohci1394
    Kernel modules: ohci1394

05:01.0 SCSI storage controller: Adaptec AHA-2940U/UW/D / AIC-7881U
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (2000ns min, 2000ns max), Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: I/O ports at d000 [disabled] [size=256]
    Region 1: Memory at f9000000 (32-bit, non-prefetchable) [size=4K]
    [virtual] Expansion ROM at fa300000 [disabled] [size=64K]
    Kernel driver in use: aic7xxx
    Kernel modules: aic7xxx

/proc/scsi/scsi:

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKS-7 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATAPI    Model: DVD D  DH16D3S   Rev: SP51
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: LITE-ON  Model: DVDRW LH-20A1L   Rev: BL05
  Type:   CD-ROM                           ANSI  SCSI revision: 05

output of ver_linux:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux orion 2.6.26-1-686-bigmem #1 SMP Thu Oct 9 16:07:43 UTC 2008 i686 
GNU/Linux
 
Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.2
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         fglrx binfmt_misc ppdev lp vmnet vmblock vmci 
vmmon video output ac battery acpi_cpufreq cpufreq_conservative 
cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_ondemand 
freq_table nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc ipv6 
sha256_generic aes_i586 aes_generic cbc dm_crypt crypto_blkcipher 
coretemp it87 hwmon_vid loop parport_pc parport psmouse serio_raw pcspkr 
i2c_i801 i2c_core snd_pcm_oss snd_mixer_oss iTCO_wdt snd_hda_intel 
snd_seq_dummy snd_pcm snd_seq_oss snd_seq_midi_event snd_seq snd_timer 
snd_seq_device snd soundcore snd_page_alloc button intel_agp agpgart 
evdev ext3 jbd mbcache dm_mirror dm_log dm_snapshot dm_mod raid1 md_mod 
ide_floppy ide_pci_generic sg sr_mod cdrom sd_mod jmicron ide_core 
usbhid hid ff_memless floppy aic7xxx scsi_transport_spi ohci1394 
ieee1394 r8169 ahci ata_generic libata scsi_mod dock ehci_hcd uhci_hcd 
usbcore thermal processor fan thermal_sys

Can you help for that problem?
Thank you

Johann Woeckinger

