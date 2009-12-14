Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZLNX27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZLNX27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZLNX26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:28:58 -0500
Received: from bertrand.catalyst.net.nz ([202.78.240.40]:42303 "EHLO
	mail.catalyst.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZLNX25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:28:57 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 18:28:56 EST
to: linux-kernel@vger.kernel.org
subject: linux container BUG report
mime-version: 1.0
date: Mon, 14 Dec 2009 23:22:23 -0000
from: <stevek@catalyst.net.nz>
content-type: text/plain; charset="iso-8859-1"
x-mailer: LuaSocket 2.0.1
Message-Id: <20091214232224.2F28831BF6@mail.catalyst.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TO: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    

Kernel Panic not syncing. Profile 0 (used by '<kernel>') not defined

[2.] Full description of the problem/report:

I use and test linux container extensively ; it has been running for a while. Today after a restart I start the container and get kernel panic. The whole system freeze and require a reset button. Even SysRQ does not work. 

The message 

Kernel Panic not syncing. Profile 0 (used by '<kernel>') not defined 

is printed on the console

It seems it happened with only one of my container and not with others. I still keep that root tree of that containers intact for debugging purposes. That container has been running without problem for long time

[3.] Keywords (i.e., modules, networking, kernel):

linux container, lxc

[4.] Kernel version (from /proc/version):

Happened with 2.6.31.7 and 2.6.32 (source from kernel.org )

[5.] Output of Oops.. message (if applicable) with symbolic information resolved (see Documentation/oops-tracing.txt)

N/A, the only message could be captured is above.

[6.] A small shell script or example program which triggers the
     problem (if possible)

just do  'lxc-start -n build-bart' make it happen

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

uname -a
Linux peace 2.6.31.7x64 #2 SMP Mon Dec 14 18:45:23 NZDT 2009 x86_64 GNU/Linux

[7.2.] Processor information (from /proc/cpuinfo):

root@peace:~# cat /proc/cpuinfo 
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 67
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 5200+
stepping	: 3
cpu MHz		: 2611.986
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips	: 5226.63
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 67
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 5200+
stepping	: 3
cpu MHz		: 2611.986
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips	: 5225.34
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

[7.3.] Module information (from /proc/modules):

root@peace:~# cat /proc/modules 
ipt_REJECT 3512 3 - Live 0xffffffffa025d000
xt_state 2328 5 - Live 0xffffffffa024e000
xt_TCPMSS 4536 2 - Live 0xffffffffa0228000
xt_tcpudp 3448 12 - Live 0xffffffffa0213000
xt_mark 2392 2 - Live 0xffffffffa0200000
xt_MARK 2968 1 - Live 0xffffffffa01e8000
iptable_mangle 4120 1 - Live 0xffffffffa01c4000
iptable_filter 3768 1 - Live 0xffffffffa01a9000
nf_nat_ftp 3256 0 - Live 0xffffffffa0187000
iptable_nat 6552 1 - Live 0xffffffffa0169000
nf_nat 19820 2 nf_nat_ftp,iptable_nat, Live 0xffffffffa0fd2000
nf_conntrack_ftp 8696 1 nf_nat_ftp, Live 0xffffffffa0fcd000
nf_conntrack_ipv4 9384 8 iptable_nat,nf_nat, Live 0xffffffffa0fc8000
nf_conntrack 67232 6 xt_state,nf_nat_ftp,iptable_nat,nf_nat,nf_conntrack_ftp,nf_conntrack_ipv4, Live 0xffffffffa0fb5000
nf_defrag_ipv4 2136 1 nf_conntrack_ipv4, Live 0xffffffffa0016000
ip_tables 19432 3 iptable_mangle,iptable_filter,iptable_nat, Live 0xffffffffa0fae000
x_tables 21568 8 ipt_REJECT,xt_state,xt_TCPMSS,xt_tcpudp,xt_mark,xt_MARK,iptable_nat,ip_tables, Live 0xffffffffa0fa6000
tun 16888 1 - Live 0xffffffffa0f9f000
binfmt_misc 9668 1 - Live 0xffffffffa0f9a000
bridge 55096 0 - Live 0xffffffffa0f8a000
stp 2652 1 bridge, Live 0xffffffffa019b000
rfcomm 42040 0 - Live 0xffffffffa0f7d000
bnep 14584 2 - Live 0xffffffffa0f77000
sco 12220 2 - Live 0xffffffffa0f72000
l2cap 25240 6 rfcomm,bnep, Live 0xffffffffa0f69000
bluetooth 61700 6 rfcomm,bnep,sco,l2cap, Live 0xffffffffa0f57000
rfkill 20672 1 bluetooth, Live 0xffffffffa0f4f000
vboxnetadp 98796 0 - Live 0xffffffffa0f34000
vboxnetflt 106028 0 - Live 0xffffffffa0f18000
vboxdrv 1710860 1 vboxnetflt, Live 0xffffffffa0d74000
kvm_amd 40748 0 - Live 0xffffffffa0cc3000
kvm 183056 1 kvm_amd, Live 0xffffffffa0d45000
ipv6 305120 24 - Live 0xffffffffa0cf8000
video 22420 0 - Live 0xffffffffa0ced000
output 3352 1 video, Live 0xffffffffa0ce7000
battery 12512 0 - Live 0xffffffffa0cde000
sbs 13800 0 - Live 0xffffffffa0cd5000
sbshc 5848 1 sbs, Live 0xffffffffa0cce000
nfsd 303040 9 - Live 0xffffffffa0c77000
nfs 301136 0 - Live 0xffffffffa0c28000
lockd 75284 2 nfsd,nfs, Live 0xffffffffa0c10000
nfs_acl 3288 2 nfsd,nfs, Live 0xffffffffa0c0d000
auth_rpcgss 44672 2 nfsd,nfs, Live 0xffffffffa0bfd000
sunrpc 202696 10 nfsd,nfs,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa0bc6000
ac 4960 0 - Live 0xffffffffa0bbf000
as_iosched 13928 0 - Live 0xffffffffa0bb6000
lp 12548 0 - Live 0xffffffffa0bad000
snd_hda_codec_realtek 289244 1 - Live 0xffffffffa0b61000
snd_hda_intel 32040 0 - Live 0xffffffffa0b54000
snd_hda_codec 69592 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa0b41000
snd_hwdep 9216 1 snd_hda_codec, Live 0xffffffffa0b39000
snd_pcm_oss 51776 0 - Live 0xffffffffa0b27000
snd_mixer_oss 18936 1 snd_pcm_oss, Live 0xffffffffa0b1d000
snd_pcm 90592 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xffffffffa0b01000
snd_seq_dummy 3260 0 - Live 0xffffffffa0afb000
amd64_edac_mod 22560 0 - Live 0xffffffffa0af0000
snd_seq_oss 35936 0 - Live 0xffffffffa0ae2000
nvidia 8115128 0 - Live 0xffffffffa031f000 (P)
i2c_nforce2 7936 0 - Live 0xffffffffa0318000
snd_seq_midi 8576 0 - Live 0xffffffffa0310000
ppdev 8032 0 - Live 0xffffffffa0309000
edac_core 44900 1 amd64_edac_mod, Live 0xffffffffa02f9000
8250_pnp 18168 0 - Live 0xffffffffa02ef000
k8temp 5496 0 - Live 0xffffffffa02e8000
snd_rawmidi 25248 1 snd_seq_midi, Live 0xffffffffa02dc000
i2c_core 23424 2 nvidia,i2c_nforce2, Live 0xffffffffa02d1000
hwmon 3080 1 k8temp, Live 0xffffffffa02cb000
parport_pc 41352 1 - Live 0xffffffffa02bb000
snd_seq_midi_event 7416 2 snd_seq_oss,snd_seq_midi, Live 0xffffffffa02b4000
parport 38032 3 lp,ppdev,parport_pc, Live 0xffffffffa02a5000
button 6552 0 - Live 0xffffffffa029e000
snd_seq 61632 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa0289000
snd_timer 24296 2 snd_pcm,snd_seq, Live 0xffffffffa027e000
snd_seq_device 7692 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa0277000
snd 72296 14 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xffffffffa0260000
soundcore 7488 1 snd, Live 0xffffffffa0259000
snd_page_alloc 9896 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0251000
8250 33736 1 8250_pnp, Live 0xffffffffa0243000
serial_core 22328 1 8250, Live 0xffffffffa023b000
usbhid 44160 0 - Live 0xffffffffa022b000
sg 34592 0 - Live 0xffffffffa021d000
ata_generic 6012 0 - Live 0xffffffffa0216000
pata_acpi 5272 0 - Live 0xffffffffa020f000
8139too 27228 0 - Live 0xffffffffa0203000
pata_amd 14684 0 - Live 0xffffffffa01fa000
8139cp 23224 0 - Live 0xffffffffa01ef000
mii 5272 2 8139too,8139cp, Live 0xffffffffa01eb000
forcedeth 61956 0 - Live 0xffffffffa01d6000
ahci 40936 4 - Live 0xffffffffa01c7000
ehci_hcd 40552 0 - Live 0xffffffffa01b8000
ohci_hcd 26260 0 - Live 0xffffffffa01ac000
dm_mirror 16064 0 - Live 0xffffffffa01a3000
dm_region_hash 10744 1 dm_mirror, Live 0xffffffffa019e000
dm_log 10556 2 dm_mirror,dm_region_hash, Live 0xffffffffa0196000
dm_snapshot 24620 0 - Live 0xffffffffa018a000
dm_mod 72168 3 dm_mirror,dm_log,dm_snapshot, Live 0xffffffffa0173000
fan 5184 0 - Live 0xffffffffa016c000
xfs 538496 2 - Live 0xffffffffa00e3000
exportfs 4760 2 nfsd,xfs, Live 0xffffffffa00df000
ext3 139016 0 - Live 0xffffffffa00b8000
jbd 48384 1 ext3, Live 0xffffffffa00a7000
jfs 180560 0 - Live 0xffffffffa0075000
ext4 327648 1 - Live 0xffffffffa0020000
mbcache 8156 2 ext3,ext4, Live 0xffffffffa0019000
jbd2 81504 1 ext4, Live 0xffffffffa0000000
root@peace:~# 


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

root@peace:~# cat /proc/iomem 
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000cee00-000cffff : pnp 00:0c
000f0000-000fffff : reserved
00100000-7feeffff : System RAM
  01000000-0136a552 : Kernel code
  0136a553-01524a0f : Kernel data
  015b5000-016419db : Kernel bss
7fef0000-7fef2fff : ACPI Non-volatile Storage
7fef3000-7fefffff : ACPI Tables
7ff00000-7fffffff : RAM buffer
80000000-800fffff : PCI Bus 0000:01
  80000000-8000ffff : 0000:01:06.0
e0000000-efffffff : PCI Bus 0000:02
  e0000000-efffffff : 0000:02:00.0
f0000000-f1ffffff : PCI MMCONFIG 0 [00-1f]
  f0000000-f1ffffff : reserved
    f0000000-f1ffffff : pnp 00:0b
f2000000-f4ffffff : PCI Bus 0000:02
  f2000000-f2ffffff : 0000:02:00.0
    f2000000-f2ffffff : nvidia
  f3000000-f3ffffff : 0000:02:00.0
  f4000000-f401ffff : 0000:02:00.0
f5000000-f6ffffff : PCI Bus 0000:01
  f6000000-f6003fff : 0000:01:0e.0
  f6004000-f60047ff : 0000:01:0e.0
  f6005000-f60050ff : 0000:01:06.0
    f6005000-f60050ff : 8139too
f7000000-f7003fff : 0000:00:07.0
  f7000000-f7003fff : ICH HD audio
f7004000-f7005fff : 0000:00:0a.0
  f7004000-f7005fff : ahci
f7006000-f7006fff : 0000:00:06.0
  f7006000-f7006fff : forcedeth
f7007000-f7007fff : 0000:00:02.0
  f7007000-f7007fff : ohci_hcd
f7008000-f70080ff : 0000:00:02.1
  f7008000-f70080ff : ehci_hcd
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0c
  feff0000-feff03ff : HPET 0
  ffff0000-ffffffff : pnp 00:0c
root@peace:~# 

root@peace:~# cat /proc/ioports 
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
0170-0177 : 0000:00:09.0
  0170-0177 : pata_amd
01f0-01f7 : 0000:00:09.0
  01f0-01f7 : pata_amd
0290-0294 : pnp 00:02
0295-0314 : pnp 00:02
0376-0376 : 0000:00:09.0
  0376-0376 : pata_amd
0378-037a : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:09.0
  03f6-03f6 : pata_amd
03f8-03ff : serial
04d0-04d1 : pnp 00:02
0800-087f : pnp 00:02
0970-0977 : 0000:00:0a.0
  0970-0977 : ahci
09f0-09f7 : 0000:00:0a.0
  09f0-09f7 : ahci
0b70-0b73 : 0000:00:0a.0
  0b70-0b73 : ahci
0bf0-0bf3 : 0000:00:0a.0
  0bf0-0bf3 : ahci
0cf8-0cff : PCI conf1
1000-107f : pnp 00:01
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  101c-101c : ACPI PM2_CNT_BLK
  1020-1027 : ACPI GPE0_BLK
1080-10ff : pnp 00:01
1400-147f : pnp 00:01
1480-14ff : pnp 00:01
  14a0-14af : ACPI GPE1_BLK
1800-187f : pnp 00:01
1880-18ff : pnp 00:01
1c00-1c3f : 0000:00:01.1
  1c00-1c3f : nForce2_smbus
1c40-1c7f : 0000:00:01.1
  1c40-1c7f : nForce2_smbus
a000-afff : PCI Bus 0000:01
  a000-a0ff : 0000:01:06.0
    a000-a0ff : 8139too
b000-bfff : PCI Bus 0000:02
  b000-b07f : 0000:02:00.0
c400-c407 : 0000:00:06.0
  c400-c407 : forcedeth
c800-c83f : 0000:00:01.1
dc00-dc0f : 0000:00:0a.0
  dc00-dc0f : ahci
f000-f00f : 0000:00:09.0
  f000-f00f : pata_amd
root@peace:~# 

[7.5.] PCI information ('lspci -vvv' as root)

root@peace:~# lspci -vv
00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a3)
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a3)
	Subsystem: Giga-byte Technology Device 0c11
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
	Subsystem: Giga-byte Technology Device 0c11
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at c800 [size=64]
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at 1c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: Giga-byte Technology Device 0c11
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a3) (prog-if 10)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f7007000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a3) (prog-if 20)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 22
	Region 0: Memory at f7008000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:06.0 Ethernet controller: nVidia Corporation MCP65 Ethernet (rev a3)
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 26
	Region 0: Memory at f7006000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at c400 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/3 Enable+
		Address: 00000000fee0300c  Data: 4181
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: forcedeth
	Kernel modules: forcedeth

00:07.0 Audio device: nVidia Corporation MCP65 High Definition Audio (rev a1)
	Subsystem: Giga-byte Technology Device a002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 23
	Region 0: Memory at f7000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: f5000000-f6ffffff
	Prefetchable memory behind bridge: 80000000-800fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: Giga-byte Technology Device 026f
	Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000

00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_amd
	Kernel modules: ata_generic, pata_acpi, pata_amd

00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a3) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 25
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at dc00 [size=16]
	Region 5: Memory at f7004000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable+
		Address: 00000000fee0300c  Data: 4171
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: ahci
	Kernel modules: ata_generic, pata_acpi, ahci

00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: f2000000-f4ffffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4149
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp

01:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at a000 [size=256]
	Region 1: Memory at f6005000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 80000000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: 8139too
	Kernel modules: 8139too, 8139cp

01:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10)
	Subsystem: Giga-byte Technology Device 1000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f6004000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at f6000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: firewire-ohci

02:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7300 GT] (rev a1)
	Subsystem: LeadTek Research Inc. Device 2a5f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f3000000 (64-bit, non-prefetchable) [size=16M]
	Region 5: I/O ports at b000 [size=128]
	[virtual] Expansion ROM at f4000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns, L1 <4us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nvidiafb

root@peace:~# 


[7.6.] SCSI information (from /proc/scsi/scsi)

root@peace:~# cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 7Y250M0   Rev: YAR5
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3120827AS      Rev: 3.42
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ASUS     Model: DRW-1814BL       Rev: 1.13
  Type:   CD-ROM                           ANSI  SCSI revision: 05
root@peace:~#

[7.7.] Other information that might be relevant to the problem

lxc-util version:  0.6.3


