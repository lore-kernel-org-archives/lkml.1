Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZBUGOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZBUGOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 01:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZBUGN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 01:13:59 -0500
Received: from Troy.its.carleton.edu ([137.22.94.86]:10906 "EHLO
	troy.its.carleton.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZBUGN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 01:13:57 -0500
Date: Fri, 20 Feb 2009 23:42:13 -0600 (CST)
From: "Matthew A. Bockol" <mbockol@carleton.edu>
To: linux-kernel@vger.kernel.org
Message-ID: <2141151129.266050251235194933826.JavaMail.root@mail2.its.carleton.edu>
Subject: PROBLEM: Starting with 2.6.28.5 Core2 Duo CPU T8300 /proc/cpuinfo
 reports different cpu MHz values for processor0 and processor1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [75.134.153.46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

Starting with 2.6.28.5's ACPI_PDC_SMP_P_HWCOORD patch to include/acpi/pdc_intel.h on a Lenovo Thinkpad T61 (Core2 Duo CPU T8300) /proc/cpuinfo reports different cpu MHz values for processor0 and processor1 

Using the performance govenor /proc/cpuinfo's "cpu MHz" line reports different values for processor0 and processor1.  processor0 stays locked at 2400 while processor1 fluctuates from 800 to 2400 depending on system load.
I removed the ACPI_PDC_SMP_P_HWCOORD change from a stock 2.5.28.6 kernel and the values re-synchonized.

KEYWORDS: ACPI_PDC_SMP_P_HWCOORD ACPI cpuinfo MHz

both kernel versions exhibit the same problem prior to removing the pdc_intel.h patch introduced in 2.6.28.5 (see http://www.spinics.net/lists/linux-acpi/msg19985.html)
Linux version 2.6.28.5 (root@afterthought) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #2 SMP Fri Feb 20 23:11:44 CST 2009
Linux version 2.6.28.6 (root@afterthought) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #2 SMP Fri Feb 20 22:00:15 CST 2009


here's the patch I applied to 2.6.28.6 to eliminate the discrepancy, though I don't know what it's doing :)

*** linux-2.6.28.6/include/acpi/pdc_intel.h 2009-02-17 11:29:27.000000000 -0600
--- linux-2.6.28.6m1/include/acpi/pdc_intel.h   2009-02-20 23:05:05.000000000 -0600
***************
*** 14,20 ****
  #define ACPI_PDC_SMP_T_SWCOORD        (0x0080)
  #define ACPI_PDC_C_C1_FFH     (0x0100)
  #define ACPI_PDC_C_C2C3_FFH       (0x0200)
- #define ACPI_PDC_SMP_P_HWCOORD        (0x0800)
  
  #define ACPI_PDC_EST_CAPABILITY_SMP   (ACPI_PDC_SMP_C1PT | \
                     ACPI_PDC_C_C1_HALT | \
--- 14,19 ----
***************
*** 23,29 ****
  #define ACPI_PDC_EST_CAPABILITY_SWSMP (ACPI_PDC_SMP_C1PT | \
                     ACPI_PDC_C_C1_HALT | \
                     ACPI_PDC_SMP_P_SWCOORD | \
-                    ACPI_PDC_SMP_P_HWCOORD | \
                     ACPI_PDC_P_FFH)
  
  #define ACPI_PDC_C_CAPABILITY_SMP (ACPI_PDC_SMP_C2C3  | \
--- 22,27 ----


and here's some data about my Thinkpad:



roue@afterthought:~$ cat /proc/cpuinfo 
processor   : 0
vendor_id   : GenuineIntel
cpu family  : 6
model       : 23
model name  : Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz
stepping    : 6
cpu MHz     : 2401.000
cache size  : 3072 KB
physical id : 0
siblings    : 2
core id     : 0
cpu cores   : 2
apicid      : 0
initial apicid  : 0
fpu     : yes
fpu_exception   : yes
cpuid level : 10
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida tpr_shadow vnmi flexpriority
bogomips    : 4788.79
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor   : 1
vendor_id   : GenuineIntel
cpu family  : 6
model       : 23
model name  : Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz
stepping    : 6
cpu MHz     : 2401.000
cache size  : 3072 KB
physical id : 0
siblings    : 2
core id     : 1
cpu cores   : 2
apicid      : 1
initial apicid  : 1
fpu     : yes
fpu_exception   : yes
cpuid level : 10
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida tpr_shadow vnmi flexpriority
bogomips    : 4788.02
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


roue@afterthought:~$ cat /proc/modules 
i915 61832 2 - Live 0xffffffffa04f8000
drm 106448 3 i915, Live 0xffffffffa04dc000
tun 15236 1 - Live 0xffffffffa04d6000
rfcomm 40864 0 - Live 0xffffffffa04ca000
l2cap 25216 5 rfcomm, Live 0xffffffffa04c1000
ppdev 11656 0 - Live 0xffffffffa04bc000
parport_pc 30872 0 - Live 0xffffffffa04b2000
lp 14436 0 - Live 0xffffffffa04ac000
parport 41888 3 ppdev,parport_pc,lp, Live 0xffffffffa049f000
ipv6 267392 18 - Live 0xffffffffa045b000
acpi_cpufreq 12176 1 - Live 0xffffffffa0456000
cpufreq_conservative 11272 0 - Live 0xffffffffa0451000
cpufreq_userspace 7684 0 - Live 0xffffffffa01f1000
cpufreq_stats 8964 0 - Live 0xffffffffa044c000
cpufreq_powersave 5888 0 - Live 0xffffffffa01b1000
cpufreq_ondemand 11664 0 - Live 0xffffffffa0447000
freq_table 9088 3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand, Live 0xffffffffa0442000
fuse 55616 1 - Live 0xffffffffa0432000
kvm_intel 44624 0 - Live 0xffffffffa0425000
kvm 147184 1 kvm_intel, Live 0xffffffffa03ff000
loop 19212 0 - Live 0xffffffffa03f8000
joydev 15104 0 - Live 0xffffffffa03f2000
pcmcia 39576 0 - Live 0xffffffffa03e6000
snd_hda_intel 493252 0 - Live 0xffffffffa036b000
snd_pcm_oss 40736 0 - Live 0xffffffffa035f000
snd_mixer_oss 18816 1 snd_pcm_oss, Live 0xffffffffa0358000
snd_pcm 82824 2 snd_hda_intel,snd_pcm_oss, Live 0xffffffffa0341000
snd_seq_dummy 7300 0 - Live 0xffffffffa0197000
snd_seq_oss 32832 0 - Live 0xffffffffa0336000
arc4 6144 2 - Live 0xffffffffa010b000
snd_seq_midi 10816 0 - Live 0xffffffffa0331000
snd_rawmidi 27040 1 snd_seq_midi, Live 0xffffffffa0328000
ecb 7168 2 - Live 0xffffffffa0017000
snd_seq_midi_event 11648 2 snd_seq_oss,snd_seq_midi, Live 0xffffffffa0323000
yenta_socket 29068 1 - Live 0xffffffffa0319000
rsrc_nonstatic 14080 1 yenta_socket, Live 0xffffffffa0313000
pcmcia_core 40484 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xffffffffa0307000
snd_seq 54128 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa02f7000
psmouse 45468 0 - Live 0xffffffffa02e9000
pcspkr 6912 0 - Live 0xffffffffa0183000
serio_raw 9988 0 - Live 0xffffffffa02e4000
snd_timer 26384 2 snd_pcm,snd_seq, Live 0xffffffffa02db000
snd_seq_device 11668 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa02d6000
i2c_i801 13852 0 - Live 0xffffffffa022d000
snd 63864 9 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xffffffffa02c4000
i2c_core 29088 1 i2c_i801, Live 0xffffffffa02ba000
iTCO_wdt 16592 0 - Live 0xffffffffa02b3000
iwl3945 87144 0 - Live 0xffffffffa029b000
mac80211 131344 1 iwl3945, Live 0xffffffffa0278000
hci_usb 18456 2 - Live 0xffffffffa0271000
soundcore 12048 1 snd, Live 0xffffffffa026c000
cfg80211 36000 2 iwl3945,mac80211, Live 0xffffffffa0261000
snd_page_alloc 13840 2 snd_hda_intel,snd_pcm, Live 0xffffffffa025b000
bluetooth 59428 7 rfcomm,l2cap,hci_usb, Live 0xffffffffa024a000
battery 11776 0 - Live 0xffffffffa0245000
ac 7936 0 - Live 0xffffffffa00f2000
video 24596 0 - Live 0xffffffffa023c000
output 7552 1 video, Live 0xffffffffa0041000
wmi 11840 0 - Live 0xffffffffa0237000
button 11552 0 - Live 0xffffffffa0232000
thinkpad_acpi 65044 0 - Live 0xffffffffa021b000
intel_agp 32496 1 - Live 0xffffffffa020e000
rfkill 16064 2 thinkpad_acpi, Live 0xffffffffa0205000
led_class 8840 1 thinkpad_acpi, Live 0xffffffffa01fd000
nvram 12684 1 thinkpad_acpi, Live 0xffffffffa01f4000
evdev 14864 8 - Live 0xffffffffa01eb000
ext3 125328 1 - Live 0xffffffffa01c7000
jbd 54824 1 ext3, Live 0xffffffffa01b4000
mbcache 13188 1 ext3, Live 0xffffffffa01ab000
dm_mirror 18048 0 - Live 0xffffffffa01a1000
dm_region_hash 16768 1 dm_mirror, Live 0xffffffffa019a000
dm_log 14084 2 dm_mirror,dm_region_hash, Live 0xffffffffa0191000
dm_snapshot 20552 0 - Live 0xffffffffa0186000
dm_mod 59744 3 dm_mirror,dm_log,dm_snapshot, Live 0xffffffffa0172000
sg 33488 0 - Live 0xffffffffa0167000
sd_mod 30760 3 - Live 0xffffffffa015d000
sr_mod 19508 0 - Live 0xffffffffa0156000
cdrom 37672 1 sr_mod, Live 0xffffffffa014a000
ide_pci_generic 8708 0 - Live 0xffffffffa0145000
piix 11272 0 - Live 0xffffffffa0140000
ide_core 116844 2 ide_pci_generic,piix, Live 0xffffffffa0121000
ata_generic 10116 0 - Live 0xffffffffa00b5000
ohci1394 33460 0 - Live 0xffffffffa0116000
sdhci_pci 12032 0 - Live 0xffffffffa010e000
sdhci 20484 1 sdhci_pci, Live 0xffffffffa0103000
ahci 36492 2 - Live 0xffffffffa00f5000
ata_piix 28932 0 - Live 0xffffffffa00e8000
ieee1394 90728 1 ohci1394, Live 0xffffffffa00cc000
mmc_core 56128 1 sdhci, Live 0xffffffffa00b9000
ricoh_mmc 8320 0 - Live 0xffffffffa0084000
libata 176064 3 ata_generic,ahci,ata_piix, Live 0xffffffffa0088000
scsi_mod 166952 4 sg,sd_mod,sr_mod,libata, Live 0xffffffffa0059000
ehci_hcd 38412 0 - Live 0xffffffffa004d000
uhci_hcd 26528 0 - Live 0xffffffffa0044000
e1000e 114736 0 - Live 0xffffffffa0022000
thermal 22944 0 - Live 0xffffffffa001a000
processor 49464 4 acpi_cpufreq,thermal, Live 0xffffffffa0008000
fan 9480 0 - Live 0xffffffffa0000000

roue@afterthought:~$ cat /proc/ioports 
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
0800-080f : pnp 00:02
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : pnp 00:02
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK
    1030-1033 : iTCO_wdt
    1060-107f : iTCO_wdt
1180-11bf : 0000:00:1f.0
  1180-11bf : pnp 00:02
15e0-15ef : pnp 00:02
164e-164f : pnp 00:02
1800-1807 : 0000:00:02.0
1840-185f : 0000:00:19.0
1860-187f : 0000:00:1a.0
  1860-187f : uhci_hcd
1880-189f : 0000:00:1a.1
  1880-189f : uhci_hcd
18a0-18bf : 0000:00:1d.0
  18a0-18bf : uhci_hcd
18c0-18df : 0000:00:1d.1
  18c0-18df : uhci_hcd
18e0-18ff : 0000:00:1d.2
  18e0-18ff : uhci_hcd
1c00-1c0f : 0000:00:1f.1
  1c00-1c0f : ata_piix
1c20-1c3f : 0000:00:1f.2
  1c20-1c3f : ahci
1c40-1c43 : 0000:00:1f.2
  1c40-1c43 : ahci
1c44-1c47 : 0000:00:1f.2
  1c44-1c47 : ahci
1c48-1c4f : 0000:00:1f.2
  1c48-1c4f : ahci
1c50-1c57 : 0000:00:1f.2
  1c50-1c57 : ahci
1c60-1c7f : 0000:00:1f.3
  1c60-1c7f : i801_smbus
2000-2fff : PCI Bus 0000:02
3000-3fff : PCI Bus 0000:03
4000-4fff : PCI Bus 0000:04
5000-5fff : PCI Bus 0000:05
6000-6fff : PCI Bus 0000:0d
7000-afff : PCI Bus 0000:15
  7000-70ff : PCI CardBus 0000:16
  7400-74ff : PCI CardBus 0000:16

roue@afterthought:~$ cat /proc/iomem 
00000000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000c0000-000c3fff : pnp 00:00
000c4000-000c7fff : pnp 00:00
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000e0000-000fffff : reserved
00100000-bf6affff : System RAM
  00200000-00456bbd : Kernel code
  00456bbe-00594577 : Kernel data
  00674000-006fe227 : Kernel bss
bf6b0000-bf6cbfff : ACPI Tables
bf6cc000-bf6fffff : ACPI Non-volatile Storage
bf700000-bfffffff : reserved
c4000000-c7ffffff : PCI CardBus 0000:16
c8000000-c8000fff : Intel Flush Page
d0000000-d1ffffff : PCI Bus 0000:0d
d4000000-d5ffffff : PCI Bus 0000:05
d8000000-d9ffffff : PCI Bus 0000:04
dc000000-df3fffff : PCI Bus 0000:03
  df3ff000-df3fffff : 0000:03:00.0
    df3ff000-df3fffff : iwl3945
df500000-df5fffff : PCI Bus 0000:0d
df800000-df8fffff : PCI Bus 0000:05
dfb00000-dfbfffff : PCI Bus 0000:04
dfe00000-dfefffff : PCI Bus 0000:03
e0000000-efffffff : 0000:00:02.0
f0000000-f3ffffff : PCI MMCONFIG 0
  f0000000-f3ffffff : reserved
    f0000000-f3ffffff : pnp 00:02
f4000000-f7ffffff : PCI Bus 0000:15
  f4000000-f7ffffff : PCI CardBus 0000:16
f8000000-f80fffff : PCI Bus 0000:02
f8100000-f81fffff : 0000:00:02.0
f8200000-f82fffff : 0000:00:02.1
f8300000-fbffffff : PCI Bus 0000:15
  f8300000-f8300fff : 0000:15:00.0
    f8300000-f8300fff : yenta_socket
  f8301000-f83017ff : 0000:15:00.1
    f8301000-f83017ff : ohci1394
  f8301800-f83018ff : 0000:15:00.2
    f8301800-f83018ff : mmc0
  f8301c00-f8301cff : 0000:15:00.3
  f8302000-f83020ff : 0000:15:00.4
  f8302400-f83024ff : 0000:15:00.5
fc000000-fdffffff : PCI Bus 0000:02
fe000000-fe01ffff : 0000:00:19.0
  fe000000-fe01ffff : e1000e
fe020000-fe023fff : 0000:00:1b.0
  fe020000-fe023fff : ICH HD audio
fe025000-fe025fff : 0000:00:19.0
  fe025000-fe025fff : e1000e
fe226000-fe2267ff : 0000:00:1f.2
  fe226000-fe2267ff : ahci
fe226c00-fe226fff : 0000:00:1a.7
  fe226c00-fe226fff : ehci_hcd
fe227000-fe2273ff : 0000:00:1d.7
  fe227000-fe2273ff : ehci_hcd
fe227400-fe2274ff : 0000:00:1f.3
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
  fed14000-fed17fff : pnp 00:02
  fed18000-fed18fff : pnp 00:02
  fed19000-fed19fff : pnp 00:02
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
  fed45000-fed4bfff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
100000000-13bffffff : System RAM


afterthought:/home/roue# lspci -vvv 
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    Subsystem: Lenovo T61
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information <?>
    Kernel driver in use: agpgart-intel
    Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA controller])
    Subsystem: Lenovo T61
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 1271
    Region 0: Memory at f8100000 (64-bit, non-prefetchable) [size=1M]
    Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at 1800 [size=8]
    Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
        Address: fee0300c  Data: 41d9
    Capabilities: [d0] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Bridge: PM- B3+
    Kernel modules: intelfb

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    Subsystem: Lenovo T61
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Region 0: Memory at f8200000 (64-bit, non-prefetchable) [size=1M]
    Capabilities: [d0] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Bridge: PM- B3+

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 1274
    Region 0: Memory at fe000000 (32-bit, non-prefetchable) [size=128K]
    Region 1: Memory at fe025000 (32-bit, non-prefetchable) [size=4K]
    Region 2: I/O ports at 1840 [size=32]
    Capabilities: [c8] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
        Address: 00000000fee0300c  Data: 41c9
    Kernel driver in use: e1000e
    Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 20
    Region 4: I/O ports at 1860 [size=32]
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo ThinkPad T60
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 21
    Region 4: I/O ports at 1880 [size=32]
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 22
    Region 0: Memory at fe226c00 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
    Subsystem: Lenovo ThinkPad T61
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 17
    Region 0: Memory at fe020000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE- FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [130] Root Complex Link <?>
    Kernel driver in use: HDA Intel
    Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 00002000-00002fff
    Memory behind bridge: fc000000-fdffffff
    Prefetchable memory behind bridge: 00000000f8000000-00000000f80fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
        Address: fee0300c  Data: 4171
    Capabilities: [90] Subsystem: Lenovo Device 20ad
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 00003000-00003fff
    Memory behind bridge: dc000000-df3fffff
    Prefetchable memory behind bridge: 00000000dfe00000-00000000dfefffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet+ LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
        Address: fee0300c  Data: 4179
    Capabilities: [90] Subsystem: Lenovo Device 20ad
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 00004000-00004fff
    Memory behind bridge: d8000000-d9ffffff
    Prefetchable memory behind bridge: 00000000dfb00000-00000000dfbfffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot #  4, PowerLimit 6.500000; Interlock- NoCompl-
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
        Address: fee0300c  Data: 4181
    Capabilities: [90] Subsystem: Lenovo Device 20ad
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
    I/O behind bridge: 00005000-00005fff
    Memory behind bridge: d4000000-d5ffffff
    Prefetchable memory behind bridge: 00000000df800000-00000000df8fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot #  5, PowerLimit 6.500000; Interlock- NoCompl-
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
        Address: fee0300c  Data: 4189
    Capabilities: [90] Subsystem: Lenovo Device 20ad
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
    I/O behind bridge: 00006000-00006fff
    Memory behind bridge: d0000000-d1ffffff
    Prefetchable memory behind bridge: 00000000df500000-00000000df5fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
            ClockPM- Suprise- LLActRep+ BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
            Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
        Address: fee0300c  Data: 4191
    Capabilities: [90] Subsystem: Lenovo Device 20ad
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [180] Root Complex Link <?>
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 4: I/O ports at 18a0 [size=32]
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 17
    Region 4: I/O ports at 18c0 [size=32]
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 4: I/O ports at 18e0 [size=32]
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 19
    Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
    I/O behind bridge: 00007000-0000afff
    Memory behind bridge: f8300000-fbffffff
    Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Subsystem: Lenovo Device 20ae

00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
    Subsystem: Lenovo T61
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information <?>
    Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 16
    Region 0: I/O ports at 01f0 [size=8]
    Region 1: I/O ports at 03f4 [size=1]
    Region 2: I/O ports at 0170 [size=8]
    Region 3: I/O ports at 0374 [size=1]
    Region 4: I/O ports at 1c00 [size=16]
    Kernel driver in use: ata_piix
    Kernel modules: ata_piix, ata_generic, piix, ide-pci-generic

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 1273
    Region 0: I/O ports at 1c50 [size=8]
    Region 1: I/O ports at 1c44 [size=4]
    Region 2: I/O ports at 1c48 [size=8]
    Region 3: I/O ports at 1c40 [size=4]
    Region 4: I/O ports at 1c20 [size=32]
    Region 5: Memory at fe226000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
        Address: fee0300c  Data: 41b9
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA <?>
    Kernel driver in use: ahci
    Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
    Subsystem: Lenovo ThinkPad T61
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at fe227400 (32-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at 1c60 [size=32]
    Kernel driver in use: i801_smbus
    Kernel modules: i2c-i801

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    Subsystem: Intel Corporation Device 1010
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 1272
    Region 0: Memory at df3ff000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [c8] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
        Address: 00000000fee0300c  Data: 41d1
    Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
            ClockPM+ Suprise- LLActRep- BwNot-
        LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Advanced Error Reporting <?>
    Capabilities: [140] Device Serial Number f1-e7-91-ff-ff-3c-1f-00
    Kernel driver in use: iwl3945
    Kernel modules: iwl3945

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
    Subsystem: Lenovo Device 20c6
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 168
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f8300000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
    Memory window 0: f4000000-f7fff000 (prefetchable)
    Memory window 1: c4000000-c7fff000
    I/O window 0: 00007000-000070ff
    I/O window 1: 00007400-000074ff
    BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
    16-bit legacy interface ports at 0001
    Kernel driver in use: yenta_cardbus
    Kernel modules: yenta_socket

15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
    Subsystem: Lenovo Device 20c7
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (500ns min, 1000ns max)
    Interrupt: pin B routed to IRQ 17
    Region 0: Memory at f8301000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=2 PME+
    Kernel driver in use: ohci1394
    Kernel modules: ohci1394

15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
    Subsystem: Lenovo Device 20c8
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 64
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at f8301800 (32-bit, non-prefetchable) [size=256]
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=2 PME-
    Kernel driver in use: sdhci-pci
    Kernel modules: sdhci-pci

15:00.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff) (prog-if ff)
    !!! Unknown header type 7f
    Kernel driver in use: ricoh-mmc
    Kernel modules: ricoh_mmc

15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 11)
    Subsystem: Lenovo Device 20ca
    Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 11
    Region 0: Memory at f8302000 (32-bit, non-prefetchable) [size=256]
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=2 PME-

15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
    Subsystem: Lenovo Device 20cb
    Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 11
    Region 0: Memory at f8302400 (32-bit, non-prefetchable) [size=256]
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=2 PME-







