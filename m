Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241Ab0AMJ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0AMJ33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0AMJ31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:29:27 -0500
Received: from web27606.mail.ukl.yahoo.com ([217.146.177.225]:43740 "HELO
	web27606.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755168Ab0AMJ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:29:24 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 04:29:21 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=WSo+IH42rPNPtlOOIHd+qAOiyU6kfAVayD2tP4tumqHfaC8l/pocgSpL6F+kv+cjPk8R7vLae8keHY5grl/9DrFQd05KXLermtJWB5oAjLNJxDNAYdkOVGJX1lHRNHtLMro9dp7cImyQdVvNH1iR2DVrl5SJikaVXhGJN0Xrxh8=;
Message-ID: <244239.49075.qm@web27606.mail.ukl.yahoo.com>
X-YMail-OSG: ah4WXJQVM1ncAwydBgzvRine0h0BsIq7LWdqOpBnm9qw6w2WVyJ1CO0OXtQqFtLRY3IOmCgk2yraSv21HcVz86y0HWQjWBej8EYI1HIt1Hm8hLiNbbx3H0MVPDBYD_FMEFNHWKKi8twVcvMyXynJoTSpVqtjg8cOkbbeAHB.H4wFySjQmohDIYR.6iiar_QdJW43kgv81lNCsa0PqyugKyff3VIHSl_k_79VKbUufWX.1dI18t4vY0K0Y.l2IgWpWb6Npf2TpBV4cA--
X-Mailer: YahooMailClassic/9.0.20 YahooMailWebService/0.8.100.260964
Date: Wed, 13 Jan 2010 09:22:40 +0000 (GMT)
From: richard parkins <p1rpp@yahoo.co.uk>
Subject: Problems with futex
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-204985010-1263374560=:49075"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-204985010-1263374560=:49075
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Please CC rparkins@undo-software.com with any responses

1. Various problems with futex
2. Test attached shows errors:
FUTEX_WAKE_OP arg4 not decoded correctly in 32-bit (looks like fixed in lin=
ux-2.6.32.3)
FUTEX_LOCK_PI(_PRIVATE) with non-NULL timeout returns ETIMEDOUT immediately=
 without waiting (may be fixed in linux-2.6.32.3)
FUTEX_WAIT_BITSET(_PRIVATE) with non-NULL timeout returns ETIMEDOUT immedia=
tely without waiting (patch suggested below)
Definitions of FUTEX_WAIT_BITSET_PRIVATE and FUTEX_WAKE_BITSET_PRIVATE were=
 bad in header file (fixed in linux-2.6.32.3)
Definition of FUTEX_OP unsafe if actual arguments are expressions (safe one=
 suggested below)
3. futex
4. Linux version 2.6.27.39-0.2-default (geeko@buildhost) (gcc version 4.3.2=
 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 2009-11-23 12:57:38=
 +0100
5. not applicable
6. test attached
7.1
Linux rparkins64 2.6.27.39-0.2-default #1 SMP 2009-11-23 12:57:38 +0100 x86=
_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.3
Gnu make               3.81
binutils               11.1
2.19
util-linux             ver_linux: line 23: fdformat: command not found
mount                  support
module-init-tools      found
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Kbd                    1.14.1
oprofile               0.9.4
Sh-utils               6.12
udev                   128
Modules Loaded         ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_pa=
cket snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT nf_conntr=
ack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_fi=
lter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack=
 ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cp=
ufreq_userspace cpufreq_powersave acpi_cpufreq dm_crypt fuse loop dm_mod ar=
c4 ecb snd_hda_intel crypto_blkcipher iwl3945 snd_pcm usbhid pcmcia video s=
nd_timer rfkill iTCO_wdt hid mac80211 iTCO_vendor_support snd_page_alloc tg=
3 yenta_socket nvidia snd_hwdep ohci1394 i2c_i801 battery snd output rtc_cm=
os libphy led_class button ac rsrc_nonstatic pcspkr joydev ff_memless ieee1=
394 intel_agp wmi sr_mod irda rtc_core pcmcia_core dcdbas cdrom soundcore r=
tc_lib i2c_core cfg80211 crc_ccitt sg sd_mod crc_t10dif ehci_hcd uhci_hcd u=
sbcore edd ext3 mbcache jbd fan ide_pci_generic ide_core ata_generic
 ata_piix libata scsi_mod dock thermal processor thermal_sys hwmon
7.2
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx l=
m constant_tsc arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx e=
st tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3989.97
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx l=
m constant_tsc arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx e=
st tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3990.05
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:
7.3
ip6t_LOG 7180 7 - Live 0xffffffffa0dbe000
xt_tcpudp 3608 4 - Live 0xffffffffa0dbc000
xt_pkttype 2152 3 - Live 0xffffffffa0dba000
ipt_LOG 6812 8 - Live 0xffffffffa0db7000
xt_limit 3180 15 - Live 0xffffffffa0db5000
af_packet 20232 4 - Live 0xffffffffa0daf000
snd_pcm_oss 48624 0 - Live 0xffffffffa0da2000
snd_mixer_oss 16808 1 snd_pcm_oss, Live 0xffffffffa0d9c000
snd_seq 61504 0 - Live 0xffffffffa0d8b000
snd_seq_device 8604 1 snd_seq, Live 0xffffffffa0d87000
ip6t_REJECT 6024 3 - Live 0xffffffffa0d84000
nf_conntrack_ipv6 24712 5 - Live 0xffffffffa0d7c000
ip6table_raw 2456 1 - Live 0xffffffffa0d7a000
xt_NOTRACK 2152 4 - Live 0xffffffffa0d78000
ipt_REJECT 3480 3 - Live 0xffffffffa0d76000
xt_state 2568 10 - Live 0xffffffffa0d74000
iptable_raw 2760 1 - Live 0xffffffffa0d72000
iptable_filter 3400 1 - Live 0xffffffffa0d70000
ip6table_mangle 3128 0 - Live 0xffffffffa0d6e000
nf_conntrack_netbios_ns 2840 0 - Live 0xffffffffa0219000
nf_conntrack_ipv4 12808 5 - Live 0xffffffffa0d69000
nf_conntrack 80352 5 nf_conntrack_ipv6,xt_NOTRACK,xt_state,nf_conntrack_net=
bios_ns,nf_conntrack_ipv4, Live 0xffffffffa0d54000
ip_tables 19464 2 iptable_raw,iptable_filter, Live 0xffffffffa0d4e000
ip6table_filter 3240 1 - Live 0xffffffffa01d3000
ip6_tables 21048 4 ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter, L=
ive 0xffffffffa0d47000
x_tables 23376 11 ip6t_LOG,xt_tcpudp,xt_pkttype,ipt_LOG,xt_limit,ip6t_REJEC=
T,xt_NOTRACK,ipt_REJECT,xt_state,ip_tables,ip6_tables, Live 0xffffffffa0d40=
000
ipv6 292472 23 ip6t_REJECT,nf_conntrack_ipv6,ip6table_mangle, Live 0xffffff=
ffa0cf7000
cpufreq_conservative 8384 0 - Live 0xffffffffa0cf3000
cpufreq_userspace 4204 0 - Live 0xffffffffa0cf0000
cpufreq_powersave 2248 0 - Live 0xffffffffa015f000
acpi_cpufreq 8216 0 - Live 0xffffffffa0cec000
dm_crypt 14352 0 - Live 0xffffffffa0ce7000
fuse 57872 3 - Live 0xffffffffa0cd7000
loop 16660 0 - Live 0xffffffffa0cd1000
dm_mod 74064 1 dm_crypt, Live 0xffffffffa0cbd000
arc4 2216 2 - Live 0xffffffffa01ec000
ecb 3464 2 - Live 0xffffffffa01df000
snd_hda_intel 562228 2 - Live 0xffffffffa0c32000
crypto_blkcipher 19372 2 dm_crypt,ecb, Live 0xffffffffa0c2c000
iwl3945 97892 0 - Live 0xffffffffa0c13000
snd_pcm 92064 2 snd_pcm_oss,snd_hda_intel, Live 0xffffffffa0bfb000
usbhid 52544 0 - Live 0xffffffffa0bed000
pcmcia 38288 0 - Live 0xffffffffa0be2000
video 24316 6 - Live 0xffffffffa0bdb000
snd_timer 24968 2 snd_seq,snd_pcm, Live 0xffffffffa0bd3000
rfkill 10948 2 iwl3945, Live 0xffffffffa0bcf000
iTCO_wdt 12416 0 - Live 0xffffffffa0bca000
hid 41136 1 usbhid, Live 0xffffffffa0bbe000
mac80211 241360 1 iwl3945, Live 0xffffffffa0b82000
iTCO_vendor_support 4268 1 iTCO_wdt, Live 0xffffffffa0216000
snd_page_alloc 9800 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0212000
tg3 125084 0 - Live 0xffffffffa0b62000
yenta_socket 26404 1 - Live 0xffffffffa0b5a000
nvidia 9616824 32 - Live 0xffffffffa022d000 (PX)
snd_hwdep 9104 1 snd_hda_intel, Live 0xffffffffa0229000
ohci1394 31364 0 - Live 0xffffffffa0220000
i2c_i801 12756 0 - Live 0xffffffffa021b000
battery 13856 0 - Live 0xffffffffa01b4000
snd 73576 12 snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel=
,snd_pcm,snd_timer,snd_hwdep, Live 0xffffffffa01ff000
output 3672 1 video, Live 0xffffffffa01fd000
rtc_cmos 13000 0 - Live 0xffffffffa01f8000
libphy 23080 1 tg3, Live 0xffffffffa01f1000
led_class 5008 1 iwl3945, Live 0xffffffffa01ee000
button 8328 0 - Live 0xffffffffa01e8000
ac 5776 0 - Live 0xffffffffa01e5000
rsrc_nonstatic 10920 1 yenta_socket, Live 0xffffffffa01e1000
pcspkr 3064 0 - Live 0xffffffffa01dd000
joydev 11376 0 - Live 0xffffffffa01d9000
ff_memless 8752 1 usbhid, Live 0xffffffffa01d5000
ieee1394 98464 1 ohci1394, Live 0xffffffffa01b9000
intel_agp 30400 0 - Live 0xffffffffa01ab000
wmi 8160 0 - Live 0xffffffffa01a8000
sr_mod 15860 0 - Live 0xffffffffa01a3000
irda 132756 0 - Live 0xffffffffa0181000
rtc_core 21396 1 rtc_cmos, Live 0xffffffffa017a000
pcmcia_core 39140 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xffffffffa016=
f000
dcdbas 10984 0 - Live 0xffffffffa016b000 (X)
cdrom 36200 1 sr_mod, Live 0xffffffffa0161000
soundcore 8368 1 snd, Live 0xffffffffa015b000
rtc_lib 3560 1 rtc_core, Live 0xffffffffa0131000
i2c_core 35296 2 nvidia,i2c_i801, Live 0xffffffffa0151000
cfg80211 28168 2 iwl3945,mac80211, Live 0xffffffffa0149000
crc_ccitt 2392 1 irda, Live 0xffffffffa0120000
sg 35376 0 - Live 0xffffffffa013f000
sd_mod 35240 6 - Live 0xffffffffa0135000
crc_t10dif 2152 1 sd_mod, Live 0xffffffffa0133000
ehci_hcd 54676 0 - Live 0xffffffffa0122000
uhci_hcd 26840 0 - Live 0xffffffffa0118000
usbcore 195808 4 usbhid,ehci_hcd,uhci_hcd, Live 0xffffffffa00e7000
edd 10272 0 - Live 0xffffffffa00e3000
ext3 140824 3 - Live 0xffffffffa00bf000
mbcache 9484 1 ext3, Live 0xffffffffa00bb000
jbd 61752 1 ext3, Live 0xffffffffa00aa000
fan 6016 0 - Live 0xffffffffa00a7000
ide_pci_generic 4652 0 - Live 0xffffffffa00a4000
ide_core 115068 1 ide_pci_generic, Live 0xffffffffa0086000
ata_generic 6044 0 - Live 0xffffffffa0083000
ata_piix 21980 5 - Live 0xffffffffa007c000
libata 183856 2 ata_generic,ata_piix, Live 0xffffffffa004e000
scsi_mod 178968 4 sr_mod,sg,sd_mod,libata, Live 0xffffffffa0021000
dock 14212 1 libata, Live 0xffffffffa001c000
thermal 24408 0 - Live 0xffffffffa0015000
processor 49472 4 acpi_cpufreq,thermal, Live 0xffffffffa0007000
thermal_sys 14336 4 video,fan,thermal,processor, Live 0xffffffffa0002000
hwmon 3720 1 thermal_sys, Live 0xffffffffa0000000
7.4
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
0170-0177 : 0000:00:1f.2
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : ata_piix
02f8-02ff : serial
0376-0376 : 0000:00:1f.2
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : ata_piix
03f8-03ff : serial
04d0-04d1 : pnp 00:02
0809-0809 : pnp 00:03
0910-091f : pnp 00:08
0920-092f : pnp 00:08
0930-097f : pnp 00:08
0c80-0caf : pnp 00:08
0cb0-0cbb : pnp 00:0e
0cbc-0cbf : pnp 00:08
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  1010-1015 : ACPI CPU throttle
  1020-1020 : ACPI PM2_CNT_BLK
  1028-102f : ACPI GPE0_BLK
  1060-107f : iTCO_wdt
1080-10bf : 0000:00:1f.0
  1080-10bf : pnp 00:03
10c0-10df : 0000:00:1f.3
  10c0-10df : pnp 00:03
    10c0-10df : i801_smbus
2000-2fff : PCI Bus 0000:03
  2000-20ff : PCI CardBus 0000:04
  2400-24ff : PCI CardBus 0000:04
bf20-bf3f : 0000:00:1d.3
  bf20-bf3f : uhci_hcd
bf40-bf5f : 0000:00:1d.2
  bf40-bf5f : uhci_hcd
bf60-bf7f : 0000:00:1d.1
  bf60-bf7f : uhci_hcd
bf80-bf9f : 0000:00:1d.0
  bf80-bf9f : uhci_hcd
bfa0-bfaf : 0000:00:1f.2
  bfa0-bfaf : ata_piix
e000-efff : PCI Bus 0000:0d
f400-f4fe : pnp 00:03
00000000-0009efff : System RAM
0009f000-0009ffff : reserved
000c0000-000cffff : pnp 00:00
000e0000-000fffff : pnp 00:00
00100000-7fe813ff : System RAM
  00200000-004a420f : Kernel code
  004a4210-007bd18f : Kernel data
  00a36000-00bcc8b7 : Kernel bss
7fe81400-7fffffff : reserved
88000000-8bffffff : PCI Bus 0000:03
  88000000-8bffffff : PCI CardBus 0000:04
8c000000-8fffffff : PCI CardBus 0000:04
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:00.0
e0000000-e01fffff : PCI Bus 0000:0d
ecb00000-ecbfffff : PCI Bus 0000:03
  ecb00000-ecb00fff : 0000:03:01.0
    ecb00000-ecb00fff : yenta_socket
  ecbfe800-ecbfefff : 0000:03:01.4
  ecbff000-ecbfffff : 0000:03:01.4
    ecbff000-ecbff7ff : ohci1394
ecc00000-ecdfffff : PCI Bus 0000:0d
ece00000-ecefffff : PCI Bus 0000:09
  ecef0000-ecefffff : 0000:09:00.0
    ecef0000-ecefffff : tg3
ecf00000-ecffffff : PCI Bus 0000:0c
  ecfff000-ecffffff : 0000:0c:00.0
    ecfff000-ecffffff : iwl3945
ed000000-efefffff : PCI Bus 0000:01
  ed000000-edffffff : 0000:01:00.0
    ed000000-edffffff : nvidia
  ee000000-eeffffff : 0000:01:00.0
  ef000000-ef01ffff : 0000:01:00.0
efffc000-efffffff : 0000:00:1b.0
  efffc000-efffffff : ICH HD audio
f0000000-f4006fff : reserved
  f0000000-f3ffffff : PCI MMCONFIG 0
f4008000-f400bfff : reserved
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:0b
fed20000-fed9ffff : reserved
fee00000-fee0ffff : reserved
  fee00000-fee00fff : Local APIC
ffa80000-ffa803ff : 0000:00:1d.7
  ffa80000-ffa803ff : ehci_hcd
ffb00000-ffffffff : reserved
7.5
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and =
945GT Express Memory Controller Hub (rev 03)
        Subsystem: Dell Device 01cc
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>
        Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 9=
45GT Express PCI Express Root Port (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: ed000000-efefffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dffffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: Dell Device 01cc
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Count=
=3D1/1 Enable+
                Address: fee0300c  Data: 4169
        Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64n=
s, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Tr=
ansPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Lat=
ency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DL=
Active- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Su=
rpise-
                        Slot #  1, PowerLimit 75.000000; Interlock- NoCompl=
-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPI=
rq- LinkChg-
                        Control: AttnInd Off, PwrInd On, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ I=
nterlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [140] Root Complex Link <?>
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definitio=
n Audio Controller (rev 01)
        Subsystem: Dell Device 01cc
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at efffc000 (64-bit, non-prefetchable) [size=3D16K=
]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D=
2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Count=
=3D1/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, M=
SI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64n=
s, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Lat=
ency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLA=
ctive- BWMgmt- ABWMgmt-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port=
 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0b, subordinate=3D0b, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unli=
mited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <1us, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLA=
ctive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Su=
rpise+
                        Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPI=
rq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- In=
terlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- I=
nterlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=
=3D1/1 Enable+
                Address: fee0300c  Data: 4171
        Capabilities: [90] Subsystem: Dell Device 01cc
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port=
 2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0c, subordinate=3D0c, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: ecf00000-ecffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unli=
mited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Su=
rpise+
                        Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPI=
rq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- In=
terlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ I=
nterlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=
=3D1/1 Enable+
                Address: fee0300c  Data: 4179
        Capabilities: [90] Subsystem: Dell Device 01cc
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port=
 3 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D09, subordinate=3D09, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: ece00000-ecefffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unli=
mited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Su=
rpise+
                        Slot #  4, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPI=
rq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- In=
terlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ I=
nterlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=
=3D1/1 Enable+
                Address: fee0300c  Data: 4189
        Capabilities: [90] Subsystem: Dell Device 01cc
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port=
 4 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0d, subordinate=3D0e, sec-latency=3D=
0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: ecc00000-ecdfffff
        Prefetchable memory behind bridge: 00000000e0000000-00000000e01ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unli=
mited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <1us, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLA=
ctive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Su=
rpise+
                        Slot #  5, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPI=
rq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- In=
terlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- I=
nterlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=
=3D1/1 Enable+
                Address: fee0300c  Data: 4191
        Capabilities: [90] Subsystem: Dell Device 01cc
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Con=
troller #1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at bf80 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Con=
troller #2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at bf60 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Con=
troller #3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 22
        Region 4: I/O ports at bf40 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Con=
troller #4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 23
        Region 4: I/O ports at bf20 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Co=
ntroller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Dell Device 01cc
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=3D1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,=
D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1) (pro=
g-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=3D00, secondary=3D03, subordinate=3D07, sec-latency=3D=
32
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: ecb00000-ecbfffff
        Prefetchable memory behind bridge: 0000000088000000-000000008bfffff=
f
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR+
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Dell Device 01cc

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridg=
e (rev 01)
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>
        Kernel modules: iTCO_wdt, intel-rng

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA ID=
E Controller (rev 01) (prog-if 80 [Master])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 01f0 [size=3D8]
        Region 1: I/O ports at 03f4 [size=3D1]
        Region 2: I/O ports at 0170 [size=3D8]
        Region 3: I/O ports at 0374 [size=3D1]
        Region 4: I/O ports at bfa0 [size=3D16]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Kernel driver in use: ata_piix
        Kernel modules: ide-pci-generic, ata_generic, pata_acpi, ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev=
 01)
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 10c0 [size=3D32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation G72M [Quadro NVS 110M=
/GeForce Go 7300] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at ed000000 (32-bit, non-prefetchable) [size=3D16M=
]
        Region 1: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
        Region 3: Memory at ee000000 (64-bit, non-prefetchable) [size=3D16M=
]
        [virtual] Expansion ROM at ef000000 [disabled] [size=3D128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Count=
=3D1/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256=
ns, L1 <4us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Tr=
ansPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Lat=
ency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- Com=
mClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DL=
Active- BWMgmt- ABWMgmt-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [128] Power Budgeting <?>
        Kernel driver in use: nvidia
        Kernel modules: nvidia, nvidiafb

03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at ecb00000 (32-bit, non-prefetchable) [size=3D4K]
        Bus: primary=3D03, secondary=3D04, subordinate=3D07, sec-latency=3D=
176
        Memory window 0: 88000000-8bfff000 (prefetchable)
        Memory window 1: 8c000000-8ffff000
        I/O window 0: 00002000-000020ff
        I/O window 1: 00002400-000024ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrit=
e+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus
        Kernel modules: yenta_socket

03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) =
(prog-if 10 [OHCI])
        Subsystem: Dell Device 01cc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at ecbff000 (32-bit, non-prefetchable) [size=3D4K]
        Region 1: Memory at ecbfe800 (32-bit, non-prefetchable) [size=3D2K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME+
        Kernel driver in use: ohci1394
        Kernel modules: ohci1394

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit=
 Ethernet PCI Express (rev 02)
        Subsystem: Dell Device 01cc
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 4345
        Region 0: Memory at ecef0000 (64-bit, non-prefetchable) [size=3D64K=
]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [50] Vital Product Data <?>
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Count=
=3D1/8 Enable+
                Address: 00000000fee0300c  Data: 41c1
        Capabilities: [d0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us=
, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <2us, L1 <64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP+ Rollover- Timeout- NonFatal=
Err-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ Ch=
kEn-
        Capabilities: [13c] Virtual Channel <?>
        Kernel driver in use: tg3
        Kernel modules: tg3

0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] =
Network Connection (rev 02)
        Subsystem: Intel Corporation Device 1021
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 4346
        Region 0: Memory at ecfff000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Count=
=3D1/1 Enable+
                Address: 00000000fee0100c  Data: 41b9
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512=
ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <128ns, L1 <64us
                        ClockPM+ Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- Ch=
kEn-
        Capabilities: [140] Device Serial Number 07-0e-7b-ff-ff-d2-19-00
        Kernel driver in use: iwl3945
        Kernel modules: iwl3945
7.6
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HTS54161 Rev: SBDO
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: DVD+-RW TS-L632D Rev: DE03
  Type:   CD-ROM                           ANSI  SCSI revision: 05

Here is the output from the attached test compiled with -m32 and run under =
64-bit Linux 2.6.27.39.

Could not find undodb private space
FUTEX_WAKE_PRIVATE with bad address succeeds
FUTEX_WAKE with zero val woke a process
FUTEX_WAKE with negative val woke a process
FUTEX_REQUEUE returns 1 when waking no processes but requeueing one
KERNELBUG? FUTEX_WAKE_OP arg4 not decoded correctly in 32-bit
KERNELBUG? FUTEX_LOCK_PI with timer returns ETIMEDOUT immediately
KERNELBUG? FUTEX_LOCK_PI_PRIVATE with timer returns ETIMEDOUT immediately
KERNELBUG? FUTEX_WAIT_BITSET with timer returns ETIMEDOUT immediately
KERNELBUG? FUTEX_WAIT_BITSET_PRIVATE with timer returns ETIMEDOUT immediate=
ly
Test succeeded

If compiled in 64-bit mode the output is the same but without the line abou=
t FUTEX_WAKE_OP.

Here is the output again with my comments.
>>>Could not find undodb private space
Nothing to do with the kernel: it prints this if it isn't running under our=
 debugger.

>>>FUTEX_WAKE_PRIVATE with bad address succeeds
It isn't clear that this is a bug. FUTEX_WAKE always returns -EFAULT with a=
 bad uaddr, because it looks for the vma and doesn't find one. FUTEX_WAIT_P=
RIVATE only does access_ok(), which is a weak test on x86 architecture. On =
32-bit FUTEX_WAKE_PRIVATE always returns 0 because it doesn't find a waiter=
: on 64-bit it returns -EFAULT if uaddr is negative and otherwise 0. I can =
see the case for not doing a proper accessibility check since the kernel do=
esn't actually dereference uaddr for FUTEX_WAKE, but the existing behaviour=
 is a bit inconsistent.

>>>FUTEX_WAKE with zero val woke a process
>>>FUTEX_WAKE with negative val woke a process
>>>FUTEX_REQUEUE returns 1 when waking no processes but requeueing one
These messages are because the kernel doesn't do what the man page says it =
does. Maybe the man page is wrong.... The treatment of counts of processes =
to be woken or requeued is a bit inconsistent. Sometimes you wake a process=
 before checking the count (so a zero or negative count is treated as 1) an=
d sometimes you check the count first. Maybe there's some method in your ma=
dness, but if so the man page is wrong.

>>>KERNELBUG? FUTEX_WAKE_OP arg4 not decoded correctly in 32-bit
Should already have been fixed by this diff in futex_compat.c from 2.6.27.3=
9 to 2.6.32.3
191c195,196
<       if (cmd =3D=3D FUTEX_REQUEUE || cmd =3D=3D FUTEX_CMP_REQUEUE)
---
>       if (cmd =3D=3D FUTEX_REQUEUE || cmd =3D=3D FUTEX_CMP_REQUEUE ||
>           cmd =3D=3D FUTEX_CMP_REQUEUE_PI || cmd =3D=3D FUTEX_WAKE_OP)

>>>KERNELBUG? FUTEX_LOCK_PI with timer returns ETIMEDOUT immediately
>>>KERNELBUG? FUTEX_LOCK_PI_PRIVATE with timer returns ETIMEDOUT immediatel=
y
The problem was in rtmutex.c. The code has changed, so it may be fixed now.

>>>KERNELBUG? FUTEX_WAIT_BITSET with timer returns ETIMEDOUT immediately
>>>KERNELBUG? FUTEX_WAIT_BITSET_PRIVATE with timer returns ETIMEDOUT immedi=
ately
This doesn't seem to be fixed yet. I think it should be fixed by this diff =
to futex.c in version linux-2.6.32.3.
2611c2611
<               if (cmd =3D=3D FUTEX_WAIT)
---
>               if ((cmd =3D=3D FUTEX_WAIT) || (cmd =3D=3D FUTEX_WAIT_BITSE=
T))
The same change is needed for futex_compat.c.
191c191
<               if (cmd =3D=3D FUTEX_WAIT)
---
>               if ((cmd =3D=3D FUTEX_WAIT) || (cmd =3D=3D FUTEX_WAIT_BITSE=
T))

>>>Test succeeded
It didn't find any problems that it didn't expect.

Definitions of FUTEX_WAIT_BITSET_PRIVATE and FUTEX_WAKE_BITSET_PRIVATE were=
 bad in linux/futex.h, but have been fixed in linux-2.6.32.3.

The definition of FUTEX_OP in linux/futex.h doesn't protect against the act=
ual arguments being expressions. Here is a safer one
#define FUTEX_OP(op, oparg, cmp, cmparg) \
  ((((op) & 0xf) << 28) | (((cmp) & 0xf) << 24)=09=09\
   | (((oparg) & 0xfff) << 12) | ((cmparg) & 0xfff))

Richard P. Parkins, M. A.
rparkins@undo-software.com

=0A=0A=0A      
--0-204985010-1263374560=:49075
Content-Type: text/plain; name="test1517.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="test1517.c"

LyogV3JpdHRlbiBieSBSaWNoYXJkIFBhcmtpbnMsIHJwYXJraW5zQHVuZG8t
c29mdHdhcmUuY29tLiAqLwovKiBDb3B5cmlnaHQgMjAwOSwgVW5kbyBMdGQu
ICovCi8qIFJlbGVhc2VkIHVuZGVyIHRoZSBHTlUgUHVibGljIExpY2VuY2Uu
ICovCgovKiBGdXRleCB0ZXN0ICovCgojZGVmaW5lIF9HTlVfU09VUkNFCiNp
bmNsdWRlIDxzY2hlZC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUg
PGVycm5vLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGxp
Yi5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDx0aW1lLmg+CiNp
bmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPHN5cy9zeXNjYWxsLmg+CiNp
bmNsdWRlIDxzeXMvdGltZS5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2lu
Y2x1ZGUgPHN5cy93YWl0Lmg+CiNpbmNsdWRlIDxsaW51eC9mdXRleC5oPgoK
LyogU29tZSBkaXN0cm9zIGhhdmUgYnJva2VuIGRlZmluaXRpb25zIG9mIHRo
ZXNlLiAqLwojdW5kZWYgRlVURVhfV0FJVF9CSVRTRVRfUFJJVkFURQojdW5k
ZWYgRlVURVhfV0FLRV9CSVRTRVRfUFJJVkFURQojdW5kZWYgRlVURVhfT1AK
I2RlZmluZSBGVVRFWF9XQUlUX0JJVFNFVF9QUklWQVRFCShGVVRFWF9XQUlU
X0JJVFNFVCB8IEZVVEVYX1BSSVZBVEVfRkxBRykKI2RlZmluZSBGVVRFWF9X
QUtFX0JJVFNFVF9QUklWQVRFCShGVVRFWF9XQUtFX0JJVFNFVCB8IEZVVEVY
X1BSSVZBVEVfRkxBRykKI2RlZmluZSBGVVRFWF9PUChvcCwgb3BhcmcsIGNt
cCwgY21wYXJnKSBcCiAgKCgoKG9wKSAmIDB4ZikgPDwgMjgpIHwgKCgoY21w
KSAmIDB4ZikgPDwgMjQpCQlcCiAgIHwgKCgob3BhcmcpICYgMHhmZmYpIDw8
IDEyKSB8ICgoY21wYXJnKSAmIDB4ZmZmKSkKCi8qIGZ1dGV4LCB0a2lsbCwg
YW5kIGdldHRpZCBzeXN0ZW0gY2FsbHMgYXJlIG5vdCBkZWZpbmVkIGluIGhl
YWRlciBmaWxlcy4gKi8KI2RlZmluZSAgICAgIGZ1dGV4KCBhcmcxLCBhcmcy
LCBhcmczLCBhcmc0LCBhcmc1LCBhcmc2KSBcCiBzeXNjYWxsKFNZU19mdXRl
eCwgYXJnMSwgYXJnMiwgYXJnMywgYXJnNCwgYXJnNSwgYXJnNikKI2RlZmlu
ZSAgICAgIHRraWxsKCBhcmcxLCBhcmcyKSBcCiBzeXNjYWxsKFNZU190a2ls
bCwgYXJnMSwgYXJnMikKI2RlZmluZSAgICAgIGdldHRpZCgpIFwKIHN5c2Nh
bGwoU1lTX2dldHRpZCkKCnN0YXRpYyBzdHJ1Y3QgdGltZXNwZWMgVEVOX21z
ID0gezAsIDEwKjEwMDAqMTAwMH07CgpzdGF0aWMgc3RydWN0IHRpbWVzcGVj
IE9ORV9zZWMgPSB7MSwgMH07CgpzdGF0aWMgRklMRSAqIHN0YXR1czsKCnN0
YXRpYyBpbnQgZjEsIGYyOwoKc3RhdGljIGludCB0aHJlYWRfYWN0aW9uOwoK
c3RydWN0IHNoYSB7CiAgICBpbnQgZjM7CiAgICBpbnQgZjQ7CiAgICBpbnQg
Y2hpbGRfYWN0aW9uOwp9OwoKc3RhdGljIHN0cnVjdCBzaGEgKiBzaG1lbTsK
CnN0YXRpYyBwaWRfdCBwYXJlbnRfcGlkLCB0aHJlYWRfcGlkLCBjaGlsZF9w
aWQ7CgpzdGF0aWMgY2hhciB0aHNbMHgyMDAwMF07CgojZGVmaW5lIHRocmVh
ZF9zdGFjayAodGhzICsgc2l6ZW9mKHRocykgLSBzaXplb2YobG9uZykpCgpz
dGF0aWMgaW50IHBhcmVudF9zbGVlcGluZyh2b2lkKQp7CiAgICAvKiBOb3Rl
IHdoZW4gY2FsbGVkIGZyb20gdGhlIGNoaWxkIChhIGZvcmtlZCBwcm9jZXNz
KSwgdGhpcyBpcyBhIGRpZmZlcmVudAogICAgICogY29weSBvZiB0aGUgRklM
RSBvYmplY3QgZnJvbSB0aGF0IHVzZWQgd2hlbiBjYWxsZWQgZnJvbSB0aGUg
dGhyZWFkLgogICAgICovCiAgICByZXdpbmQoc3RhdHVzKTsKICAgIGludCBp
OwogICAgY2hhciBjOwogICAgaW50IHIgPSBmc2NhbmYoc3RhdHVzLCAiJWQg
JSpzICVjIiwgJmksICZjKTsKICAgIGlmIChyICE9IDIpCiAgICB7CiAgICAg
ICAgaWYgKHIgPCAwKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZzY2FuZiBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgfQogICAgICAgIGVsc2UKICAgICAgICB7CiAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmc2NhbmYgcmV0dXJuZWQgJWQg
aW5zdGVhZCBvZiAyXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICB9CiAgICAgICAgdGtpbGwocGFyZW50X3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICBleGl0KDEpOwogICAgfQogICAgcmV0dXJuIChjID09ICdTJyk7Cn0K
Ci8qIFRocmVhZCB3YWl0cyBmb3IgdGhyZWFkX2FjdGlvbiB0byBiZSBub256
ZXJvCiAqIChhbmQgZm9yIHNvbWUgYWN0aW9ucyBmb3IgdGhlIHBhcmVudCB0
byBiZSB3YWl0aW5nIGZvciBpdCksCiAqIGFuZCB0aGVuIGRvZXMgdGhlIHJl
cXVpcmVkIGFjdGlvbi4KICovCnN0YXRpYyBpbnQgdGhyZWFkKHZvaWQgKiBh
cmcgX19hdHRyaWJ1dGVfXyAoKHVudXNlZCkpKQp7CiAgICBpbnQgcjsKICAg
IHdoaWxlICgxKQogICAgewogICAgICAgIHN3aXRjaCAodGhyZWFkX2FjdGlv
bikKICAgICAgICB7CiAgICAgICAgICAgIGNhc2UgLTE6CiAgICAgICAgICAg
IGNhc2UgMDoKICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICBj
YXNlIDE6CiAgICAgICAgICAgICAgICBpZiAocGFyZW50X3NsZWVwaW5nKCkp
CiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgdGhyZWFk
X2FjdGlvbiA9IDA7CiAgICAgICAgICAgICAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfV0FLRSwgMiwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAg
ICAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICAgICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAg
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgICAgIH0K
ICAgICAgICAgICAgICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggcmV0dXJuZWQgJWQgaW5zdGVh
ZCBvZiAxXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICAgICAgICAgIH0KICAg
ICAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMjoKICAgICAgICAg
ICAgICAgIGlmIChwYXJlbnRfc2xlZXBpbmcoKSkKICAgICAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gMDsKICAg
ICAgICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX1BS
SVZBVEUsIDIsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgICAg
IGlmIChyICE9IDEpCiAgICAgICAgICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgICAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAg
ICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIGZ1dGV4IHJldHVybmVkICVkIGluc3RlYWQgb2YgMVxu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICAgICAgICAgIH0KICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAg
IGJyZWFrOwogICAgICAgICAgICBjYXNlIDM6CiAgICAgICAgICAgICAgICBp
ZiAocGFyZW50X3NsZWVwaW5nKCkpCiAgICAgICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDA7CiAgICAgICAgICAg
ICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwg
MiwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICAgICAgaWYgKHIg
IT0gMSkKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAg
ICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAg
ICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggcmV0dXJuZWQgJWQgaW5zdGVhZCBvZiAxXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgfQogICAgICAgICAg
ICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgNDoKICAgICAgICAgICAg
ICAgIHRocmVhZF9hY3Rpb24gPSAtMTsKICAgICAgICAgICAgICAgIC8qIEl0
IGlzIHBvc3NpYmxlIHRoYXQgYSB0aHJlYWQgc3dpdGNoIG9jY3VycyBoZXJl
OgogICAgICAgICAgICAgICAgICogd2FpdF9mb3JfdGhyZWFkKCkgZG9lcyBh
biBleHRyYSAxMG1zIHNsZWVwIHRvIGdpdmUgdGhpcwogICAgICAgICAgICAg
ICAgICogdGhyZWFkIGEgY2hhbmNlIHRvIHN0YXJ0IHRoZSB3YWl0LCBidXQg
b24gYSBidXN5IG1hY2hpbmUKICAgICAgICAgICAgICAgICAqIGl0IG1heSBu
b3QgZ2V0IHRvIHJ1biBhbmQgdGhlIHRlc3Qgb24gdGhlIG51bWJlciBvZgog
ICAgICAgICAgICAgICAgICogcHJvY2Vzc2VzIHdva2VuIHdpbGwgZmFpbC4g
T2YgY291cnNlIGZ1dGV4ZXMgYXJlIGRlc2lnbmVkCiAgICAgICAgICAgICAg
ICAgKiBqdXN0IHRvIGF2b2lkIHRoaXMgc29ydCBvZiByYWNlLCBidXQgc2lu
Y2Ugd2UgYXJlIHRlc3RpbmcKICAgICAgICAgICAgICAgICAqIGZ1dGV4ZXMg
aGVyZSB3ZSBjYW4ndCB1c2Ugb25lLgogICAgICAgICAgICAgICAgICovCiAg
ICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUlULCBmMSwg
TlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICAgICAgfQogICAgICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNh
c2UgNToKICAgICAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAtMTsKICAg
ICAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBSVRfUFJJVkFU
RSwgZjEsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKHIp
CiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubykpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAg
ICAgICBjYXNlIDY6CiAgICAgICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0g
LTE7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBG
VVRFWF9XQUlULCBzaG1lbS0+ZjMsICZPTkVfc2VjLCBOVUxMLCAwKTsKICAg
ICAgICAgICAgICAgIGlmIChyKQogICAgICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRl
eCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAg
ICAgICBicmVhazsKICAgICAgICAgICAgY2FzZSA3OgogICAgICAgICAgICAg
ICAgdGhyZWFkX2FjdGlvbiA9IC0xOwogICAgICAgICAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfTE9DS19QSSwgMCwgJlRFTl9tcywgTlVMTCwgMCk7
CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgODoKICAgICAgICAg
ICAgICAgIHRocmVhZF9hY3Rpb24gPSAtMTsKICAgICAgICAgICAgICAgIHIg
PSBmdXRleCgmZjEsIEZVVEVYX0xPQ0tfUElfUFJJVkFURSwgMCwgJlRFTl9t
cywgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAg
ICAgfQogICAgICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2Ug
OToKICAgICAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAtMTsKICAgICAg
ICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX0xPQ0tf
UEksIDAsICZURU5fbXMsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYg
KHIpCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGJyZWFrOwogICAg
ICAgICAgICBjYXNlIDEwOgogICAgICAgICAgICAgICAgaWYgKHBhcmVudF9z
bGVlcGluZygpKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ICAgIHRocmVhZF9hY3Rpb24gPSAwOwogICAgICAgICAgICAgICAgICAgIHIg
PSBmdXRleCgmZjEsIEZVVEVYX1VOTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwg
MCk7CiAgICAgICAgICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
bykpOwogICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChwYXJl
bnRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICB9
CiAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgICAgY2FzZSAxMToK
ICAgICAgICAgICAgICAgIGlmIChwYXJlbnRfc2xlZXBpbmcoKSkKICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICB0aHJlYWRfYWN0aW9u
ID0gMDsKICAgICAgICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRF
WF9VTkxPQ0tfUElfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAg
ICAgICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAg
ICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICB9CiAgICAgICAg
ICAgICAgICBicmVhazsKICAgICAgICAgICAgY2FzZSAxMjoKICAgICAgICAg
ICAgICAgIGlmIChwYXJlbnRfc2xlZXBpbmcoKSkKICAgICAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gMDsKICAg
ICAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRF
WF9VTkxPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAg
ICAgICAgIGlmIChyKQogICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICAgICAgfQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAg
YnJlYWs7CiAgICAgICAgICAgIGNhc2UgMTM6CiAgICAgICAgICAgICAgICB0
aHJlYWRfYWN0aW9uID0gLTE7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9XQUlUX0JJVFNFVCwgZjEsIE5VTEwsIE5VTEwsIDB4Myk7
CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMTQ6CiAgICAgICAg
ICAgICAgICB0aHJlYWRfYWN0aW9uID0gLTE7CiAgICAgICAgICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUlUX0JJVFNFVF9QUklWQVRFLCBmMSwg
TlVMTCwgTlVMTCwgMHgzMCk7CiAgICAgICAgICAgICAgICBpZiAocikKICAg
ICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICAgICAgfQogICAgICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAg
IGNhc2UgMTU6CiAgICAgICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gLTE7
CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRF
WF9XQUlUX0JJVFNFVCwgc2htZW0tPmYzLCBOVUxMLCBOVUxMLCAweDMwMCk7
CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMTY6CiAgICAgICAg
ICAgICAgICB0aHJlYWRfYWN0aW9uID0gLTE7CiAgICAgICAgICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9MT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAw
KTsKICAgICAgICAgICAgICAgIGlmIChyKQogICAgICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAg
ICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9VTkxPQ0tfUEksIDAs
IE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKHIpCiAgICAg
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgICAgIH0KICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICBj
YXNlIDE3OgogICAgICAgICAgICAgICAgdGhyZWFkX2FjdGlvbiA9IC0xOwog
ICAgICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfTE9DS19QSV9Q
UklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlm
IChyKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKHBhcmVu
dF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9VTkxPQ0tfUElfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwg
MCk7CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAg
ICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMTg6CiAgICAg
ICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gLTE7CiAgICAgICAgICAgICAg
ICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9MT0NLX1BJLCAwLCBO
VUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlmIChyKQogICAgICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsK
ICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMp
LCBGVVRFWF9VTkxPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAg
ICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZh
aWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAg
dGtpbGwocGFyZW50X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAg
IGJyZWFrOwogICAgICAgICAgICBjYXNlIDE5OgogICAgICAgICAgICAgICAg
dGhyZWFkX2FjdGlvbiA9IC0xOwogICAgICAgICAgICAgICAgYnJlYWs7CiAg
ICAgICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgaW52YWxpZCB0aHJlYWRfYWN0aW9uICVkXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgdGhyZWFkX2Fj
dGlvbik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAg
ICBpZiAobmFub3NsZWVwKCZURU5fbXMsIE5VTEwpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIG5hbm9zbGVl
cCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgIH0K
fQoKc3RhdGljIHZvaWQgd2Z0KGxvbmcgbGluZSkKewogICAgaW50IHI7CiAg
ICBmb3IgKHIgPSAwOyB0aHJlYWRfYWN0aW9uOyArK3IpCiAgICB7CiAgICAg
ICAgaWYgKHIgPiA2MDAwKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJ3YWl0X2Zvcl90aHJlYWQgZnJvbSBsaW5lICVsZCB0aHJl
YWQgbm90IHJlc3BvbmRpbmdcbiIsCiAgICAgICAgICAgICAgICAgICAgbGlu
ZSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGlmICh0aHJl
YWRfYWN0aW9uIDwgMCkKICAgICAgICB7CiAgICAgICAgICAgIHRocmVhZF9h
Y3Rpb24gPSAwOwogICAgICAgIH0KICAgICAgICBpZiAobmFub3NsZWVwKCZU
RU5fbXMsIE5VTEwpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJ3YWl0X2Zvcl90aHJlYWQgZnJvbSBsaW5lICVsZCBuYW5vc2xl
ZXAgZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgIGxpbmUsIHN0
cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAg
fQp9CiNkZWZpbmUgd2FpdF9mb3JfdGhyZWFkKCkgd2Z0KF9fTElORV9fKQoK
LyogQ2hpbGQgcHJvY2VzcyB3YWl0cyBmb3Igc2htZW0tPmNoaWxkX2FjdGlv
biB0byBiZSBub256ZXJvCiAqIChhbmQgZm9yIHNvbWUgYWN0aW9ucyBmb3Ig
dGhlIHBhcmVudCB0byBiZSB3YWl0aW5nIGZvciBpdCksCiAqIGFuZCB0aGVu
IGRvZXMgdGhlIHJlcXVpcmVkIGFjdGlvbi4KICovCnN0YXRpYyB2b2lkIGNo
aWxkKHZvaWQpCnsKICAgIGludCByOwogICAgd2hpbGUgKDEpCiAgICB7CiAg
ICAgICAgc3dpdGNoIChzaG1lbS0+Y2hpbGRfYWN0aW9uKQogICAgICAgIHsK
ICAgICAgICAgICAgY2FzZSAwOgogICAgICAgICAgICBjYXNlIC0xOgogICAg
ICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMzoKICAgICAg
ICAgICAgICAgIGlmIChwYXJlbnRfc2xlZXBpbmcoKSkKICAgICAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9u
ID0gMDsKICAgICAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+
ZjMpLCBGVVRFWF9XQUtFLCAyLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAg
ICAgICAgICAgICBpZiAociAhPSAxKQogICAgICAgICAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAg
ICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICAgICAg
fQogICAgICAgICAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCByZXR1cm5lZCAlZCBpbnN0
ZWFkIG9mIDFcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgICAgICAgICAgfQog
ICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChwYXJlbnRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAg
ICAgICBicmVhazsKICAgICAgICAgICAgY2FzZSA2OgogICAgICAgICAgICAg
ICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IC0xOwogICAgICAgICAgICAgICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FJVCwgc2htZW0tPmYz
LCAmT05FX3NlYywgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICBpZiAocikK
ICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwocGFyZW50X3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAg
ICBjYXNlIDk6CiAgICAgICAgICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9u
ID0gLTE7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMp
LCBGVVRFWF9MT0NLX1BJLCAwLCAmVEVOX21zLCBOVUxMLCAwKTsKICAgICAg
ICAgICAgICAgIGlmIChyKQogICAgICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0
a2lsbChwYXJlbnRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAg
YnJlYWs7CiAgICAgICAgICAgIGNhc2UgMTI6CiAgICAgICAgICAgICAgICBp
ZiAocGFyZW50X3NsZWVwaW5nKCkpCiAgICAgICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDA7CiAgICAg
ICAgICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhf
VU5MT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAg
ICAgICBpZiAocikKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRl
eCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgICAg
IH0KICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGJyZWFrOwog
ICAgICAgICAgICBjYXNlIDE1OgogICAgICAgICAgICAgICAgc2htZW0tPmNo
aWxkX2FjdGlvbiA9IC0xOwogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCYo
c2htZW0tPmYzKSwgRlVURVhfV0FJVF9CSVRTRVQsIHNobWVtLT5mMywgTlVM
TCwgTlVMTCwgMHgzMDApOwogICAgICAgICAgICAgICAgaWYgKHIpCiAgICAg
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgICAgY2Fz
ZSAxNjoKICAgICAgICAgICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSAt
MTsKICAgICAgICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX1dBSVRfQklUU0VULCAwLCBOVUxMLCBOVUxMLCAweDMwMDApOwogICAg
ICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgICAg
IHRraWxsKHBhcmVudF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICAvKiBJdCBpcyBwb3NzaWJsZSB0aGF0IGEgcHJvY2VzcyBzd2l0Y2ggb2Nj
dXJzIGhlcmU6CiAgICAgICAgICAgICAgICAgKiBUaGUgbWFpbiBwcm9ncmFt
IGRvZXMgYSAxMG1zIHdhaXQgdG8gZ2l2ZSB0aGlzIHByb2Nlc3MgdGltZQog
ICAgICAgICAgICAgICAgICogdG8gc2V0IHNobWVtLT5jaGlsZF9hY3Rpb24s
IGJ1dCBvbiBhIGJ1c3kgbWFjaGluZSBpdCBtYXkgbm90CiAgICAgICAgICAg
ICAgICAgKiBnZXQgdG8gcnVuIGFuZCB0aGUgdGVzdCB3aWxsIGZhaWwuIE9m
IGNvdXJzZSBmdXRleGVzIGFyZQogICAgICAgICAgICAgICAgICogZGVzaWdu
ZWQganVzdCB0byBhdm9pZCB0aGlzIHNvcnQgb2YgcmFjZSwgYnV0IHNpbmNl
IHdlIGFyZQogICAgICAgICAgICAgICAgICogdGVzdGluZyBmdXRleGVzIGhl
cmUgd2UgY2FuJ3QgdXNlIG9uZS4KICAgICAgICAgICAgICAgICAqLwogICAg
ICAgICAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDE3OwogICAgICAg
ICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMTc6CiAgICAgICAg
ICAgICAgICBicmVhazsKICAgICAgICAgICAgY2FzZSAxODoKICAgICAgICAg
ICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSAtMTsKICAgICAgICAgICAg
ICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX0xPQ0tfUEksIDAs
IE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKHIpCiAgICAg
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgICAgIHRraWxsKHBhcmVudF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMp
LCBGVVRFWF9VTkxPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAg
ICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZh
aWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgICAgIHRr
aWxsKHBhcmVudF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBi
cmVhazsKICAgICAgICAgICAgY2FzZSAxOToKICAgICAgICAgICAgICAgIHNo
bWVtLT5jaGlsZF9hY3Rpb24gPSAtMTsKICAgICAgICAgICAgICAgIGJyZWFr
OwogICAgICAgICAgICBkZWZhdWx0OgogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGludmFsaWQgY2hpbGRfYWN0aW9uICVk
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc2htZW0t
PmNoaWxkX2FjdGlvbik7CiAgICAgICAgICAgICAgICB0a2lsbChwYXJlbnRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgfQogICAgICAgIGlmIChuYW5vc2xlZXAoJlRFTl9tcywgTlVMTCkpCiAg
ICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgbmFub3NsZWVwIGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgdGtp
bGwocGFyZW50X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgfQogICAgfQp9CgpzdGF0aWMgdm9pZCB3ZmMgKGxvbmcgbGlu
ZSkKewogICAgaW50IHI7CiAgICBmb3IgKHIgPSAwOyBzaG1lbS0+Y2hpbGRf
YWN0aW9uOyArK3IpCiAgICB7CiAgICAgICAgaWYgKHIgPiA2MDAwKQogICAg
ICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJ3YWl0X2Zvcl9j
aGlsZCBmcm9tIGxpbmUgJWxkIGNoaWxkIG5vdCByZXNwb25kaW5nXG4iLAog
ICAgICAgICAgICAgICAgICAgIGxpbmUpOwogICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgIH0KICAgICAgICBpZiAoc2htZW0tPmNoaWxkX2FjdGlvbiA8IDApCiAg
ICAgICAgewogICAgICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gMDsK
ICAgICAgICB9CiAgICAgICAgaWYgKG5hbm9zbGVlcCgmVEVOX21zLCBOVUxM
KSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAid2Fp
dF9mb3JfY2hpbGQgZnJvbSBsaW5lICVsZCBuYW5vc2xlZXAgZmFpbGVkICVz
XG4iLAogICAgICAgICAgICAgICAgICAgIGxpbmUsIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgfQp9CiNkZWZpbmUg
d2FpdF9mb3JfY2hpbGQoKSB3ZmMoX19MSU5FX18pCgppbnQgbWFpbihpbnQg
YXJnYyBfX2F0dHJpYnV0ZV9fICgodW51c2VkKSksIGNoYXIqIGFyZ3ZbXSBf
X2F0dHJpYnV0ZV9fICgodW51c2VkKSkpCnsKICAgIC8qIEdldCBhIGhhbmRs
ZSBvbiBvdXIgc3RhdHVzIGZvciB0aGUgY2hpbGQgdG8gdXNlLiAqLwogICAg
c3RhdHVzID0gZm9wZW4oIi9wcm9jL3NlbGYvc3RhdCIsICJyIik7CiAgICBp
ZiAoIXN0YXR1cykKICAgIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZm9wZW4gZmFpbGVkICVzXG4iLCBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICBleGl0KDEpOwogICAgfQoKICAgIC8qIEFs
bG9jYXRlIHR3byBzaGFyZWQgbWVtb3J5IHBhZ2VzLiAqLwogICAgc2htZW0g
PSAoc3RydWN0IHNoYSAqKW1tYXAoTlVMTCwgMiAqIDQwOTYsIFBST1RfUkVB
RCB8IFBST1RfV1JJVEUsIE1BUF9TSEFSRUQgfCBNQVBfQU5PTllNT1VTLAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLTEsIDApOwogICAgaWYg
KHNobWVtID09IE1BUF9GQUlMRUQpCiAgICB7CiAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIG1tYXAgZmFpbGVkICVzXG4iLCBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICBleGl0KDEpOwogICAgfQog
ICAgLyogUmUtcHJvdGVjdCB0aGUgc2Vjb25kIHRvIGVuc3VyZSBzaG1lbSs0
MDk2IGlzIGludmFsaWQuICovCiAgICBpZiAobXByb3RlY3QoNDA5NiArIChj
aGFyICopc2htZW0sIDQwOTYsIFBST1RfTk9ORSkpCiAgICB7CiAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIG1wcm90ZWN0IGZhaWxlZCAl
c1xuIiwgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgZXhp
dCgxKTsKICAgIH0KICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSAwOwogICAg
dGhyZWFkX2FjdGlvbiA9IDA7CgogICAgLyogR2V0IGFuIGFkZHJlc3MgaW4g
dW5kb2RiIHByaXZhdGUgc3BhY2UgKi8KICAgIEZJTEUgKm1hcHMgPSBmb3Bl
bigiL3Byb2Mvc2VsZi9tYXBzIiwgInIiKTsKICAgIGlmICghbWFwcykKICAg
IHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZm9wZW4g
ZmFpbGVkICVzXG4iLCBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAg
ICAgICBleGl0KDEpOwogICAgfQogICAgY2hhciBidWZmWzEwMjRdOwogICAg
Y2hhciAqIHVwcml2ID0gKGNoYXIgKik4OwogICAgd2hpbGUgKGZnZXRzKGJ1
ZmYsIHNpemVvZihidWZmKSwgbWFwcykpCiAgICB7CiAgICAgICAgc2l6ZV90
IGk7CiAgICAgICAgZm9yIChpID0gMDsgaSA8IHN0cmxlbihidWZmKTsgKytp
KQogICAgICAgIHsKICAgICAgICAgICAgaWYgKCAgIChzdHJuY21wKCJwcmVs
b2FkMSIsIGJ1ZmYgKyBpLCA4KSA9PSAwKQogICAgICAgICAgICAgICAgfHwg
KHN0cm5jbXAoImdkYm1hY3JvLXJlbGVhc2UiLCBidWZmICsgaSwgOCkgPT0g
MCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChzc2NhbmYo
YnVmZiwgIiVseC0iLCAodW5zaWduZWQgbG9uZyopJnVwcml2KSA9PSAxKQog
ICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGJyZWFrOwog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAic3NjYW5mKFwiJXNcIiwgXCIlJWx4LVwiKSAhPSAxIiwgYnVmZik7CiAg
ICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICB9
CiAgICBpZiAodXByaXYgPT0gKGNoYXIgKik4KQogICAgewogICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQ291bGQgbm90IGZpbmQgdW5kb2RiIHByaXZhdGUg
c3BhY2VcbiIpOwogICAgICAgIC8qIG5vdCBmYXRhbCAqLwogICAgfQoKICAg
IC8qIENyZWF0ZSBhIGNoaWxkIHRocmVhZCBhbmQgYSBjaGlsZCBwcm9jZXNz
LiAqLwogICAgcGFyZW50X3BpZCA9IGdldHRpZCgpOwogICAgdGhyZWFkX3Bp
ZCA9IGNsb25lKHRocmVhZCwgdGhyZWFkX3N0YWNrLCBDTE9ORV9WTSB8IENM
T05FX1RIUkVBRCB8IENMT05FX1NJR0hBTkQsCiAgICAgICAgICAgICAgICAg
ICAgICAgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCk7CiAgICBpZiAodGhyZWFk
X3BpZCA8IDApCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIGNsb25lIGZhaWxlZCAlc1xuIiwgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIGNoaWxkX3Bp
ZCA9IGZvcmsoKTsKICAgIGlmIChjaGlsZF9waWQgPCAwKQogICAgewogICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmb3JrIGZhaWxlZCAl
c1xuIiwgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgZXhp
dCgxKTsKICAgIH0KICAgIGVsc2UgaWYgKGNoaWxkX3BpZCA9PSAwKQogICAg
ewogICAgICAgIGNoaWxkKCk7CiAgICB9CiAgICAvKiBPdGhlcndpc2UgY29u
dGludWUgd2l0aCBwYXJlbnQgYmVpbmcgZGVidWdnZWQuICovCgogICAgaW50
IHIgPSBmdXRleChOVUxMLCBGVVRFWF9XQUlULCAwLCBOVUxMLCBOVUxMLCAw
KTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAg
IHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
V0FJVCB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2Yg
JXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAgICB9CiAgICByID0g
ZnV0ZXgoTlVMTCwgRlVURVhfV0FJVF9QUklWQVRFLCAwLCBOVUxMLCBOVUxM
LCAwKTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkK
ICAgIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FJVF9QUklWQVRFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAg
IH0KICAgIHIgPSBmdXRleCgoaW50ICopOCwgRlVURVhfV0FJVCwgMCwgTlVM
TCwgTlVMTCwgMCk7CiAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVG
QVVMVCkpCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBSVQgd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBp
bnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICBleGl0KDEpOwogICAg
fQogICAgciA9IGZ1dGV4KChpbnQgKik4LCBGVVRFWF9XQUlUX1BSSVZBVEUs
IDAsIE5VTEwsIE5VTEwsIDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJu
byAhPSBFRkFVTFQpKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9XQUlUX1BSSVZBVEUgd2l0aCBiYWQgYWRkcmVz
cyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxU
KSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICBleGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4KChpbnQgKil1cHJpdiwg
RlVURVhfV0FJVCwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICBpZiAoKHIgPj0g
MCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICB7CiAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVQgd2l0aCBiYWQgYWRk
cmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZB
VUxUKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICBleGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4KChpbnQgKil1cHJp
diwgRlVURVhfV0FJVF9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAg
IGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgIHsKICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJVF9Q
UklWQVRFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIHIg
PSBmdXRleCgoaW50ICopKDEgKyAoY2hhciAqKSZmMSksIEZVVEVYX1dBSVQs
IDAsIE5VTEwsIE5VTEwsIDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJu
byAhPSBFSU5WQUwpKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9XQUlUIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNz
IHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwp
KTsKICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
IGV4aXQoMSk7CiAgICB9CiAgICByID0gZnV0ZXgoKGludCAqKSgxICsgKGNo
YXIgKikmZjEpLCBGVVRFWF9XQUlUX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEws
IDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQog
ICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9XQUlUX1BSSVZBVEUgd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJu
ZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgx
KTsKICAgIH0KICAgIHIgPSBmdXRleCgoaW50ICopKDEgKyAoY2hhciAqKSYo
c2htZW0tPmYzKSksIEZVVEVYX1dBSVQsIDAsIE5VTEwsIE5VTEwsIDApOwog
ICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgewog
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUlU
IHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQg
b2YgJXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAgICB9CiAgICBy
ID0gZnV0ZXgoKGludCAqKSg0MDk0ICsgKGNoYXIgKikmKHNobWVtLT5mMykp
LCBGVVRFWF9XQUlULCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgIHsKICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJVCB3aXRoIG1pc2Fs
aWduZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAog
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3Ry
ZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICBleGl0KDEpOwogICAgfQogICAgZjEgPSAwOwogICAg
ciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVCwgMSwgTlVMTCwgTlVMTCwgMCk7
CiAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVXT1VMREJMT0NLKSkK
ICAgIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FJVCB3aXRoICp1YWRkciAhPSB2YWwgcmV0dXJuZWQgJXMgaW5zdGVh
ZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVXT1VMREJMT0NLKSk7CiAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICBleGl0KDEpOwogICAg
fQogICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVF9QUklWQVRFLCAxLCBO
VUxMLCBOVUxMLCAwKTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0g
RVdPVUxEQkxPQ0spKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9XQUlUX1BSSVZBVEUgd2l0aCAqdWFkZHIgIT0g
dmFsIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFV09V
TERCTE9DSykpOwogICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIHNobWVtLT5mMyA9IDA7CiAg
ICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUlULCAxLCBOVUxM
LCBOVUxMLCAwKTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVdP
VUxEQkxPQ0spKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUlUIHdpdGggKnVhZGRyICE9IHZhbCByZXR1cm5l
ZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRVdPVUxEQkxPQ0spKTsK
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4
aXQoMSk7CiAgICB9CiAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUlULCAw
LCAoc3RydWN0IHRpbWVzcGVjICopOCwgTlVMTCwgMCk7CiAgICBpZiAoKHIg
Pj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICB7CiAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVQgd2l0aCBiYWQg
dGltZW91dCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RUZBVUxUKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICBleGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4KCZmMSwgRlVU
RVhfV0FJVF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVjICopOCwgTlVM
TCwgMCk7CiAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkp
CiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBSVRfUFJJVkFURSB3aXRoIGJhZCB0aW1lb3V0IHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAg
ICB9CiAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUlULCAw
LCAoc3RydWN0IHRpbWVzcGVjICopOCwgTlVMTCwgMCk7CiAgICBpZiAoKHIg
Pj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICB7CiAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVQgd2l0aCBiYWQg
dGltZW91dCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RUZBVUxUKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICBleGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4KCZmMSwgRlVU
RVhfV0FJVCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKXVwcml2LCBOVUxMLCAw
KTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAg
IHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
V0FJVCB3aXRoIGJhZCB0aW1lb3V0IHJldHVybmVkICVzIGluc3RlYWQgb2Yg
JXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAgICB9CiAgICByID0g
ZnV0ZXgoJmYxLCBGVVRFWF9XQUlUX1BSSVZBVEUsIDAsIChzdHJ1Y3QgdGlt
ZXNwZWMgKil1cHJpdiwgTlVMTCwgMCk7CiAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVGQVVMVCkpCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVRfUFJJVkFURSB3aXRoIGJhZCB0
aW1lb3V0IHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihF
RkFVTFQpKTsKICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgIGV4aXQoMSk7CiAgICB9CiAgICByID0gZnV0ZXgoJihzaG1lbS0+
ZjMpLCBGVVRFWF9XQUlULCAwLCAoc3RydWN0IHRpbWVzcGVjICopdXByaXYs
IE5VTEwsIDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFV
TFQpKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUlUIHdpdGggYmFkIHRpbWVvdXQgcmV0dXJuZWQgJXMgaW5z
dGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0K
ICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBSVQsIDAsICZURU5fbXMsIE5V
TEwsIDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFVElNRURP
VVQpKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUlUIHdoaWNoIHNob3VsZCB0aW1lIG91dCByZXR1cm5lZCAl
cyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRVRJTUVET1VUKSk7CiAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICBleGl0KDEp
OwogICAgfQogICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVF9QUklWQVRF
LCAwLCAmVEVOX21zLCBOVUxMLCAwKTsKICAgIGlmICgociA+PSAwKSB8fCAo
ZXJybm8gIT0gRVRJTUVET1VUKSkKICAgIHsKICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJVF9QUklWQVRFIHdoaWNoIHNo
b3VsZCB0aW1lIG91dCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAog
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3Ry
ZXJyb3IoRVRJTUVET1VUKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICBleGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4
KCYoc2htZW0tPmYzKSwgRlVURVhfV0FJVCwgMCwgJlRFTl9tcywgTlVMTCwg
MCk7CiAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVUSU1FRE9VVCkp
CiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBSVQgd2hpY2ggc2hvdWxkIHRpbWUgb3V0IHJldHVybmVkICVzIGlu
c3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFVElNRURPVVQpKTsKICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAg
ICB9CiAgICB0aHJlYWRfYWN0aW9uID0gMTsKICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1dBSVQsIDAsICZPTkVfc2VjLCAmZjIsIDApOwogICAgaWYgKHIp
CiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubykpOwogICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIHRocmVhZF9hY3Rp
b24gPSAxOwogICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVCwgMCwgJk9O
RV9zZWMsIE5VTEwsIDApOwogICAgaWYgKHIpCiAgICB7CiAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwog
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhp
dCgxKTsKICAgIH0KICAgIHRocmVhZF9hY3Rpb24gPSAxOwogICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfV0FJVCwgMCwgJk9ORV9zZWMsIChpbnQgKik4LCAw
KTsKICAgIGlmIChyKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAgICB9CiAg
ICB0aHJlYWRfYWN0aW9uID0gMTsKICAgIHIgPSBmdXRleCgmZjEsIEZVVEVY
X1dBSVQsIDAsICZPTkVfc2VjLCAoaW50ICopdXByaXYsIDApOwogICAgaWYg
KHIpCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIHRocmVhZF9h
Y3Rpb24gPSAyOwogICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVF9QUklW
QVRFLCAwLCAmT05FX3NlYywgTlVMTCwgMSk7CiAgICBpZiAocikKICAgIHsK
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICBleGl0KDEpOwogICAgfQogICAgdGhyZWFkX2FjdGlvbiA9IDM7
CiAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUlULCAwLCAm
T05FX3NlYywgTlVMTCwgMik7CiAgICBpZiAocikKICAgIHsKICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICBl
eGl0KDEpOwogICAgfQogICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDM7CiAg
ICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUlULCAwLCAmT05F
X3NlYywgTlVMTCwgMyk7CiAgICBpZiAocikKICAgIHsKICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICBleGl0
KDEpOwogICAgfQogICAgciA9IGZ1dGV4KE5VTEwsIEZVVEVYX1dBS0UsIDAs
IE5VTEwsIE5VTEwsIDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJubyAh
PSBFRkFVTFQpKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQg
JXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsK
ICAgIH0KICAgIC8qIEN1cmlvdXNseSwgdGhlIGtlcm5lbCByZXR1cm5zIDAg
b24gdGhpcyBjYWxsLCBhbHRob3VnaCBubyBwcm9jZXNzIGNhbiBiZQogICAg
ICogd2FrZW5lZCwgc2luY2UgZnV0ZXgoTlVMTCwgRlVURVhfV0FJVF9QUklW
QVRFLCAuLi4pIGZhaWxzLgogICAgICovCiAgICByID0gZnV0ZXgoTlVMTCwg
RlVURVhfV0FLRV9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgIGlm
IChyKQogICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7CiAgICB9CiAgICBlbHNlCiAg
ICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJGVVRFWF9XQUtFX1BSSVZB
VEUgd2l0aCBiYWQgYWRkcmVzcyBzdWNjZWVkc1xuIik7CiAgICB9CiAgICBy
ID0gZnV0ZXgoKGludCAqKTgsIEZVVEVYX1dBS0UsIDAsIE5VTEwsIE5VTEws
IDApOwogICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQog
ICAgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9XQUtFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIHIg
PSBmdXRleCgoaW50ICopOCwgRlVURVhfV0FLRV9QUklWQVRFLCAwLCBOVUxM
LCBOVUxMLCAwKTsKICAgIGlmIChyKQogICAgewogICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQoMSk7
CiAgICB9CiAgICByID0gZnV0ZXgoKGludCAqKXVwcml2LCBGVVRFWF9XQUtF
LCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJy
bm8gIT0gRUZBVUxUKSkKICAgIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfV0FLRSB3aXRoIGJhZCBhZGRyZXNzIHJldHVy
bmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgIGV4aXQo
MSk7CiAgICB9CiAgICByID0gZnV0ZXgoKGludCAqKXVwcml2LCBGVVRFWF9X
QUtFX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDApOwogICAgaWYgKHIpCiAg
ICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgZXhpdCgxKTsKICAgIH0KICAgIHIgPSBmdXRleCgoaW50
ICopKC04KSwgRlVURVhfV0FLRSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICBp
ZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICB7CiAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0Ugd2l0
aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAog
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3Ry
ZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICBleGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4KChp
bnQgKikoLTgpLCBGVVRFWF9XQUtFX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEws
IDApOwojaWZkZWYgX19pMzg2X18KICAgIGlmIChyKQogICAgewogICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
IGV4aXQoMSk7CiAgICB9CiNlbHNlCiAgICBpZiAoKHIgPj0gMCkgfHwgKGVy
cm5vICE9IEVGQVVMVCkpCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfUFJJVkFURSB3aXRoIGJhZCBhZGRy
ZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFV
TFQpKTsKICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgIGV4aXQoMSk7CiAgICB9CiNlbmRpZgogICAgciA9IGZ1dGV4KChpbnQg
KikoMSArIChjaGFyICopJmYxKSwgRlVURVhfV0FLRSwgMCwgTlVMTCwgTlVM
TCwgMCk7CiAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkp
CiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBS0Ugd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAg
IH0KICAgIHIgPSBmdXRleCgoaW50ICopKDEgKyAoY2hhciAqKSZmMSksIEZV
VEVYX1dBS0VfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICBpZiAo
KHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICB7CiAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IHdpdGggbWlzYWxp
Z25lZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJl
cnJvcihFSU5WQUwpKTsKICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgIGV4aXQoMSk7CiAgICB9CiAgICByID0gZnV0ZXgoKGlu
dCAqKSgxICsgKGNoYXIgKikmKHNobWVtLT5mMykpLCBGVVRFWF9XQUtFLCAw
LCBOVUxMLCBOVUxMLCAwKTsKICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8g
IT0gRUlOVkFMKSkKICAgIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfV0FLRSB3aXRoIG1pc2FsaWduZWQgYWRkcmVzcyBy
ZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7
CiAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICBl
eGl0KDEpOwogICAgfQogICAgciA9IGZ1dGV4KChpbnQgKikoNDA5NCArIChj
aGFyICopJihzaG1lbS0+ZjMpKSwgRlVURVhfV0FLRSwgMCwgTlVMTCwgTlVM
TCwgMCk7CiAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkp
CiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBS0Ugd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgZXhpdCgxKTsKICAg
IH0KICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBS0UsIDMsIChzdHJ1Y3Qg
dGltZXNwZWMgKil1cHJpdiwgKGludCAqKXVwcml2LCAwKTsKICAgIGlmIChy
KQogICAgewogICAgICAgIGlmIChyIDwgMCkKICAgICAgICB7CiAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGVs
c2UKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFIHJldHVybmVkICVkIHdoZW4gbm8gcHJvY2Vz
c2VzIHRvIHdha2VcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHIpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgIH0KICAgIHIgPSBm
dXRleCgmZjEsIEZVVEVYX1dBS0VfUFJJVkFURSwgMywgKHN0cnVjdCB0aW1l
c3BlYyAqKXVwcml2LCAoaW50ICopdXByaXYsIDIpOwogICAgaWYgKHIpCiAg
ICB7CiAgICAgICAgaWYgKHIgPCAwKQogICAgICAgIHsKICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgZWxzZQog
ICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBS0VfUFJJVkFURSByZXR1cm5lZCAlZCB3aGVuIG5vIHBy
b2Nlc3NlcyB0byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICB9CiAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFLCAzLCAoc3RydWN0
IHRpbWVzcGVjICopdXByaXYsIChpbnQgKil1cHJpdiwgMSk7CiAgICBpZiAo
cikKICAgIHsKICAgICAgICBpZiAociA8IDApCiAgICAgICAgewogICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICBl
bHNlCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1cm5lZCAlZCB3aGVuIG5vIHByb2Nl
c3NlcyB0byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICB9CiAgICB0aHJl
YWRfYWN0aW9uID0gNDsKICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgciA9
IGZ1dGV4KCZmMSwgRlVURVhfV0FLRSwgMywgKHN0cnVjdCB0aW1lc3BlYyAq
KXVwcml2LCAoaW50ICopdXByaXYsIDMpOwogICAgaWYgKHIgIT0gMSkKICAg
IHsKICAgICAgICBpZiAociA8IDApCiAgICAgICAgewogICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
bykpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICBlbHNlCiAg
ICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FLRSByZXR1cm5lZCAlZCB3aGVuIDEgcHJvY2VzcyB0byB3
YWtlXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICB9CiAgICB9CiAgICB0aHJlYWRfYWN0aW9u
ID0gNTsKICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfV0FLRV9QUklWQVRFLCAzLCAoc3RydWN0IHRpbWVzcGVjICop
dXByaXYsIChpbnQgKil1cHJpdiwgNCk7CiAgICBpZiAociAhPSAxKQogICAg
ewogICAgICAgIGlmIChyIDwgMCkKICAgICAgICB7CiAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGVsc2UKICAg
ICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUtFX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiAxIHByb2Nl
c3MgdG8gd2FrZVxuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgfQogICAgdGhyZWFk
X2FjdGlvbiA9IDY7CiAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgIHIgPSBm
dXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1dBS0UsIDMsIChzdHJ1Y3QgdGlt
ZXNwZWMgKil1cHJpdiwgKGludCAqKXVwcml2LCA1KTsKICAgIGlmIChyICE9
IDEpCiAgICB7CiAgICAgICAgaWYgKHIgPCAwKQogICAgICAgIHsKICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxl
ZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAg
ZWxzZQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0UgcmV0dXJuZWQgJWQgd2hlbiAxIHByb2Nl
c3MgdG8gd2FrZVxuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgfQogICAgc2htZW0t
PmNoaWxkX2FjdGlvbiA9IDY7CiAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMywgKHN0cnVj
dCB0aW1lc3BlYyAqKXVwcml2LCAoaW50ICopdXByaXYsIDYpOwogICAgaWYg
KHIgIT0gMSkKICAgIHsKICAgICAgICBpZiAociA8IDApCiAgICAgICAgewog
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXgg
ZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubykpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAg
ICAgICBlbHNlCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1cm5lZCAlZCB3aGVuIDEg
cHJvY2VzcyB0byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICB9CiAgICB0
aHJlYWRfYWN0aW9uID0gNjsKICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAg
c2htZW0tPmNoaWxkX2FjdGlvbiA9IDY7CiAgICB3YWl0X2Zvcl9jaGlsZCgp
OwogICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMywg
KHN0cnVjdCB0aW1lc3BlYyAqKXVwcml2LCAoaW50ICopdXByaXYsIDcpOwog
ICAgaWYgKHIgIT0gMikKICAgIHsKICAgICAgICBpZiAociA8IDApCiAgICAg
ICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAg
IH0KICAgICAgICBlbHNlCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1cm5lZCAlZCB3
aGVuIDIgcHJvY2Vzc2VzIHRvIHdha2VcbiIsCiAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAg
IH0KICAgIHRocmVhZF9hY3Rpb24gPSA2OwogICAgd2FpdF9mb3JfdGhyZWFk
KCk7CiAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgIHdhaXRfZm9y
X2NoaWxkKCk7CiAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9X
QUtFLCAxLCAoc3RydWN0IHRpbWVzcGVjICopdXByaXYsIChpbnQgKil1cHJp
diwgOCk7CiAgICBpZiAociAhPSAxKQogICAgewogICAgICAgIGlmIChyIDwg
MCkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgfQogICAgICAgIGVsc2UKICAgICAgICB7CiAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFIHJldHVy
bmVkICVkIHdoZW4gb25seSB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgIH0KICAgIH0KICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX1dBS0UsIDAsIE5VTEwsIE5VTEwsIDkpOwogICAgaWYgKHIpCiAgICB7
CiAgICAgICAgaWYgKHIgPCAwKQogICAgICAgIHsKICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgZWxzZQogICAg
ICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJGVVRFWF9XQUtF
IHdpdGggemVybyB2YWwgd29rZSBhIHByb2Nlc3NcbiIpOwogICAgICAgICAg
ICAvKiBJdCBpc24ndCBjbGVhciB3aGV0aGVyIHRoaXMgaXMgYSBidWcgaW4g
dGhlIGtlcm5lbCBvciB0aGUKICAgICAgICAgICAgICogbWFudWFsIHBhZ2Us
IHdoaWNoIHNheXMgIndha2VzIGF0IG1vc3QgdmFsIHByb2Nlc3NlcyIuCiAg
ICAgICAgICAgICAqLwogICAgICAgIH0KICAgIH0gZWxzZSB7CiAgICAgICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMSwgTlVMTCwg
TlVMTCwgMTApOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FL
RSByZXR1cm5lZCAlZCB3aGVuIG9ubHkgd2FraW5nIG9uZSBwcm9jZXNzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAg
IH0KICAgIHRocmVhZF9hY3Rpb24gPSA2OwogICAgd2FpdF9mb3JfdGhyZWFk
KCk7CiAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgIHdhaXRfZm9y
X2NoaWxkKCk7CiAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9X
QUtFLCAtMSwgTlVMTCwgTlVMTCwgMTEpOwogICAgaWYgKHIpCiAgICB7CiAg
ICAgICAgaWYgKHIgPCAwKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsK
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgZWxzZQogICAgICAg
IHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJGVVRFWF9XQUtFIHdp
dGggbmVnYXRpdmUgdmFsIHdva2UgYSBwcm9jZXNzXG4iKTsKICAgICAgICAg
ICAgLyogSXQgaXNuJ3QgY2xlYXIgd2hldGhlciB0aGlzIGlzIGEgYnVnIGlu
IHRoZSBrZXJuZWwgb3IgdGhlCiAgICAgICAgICAgICAqIG1hbnVhbCBwYWdl
LCB3aGljaCBzYXlzICJ3YWtlcyBhdCBtb3N0IHZhbCBwcm9jZXNzZXMiLgog
ICAgICAgICAgICAgKi8KICAgICAgICB9CiAgICB9IGVsc2UgewogICAgICAg
IHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1dBS0UsIDEsIE5VTEws
IE5VTEwsIDEyKTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0UgcmV0dXJuZWQgJWQgd2hlbiBvbmx5IHdha2luZyBvbmUgcHJvY2Vzc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAg
ICB9CiAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFLCAx
LCBOVUxMLCBOVUxMLCAxMyk7CiAgICBpZiAociAhPSAxKQogICAgewogICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGVsc2UKICAgICAgICB7
CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9XQUtFIHJldHVybmVkICVkIHdoZW4gb25seSB3YWtpbmcgb25lIHByb2Nl
c3NcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgIH0KICAgIH0KICAgIC8qIE5vdGUgdGhlIG1h
biBwYWdlIHNheXMgdGhhdCB0aGUgYXJnIDUgKHRpbWVvdXQpIGlzIGlnbm9y
ZWQgZm9yCiAgICAgKiBGVVRFWF9SRVFVRVVFIGFuZCBGVVRFWF9DTVBfUkVR
VUVVRSwgYnV0IHRoZSBrZXJuZWwgZG9lcyB1c2UgaXQgYXMKICAgICAqIHRo
ZSBtYXhpbXVtIG51bWJlciBvZiBwcm9jZXNzZXMgdG8gcmVxdWV1ZS4gSG93
ZXZlciBpZiBpdCBpcyAwLCB0aGUKICAgICAqIGtlcm5lbCBzdGlsbCByZXF1
ZXVlcyBvbmUgcHJvY2Vzcy4KICAgICAqIEFsc28gdGhlIG1hbiBwYWdlIHNh
eXMgaXQgcmV0dXJucyB0aGUgbnVtYmVyIG9mIHByb2Nlc3NlcyB3b2tlbiB1
cCwKICAgICAqIGJ1dCBhY3R1YWxseSBpdCByZXR1cm5zIHRoZSBudW1iZXIg
b2YgcHJvY2Vzc2VzIHdva2VuIG9yIHJlcXVldWVkLgogICAgICovCiAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAmZjIsIDAp
OwogICAgaWYgKChyIDwgMCkgJiYgKGVycm5vID09IEVOT1NZUykpCiAgICB7
CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJGVVRFWF9SRVFVRVVFIG5vdCBz
dXBwb3J0ZWQgaW4gdGhpcyBrZXJuZWxcbiIpOwogICAgICAgIC8qIG5vdCBm
YXRhbCAqLwogICAgfQogICAgZWxzZQogICAgewogICAgICAgIGlmIChyKQog
ICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1JFUVVFVUUgcmV0dXJuZWQgJWQgd2hlbiBubyBwcm9jZXNz
IHRvIHdha2VcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1JFUVVFVUVf
UFJJVkFURSwgMSwgTlVMTCwgJmYyLCAxKTsKICAgICAgICBpZiAocikKICAg
ICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9SRVFVRVVFX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiBubyBw
cm9jZXNzIHRvIHdha2VcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyks
IEZVVEVYX1JFUVVFVUUsIDEsIE5VTEwsICYoc2htZW0tPmY0KSwgMik7CiAg
ICAgICAgaWYgKHIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDAp
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAg
ZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAlZCB3
aGVuIG5vIHByb2Nlc3MgdG8gd2FrZVxuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KE5VTEws
IEZVVEVYX1JFUVVFVUUsIDEsIE5VTEwsICZmMiwgMyk7CiAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JF
UVVFVUUgd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9m
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoTlVMTCwgRlVURVhfUkVRVUVV
RV9QUklWQVRFLCAxLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYyLCA0KTsK
ICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1JFUVVFVUUsIDEsIE5VTEwsIE5VTEwsIDUpOwogICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9S
RVFVRVVFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfUkVRVUVV
RV9QUklWQVRFLCAxLCBOVUxMLCBOVUxMLCA2KTsKICAgICAgICBpZiAocikK
ICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgfQogICAgICAgIHIgPSBmdXRleCgoaW50ICopdXByaXYsIEZVVEVY
X1JFUVVFVUUsIDEsIE5VTEwsICZmMiwgNyk7CiAgICAgICAgaWYgKChyID49
IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUUg
d2l0aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4i
LAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
byksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAg
IH0KICAgICAgICByID0gZnV0ZXgoKGludCAqKTgsIEZVVEVYX1JFUVVFVUVf
UFJJVkFURSwgMSwgTlVMTCwgJmYyLCA4KTsKICAgICAgICBpZiAocikKICAg
ICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgfQogICAgICAgIHIgPSBmdXRleCgoaW50ICopOCwgRlVURVhfUkVRVUVV
RSwgMSwgTlVMTCwgJmYyLCA5KTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgewogICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfUkVRVUVVRSB3aXRoIGJh
ZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3Ry
ZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAg
ICAgIHIgPSBmdXRleCgoaW50ICopdXByaXYsIEZVVEVYX1JFUVVFVUVfUFJJ
VkFURSwgMSwgTlVMTCwgJmYyLCAxMCk7CiAgICAgICAgaWYgKHIpCiAgICAg
ICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAg
IH0KICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFLCAxLCBO
VUxMLCAoaW50ICopOCwgMTEpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAo
ZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHdpdGggYmFk
IGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJl
cnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAg
ICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfUkVRVUVVRV9QUklWQVRFLCAxLCBO
VUxMLCAoaW50ICopOCwgMTIpOwogICAgICAgIGlmIChyKQogICAgICAgIHsK
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfUkVRVUVVRSwgMSwgTlVMTCwg
KGludCAqKXVwcml2LCAxMyk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChl
cnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUUgd2l0aCBiYWQg
YWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVy
cm9yKEVGQVVMVCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAg
ICByID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFX1BSSVZBVEUsIDEsIE5V
TEwsIChpbnQgKil1cHJpdiwgMTQpOwogICAgICAgIGlmIChyKQogICAgICAg
IHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9
CiAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoMSArIChjaGFyICopJmYxKSwg
RlVURVhfUkVRVUVVRSwgMSwgTlVMTCwgJmYyLCAxNSk7CiAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JF
UVVFVUUgd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5z
dGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoMSAr
IChjaGFyICopJmYxKSwgRlVURVhfUkVRVUVVRV9QUklWQVRFLCAxLCBOVUxM
LCAmZjIsIDE2KTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9
IEVJTlZBTCkpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfUkVRVUVVRV9QUklWQVRFIHdpdGggbWlz
YWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
fQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1JFUVVFVUUsIDEsIE5V
TEwsIChpbnQgKikoMSArIChjaGFyICopJmYxKSwgMTcpOwogICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgICAgICB7CiAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9S
RVFVRVVFIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVzIGlu
c3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVY
X1JFUVVFVUVfUFJJVkFURSwgMSwgTlVMTCwgKGludCAqKSgxICsgKGNoYXIg
KikmZjEpLCAxOCk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAh
PSBFSU5WQUwpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUVfUFJJVkFURSB3aXRoIG1p
c2FsaWduZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4i
LAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
byksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAg
IH0KICAgICAgICByID0gZnV0ZXgoKGludCAqKSgxICsgKGNoYXIgKikmKHNo
bWVtLT5mMykpLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAmZjIsIDE5KTsK
ICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAg
ICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfUkVRVUVVRSB3aXRoIG1pc2FsaWduZWQgYWRkcmVzcyByZXR1
cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkp
OwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAoaW50ICopKDEgKyAoY2hh
ciAqKSYoc2htZW0tPmYzKSksIDIwKTsKICAgICAgICBpZiAoKHIgPj0gMCkg
fHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICAgICAgewogICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfUkVRVUVVRSB3aXRo
IG1pc2FsaWduZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgIH0KICAgICAgICByID0gZnV0ZXgoKGludCAqKSg0MDk0ICsgKGNoYXIg
KikmKHNobWVtLT5mMykpLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAmZjIs
IDIxKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZB
TCkpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfUkVRVUVVRSB3aXRoIG1pc2FsaWduZWQgYWRkcmVz
cyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJ
TlZBTCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0g
ZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAoaW50ICopKDQw
OTQgKyAoY2hhciAqKSYoc2htZW0tPmYzKSksIDIyKTsKICAgICAgICBpZiAo
KHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICAgICAgewogICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfUkVR
VUVVRSB3aXRoIG1pc2FsaWduZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0
ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0
KDEpOwogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsKICAg
ICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJmYx
LCBGVVRFWF9SRVFVRVVFLCAwLCBOVUxMLCAmZjIsIDIzKTsKICAgICAgICBp
ZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUUgcmV0dXJuZWQgJWQgd2hl
biByZXF1ZXVlaW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgfQogICAgICAgIGVsc2UKICAgICAgICB7CiAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiRlVURVhfUkVRVUVVRSByZXR1
cm5zIDEgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2VzIGJ1dCByZXF1ZXVlaW5n
IG9uZVxuIik7CiAgICAgICAgICAgIC8qIFByb2JhYmx5IGEgbWFuIHBhZ2Ug
ZXJyb3IuICovCiAgICAgICAgfQogICAgICAgIC8qIFdlIHdva2Ugbm9uZSwg
c28gb25lIHNob3VsZCBiZSByZXF1ZXVlZCBvbiBmMi4gKi8KICAgICAgICBy
ID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFLCAxLCBOVUxMLCBOVUxMLCAyNCk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFIHJldHVybmVk
ICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0
aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFX1BSSVZBVEUsIDAsIE5VTEws
ICZmMiwgMjUpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfUkVR
VUVVRV9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gcmVxdWV1ZWluZyBvbmUg
cHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICB9CiAgICAgICAgLyogV2Ugd29rZSBub25lLCBzbyBvbmUgc2hvdWxk
IGJlIHJlcXVldWVkIG9uIGYyLiAqLwogICAgICAgIHIgPSBmdXRleCgmZjIs
IEZVVEVYX1dBS0VfUFJJVkFURSwgMSwgTlVMTCwgTlVMTCwgMjYpOwogICAg
ICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8
IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9QUklWQVRFIHJldHVy
bmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRf
YWN0aW9uID0gNDsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAg
ICByID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAmZjIs
IDI3KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAg
ICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUUg
cmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRo
cmVhZF9hY3Rpb24gPSA1OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwog
ICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1JFUVVFVUVfUFJJVkFURSwg
MSwgTlVMTCwgJmYyLCAyOCk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9SRVFVRVVFX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcg
b25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0OwogICAgICAg
IHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjEsIEZV
VEVYX1JFUVVFVUUsIDIsIE5VTEwsICZmMiwgMjkpOwogICAgICAgIGlmIChy
ICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVuIHdh
a2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDU7CiAg
ICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfUkVRVUVVRV9QUklWQVRFLCAyLCBOVUxMLCAmZjIsIDMwKTsK
ICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYg
KHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUVfUFJJVkFU
RSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAg
dGhyZWFkX2FjdGlvbiA9IDQ7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7
CiAgICAgICAgLyogUmVxdWV1ZSB0byBzYW1lIGZ1dGV4IGlzIGFsbG93ZWQu
ICovCiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfUkVRVUVVRSwgMCwg
TlVMTCwgJmYxLCAzMSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7
CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZh
aWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9SRVFVRVVFIHJldHVybmVkICVkIHdoZW4gcmVxdWV1ZWluZyBvbmUgcHJv
Y2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRSwgMSwgTlVM
TCwgTlVMTCwgMCk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAg
ICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxl
ZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9X
QUtFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAg
ICB0aHJlYWRfYWN0aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQo
KTsKICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFX1BSSVZB
VEUsIDAsIE5VTEwsICZmMSwgMzIpOwogICAgICAgIGlmIChyICE9IDEpCiAg
ICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfUkVRVUVVRV9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gcmVx
dWV1ZWluZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVU
RVhfV0FLRV9QUklWQVRFLCAxLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICBp
ZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfUFJJVkFURSByZXR1cm5lZCAl
ZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlv
biA9IDQ7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9
IGZ1dGV4KCZmMSwgRlVURVhfUkVRVUVVRSwgMSwgTlVMTCwgJmYxLCAzMyk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHJldHVy
bmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRf
YWN0aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAg
ICByID0gZnV0ZXgoJmYxLCBGVVRFWF9SRVFVRVVFX1BSSVZBVEUsIDEsIE5V
TEwsICZmMSwgMzQpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewog
ICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWls
ZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
UkVRVUVVRV9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBw
cm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsKICAgICAgICB3YWl0
X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9S
RVFVRVVFLCAyLCBOVUxMLCAmZjEsIDM1KTsKICAgICAgICBpZiAociAhPSAx
KQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1JFUVVFVUUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcg
b25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA1OwogICAgICAg
IHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjEsIEZV
VEVYX1JFUVVFVUVfUFJJVkFURSwgMiwgTlVMTCwgJmYxLCAzNik7CiAgICAg
ICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwg
MCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAg
ICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFX1BSSVZBVEUgcmV0
dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVh
ZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAg
ICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1JFUVVFVUUsIDAs
IE5VTEwsICYoc2htZW0tPmY0KSwgMzcpOwogICAgICAgIGlmIChyICE9IDEp
CiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVuIHJlcXVldWVp
bmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCks
IEZVVEVYX1dBS0UsIDEsIE5VTEwsIE5VTEwsIDM4KTsKICAgICAgICBpZiAo
ciAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIGZ1dGV4IHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9u
ZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3
YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+
ZjMpLCBGVVRFWF9SRVFVRVVFLCAxLCBOVUxMLCAmKHNobWVtLT5mNCksIDM5
KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAg
aWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVFVUUgcmV0
dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVh
ZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAg
ICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1JFUVVFVUUsIDIs
IE5VTEwsICYoc2htZW0tPmY0KSwgNDApOwogICAgICAgIGlmIChyICE9IDEp
CiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBv
bmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAg
d2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0t
PmYzKSwgRlVURVhfUkVRVUVVRSwgMCwgTlVMTCwgJihzaG1lbS0+ZjMpLCA0
MSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAg
IGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHJl
dHVybmVkICVkIHdoZW4gcmVxdWV1ZWluZyBvbmUgcHJvY2Vzc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMSwgTlVMTCwg
TlVMTCwgNDIpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FL
RSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAg
dGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7
CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfUkVRVUVV
RSwgMSwgTlVMTCwgJihzaG1lbS0+ZjMpLCA0Myk7CiAgICAgICAgaWYgKHIg
IT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHJldHVybmVkICVkIHdoZW4gd2Fr
aW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAg
ICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJihz
aG1lbS0+ZjMpLCBGVVRFWF9SRVFVRVVFLCAyLCBOVUxMLCAmKHNobWVtLT5m
MyksIDQ0KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAg
ICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JFUVVF
VUUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAg
IHRocmVhZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgp
OwogICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSA2OwogICAgICAgIHdh
aXRfZm9yX2NoaWxkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYz
KSwgRlVURVhfUkVRVUVVRSwgMCwgTlVMTCwgJihzaG1lbS0+ZjQpLCA0NSk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHJldHVy
bmVkICVkIHdoZW4gcmVxdWV1ZWluZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9
IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMiwgTlVMTCwgTlVM
TCwgNDYpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAg
ICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9
IGZ1dGV4KCYoc2htZW0tPmY0KSwgRlVURVhfV0FLRSwgMiwgTlVMTCwgTlVM
TCwgNDcpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAg
ICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhy
ZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9m
b3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBG
VVRFWF9SRVFVRVVFLCAwLCAoc3RydWN0IHRpbWVvdXQgKikxLCAmKHNobWVt
LT5mNCksIDQ4KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1JF
UVVFVUUgcmV0dXJuZWQgJWQgd2hlbiByZXF1ZXVlaW5nIG9uZSBwcm9jZXNz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFLCAy
LCBOVUxMLCBOVUxMLCA0OSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFLCAy
LCBOVUxMLCBOVUxMLCA1MCk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90
aHJlYWQoKTsKICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAg
ICAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNo
bWVtLT5mMyksIEZVVEVYX1JFUVVFVUUsIDAsIChzdHJ1Y3QgdGltZW91dCAq
KTIsICYoc2htZW0tPmY0KSwgNTEpOwogICAgICAgIGlmIChyICE9IDIpCiAg
ICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVuIHJlcXVldWVpbmcg
dHdvIHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmY0KSwg
RlVURVhfV0FLRSwgMiwgTlVMTCwgTlVMTCwgNTIpOwogICAgICAgIGlmIChy
ICE9IDIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1cm5lZCAlZCB3aGVuIHdha2lu
ZyB0d28gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAg
ICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICBzaG1lbS0+Y2hpbGRf
YWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAgICAg
IHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1JFUVVFVUUsIDEsIE5V
TEwsICYoc2htZW0tPmY0KSwgNTMpOwogICAgICAgIGlmIChyICE9IDIpCiAg
ICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAlZCBpbnN0ZWFkIG9mIDJcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAg
ICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0UsIDIsIE5V
TEwsIE5VTEwsIDU0KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsK
ICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBS0UgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAg
ICAgIHRocmVhZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVh
ZCgpOwogICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSA2OwogICAgICAg
IHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0t
PmYzKSwgRlVURVhfUkVRVUVVRSwgMiwgTlVMTCwgJihzaG1lbS0+ZjQpLCA1
NSk7CiAgICAgICAgaWYgKHIgIT0gMikKICAgICAgICB7CiAgICAgICAgICAg
IGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHJl
dHVybmVkICVkIHdoZW4gd2FraW5nIHR3byBwcm9jZXNzZXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRo
cmVhZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwog
ICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRf
Zm9yX2NoaWxkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwg
RlVURVhfUkVRVUVVRSwgMCwgTlVMTCwgJihzaG1lbS0+ZjMpLCA1Nik7CiAg
ICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9SRVFVRVVFIHJldHVybmVk
ICVkIHdoZW4gcmVxdWV1ZWluZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1
dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMiwgTlVMTCwgTlVMTCwg
NTcpOwogICAgICAgIGlmIChyICE9IDIpCiAgICAgICAgewogICAgICAgICAg
ICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1
cm5lZCAlZCB3aGVuIHdha2luZyB0d28gcHJvY2Vzc2VzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJl
YWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAg
ICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zv
cl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX1JFUVVFVUUsIDEsIE5VTEwsICYoc2htZW0tPmYzKSwgNTgpOwogICAg
ICAgIGlmIChyICE9IDIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8
IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfUkVRVUVVRSByZXR1cm5lZCAl
ZCBpbnN0ZWFkIG9mIDJcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyks
IEZVVEVYX1dBS0UsIDIsIE5VTEwsIE5VTEwsIDU5KTsKICAgICAgICBpZiAo
ciAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0UgcmV0dXJuZWQgJWQgd2hlbiB3YWtp
bmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA2OwogICAg
ICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHNobWVtLT5jaGlsZF9h
Y3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfUkVRVUVVRSwgMiwgTlVM
TCwgJihzaG1lbS0+ZjMpLCA2MCk7CiAgICAgICAgaWYgKHIgIT0gMikKICAg
ICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9SRVFVRVVFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIHR3byBw
cm9jZXNzZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgfQogICAgfQogICAgZjEgPSAwOwogICAgciA9IGZ1dGV4KCZmMSwg
RlVURVhfQ01QX1JFUVVFVUUsIDEsIE5VTEwsICZmMiwgMCk7CiAgICBpZiAo
KHIgPCAwKSAmJiAoZXJybm8gPT0gRU5PU1lTKSkKICAgIHsKICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkZVVEVYX0NNUF9SRVFVRVVFIG5vdCBzdXBwb3J0
ZWQgaW4gdGhpcyBrZXJuZWxcbiIpOwogICAgICAgIC8qIG5vdCBmYXRhbCAq
LwogICAgfQogICAgZWxzZQogICAgewogICAgICAgIGlmIChyKQogICAgICAg
IHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXgg
ZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX0NNUF9SRVFVRVVFIHJldHVybmVkICVkIHdoZW4gbm8gcHJvY2VzcyB0
byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgIH0KICAgICAgICBmMSA9IDE7CiAgICAgICAgciA9IGZ1dGV4KCZmMSwg
RlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSwgMSwgTlVMTCwgJmYyLCAxKTsK
ICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwg
MCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAg
ICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRF
IHJldHVybmVkICVkIHdoZW4gbm8gcHJvY2VzcyB0byB3YWtlXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBm
MSA9IDI7CiAgICAgICAgciA9IGZ1dGV4KE5VTEwsIEZVVEVYX0NNUF9SRVFV
RVVFLCAxLCBOVUxMLCAmZjIsIDIpOwogICAgICAgIGlmICgociA+PSAwKSB8
fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSB3
aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
fQogICAgICAgIHIgPSBmdXRleChOVUxMLCBGVVRFWF9DTVBfUkVRVUVVRV9Q
UklWQVRFLCAxLCBOVUxMLCAmZjIsIDIpOwogICAgICAgIGlmICgociA+PSAw
KSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVV
RSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVF
LCAxLCBOVUxMLCBOVUxMLCAyKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgewogICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0
aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyks
IHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0K
ICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklW
QVRFLCAxLCBOVUxMLCBOVUxMLCAyKTsKICAgICAgICBpZiAocikKICAgICAg
ICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
fQogICAgICAgIHIgPSBmdXRleCgoaW50ICopOCwgRlVURVhfQ01QX1JFUVVF
VUUsIDEsIE5VTEwsICZmMiwgMik7CiAgICAgICAgaWYgKChyID49IDApIHx8
IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFIHdp
dGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
LCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9
CiAgICAgICAgciA9IGZ1dGV4KChpbnQgKik4LCBGVVRFWF9DTVBfUkVRVUVV
RV9QUklWQVRFLCAxLCBOVUxMLCAmZjIsIDIpOwogICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVR
VUVVRSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2Yg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFV
RVVFLCAxLCBOVUxMLCAoaW50ICopOCwgMik7CiAgICAgICAgaWYgKChyID49
IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFV
RVVFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVF
VUVfUFJJVkFURSwgMSwgTlVMTCwgKGludCAqKTgsIDIpOwogICAgICAgIGlm
IChyKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KChpbnQgKil1cHJpdiwg
RlVURVhfQ01QX1JFUVVFVUUsIDEsIE5VTEwsICZmMiwgMik7CiAgICAgICAg
aWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsK
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X0NNUF9SRVFVRVVFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5z
dGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KChpbnQgKil1cHJp
diwgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSwgMSwgTlVMTCwgJmYyLCAy
KTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkp
CiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0aCBiYWQgYWRkcmVzcyByZXR1
cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkp
OwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMSwgTlVMTCwgKGludCAqKXVwcml2
LCAyKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVM
VCkpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0aCBiYWQgYWRkcmVzcyBy
ZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVM
VCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0
ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFLCAxLCBOVUxMLCAo
aW50ICopdXByaXYsIDIpOwogICAgICAgIGlmIChyKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZh
aWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAg
ICAgciA9IGZ1dGV4KChpbnQgKikoMSArIChjaGFyICopJmYxKSwgRlVURVhf
Q01QX1JFUVVFVUUsIDEsIE5VTEwsICZmMiwgMik7CiAgICAgICAgaWYgKChy
ID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9S
RVFVRVVFIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVzIGlu
c3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgoaW50ICopKDEg
KyAoY2hhciAqKSZmMSksIEZVVEVYX0NNUF9SRVFVRVVFX1BSSVZBVEUsIDEs
IE5VTEwsICZmMiwgMik7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJu
byAhPSBFSU5WQUwpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFX1BSSVZBVEUg
d2l0aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JF
UVVFVUUsIDEsIE5VTEwsIChpbnQgKikoMSArIChjaGFyICopJmYxKSwgMik7
CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQog
ICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX0NNUF9SRVFVRVVFIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNz
IHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlO
VkFMKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBm
dXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFX1BSSVZBVEUsIDEsIE5VTEws
IChpbnQgKikoMSArIChjaGFyICopJmYxKSwgMik7CiAgICAgICAgaWYgKChy
ID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9S
RVFVRVVFX1BSSVZBVEUgd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJu
ZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsK
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KChp
bnQgKikoMSArIChjaGFyICopJihzaG1lbS0+ZjMpKSwgRlVURVhfQ01QX1JF
UVVFVUUsIDEsIE5VTEwsICZmMiwgMik7CiAgICAgICAgaWYgKChyID49IDAp
IHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVF
IHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQg
b2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9S
RVFVRVVFLCAxLCBOVUxMLCAoaW50ICopKDEgKyAoY2hhciAqKSYoc2htZW0t
PmYzKSksIDIpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0g
RUlOVkFMKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSB3aXRoIG1pc2FsaWdu
ZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0
cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAg
ICAgICByID0gZnV0ZXgoKGludCAqKSg0MDk0ICsgKGNoYXIgKikmKHNobWVt
LT5mMykpLCBGVVRFWF9DTVBfUkVRVUVVRSwgMSwgTlVMTCwgJmYyLCAyKTsK
ICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAg
ICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3Mg
cmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5W
QUwpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUUsIDEsIE5VTEwsIChpbnQgKiko
NDA5NCArIChjaGFyICopJihzaG1lbS0+ZjMpKSwgMik7CiAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NN
UF9SRVFVRVVFIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGYxID0gMzsKICAgICAgICB0
aHJlYWRfYWN0aW9uID0gNDsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsK
ICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMCwg
TlVMTCwgJmYyLCAwKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5v
ICE9IEVBR0FJTikpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0aCBub24g
bWF0Y2ggcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJv
cihFQUdBSU4pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAg
ciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUUsIDAsIE5VTEwsICZm
MiwgMyk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVR
VUVVRSByZXR1cm5lZCAlZCB3aGVuIHJlcXVldWVpbmcgb25lIHByb2Nlc3Nc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQog
ICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0UsIDEsIE5VTEwsIE5V
TEwsIDApOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAg
ICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhy
ZWFkX2FjdGlvbiA9IDU7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFU
RSwgMCwgTlVMTCwgJmYyLCAwKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVBR0FJTikpCiAgICAgICAgewogICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUVfUFJJ
VkFURSB3aXRoIG5vbiBtYXRjaCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVBR0FJTikpOwogICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVV
RV9QUklWQVRFLCAwLCBOVUxMLCAmZjIsIDMpOwogICAgICAgIGlmIChyICE9
IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSByZXR1cm5lZCAl
ZCB3aGVuIHJlcXVldWVpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRl
eCgmZjIsIEZVVEVYX1dBS0VfUFJJVkFURSwgMSwgTlVMTCwgTlVMTCwgMCk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX1BSSVZBVEUg
cmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRo
cmVhZF9hY3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwog
ICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFLCAxLCBO
VUxMLCAmZjIsIDApOwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8g
IT0gRUFHQUlOKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSB3aXRoIG5vbiBt
YXRjaCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9y
KEVBR0FJTikpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMSwgTlVMTCwgJmYy
LCAzKTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAg
ICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFV
RVVFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAg
ICB0aHJlYWRfYWN0aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQo
KTsKICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9Q
UklWQVRFLCAxLCBOVUxMLCAmZjIsIDApOwogICAgICAgIGlmICgociA+PSAw
KSB8fCAoZXJybm8gIT0gRUFHQUlOKSkKICAgICAgICB7CiAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVV
RV9QUklWQVRFIHdpdGggbm9uIG1hdGNoIHJldHVybmVkICVzIGluc3RlYWQg
b2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUFHQUlOKSk7CiAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9S
RVFVRVVFX1BSSVZBVEUsIDEsIE5VTEwsICZmMiwgMyk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFIHJldHVy
bmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRf
YWN0aW9uID0gNDsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAg
ICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMiwgTlVMTCwg
JmYyLCAwKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVB
R0FJTikpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0aCBub24gbWF0Y2gg
cmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFQUdB
SU4pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUUsIDIsIE5VTEwsICZmMiwgMyk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhy
ZWFkX2FjdGlvbiA9IDU7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFU
RSwgMiwgTlVMTCwgJmYyLCAwKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVBR0FJTikpCiAgICAgICAgewogICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUVfUFJJ
VkFURSB3aXRoIG5vbiBtYXRjaCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVBR0FJTikpOwogICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVV
RV9QUklWQVRFLCAyLCBOVUxMLCAmZjIsIDMpOwogICAgICAgIGlmIChyICE9
IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSByZXR1cm5lZCAl
ZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlv
biA9IDQ7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9
IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUUsIDIsIE5VTEwsICZmMSwg
NCk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFQUdBSU4p
KQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFIHdpdGggbm9uIG1hdGNoIHJldHVy
bmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUFHQUlOKSk7
CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGYxID0gNDsKICAg
ICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMSwgTlVM
TCwgJmYxLCA0KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IHJl
dHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJl
YWRfYWN0aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAg
ICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRF
LCAwLCBOVUxMLCAmZjEsIDMpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAo
ZXJybm8gIT0gRUFHQUlOKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklW
QVRFIHdpdGggbm9uIG1hdGNoIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRUFHQUlOKSk7CiAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVF
X1BSSVZBVEUsIDAsIE5VTEwsICZmMSwgNCk7CiAgICAgICAgaWYgKHIgIT0g
MSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFIHJldHVybmVkICVk
IHdoZW4gcmVxdWV1ZWluZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4
KCZmMSwgRlVURVhfV0FLRV9QUklWQVRFLCAxLCBOVUxMLCBOVUxMLCAwKTsK
ICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYg
KHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfUFJJVkFURSBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhy
ZWFkX2FjdGlvbiA9IDQ7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUUsIDEsIE5V
TEwsICZmMSwgMyk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAh
PSBFQUdBSU4pKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFIHdpdGggbm9uIG1h
dGNoIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RUFHQUlOKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIg
PSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFLCAxLCBOVUxMLCAmZjEs
IDQpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAg
ICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVF
VUUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAg
IHRocmVhZF9hY3Rpb24gPSA1OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgp
OwogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFX1BS
SVZBVEUsIDEsIE5VTEwsICZmMSwgMyk7CiAgICAgICAgaWYgKChyID49IDAp
IHx8IChlcnJubyAhPSBFQUdBSU4pKQogICAgICAgIHsKICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVF
X1BSSVZBVEUgd2l0aCBub24gbWF0Y2ggcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFQUdBSU4pKTsKICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfQ01QX1JF
UVVFVUVfUFJJVkFURSwgMSwgTlVMTCwgJmYxLCA0KTsKICAgICAgICBpZiAo
ciAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFX1BSSVZBVEUgcmV0dXJu
ZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9h
Y3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAg
IHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFLCAyLCBOVUxMLCAm
ZjEsIDMpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUFH
QUlOKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSB3aXRoIG5vbiBtYXRjaCBy
ZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVBR0FJ
TikpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0
ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMiwgTlVMTCwgJmYxLCA0KTsK
ICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYg
KHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFIHJl
dHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJl
YWRfYWN0aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAg
ICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRF
LCAyLCBOVUxMLCAmZjEsIDMpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAo
ZXJybm8gIT0gRUFHQUlOKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklW
QVRFIHdpdGggbm9uIG1hdGNoIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRUFHQUlOKSk7CiAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVF
X1BSSVZBVEUsIDIsIE5VTEwsICZmMSwgNCk7CiAgICAgICAgaWYgKHIgIT0g
MSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFIHJldHVybmVkICVk
IHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9u
ID0gNDsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0g
ZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMCwgTlVMTCwgJmYxLCAz
KTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVBR0FJTikp
CiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgd2l0aCBub24gbWF0Y2ggcmV0dXJu
ZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFQUdBSU4pKTsK
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfQ01QX1JFUVVFVUUsIDAsIE5VTEwsICZmMSwgNCk7CiAgICAg
ICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwg
MCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAg
ICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1cm5l
ZCAlZCB3aGVuIHJlcXVldWVpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBm
dXRleCgmZjEsIEZVVEVYX1dBS0UsIDEsIE5VTEwsIE5VTEwsIDApOwogICAg
ICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8
IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1cm5lZCAlZCB3
aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9
IDU7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSwgMCwgTlVMTCwg
JmYxLCAzKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVB
R0FJTikpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSB3aXRoIG5v
biBtYXRjaCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVy
cm9yKEVBR0FJTikpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAg
ICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFLCAw
LCBOVUxMLCAmZjEsIDQpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAg
ewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfQ01QX1JFUVVFVUVfUFJJVkFURSByZXR1cm5lZCAlZCB3aGVuIHJlcXVl
dWVpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVY
X1dBS0VfUFJJVkFURSwgMSwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX1BSSVZBVEUgcmV0dXJuZWQgJWQg
d2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24g
PSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBm
dXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFLCAxLCBOVUxMLCAmZjEsIDMp
OwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUFHQUlOKSkK
ICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSB3aXRoIG5vbiBtYXRjaCByZXR1cm5l
ZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVBR0FJTikpOwog
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYx
LCBGVVRFWF9DTVBfUkVRVUVVRSwgMSwgTlVMTCwgJmYxLCA0KTsKICAgICAg
ICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAw
KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAg
IGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVFIHJldHVybmVk
ICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0
aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFLCAxLCBO
VUxMLCAmZjEsIDMpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8g
IT0gRUFHQUlOKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFIHdp
dGggbm9uIG1hdGNoIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwg
c3RyZXJyb3IoRUFHQUlOKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQog
ICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0NNUF9SRVFVRVVFX1BSSVZB
VEUsIDEsIE5VTEwsICZmMSwgNCk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAg
ICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFIHJldHVybmVkICVkIHdoZW4g
d2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsK
ICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9DTVBfUkVRVUVVRSwgMiwgTlVMTCwgJmYxLCAzKTsKICAg
ICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVBR0FJTikpCiAgICAg
ICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
RlVURVhfQ01QX1JFUVVFVUUgd2l0aCBub24gbWF0Y2ggcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVU
RVhfQ01QX1JFUVVFVUUsIDIsIE5VTEwsICZmMSwgNCk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1cm5lZCAlZCB3
aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9
IDU7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSwgMiwgTlVMTCwg
JmYxLCAzKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVB
R0FJTikpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUVfUFJJVkFURSB3aXRoIG5v
biBtYXRjaCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVy
cm9yKEVBR0FJTikpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAg
ICByID0gZnV0ZXgoJmYxLCBGVVRFWF9DTVBfUkVRVUVVRV9QUklWQVRFLCAy
LCBOVUxMLCAmZjEsIDQpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAg
ewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfQ01QX1JFUVVFVUVfUFJJVkFURSByZXR1cm5lZCAlZCB3aGVuIHdha2lu
ZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICB9CiAgICAgICAgc2htZW0tPmYzID0gNTsKICAgICAgICB0
aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsK
ICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9DTVBfUkVR
VUVVRSwgMCwgTlVMTCwgJihzaG1lbS0+ZjQpLCA0KTsKICAgICAgICBpZiAo
KHIgPj0gMCkgfHwgKGVycm5vICE9IEVBR0FJTikpCiAgICAgICAgewogICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01Q
X1JFUVVFVUUgd2l0aCBub24gbWF0Y2ggcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFQUdBSU4pKTsKICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVU
RVhfQ01QX1JFUVVFVUUsIDAsIE5VTEwsICYoc2htZW0tPmY0KSwgNSk7CiAg
ICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1
cm5lZCAlZCB3aGVuIHJlcXVldWVpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIg
PSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0UsIDEsIE5VTEwsIE5V
TEwsIDApOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAg
ICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhy
ZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfQ01QX1JFUVVF
VUUsIDEsIE5VTEwsICYoc2htZW0tPmY0KSwgNSk7CiAgICAgICAgaWYgKHIg
IT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVu
IHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7
CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4
KCYoc2htZW0tPmYzKSwgRlVURVhfQ01QX1JFUVVFVUUsIDIsIE5VTEwsICYo
c2htZW0tPmY0KSwgNSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7
CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZh
aWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9DTVBfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJv
Y2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9m
b3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwg
RlVURVhfQ01QX1JFUVVFVUUsIDAsIE5VTEwsICYoc2htZW0tPmYzKSwgNSk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSBy
ZXR1cm5lZCAlZCB3aGVuIHJlcXVldWVpbmcgb25lIHByb2Nlc3NcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAg
IHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1dBS0UsIDEsIE5VTEws
IE5VTEwsIDApOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FL
RSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAg
dGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7
CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfQ01QX1JF
UVVFVUUsIDEsIE5VTEwsICYoc2htZW0tPmYzKSwgNSk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1cm5lZCAlZCB3
aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9
IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1
dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfQ01QX1JFUVVFVUUsIDIsIE5VTEws
ICYoc2htZW0tPmYzKSwgNSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9DTVBfUkVRVUVVRSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUg
cHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2Fp
dF9mb3JfdGhyZWFkKCk7CiAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9
IDY7CiAgICAgICAgd2FpdF9mb3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0
ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9DTVBfUkVRVUVVRSwgMCwgTlVMTCwg
JihzaG1lbS0+ZjQpLCA1KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAg
IHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXgg
ZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX0NNUF9SRVFVRVVFIHJldHVybmVkICVkIHdoZW4gcmVxdWV1ZWluZyBv
bmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVU
RVhfV0FLRSwgMiwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgaWYgKHIgIT0g
MSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9u
ZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRF
WF9XQUtFLCAyLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICBpZiAociAhPSAx
KQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1dBS0UgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25l
IHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA2OwogICAgICAgIHdh
aXRfZm9yX3RocmVhZCgpOwogICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24g
PSA2OwogICAgICAgIHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAgciA9IGZ1
dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfQ01QX1JFUVVFVUUsIDAsIChzdHJ1
Y3QgdGltZW91dCAqKTEsICYoc2htZW0tPmY0KSwgNSk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1cm5lZCAlZCB3
aGVuIHJlcXVldWVpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgm
KHNobWVtLT5mMyksIEZVVEVYX1dBS0UsIDIsIE5VTEwsIE5VTEwsIDApOwog
ICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAo
ciA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRSByZXR1cm5lZCAl
ZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCYo
c2htZW0tPmY0KSwgRlVURVhfV0FLRSwgMiwgTlVMTCwgTlVMTCwgMCk7CiAg
ICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFIHJldHVybmVkICVk
IHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9u
ID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICBzaG1l
bS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgp
OwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX0NNUF9S
RVFVRVVFLCAwLCAoc3RydWN0IHRpbWVvdXQgKikyLCAmKHNobWVtLT5mNCks
IDUpOwogICAgICAgIGlmIChyICE9IDIpCiAgICAgICAgewogICAgICAgICAg
ICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVF
VUUgcmV0dXJuZWQgJWQgd2hlbiByZXF1ZXVlaW5nIHR3byBwcm9jZXNzZXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQog
ICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0UsIDIs
IE5VTEwsIE5VTEwsIDApOwogICAgICAgIGlmIChyICE9IDIpCiAgICAgICAg
ewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FLRSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyB0d28gcHJvY2Vzc2Vz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90
aHJlYWQoKTsKICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAg
ICAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNo
bWVtLT5mMyksIEZVVEVYX0NNUF9SRVFVRVVFLCAxLCBOVUxMLCAmKHNobWVt
LT5mNCksIDUpOwogICAgICAgIGlmIChyICE9IDIpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01Q
X1JFUVVFVUUgcmV0dXJuZWQgJWQgaW5zdGVhZCBvZiAyXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICByID0g
ZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFLCAyLCBOVUxMLCBOVUxM
LCAwKTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAg
ICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0UgcmV0
dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVh
ZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAg
ICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9y
X2NoaWxkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVU
RVhfQ01QX1JFUVVFVUUsIDIsIE5VTEwsICYoc2htZW0tPmY0KSwgNSk7CiAg
ICAgICAgaWYgKHIgIT0gMikKICAgICAgICB7CiAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9DTVBfUkVRVUVVRSByZXR1
cm5lZCAlZCB3aGVuIHdha2luZyB0d28gcHJvY2Vzc2VzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJl
YWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAg
ICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zv
cl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX0NNUF9SRVFVRVVFLCAwLCBOVUxMLCAmKHNobWVtLT5mMyksIDUpOwog
ICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAo
ciA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgcmV0
dXJuZWQgJWQgd2hlbiByZXF1ZXVlaW5nIG9uZSBwcm9jZXNzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFLCAyLCBOVUxMLCBO
VUxMLCAwKTsKICAgICAgICBpZiAociAhPSAyKQogICAgICAgIHsKICAgICAg
ICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0Ug
cmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgdHdvIHByb2Nlc3Nlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAg
dGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7
CiAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDY7CiAgICAgICAgd2Fp
dF9mb3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMp
LCBGVVRFWF9DTVBfUkVRVUVVRSwgMSwgTlVMTCwgJihzaG1lbS0+ZjMpLCA1
KTsKICAgICAgICBpZiAociAhPSAyKQogICAgICAgIHsKICAgICAgICAgICAg
aWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0NNUF9SRVFVRVVF
IHJldHVybmVkICVkIGluc3RlYWQgb2YgMlxuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCYo
c2htZW0tPmYzKSwgRlVURVhfV0FLRSwgMiwgTlVMTCwgTlVMTCwgMCk7CiAg
ICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFIHJldHVybmVkICVk
IHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9u
ID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICBzaG1l
bS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgp
OwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX0NNUF9S
RVFVRVVFLCAyLCBOVUxMLCAmKHNobWVtLT5mMyksIDUpOwogICAgICAgIGlm
IChyICE9IDIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxz
ZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfQ01QX1JFUVVFVUUgcmV0dXJuZWQgJWQg
d2hlbiB3YWtpbmcgdHdvIHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICB9CiAgICAvKiBGVVRFWF9X
QUtFX09QIGlzbid0IGRvY3VtZW50ZWQgaW4gdGhlIG1hbiBwYWdlLiBGcm9t
IGxvb2tpbmcgYXQgdGhlCiAgICAgKiBrZXJuZWwgY29kZSwgaXQgZG9lcyB0
aGUgZm9sbG93aW5nCiAgICAgKiBhcmc2IGVuY29kZXMgYW4gb3BlcmF0aW9u
LCBhbiBvcGVyYW5kLCBhIGNvbXBhcmlzb24gdHlwZSwKICAgICAqIGFuZCBh
IGNvbXBhcmlzb25uIHZhbHVlLgogICAgICogQXRvbWljYWxseSBwZXJmb3Jt
IHRoZSBjb21wYXJpc29uIGFuZCB0aGVuIHRoZSBvcGVyYXRpb24gb24gKmFy
ZzUKICAgICAqIFdha2UgdXAgdG8gbWF4KDEsIGFyZzMpIHByb2Nlc3Nlc3Mg
d2FpdGluZyBvbiBhcmcxCiAgICAgKiBJZiBjb21wYXJpc29uIHN1Y2NlZWRl
ZAogICAgICogICAgIFdha2UgdXAgdG8gKG1heCgxLCAoaW50KWFyZzQpIHBy
b2Nlc3NlcyB3YWl0aW5nIG9uIGFyZzUKICAgICAqIFJldHVybnMgdG90YWwg
bnVtYmVyIG9mIHByb2Nlc3NlcyBhd2FrZW5lZC4KICAgICAqLwogICAgciA9
IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9PUCwgMCwgTlVMTCwgJmYyLAogICAg
ICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09Q
X0NNUF9FUSwgMCkpOwogICAgaWYgKChyIDwgMCkgJiYgKGVycm5vID09IEVO
T1NZUykpCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJGVVRFWF9X
QUtFX09QIG5vdCBzdXBwb3J0ZWQgaW4gdGhpcyBrZXJuZWxcbiIpOwogICAg
ICAgIC8qIG5vdCBmYXRhbCAqLwogICAgfQogICAgZWxzZQogICAgewogICAg
ICAgIGlmIChyKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hl
biB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBmMSA9IDA7CiAgICAgICAg
ZjIgPSAwOwogICAgICAgIHIgPSBmdXRleChOVUxMLCBGVVRFWF9XQUtFX09Q
LCAwLCBOVUxMLCAmZjIsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRF
WF9PUF9TRVQsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9X
QUtFX09QIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KE5VTEwsIEZVVEVYX1dBS0Vf
T1BfUFJJVkFURSwgMCwgTlVMTCwgJmYyLAogICAgICAgICAgICAgICAgRlVU
RVhfT1AoRlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsK
ICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgoaW50
ICopOCwgRlVURVhfV0FLRV9PUCwgMCwgTlVMTCwgJmYyLAogICAgICAgICAg
ICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBf
RVEsIDApKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVG
QVVMVCkpCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCB3aXRoIGJhZCBhZGRyZXNzIHJl
dHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxU
KSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRl
eCgoaW50ICopOCwgRlVURVhfV0FLRV9PUF9QUklWQVRFLCAwLCBOVUxMLCAm
ZjIsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAs
IEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmIChyKQogICAgICAg
IHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9
CiAgICAgICAgciA9IGZ1dGV4KChpbnQgKil1cHJpdiwgRlVURVhfV0FLRV9P
UCwgMCwgTlVMTCwgJmYyLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVU
RVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBp
ZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgewog
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
V0FLRV9PUCB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQg
b2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgoaW50ICopdXByaXYsIEZV
VEVYX1dBS0VfT1BfUFJJVkFURSwgMCwgTlVMTCwgJmYyLAogICAgICAgICAg
ICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBf
RVEsIDApKTsKICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBm
dXRleCgoaW50ICopKDEgKyAoY2hhciAqKSZmMSksIEZVVEVYX1dBS0VfT1As
IDAsIE5VTEwsICZmMiwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVY
X09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0VfT1Agd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9m
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoKGludCAqKSgxICsgKGNoYXIg
KikmZjEpLCBGVVRFWF9XQUtFX09QX1BSSVZBVEUsIDAsIE5VTEwsICZmMiwK
ICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVU
RVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChl
cnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1BfUFJJVkFURSB3
aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
fQogICAgICAgIHIgPSBmdXRleCgoaW50ICopKDEgKyAoY2hhciAqKSYoc2ht
ZW0tPmYzKSksIEZVVEVYX1dBS0VfT1AsIDAsIE5VTEwsICZmMiwKICAgICAg
ICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1Bf
Q01QX0VRLCAwKSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAh
PSBFSU5WQUwpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1Agd2l0aCBiYWQgYWRkcmVz
cyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJ
TlZBTCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0g
ZnV0ZXgoKGludCAqKSg0MDk0ICsgKGNoYXIgKikmKHNobWVtLT5mMykpLCBG
VVRFWF9XQUtFX09QLCAwLCBOVUxMLCAmZjIsCiAgICAgICAgICAgICAgICBG
VVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkp
OwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkK
ICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9XQUtFX09QIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQg
JXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwg
RlVURVhfV0FLRV9PUCwgMCwgTlVMTCwgTlVMTCwKICAgICAgICAgICAgICAg
IEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAw
KSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQp
KQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1dBS0VfT1Agd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5l
ZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwog
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYx
LCBGVVRFWF9XQUtFX09QX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsCiAgICAg
ICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09Q
X0NNUF9FUSwgMCkpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8g
IT0gRUZBVUxUKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHdpdGggYmFkIGFkZHJl
c3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihF
RkFVTFQpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9
IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9PUCwgMCwgTlVMTCwgKGludCAqKTgs
CiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZV
VEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAo
ZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHdpdGggYmFk
IGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJl
cnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICAg
ICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9PUF9QUklWQVRFLCAwLCBO
VUxMLCAoaW50ICopOCwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVY
X09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0VfT1BfUFJJVkFURSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGlu
c3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVY
X1dBS0VfT1AsIDAsIE5VTEwsIChpbnQgKil1cHJpdiwKICAgICAgICAgICAg
ICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VR
LCAwKSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFV
TFQpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfT1Agd2l0aCBiYWQgYWRkcmVzcyByZXR1
cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkp
OwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9XQUtFX09QX1BSSVZBVEUsIDAsIE5VTEwsIChpbnQgKil1
cHJpdiwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwg
MCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKChyID49IDAp
IHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgIHsKICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1BfUFJJ
VkFURSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2Yg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBS0VfT1As
IDAsIE5VTEwsIChpbnQgKikoMSArIChjaGFyICopJmYyKSwKICAgICAgICAg
ICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01Q
X0VRLCAwKSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBF
SU5WQUwpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1Agd2l0aCBiYWQgYWRkcmVzcyBy
ZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZB
TCkpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0
ZXgoJmYxLCBGVVRFWF9XQUtFX09QX1BSSVZBVEUsIDAsIE5VTEwsIChpbnQg
KikoMSArIChjaGFyICopJmYyKSwKICAgICAgICAgICAgICAgIEZVVEVYX09Q
KEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAg
ICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAg
IHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBS0VfT1BfUFJJVkFURSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVk
ICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1dBS0VfT1AsIDAsIE5VTEwsIChpbnQgKikoMSArIChjaGFyICop
JihzaG1lbS0+ZjMpKSwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVY
X09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgIHsKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0VfT1Agd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9m
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX09Q
LCAwLCBOVUxMLCAoaW50ICopKDQwOTQgKyAoY2hhciAqKSYoc2htZW0tPmYz
KSksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAs
IEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmICgociA+PSAwKSB8
fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgICAgICB7CiAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHdpdGgg
YmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBz
dHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9PUCwgMCwgTlVMTCwg
JmYyLAogICAgICAgICAgICAgICAgRlVURVhfT1AoNSwgMCwgRlVURVhfT1Bf
Q01QX0VRLCAwKSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAh
PSBFTk9TWVMpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1Agd2l0aCBiYWQgb3BlcmF0
aW9uIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RU5PU1lTKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIg
PSBmdXRleCgmZjEsIEZVVEVYX1dBS0VfT1AsIDAsIE5VTEwsICZmMiwKICAg
ICAgICAgICAgICAgIEZVVEVYX09QKDYsIDAsIEZVVEVYX09QX0NNUF9FUSwg
MCkpOwogICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRU5PU1lT
KSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFX09QIHdpdGggYmFkIG9wZXJhdGlvbiByZXR1
cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVOT1NZUykp
OwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgo
JmYxLCBGVVRFWF9XQUtFX09QLCAwLCBOVUxMLCAmZjIsCiAgICAgICAgICAg
ICAgICBGVVRFWF9PUCg3LCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAg
ICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVOT1NZUykpCiAgICAg
ICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
RlVURVhfV0FLRV9PUCB3aXRoIGJhZCBvcGVyYXRpb24gcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFTk9TWVMpKTsKICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVU
RVhfV0FLRV9PUCwgMCwgTlVMTCwgJmYyLAogICAgICAgICAgICAgICAgRlVU
RVhfT1AoMTMsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRU5PU1lTKSkKICAgICAgICB7CiAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9X
QUtFX09QIHdpdGggYmFkIG9wZXJhdGlvbiByZXR1cm5lZCAlcyBpbnN0ZWFk
IG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubyksIHN0cmVycm9yKEVOT1NZUykpOwogICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEp
OwogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUtF
X09QLCAwLCBOVUxMLCAmZjIsCiAgICAgICAgICAgICAgICBGVVRFWF9PUCgx
NCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKChyID49
IDApIHx8IChlcnJubyAhPSBFTk9TWVMpKQogICAgICAgIHsKICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1Ag
d2l0aCBiYWQgb3BlcmF0aW9uIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRU5PU1lTKSk7CiAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBS0VfT1AsIDAs
IE5VTEwsICZmMiwKICAgICAgICAgICAgICAgIEZVVEVYX09QKDE1LCAwLCBG
VVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVOT1NZUykpCiAgICAgICAgewogICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCB3aXRoIGJh
ZCBvcGVyYXRpb24gcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBz
dHJlcnJvcihFTk9TWVMpKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9PUCwgMCwgTlVMTCwg
JmYyLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAw
LCA2LCAwKSk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBF
Tk9TWVMpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1Agd2l0aCBiYWQgY29tcGFyaXNv
biByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVO
T1NZUykpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICByID0g
ZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX09QLCAwLCBOVUxMLCAmZjIsCiAgICAg
ICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIDcsIDApKTsK
ICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVOT1NZUykpCiAg
ICAgICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FLRV9PUCB3aXRoIGJhZCBjb21wYXJpc29uIHJldHVybmVk
ICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRU5PU1lTKSk7CiAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1dBS0VfT1BfUFJJVkFURSwgMCwgTlVMTCwgJmYyLAogICAgICAg
ICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9D
TVBfRVEsIDApKTsKICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09Q
X1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2Vz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX09QLCAyLCAoc3Ry
dWN0IHRpbWVzcGVjICopMiwgJmYyLAogICAgICAgICAgICAgICAgRlVURVhf
T1AoRlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAg
ICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBl
bHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdo
ZW4gd2FraW5nIG5vIHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwg
RlVURVhfV0FLRV9PUF9QUklWQVRFLCAyLCAoc3RydWN0IHRpbWVzcGVjICop
MiwgJmYyLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VU
LCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAocikKICAg
ICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUtFX09QX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3YWtp
bmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsKICAg
ICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJmYx
LCBGVVRFWF9XQUtFX09QLCAwLCBOVUxMLCAmZjIsCiAgICAgICAgICAgICAg
ICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09QX0NNUF9FUSwg
MCkpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAg
ICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCBy
ZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhy
ZWFkX2FjdGlvbiA9IDQ7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVj
dCB0aW1lc3BlYyAqKTIsICZmMiwKICAgICAgICAgICAgICAgIEZVVEVYX09Q
KEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAg
ICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwg
MCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAg
ICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVk
IHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9u
ID0gNDsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0g
ZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVj
ICopMiwgJmYyLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1Bf
U0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAociAh
PSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtp
bmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA1OwogICAg
ICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1dBS0VfT1BfUFJJVkFURSwgMCwgKHN0cnVjdCB0aW1lc3BlYyAq
KTIsICZmMiwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NF
VCwgMCwgRlVURVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKHIgIT0g
MSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFX09QX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hl
biB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0
OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRl
eCgmZjIsIEZVVEVYX1dBS0VfT1AsIDIsIE5VTEwsICZmMSwKICAgICAgICAg
ICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01Q
X0VRLCAwKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAg
ICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtF
X09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAg
ICB0aHJlYWRfYWN0aW9uID0gNDsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQo
KTsKICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QLCAwLCAo
c3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVU
RVhfT1AoRlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsK
ICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYg
KHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJu
ZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9h
Y3Rpb24gPSA1OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAg
IHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1BfUFJJVkFURSwgMiwgTlVM
TCwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VU
LCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAociAhPSAx
KQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1dBS0VfT1BfUFJJVkFURSByZXR1cm5lZCAlZCB3aGVu
IHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDU7
CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4
KCZmMiwgRlVURVhfV0FLRV9PUF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVz
cGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhf
T1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAo
ciAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1BfUFJJVkFURSByZXR1cm5lZCAl
ZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgc2htZW0tPmYzID0g
MDsKICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zv
cl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBG
VVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJihzaG1l
bS0+ZjQpLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VU
LCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAociAhPSAx
KQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcg
b25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA2OwogICAgICAg
IHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVt
LT5mMyksIEZVVEVYX1dBS0VfT1AsIDIsIE5VTEwsICYoc2htZW0tPmY0KSwK
ICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVU
RVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9j
ZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
IH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zv
cl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBG
VVRFWF9XQUtFX09QLCAyLCBOVUxMLCAmKHNobWVtLT5mMyksCiAgICAgICAg
ICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09QX0NN
UF9FUSwgMCkpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FL
RV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAg
ICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFk
KCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmY0KSwgRlVURVhfV0FL
RV9PUCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICYoc2htZW0tPmYzKSwK
ICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVU
RVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9j
ZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
IH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zv
cl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBG
VVRFWF9XQUtFX09QLCAwLCBOVUxMLCAmKHNobWVtLT5mMyksCiAgICAgICAg
ICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09QX0NN
UF9FUSwgMCkpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FL
RV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAg
ICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFk
KCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FL
RV9PUCwgMiwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICYoc2htZW0tPmYzKSwK
ICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVU
RVhfT1BfQ01QX0VRLCAwKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9j
ZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
IH0KICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3
YWl0X2Zvcl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5m
MyksIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAm
KHNobWVtLT5mNCksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9P
UF9TRVQsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmIChy
ICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdh
a2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICB9CiAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9
IDY7CiAgICAgICAgd2FpdF9mb3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0
ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFX09QLCAyLCBOVUxMLCAmKHNo
bWVtLT5mNCksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9T
RVQsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmIChyICE9
IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2lu
ZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICB9CiAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDY7
CiAgICAgICAgd2FpdF9mb3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0ZXgo
JihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAyLCBOVUxMLCAmKHNobWVt
LT5mMyksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQs
IDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmIChyICE9IDEp
CiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBv
bmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDY7CiAg
ICAgICAgd2FpdF9mb3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0ZXgoJihz
aG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVj
ICopMiwgJihzaG1lbS0+ZjMpLAogICAgICAgICAgICAgICAgRlVURVhfT1Ao
RlVURVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAg
ICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAw
KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAg
IGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQg
d2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHNobWVtLT5jaGlsZF9h
Y3Rpb24gPSA2OwogICAgICAgIHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRV9PUCwgMCwgTlVM
TCwgJihzaG1lbS0+ZjMpLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVU
RVhfT1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBp
ZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hl
biB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHNobWVtLT5jaGlsZF9hY3Rp
b24gPSA2OwogICAgICAgIHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAgciA9
IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRV9PUCwgMiwgKHN0cnVj
dCB0aW1lc3BlYyAqKTIsICYoc2htZW0tPmYzKSwKICAgICAgICAgICAgICAg
IEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VRLCAw
KSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAg
IGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJl
dHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJl
YWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAg
ICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zv
cl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVt
LT5mNCksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQs
IDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlmIChyICE9IDEp
CiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBv
bmUgcHJvY2Vzc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX1dBS0VfT1AsIDEsIE5VTEwsICYoc2htZW0tPmY0KSwKICAgICAgICAg
ICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01Q
X0VRLCAwKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAg
ICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtF
X09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAg
ICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAxLCBO
VUxMLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChG
VVRFWF9PUF9TRVQsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAg
IGlmIChyKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3
YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+
ZjQpLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwg
JihzaG1lbS0+ZjMpLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhf
T1BfU0VULCAwLCBGVVRFWF9PUF9DTVBfRVEsIDApKTsKICAgICAgICBpZiAo
cikKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5n
IG5vIHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAg
ICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgc2htZW0tPmNoaWxkX2Fj
dGlvbiA9IDY7CiAgICAgICAgd2FpdF9mb3JfY2hpbGQoKTsKICAgICAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFX09QLCAzLCBOVUxM
LCAmKHNobWVtLT5mNCksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRF
WF9PUF9TRVQsIDAsIEZVVEVYX09QX0NNUF9FUSwgMCkpOwogICAgICAgIGlm
IChyICE9IDIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxz
ZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVu
IHdha2luZyB0d28gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0g
NjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICBzaG1lbS0+
Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgpOwog
ICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1As
IDAsIChzdHJ1Y3QgdGltZXNwZWMgKikzLCAmKHNobWVtLT5mMyksCiAgICAg
ICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDAsIEZVVEVYX09Q
X0NNUF9FUSwgMCkpOwogICAgICAgIGlmIChyICE9IDIpCiAgICAgICAgewog
ICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWls
ZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KI2lmZGVmIF9faTM4Nl9fCiAgICAgICAgICAgIGlmIChyID09
IDEpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIC8qIFdha2UgdGhl
IG90aGVyIG9uZS4gKi8KICAgICAgICAgICAgICAgICh2b2lkKWZ1dGV4KCYo
c2htZW0tPmY0KSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVjdCB0aW1lc3Bl
YyAqKTMsICYoc2htZW0tPmYzKSwKICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgMCwgRlVURVhfT1BfQ01QX0VR
LCAwKSk7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIktFUk5F
TEJVRz8gRlVURVhfV0FLRV9PUCBhcmc0IG5vdCBkZWNvZGVkIGNvcnJlY3Rs
eSBpbiAzMi1iaXRcbiIpOwogICAgICAgICAgICB9CiNlbmRpZgogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVk
ICVkIHdoZW4gd2FraW5nIHR3byBwcm9jZXNzZXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9h
Y3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAg
IHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGlt
ZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRF
WF9PUF9BREQsIDEsIEZVVEVYX09QX0NNUF9FUSwgMSkpOwogICAgICAgIGlm
IChyKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtp
bmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9X
QUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAg
ICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfQURELCAxLCBGVVRFWF9PUF9D
TVBfRVEsIDEpKTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAg
ICAgIHRocmVhZF9hY3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVh
ZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAs
IChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBG
VVRFWF9PUChGVVRFWF9PUF9PUiwgMSwgRlVURVhfT1BfQ01QX0VRLCAzKSk7
CiAgICAgICAgaWYgKHIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8
IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAl
ZCB3aGVuIHdha2luZyBubyBwcm9jZXNzZXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgm
ZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAm
ZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9PUiwgMSwg
RlVURVhfT1BfQ01QX0VRLCAzKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAg
ICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1
dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBw
cm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsKICAgICAgICB3YWl0
X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9X
QUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAg
ICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfQU5ETiwgMSwgRlVURVhfT1Bf
Q01QX0VRLCAyKSk7CiAgICAgICAgaWYgKHIpCiAgICAgICAgewogICAgICAg
ICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9P
UCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzZXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAg
IHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGlt
ZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRF
WF9PUF9BTkROLCAxLCBGVVRFWF9PUF9DTVBfRVEsIDIpKTsKICAgICAgICBp
ZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hl
biB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0
OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRl
eCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKiky
LCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9YT1Is
IDMsIEZVVEVYX09QX0NNUF9FUSwgMSkpOwogICAgICAgIGlmIChyKQogICAg
ICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0
ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJv
Y2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QLCAw
LCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAg
RlVURVhfT1AoRlVURVhfT1BfWE9SLCAzLCBGVVRFWF9PUF9DTVBfRVEsIDEp
KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAg
aWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0
dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVh
ZF9hY3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAg
ICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3Qg
dGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUCgo
RlVURVhfT1BfU0VUIHwgRlVURVhfT1BfT1BBUkdfU0hJRlQpLCA0LCBGVVRF
WF9PUF9DTVBfRVEsICgxIDw8IDQpKSk7CiAgICAgICAgaWYgKHIpCiAgICAg
ICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRl
eCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
RlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9j
ZXNzZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBy
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgfQogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAs
IChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBG
VVRFWF9PUCgoRlVURVhfT1BfU0VUIHwgRlVURVhfT1BfT1BBUkdfU0hJRlQp
LCA0LCBGVVRFWF9PUF9DTVBfRVEsICgxIDw8IDQpKSk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4g
d2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsK
ICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgo
JmYyLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwg
JmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAo
LTEpLCBGVVRFWF9PUF9DTVBfTkUsICgxIDw8IDQpKSk7CiAgICAgICAgaWYg
KHIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2lu
ZyBubyBwcm9jZXNzZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dB
S0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAg
ICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgtMSksIEZVVEVYX09Q
X0NNUF9ORSwgKDEgPDwgNCkpKTsKICAgICAgICBpZiAociAhPSAxKQogICAg
ICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0
ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHBy
b2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBy
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0OwogICAgICAgIHdhaXRf
Zm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dB
S0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAg
ICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgtMiksIEZVVEVYX09Q
X0NNUF9MVCwgKC0xKSkpOwogICAgICAgIGlmIChyKQogICAgICAgIHsKICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAg
ICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0
IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1Ao
RlVURVhfT1BfU0VULCAoLTIpLCBGVVRFWF9PUF9DTVBfTFQsICgtMSkpKTsK
ICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYg
KHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJu
ZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9h
Y3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAg
IHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGlt
ZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRF
WF9PUF9TRVQsICgtMyksIEZVVEVYX09QX0NNUF9MRSwgKC0zKSkpOwogICAg
ICAgIGlmIChyKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hl
biB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYyLCBG
VVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAog
ICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAoLTMpLCBG
VVRFWF9PUF9DTVBfTEUsICgtMykpKTsKICAgICAgICBpZiAociAhPSAxKQog
ICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
ZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25l
IHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0OwogICAgICAgIHdh
aXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVY
X1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAg
ICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgtNSksIEZVVEVY
X09QX0NNUF9MRSwgKC00KSkpOwogICAgICAgIGlmIChyKQogICAgICAgIHsK
ICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2Vz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QLCAwLCAoc3Ry
dWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhf
T1AoRlVURVhfT1BfU0VULCAoLTUpLCBGVVRFWF9PUF9DTVBfTEUsICgtNCkp
KTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAg
aWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0
dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVh
ZF9hY3Rpb24gPSA0OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAg
ICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3Qg
dGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChG
VVRFWF9PUF9TRVQsIDQsIEZVVEVYX09QX0NNUF9HVCwgKC01KSkpOwogICAg
ICAgIGlmIChyKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hl
biB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYyLCBG
VVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAog
ICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCA0LCBGVVRF
WF9PUF9DTVBfR1QsICgtNSkpKTsKICAgICAgICBpZiAociAhPSAxKQogICAg
ICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0
ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHBy
b2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBy
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0OwogICAgICAgIHdhaXRf
Zm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dB
S0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAg
ICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDYsIEZVVEVYX09QX0NN
UF9HRSwgNikpOwogICAgICAgIGlmIChyKQogICAgICAgIHsKICAgICAgICAg
ICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1Ag
cmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBy
ID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVz
cGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhf
T1BfU0VULCA2LCBGVVRFWF9PUF9DTVBfR0UsIDYpKTsKICAgICAgICBpZiAo
ciAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3
YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA0Owog
ICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgm
ZjIsIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAm
ZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgx
IDw8IDQpLCBGVVRFWF9PUF9DTVBfTkUsIDYpKTsKICAgICAgICBpZiAocikK
ICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG5v
IHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMiwgRlVURVhfV0FLRV9P
UCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICZmMSwKICAgICAgICAgICAg
ICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgKDEgPDwgNCksIEZVVEVYX09Q
X0NNUF9ORSwgNikpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewog
ICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWls
ZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
V0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAg
ICAgICAgdGhyZWFkX2FjdGlvbiA9IDU7CiAgICAgICAgd2FpdF9mb3JfdGhy
ZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCZmMiwgRlVURVhfV0FLRV9PUF9Q
UklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAg
ICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAoLTEpLCBGVVRFWF9P
UF9DTVBfTkUsICgxIDw8IDQpKSk7CiAgICAgICAgaWYgKHIpCiAgICAgICAg
ewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FLRV9PUF9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG5v
IHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMiwgRlVURVhfV0FLRV9P
UF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAg
ICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAoLTEpLCBGVVRF
WF9PUF9DTVBfTkUsICgxIDw8IDQpKSk7CiAgICAgICAgaWYgKHIgIT0gMSkK
ICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9XQUtFX09QX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3
YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA1Owog
ICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgm
ZjIsIEZVVEVYX1dBS0VfT1BfUFJJVkFURSwgMCwgKHN0cnVjdCB0aW1lc3Bl
YyAqKTIsICZmMSwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09Q
X1NFVCwgKC0yKSwgRlVURVhfT1BfQ01QX0xULCAoLTEpKSk7CiAgICAgICAg
aWYgKHIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUF9QUklWQVRFIHJldHVybmVkICVk
IHdoZW4gd2FraW5nIG5vIHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZm
MiwgRlVURVhfV0FLRV9PUF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVj
ICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1Bf
U0VULCAoLTIpLCBGVVRFWF9PUF9DTVBfTFQsICgtMSkpKTsKICAgICAgICBp
ZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVs
c2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1BfUFJJVkFURSByZXR1cm5l
ZCAlZCB3aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2Fj
dGlvbiA9IDU7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAg
ciA9IGZ1dGV4KCZmMiwgRlVURVhfV0FLRV9PUF9QUklWQVRFLCAwLCAoc3Ry
dWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAgICAgICAgICAgICAgRlVURVhf
T1AoRlVURVhfT1BfU0VULCAoLTMpLCBGVVRFWF9PUF9DTVBfTEUsICgtMykp
KTsKICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QX1BSSVZBVEUg
cmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBy
ID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QX1BSSVZBVEUsIDAsIChzdHJ1
Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9P
UChGVVRFWF9PUF9TRVQsICgtMyksIEZVVEVYX09QX0NNUF9MRSwgKC0zKSkp
OwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBp
ZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
bykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUF9QUklW
QVRFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAg
ICB0aHJlYWRfYWN0aW9uID0gNTsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQo
KTsKICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtFX09QX1BSSVZB
VEUsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAgICAgICAgICAg
ICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgtNSksIEZVVEVYX09QX0NN
UF9MRSwgKC00KSkpOwogICAgICAgIGlmIChyKQogICAgICAgIHsKICAgICAg
ICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0Vf
T1BfUFJJVkFURSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNz
ZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsK
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAg
fQogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dBS0VfT1BfUFJJVkFU
RSwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICZmMSwKICAgICAgICAgICAg
ICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgKC01KSwgRlVURVhfT1BfQ01Q
X0xFLCAoLTQpKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAg
ICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxl
ZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9X
QUtFX09QX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHBy
b2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBy
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgfQogICAgICAgIHRocmVhZF9hY3Rpb24gPSA1OwogICAgICAgIHdhaXRf
Zm9yX3RocmVhZCgpOwogICAgICAgIHIgPSBmdXRleCgmZjIsIEZVVEVYX1dB
S0VfT1BfUFJJVkFURSwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICZmMSwK
ICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09QX1NFVCwgNCwgRlVU
RVhfT1BfQ01QX0dULCAoLTUpKSk7CiAgICAgICAgaWYgKHIpCiAgICAgICAg
ewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FLRV9PUF9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG5v
IHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMiwgRlVURVhfV0FLRV9P
UF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJmYxLAogICAg
ICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCA0LCBGVVRFWF9P
UF9DTVBfR1QsICgtNSkpKTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAg
IHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXgg
ZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBS0VfT1BfUFJJVkFURSByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBv
bmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDU7CiAgICAgICAg
d2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCZmMiwgRlVU
RVhfV0FLRV9PUF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwg
JmYxLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCA2
LCBGVVRFWF9PUF9DTVBfR0UsIDYpKTsKICAgICAgICBpZiAocikKICAgICAg
ICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4
IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFX09QX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcg
bm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRFWF9XQUtF
X09QX1BSSVZBVEUsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmZjEsCiAg
ICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDYsIEZVVEVY
X09QX0NNUF9HRSwgNikpOwogICAgICAgIGlmIChyICE9IDEpCiAgICAgICAg
ewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FLRV9PUF9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9u
ZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgIH0KICAgICAgICB0aHJlYWRfYWN0aW9uID0gNTsKICAgICAgICB3
YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRF
WF9XQUtFX09QX1BSSVZBVEUsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAm
ZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgx
IDw8IDQpLCBGVVRFWF9PUF9DTVBfTkUsIDYpKTsKICAgICAgICBpZiAocikK
ICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9XQUtFX09QX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3
YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgIH0KICAgICAgICByID0gZnV0ZXgoJmYyLCBGVVRF
WF9XQUtFX09QX1BSSVZBVEUsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAm
ZjEsCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsICgx
IDw8IDQpLCBGVVRFWF9PUF9DTVBfTkUsIDYpKTsKICAgICAgICBpZiAociAh
PSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfT1BfUFJJVkFURSByZXR1cm5lZCAlZCB3
aGVuIHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9
IDY7CiAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1
dGV4KCYoc2htZW0tPmY0KSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVjdCB0
aW1lc3BlYyAqKTIsICYoc2htZW0tPmYzKSwKICAgICAgICAgICAgICAgIEZV
VEVYX09QKEZVVEVYX09QX1NFVCwgMHhmZmYsIEZVVEVYX09QX0NNUF9ORSwg
MCkpOwogICAgICAgIGlmIChyKQogICAgICAgIHsKICAgICAgICAgICAgaWYg
KHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJu
ZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICByID0gZnV0
ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRp
bWVzcGVjICopMiwgJihzaG1lbS0+ZjMpLAogICAgICAgICAgICAgICAgRlVU
RVhfT1AoRlVURVhfT1BfU0VULCAweGZmZiwgRlVURVhfT1BfQ01QX05FLCAw
KSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAg
IGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJl
dHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICB0aHJl
YWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAg
ICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAw
LCAoc3RydWN0IHRpbWVzcGVjICopMiwgJihzaG1lbS0+ZjMpLAogICAgICAg
ICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAweGZmZSwgRlVURVhf
T1BfQ01QX0xULCAweGZmZikpOwogICAgICAgIGlmIChyKQogICAgICAgIHsK
ICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2Vz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09Q
LCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJihzaG1lbS0+ZjMpLAogICAg
ICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAweGZmZSwgRlVU
RVhfT1BfQ01QX0xULCAweGZmZikpOwogICAgICAgIGlmIChyICE9IDEpCiAg
ICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUg
cHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2Fp
dF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmY0
KSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICYo
c2htZW0tPmYzKSwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09Q
X1NFVCwgMHhmZmMsIEZVVEVYX09QX0NNUF9MRSwgMHhmZmMpKTsKICAgICAg
ICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4g
d2FraW5nIG5vIHByb2Nlc3Nlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0t
PmY0KSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIs
ICYoc2htZW0tPmYzKSwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVY
X09QX1NFVCwgMHhmZmMsIEZVVEVYX09QX0NNUF9MRSwgMHhmZmMpKTsKICAg
ICAgICBpZiAociAhPSAxKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHIg
PCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsK
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAg
ICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQg
JWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHRocmVhZF9hY3Rp
b24gPSA2OwogICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgIHIg
PSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1
Y3QgdGltZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAgICAg
ICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDB4ZmMwLCBGVVRFWF9PUF9DTVBf
TEUsIDB4ZmMxKSk7CiAgICAgICAgaWYgKHIpCiAgICAgICAgewogICAgICAg
ICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9P
UCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzZXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAg
IHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1AsIDAsIChz
dHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAg
ICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDB4ZmMwLCBGVVRFWF9PUF9D
TVBfTEUsIDB4ZmMxKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7
CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZh
aWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0K
ICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl90
aHJlYWQoKTsKICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRF
WF9XQUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJihzaG1lbS0+
ZjMpLAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCA5
OCwgRlVURVhfT1BfQ01QX0dULCA5NykpOwogICAgICAgIGlmIChyKQogICAg
ICAgIHsKICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0
ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IEZVVEVYX1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJv
Y2Vzc2VzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
cik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgIH0KICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9X
QUtFX09QLCAwLCAoc3RydWN0IHRpbWVzcGVjICopMiwgJihzaG1lbS0+ZjMp
LAogICAgICAgICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCA5OCwg
RlVURVhfT1BfQ01QX0dULCA5NykpOwogICAgICAgIGlmIChyICE9IDEpCiAg
ICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBvbmUg
cHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICB9CiAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgd2Fp
dF9mb3JfdGhyZWFkKCk7CiAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmY0
KSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKTIsICYo
c2htZW0tPmYzKSwKICAgICAgICAgICAgICAgIEZVVEVYX09QKEZVVEVYX09Q
X1NFVCwgMTAwLCBGVVRFWF9PUF9DTVBfR0UsIDk5KSk7CiAgICAgICAgaWYg
KHIpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2lu
ZyBubyBwcm9jZXNzZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCks
IEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNo
bWVtLT5mMyksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9T
RVQsIDEwMCwgRlVURVhfT1BfQ01QX0dFLCA5OSkpOwogICAgICAgIGlmIChy
ICE9IDEpCiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdh
a2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICB9CiAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9
IDY7CiAgICAgICAgd2FpdF9mb3JfY2hpbGQoKTsKICAgICAgICByID0gZnV0
ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAwLCAoc3RydWN0IHRp
bWVzcGVjICopMiwgJihzaG1lbS0+ZjMpLAogICAgICAgICAgICAgICAgRlVU
RVhfT1AoRlVURVhfT1BfU0VULCAweGZmZiwgRlVURVhfT1BfQ01QX05FLCAx
MDApKTsKICAgICAgICBpZiAocikKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVy
bmVkICVkIHdoZW4gd2FraW5nIG5vIHByb2Nlc3Nlc1xuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgciA9IGZ1
dGV4KCYoc2htZW0tPmY0KSwgRlVURVhfV0FLRV9PUCwgMCwgKHN0cnVjdCB0
aW1lc3BlYyAqKTIsICYoc2htZW0tPmYzKSwKICAgICAgICAgICAgICAgIEZV
VEVYX09QKEZVVEVYX09QX1NFVCwgMHhmZmYsIEZVVEVYX09QX0NNUF9ORSwg
MTAwKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09Q
IHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBz
aG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGls
ZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dB
S0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVtLT5mMyks
CiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDB4ZmZl
LCBGVVRFWF9PUF9DTVBfTFQsIDB4ZmZmKSk7CiAgICAgICAgaWYgKHIpCiAg
ICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBubyBw
cm9jZXNzZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVY
X1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVtLT5m
MyksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDB4
ZmZlLCBGVVRFWF9PUF9DTVBfTFQsIDB4ZmZmKSk7CiAgICAgICAgaWYgKHIg
IT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4gd2Fr
aW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgIH0KICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0g
NjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAgICAgIHIgPSBmdXRl
eCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGlt
ZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAgICAgICBGVVRF
WF9PUChGVVRFWF9PUF9TRVQsIDB4ZmZjLCBGVVRFWF9PUF9DTVBfTEUsIDB4
ZmZjKSk7CiAgICAgICAgaWYgKHIpCiAgICAgICAgewogICAgICAgICAgICBp
ZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
bykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1
cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzZXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBm
dXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3Qg
dGltZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAgICAgICBG
VVRFWF9PUChGVVRFWF9PUF9TRVQsIDB4ZmZjLCBGVVRFWF9PUF9DTVBfTEUs
IDB4ZmZjKSk7CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAg
ICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtF
X09QIHJldHVybmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAg
ICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9j
aGlsZCgpOwogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVY
X1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVtLT5m
MyksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDB4
ZmMwLCBGVVRFWF9PUF9DTVBfTEUsIDB4ZmYwKSk7CiAgICAgICAgaWYgKHIp
CiAgICAgICAgewogICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5lZCAlZCB3aGVuIHdha2luZyBu
byBwcm9jZXNzZXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCByKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9
CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZV
VEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVt
LT5mMyksCiAgICAgICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQs
IDB4ZmMwLCBGVVRFWF9PUF9DTVBfTEUsIDB4ZmYwKSk7CiAgICAgICAgaWYg
KHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlmIChyIDwgMCkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVybmVkICVkIHdoZW4g
d2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgIH0KICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9u
ID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAgICAgIHIgPSBm
dXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3Qg
dGltZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAgICAgICBG
VVRFWF9PUChGVVRFWF9PUF9TRVQsIDk4LCBGVVRFWF9PUF9DTVBfR1QsIDk3
KSk7CiAgICAgICAgaWYgKHIpCiAgICAgICAgewogICAgICAgICAgICBpZiAo
ciA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9PUCByZXR1cm5l
ZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzZXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHIgPSBmdXRl
eCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1AsIDAsIChzdHJ1Y3QgdGlt
ZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAgICAgICAgICAgICBGVVRF
WF9PUChGVVRFWF9PUF9TRVQsIDk4LCBGVVRFWF9PUF9DTVBfR1QsIDk3KSk7
CiAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICB7CiAgICAgICAgICAgIGlm
IChyIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX09QIHJldHVy
bmVkICVkIHdoZW4gd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICBzaG1lbS0+
Y2hpbGRfYWN0aW9uID0gNjsKICAgICAgICB3YWl0X2Zvcl9jaGlsZCgpOwog
ICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mNCksIEZVVEVYX1dBS0VfT1As
IDAsIChzdHJ1Y3QgdGltZXNwZWMgKikyLCAmKHNobWVtLT5mMyksCiAgICAg
ICAgICAgICAgICBGVVRFWF9PUChGVVRFWF9PUF9TRVQsIDEwMCwgRlVURVhf
T1BfQ01QX0dFLCA5OSkpOwogICAgICAgIGlmIChyKQogICAgICAgIHsKICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
S0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vzc2VzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAg
ICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjQpLCBGVVRFWF9XQUtFX09QLCAw
LCAoc3RydWN0IHRpbWVzcGVjICopMiwgJihzaG1lbS0+ZjMpLAogICAgICAg
ICAgICAgICAgRlVURVhfT1AoRlVURVhfT1BfU0VULCAxMDAsIEZVVEVYX09Q
X0NNUF9HRSwgOTkpKTsKICAgICAgICBpZiAociAhPSAxKQogICAgICAgIHsK
ICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBS0VfT1AgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgb25lIHByb2Nlc3Nc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQog
ICAgfQogICAgLyogRlVURVhfTE9DS19QSSwgRlVURVhfVU5MT0NLX1BJLCBh
bmQgRlVURVhfVFJZTE9DS19QSSBhcmUgYWxzbyBub3QgZG9jdW1lbnRlZC4K
ICAgICAqIExvb2tpbmcgYXQgRG9jdW1lbnRhdGlvbi9waS1mdXRleC50eHQg
YW5kIHRoZSBrZXJuZWwgY29kZSwKICAgICAqIHdlIGZpbmQgdGhhdCBGVVRF
WF9MT0NLX1BJIGRvZXM6LQogICAgICogSWYgKmFyZzEgaXMgMCwgaXQgaXMg
c2V0IHRvIHRoaXMgdGFzaydzIFRJRCBhbmQgMCBpcyByZXR1cm5lZC4KICAg
ICAqIElmICphcmcxIGlzIGFscmVhZHkgdGhpcyB0YXNrJ3MgVElELCAtRURF
QURMSyBpcyByZXR1cm5lZC4KICAgICAqIElmICphcmcxIGlzIG5vdCBzb21l
IG90aGVyIHRhc2sncyBUSUQsIC1FU1JDSCBpcyByZXR1cm5lZC4KICAgICAq
IElmICphcmcxIGlzIHNvbWUgb3RoZXIgdGFzaydzIFRJRCwKICAgICAqICAg
ICBUaGF0IHRhc2sncyBwcmlvcml0eSBpcyByYWlzZWQgaWYgbmVjZXNzYXJ5
IHRvIHRoaXMgdGFzaydzIHByaW9yaXR5LAogICAgICogICAgICAgICAod2Ug
ZG9uJ3QgdGVzdCB0aGlzKS4KICAgICAqICAgICBUaGlzIHRhc2sgd2FpdHMg
dW50aWwgdGhlIG90aGVyIHRhc2sgZG9lcyBGVVRFWF9VTkxPQ0tfUEkuCiAg
ICAgKiAgICAgSWYgYXJnNCBpcyBub3QgTlVMTCBpdCBpcyBhIHRpbWVvdXQg
YW5kIGlmIGl0IHRpbWVzIG91dCBFVElNRURPVVQKICAgICAqICAgICAgICAg
IGlzIHJldHVybmVkCiAgICAgKiAgICAgV2hlbiB0aGUgb3RoZXIgdGFzayBk
b2VzIEZVVEVYX1VOTE9DS19QSS4KICAgICAqICAgICAgICAgICphcmcxIGlz
IHNldCB0byB0aGlzIHRhc2sncyBUSUQKICAgICAqICAgICAgICAgIDAgaXMg
cmV0dXJuZWQuCiAgICAgKiBMb29raW5nIGF0IERvY3VtZW50YXRpb24vcGkt
ZnV0ZXgudHh0IGFuZCB0aGUga2VybmVsIGNvZGUsCiAgICAgKiB3ZSBmaW5k
IHRoYXQgRlVURVhfVU5MT0NLX1BJIGRvZXM6LQogICAgICogSWYgKmFyZzEg
aXMgdGhpcyB0YXNrJ3MgVElELCAwIGlzIHJldHVybmVkIGFuZCAqYXJnMSBp
cyBjbGVhcmVkLi4KICAgICAqIElmICphcmcxIGlzIHRoaXMgdGFzaydzIFRJ
RCArIEZVVEVYX1dBSVRFUlMsLgogICAgICogICAgIFRoYXQgdGFzaydzIHBy
aW9yaXR5IGlzIGxvd2VyZWQgaWYgbmVjZXNzYXJ5IHRvIHdoYXQgaXMgd2Fz
IGJlZm9yZSwKICAgICAqICAgICAgICAgKHdlIGRvbid0IHRlc3QgdGhpcyku
CiAgICAgKiAgICAgVGhlIGhpZ2hlc3QgcHJpb3JpdHkgdGFzayB3YWl0aW5n
IGZvciBhcmcxIGlzIHdha2VuZWQsICphcmcxIGlzIHNldAogICAgICogICAg
ICAgICAgdG8gaXRzIFRJRC4gYW5kIGl0cyBGVVRFWF9MT0NLX1BJIG9wZXJh
dGlvbiByZXR1cm5zIDAuCiAgICAgKiAgICAgTWVhbndoaWxlIHRoaXMgdGFz
aydzIEZVVEVYX1VOTE9DS19QSSByZXR1cm5zIDAuCiAgICAgKiBJZiAqYXJn
MSBpcyBhbnl0aGluZyBlbHNlLCAtRVBFUk0gaXMgcmV0dXJuZWQKICAgICAq
IExvb2tpbmcgYXQgRG9jdW1lbnRhdGlvbi9waS1mdXRleC50eHQgYW5kIHRo
ZSBrZXJuZWwgY29kZSwKICAgICAqIHdlIGZpbmQgdGhhdCBGVVRFWF9UUllM
T0NLX1BJIGRvZXM6LQogICAgICogSWYgKmFyZzEgaXMgMCwgaXQgaXMgc2V0
IHRvIHRoaXMgdGFzaydzIFRJRCBhbmQgMCBpcyByZXR1cm5lZC4KICAgICAq
IElmICphcmcxIGlzIGFscmVhZHkgdGhpcyB0YXNrJ3MgVElELCAtRURFQURM
SyBpcyByZXR1cm5lZC4KICAgICAqIElmICphcmcxIGlzIG5vdCBzb21lIG90
aGVyIHRhc2sncyBUSUQsIC1FU1JDSCBpcyByZXR1cm5lZC4KICAgICAqIElm
ICphcmcxIGlzIHNvbWUgb3RoZXIgdGFzaydzIFRJRCwgLUVXT1VMREJMT0NL
IGlzIHJldHVybmVkLgogICAgICovCiAgICBmMSA9IDA7CiAgICBpbnQgdHJ5
bG9jayA9IGZ1dGV4KCZmMSwgRlVURVhfVFJZTE9DS19QSSwgMCwgTlVMTCwg
TlVMTCwgMCk7CiAgICBpZiAodHJ5bG9jaykKICAgIHsKICAgICAgICBpZiAo
ZXJybm8gPT0gRU5PU1lTKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJGVVRFWF9UUllMT0NLX1BJIG5vdCBzdXBwb3J0ZWQgaW4g
dGhpcyBrZXJuZWxcbiIpOwogICAgICAgICAgICAvKiBub3QgZmF0YWwgKi8K
ICAgICAgICB9CiAgICAgICAgZWxzZQogICAgICAgIHsKICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CiAgICB9CiAgICBlbHNl
CiAgICB7CiAgICAgICAgaWYgKGYxICE9IHBhcmVudF9waWQpCiAgICAgICAg
ewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfVFJZTE9DS19QSSBzZXQgKmFyZzEgdG8gJWQgaW5zdGVhZCBvZiAlZFxu
IiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgZjEsIHBhcmVudF9w
aWQpOwogICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgIH0KICAgICAgICAvKiBJdCBp
c24ndCBwbGF1c2libGUgdGhhdCBhIGtlcm5lbCBzdXBwb3J0cyBGVVRFWF9U
UllMT0NLX1BJIGJ1dCBub3QKICAgICAgICAgKiBGVVRFWF9VTkxPQ0tfUEku
IElmIHRoaXMgaGFwcGVucywgd2UgY2F0Y2ggaXQgYmVsb3cuCiAgICAgICAg
ICovCiAgICAgICAgKHZvaWQpZnV0ZXgoJmYxLCBGVVRFWF9VTkxPQ0tfUEks
IDAsIE5VTEwsIE5VTEwsIDApOwogICAgfQogICAgciA9IGZ1dGV4KCZmMSwg
RlVURVhfTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICBpZiAoKHIg
PCAwKSAmJiAoZXJybm8gPT0gRU5PU1lTKSkKICAgIHsKICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkZVVEVYX0xPQ0tfUEkgbm90IHN1cHBvcnRlZCBpbiB0
aGlzIGtlcm5lbFxuIik7CiAgICAgICAgLyogbm90IGZhdGFsICovCiAgICB9
CiAgICBlbHNlCiAgICB7CiAgICAgICAgaWYgKHIpCiAgICAgICAgewogICAg
ICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfTE9D
S19QSSByZXR1cm5lZCAlZCBpbnN0ZWFkIG9mIDBcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIGlmIChmMSAh
PSBwYXJlbnRfcGlkKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0xPQ0tfUEkgc2V0ICphcmcxIHRv
ICVkIGluc3RlYWQgb2YgJWRcbiIsCiAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIGYxLCBwYXJlbnRfcGlkKTsKICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfTE9DS19QSSwgMCwg
TlVMTCwgTlVMTCwgMCk7CiAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJu
byAhPSBFREVBRExLKSkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NLX1BJIHdpdGggZGVhZGxv
Y2sgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihF
REVBRExLKSk7CiAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgfQogICAgICAgIGlm
ICh0cnlsb2NrKQogICAgICAgIHsKICAgICAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfVFJZTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAg
ICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRURFQURMSykpCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9UUllMT0NLX1BJIHdpdGggZGVhZGxvY2sgcmV0
dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRURF
QURMSykpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfVU5MT0NL
X1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICBpZiAoKHIgPCAwKSAm
JiAoZXJybm8gPT0gRU5PU1lTKSkKICAgICAgICB7CiAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiRlVURVhfVU5MT0NLX1BJIG5vdCBzdXBwb3J0ZWQg
aW4gdGhpcyBrZXJuZWxcbiIpOwogICAgICAgICAgICAvKiBub3QgZmF0YWwg
Ki8KICAgICAgICB9CiAgICAgICAgZWxzZQogICAgICAgIHsKICAgICAgICAg
ICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgcmV0dXJuZWQgJWQgaW5z
dGVhZCBvZiAwXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHIpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3Bp
ZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAgICBpZiAo
ZjEpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgd2l0aCBubyB3YWl0
ZXJzIGRpZCBub3QgY2xlYXIgKmFyZzEgKCVpKVxuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIGYxKTsKICAgICAgICAgICAgICAgIHRr
aWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1VOTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAg
ICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVBFUk0pKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfVU5MT0NLX1BJIHdpdGggbm8gbG9jayByZXR1cm5lZCAl
cyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFUEVSTSkpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgciA9IGZ1dGV4KE5VTEwsIEZVVEVYX0xPQ0tfUEksIDAsIE5VTEwsIE5V
TEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9
IEVGQVVMVCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NLX1BJIHdpdGggYmFk
IGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwg
c3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoTlVMTCwgRlVURVhf
TE9DS19QSV9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAg
ICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgRlVURVhfTE9DS19QSV9QUklWQVRFIHdpdGggYmFkIGFkZHJlc3Mg
cmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKTgsIEZVVEVYX0xPQ0tf
UEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0g
MCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9M
T0NLX1BJIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0
ZXgoKGludCAqKTgsIEZVVEVYX0xPQ0tfUElfUFJJVkFURSwgMCwgTlVMTCwg
TlVMTCwgMCk7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8g
IT0gRUZBVUxUKSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0xPQ0tfUElfUFJJVkFU
RSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KChp
bnQgKil1cHJpdiwgRlVURVhfTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7
CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxU
KSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIEZVVEVYX0xPQ0tfUEkgd2l0aCBiYWQgYWRkcmVz
cyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJv
cihFRkFVTFQpKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgoaW50ICopdXByaXYsIEZVVEVY
X0xPQ0tfUElfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAg
ICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX0xPQ0tfUElfUFJJVkFURSB3aXRoIGJhZCBhZGRyZXNz
IHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9y
KEVGQVVMVCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoMSArIChjaGFyICop
JmYxKSwgRlVURVhfTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAg
ICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX0xPQ0tfUEkgd2l0aCBtaXNhbGlnbmVkIGFkZHJl
c3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJy
b3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKSgxICsgKGNoYXIg
KikmZjEpLCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEws
IDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJ
TlZBTCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUgd2l0
aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgo
KGludCAqKSgxICsgKGNoYXIgKikmKHNobWVtLT5mMykpLCBGVVRFWF9MT0NL
X1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgaWYgKChyID49
IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
TE9DS19QSSB3aXRoIG1pc2FsaWduZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBp
bnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAg
IHIgPSBmdXRleCgoaW50ICopKDQwOTQgKyAoY2hhciAqKSYoc2htZW0tPmYz
KSksIEZVVEVYX0xPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAg
ICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICAg
ICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9MT0NLX1BJIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNz
IHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9y
KEVJTlZBTCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfTE9DS19QSSwg
MCwgKHN0cnVjdCB0aW1lc3BlYyAqKTgsIE5VTEwsIDApOwogICAgICAgICAg
ICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9MT0NLX1BJIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQg
JXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUsIDAs
IChzdHJ1Y3QgdGltZXNwZWMgKik4LCBOVUxMLCAwKTsKICAgICAgICAgICAg
aWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfTE9DS19QSV9QUklWQVRFIHdpdGggYmFkIGFkZHJlc3MgcmV0
dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZB
VUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9MT0NLX1BJLCAwLCAo
c3RydWN0IHRpbWVzcGVjICopdXByaXYsIE5VTEwsIDApOwogICAgICAgICAg
ICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGlu
ZSAlZCBGVVRFWF9MT0NLX1BJIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQg
JXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUsIDAs
IChzdHJ1Y3QgdGltZXNwZWMgKil1cHJpdiwgTlVMTCwgMCk7CiAgICAgICAg
ICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX0xPQ0tfUElfUFJJVkFURSB3aXRoIGJhZCBhZGRyZXNz
IHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9y
KEVGQVVMVCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
IH0KICAgICAgICAgICAgaWYgKHRyeWxvY2spCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIHIgPSBmdXRleChOVUxMLCBGVVRFWF9UUllMT0NLX1BJ
LCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfVFJZTE9DS19QSSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVk
ICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFV
TFQpKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoTlVMTCwgRlVU
RVhfVFJZTE9DS19QSV9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAg
ICAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxU
KSkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfVFJZTE9DS19QSV9QUklW
QVRFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgICAgIHIgPSBmdXRleCgoaW50ICopOCwgRlVURVhfVFJZTE9DS19Q
SSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICBpZiAoKHIg
Pj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1RSWUxPQ0tfUEkgd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5l
ZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZB
VUxUKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICAgICAgfQogICAgICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKik4
LCBGVVRFWF9UUllMT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDAp
OwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBF
RkFVTFQpKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9UUllMT0NLX1BJ
X1BSSVZBVEUgd2l0aCBiYWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFk
IG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAg
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQog
ICAgICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKil1cHJpdiwgRlVURVhf
VFJZTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgICAg
ICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1RSWUxPQ0tfUEkgd2l0aCBiYWQgYWRkcmVz
cyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3Ry
ZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgciA9IGZ1dGV4
KChpbnQgKil1cHJpdiwgRlVURVhfVFJZTE9DS19QSV9QUklWQVRFLCAwLCBO
VUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlmICgociA+PSAwKSB8
fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfVFJZTE9DS19QSV9QUklWQVRFIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJu
ZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVG
QVVMVCkpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgICAgIH0KICAgICAgICAgICAgICAgIHIgPSBmdXRleCgoaW50ICop
KDEgKyAoY2hhciAqKSZmMSksIEZVVEVYX1RSWUxPQ0tfUEksIDAsIE5VTEws
IE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChl
cnJubyAhPSBFSU5WQUwpKQogICAgICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9U
UllMT0NLX1BJIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwp
KTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKSgxICsg
KGNoYXIgKikmZjEpLCBGVVRFWF9UUllMT0NLX1BJX1BSSVZBVEUsIDAsIE5V
TEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8
IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9UUllMT0NLX1BJX1BSSVZBVEUgd2l0aCBtaXNhbGlnbmVkIGFkZHJlc3Mg
cmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVy
cm9yKEVJTlZBTCkpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIHIgPSBmdXRleCgo
aW50ICopKDEgKyAoY2hhciAqKSYoc2htZW0tPmYzKSksIEZVVEVYX1RSWUxP
Q0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9UUllMT0NLX1BJIHdpdGggbWlzYWxpZ25lZCBhZGRy
ZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBz
dHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0
ZXgoKGludCAqKSg0MDk0ICsgKGNoYXIgKikmKHNobWVtLT5mMykpLCBGVVRF
WF9UUllMT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAg
ICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfVFJZTE9DS19QSSB3aXRoIG1pc2FsaWdu
ZWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAg
ICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0xPQ0tfUElfUFJJVkFU
RSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgIGlmIChyKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwog
ICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAg
IH0KICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
RlVURVhfTE9DS19QSV9QUklWQVRFIHJldHVybmVkICVkIGluc3RlYWQgb2Yg
MFxuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBy
KTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgICAgaWYgKGYxICE9IHBh
cmVudF9waWQpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUg
c2V0ICphcmcxIHRvICVkIGluc3RlYWQgb2YgJWRcbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBmMSwgcGFyZW50X3BpZCk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEws
IE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5v
ICE9IEVERUFETEspKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfTE9DS19QSV9QUklW
QVRFIHdpdGggZGVhZGxvY2sgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSwgc3RyZXJyb3IoRURFQURMSykpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgaWYgKHRyeWxvY2sp
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIHIgPSBmdXRleCgmZjEs
IEZVVEVYX1RSWUxPQ0tfUElfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7
CiAgICAgICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVE
RUFETEspKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9UUllMT0NLX1BJ
X1BSSVZBVEUgd2l0aCBkZWFkbG9jayByZXR1cm5lZCAlcyBpbnN0ZWFkIG9m
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRURFQURMSykpOwogICAgICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAg
ICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoTlVMTCwgRlVURVhf
VU5MT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgaWYg
KChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
RlVURVhfVU5MT0NLX1BJIHdpdGggYmFkIGFkZHJlc3MgcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAg
ICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAg
ICByID0gZnV0ZXgoTlVMTCwgRlVURVhfVU5MT0NLX1BJX1BSSVZBVEUsIDAs
IE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tf
UElfUFJJVkFURSB3aXRoIGJhZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3Rl
YWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9
IGZ1dGV4KChpbnQgKik4LCBGVVRFWF9VTkxPQ0tfUEksIDAsIE5VTEwsIE5V
TEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9
IEVGQVVMVCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgd2l0aCBi
YWQgYWRkcmVzcyByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
LCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgoaW50ICopOCwg
RlVURVhfVU5MT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDApOwog
ICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkp
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUElfUFJJVkFURSB3aXRoIGJh
ZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyks
IHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKil1cHJp
diwgRlVURVhfVU5MT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAg
ICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0
IGxpbmUgJWQgRlVURVhfVU5MT0NLX1BJIHdpdGggYmFkIGFkZHJlc3MgcmV0
dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZB
VUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKXVwcml2LCBGVVRFWF9VTkxP
Q0tfUElfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAg
IGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1VOTE9DS19QSV9QUklWQVRFIHdpdGggYmFkIGFkZHJlc3Mg
cmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgICAgICAqKGludCAqKSgxICsgKGNoYXIgKikmZjEpID0gcGFy
ZW50X3BpZDsKICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoMSArIChj
aGFyICopJmYxKSwgRlVURVhfVU5MT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAw
KTsKICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5W
QUwpKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfVU5MT0NLX1BJIHdpdGggbWlzYWxp
Z25lZCBhZGRyZXNzIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
byksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKiko
MSArIChjaGFyICopJmYxKSwgRlVURVhfVU5MT0NLX1BJX1BSSVZBVEUsIDAs
IE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwg
KGVycm5vICE9IEVJTlZBTCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tf
UElfUFJJVkFURSB3aXRoIG1pc2FsaWduZWQgYWRkcmVzcyByZXR1cm5lZCAl
cyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsK
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAg
ICAgICooaW50ICopKDEgKyAoY2hhciAqKSYoc2htZW0tPmYzKSkgPSBwYXJl
bnRfcGlkOwogICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKSgxICsgKGNo
YXIgKikmKHNobWVtLT5mMykpLCBGVVRFWF9VTkxPQ0tfUEksIDAsIE5VTEws
IE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5v
ICE9IEVJTlZBTCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgd2l0
aCBtaXNhbGlnbmVkIGFkZHJlc3MgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBmMSA9IHBhcmVu
dF9waWQ7CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1VOTE9D
S19QSV9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAg
aWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChyIDwg
MCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQogICAgICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUElfUFJJVkFURSByZXR1cm5lZCAl
ZCBpbnN0ZWFkIG9mIDBcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgICAg
IGlmIChmMSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1VOTE9DS19QSV9QUklWQVRF
IHdpdGggbm8gd2FpdGVycyBkaWQgbm90IGNsZWFyICphcmcxICglaSlcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBmMSk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9VTkxPQ0tfUElfUFJJVkFURSwgMCwgTlVM
TCwgTlVMTCwgMCk7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJy
bm8gIT0gRVBFUk0pKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfVU5MT0NLX1BJX1BS
SVZBVEUgd2l0aCBubyBsb2NrIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVQRVJNKSk7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBpZiAodHJ5bG9jaykK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwg
RlVURVhfVFJZTE9DS19QSV9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAwKTsK
ICAgICAgICAgICAgICAgIGlmIChyKQogICAgICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgICAgIGVsc2UKICAg
ICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9UUllMT0NLX1BJX1BS
SVZBVEUgcmV0dXJuZWQgJWQgaW5zdGVhZCBvZiAwXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBpZiAo
ZjEgIT0gcGFyZW50X3BpZCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
VFJZTE9DS19QSV9QUklWQVRFIHNldCAqYXJnMSB0byAlZCBpbnN0ZWFkIG9m
ICVkXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IGYxLCBwYXJlbnRfcGlkKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICByID0gZnV0
ZXgoJmYxLCBGVVRFWF9MT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEws
IDApOwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChyICE9IEVE
RUFETEspKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NLX1BJX1BS
SVZBVEUgd2l0aCBkZWFkbG9jayByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRURFQURMSykpOwogICAgICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1RSWUxPQ0tfUElfUFJJ
VkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICBpZiAo
KHIgPj0gMCkgfHwgKHIgIT0gRURFQURMSykpCiAgICAgICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1RSWUxPQ0tfUElfUFJJVkFURSB3aXRoIGRlYWRsb2NrIHJl
dHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJv
cihFREVBRExLKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfVU5MT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDAp
OwogICAgICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1VOTE9DS19QSV9Q
UklWQVRFIHJldHVybmVkICVkIGluc3RlYWQgb2YgMFxuIiwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAg
ICAgICAgfQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgaWYg
KGYxKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUElfUFJJ
VkFURSB3aXRoIG5vIHdhaXRlcnMgZGlkIG5vdCBjbGVhciAqYXJnMSAoJWkp
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIGYx
KTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgICAgc2htZW0tPmYzID0g
MDsKICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKikmKHNobWVtLT5mMyks
IEZVVEVYX0xPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAg
ICBpZiAocikKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWYgKHIg
PCAwKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX0xPQ0tfUEkgcmV0dXJuZWQgJWQgaW5zdGVh
ZCBvZiAwXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAgICBpZiAoc2ht
ZW0tPmYzICE9IHBhcmVudF9waWQpCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NL
X1BJIHNldCAqYXJnMSB0byAlZCBpbnN0ZWFkIG9mICVkXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc2htZW0tPmYzLCBwYXJlbnRf
cGlkKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX0xPQ0tf
UEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0g
MCkgfHwgKGVycm5vICE9IEVERUFETEspKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
TE9DS19QSSB3aXRoIGRlYWRsb2NrIHJldHVybmVkICVzIGluc3RlYWQgb2Yg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubyksIHN0cmVycm9yKEVERUFETEspKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGlmICh0cnls
b2NrKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgo
JihzaG1lbS0+ZjMpLCBGVVRFWF9UUllMT0NLX1BJLCAwLCBOVUxMLCBOVUxM
LCAwKTsKICAgICAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8g
IT0gRURFQURMSykpCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1RSWUxP
Q0tfUEkgd2l0aCBkZWFkbG9jayByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRURFQURMSykpOwogICAgICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBG
VVRFWF9VTkxPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAg
ICBpZiAocikKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWYgKHIg
PCAwKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1VOTE9DS19QSSByZXR1cm5lZCAlZCBpbnN0
ZWFkIG9mIDBcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgcik7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgICAgIGlmIChz
aG1lbS0+ZjMpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgd2l0aCBu
byB3YWl0ZXJzIGRpZCBub3QgY2xlYXIgKmFyZzEgKCVpKVxuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHNobWVtLT5mMyk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9VTkxPQ0tfUEksIDAsIE5V
TEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVy
cm5vICE9IEVQRVJNKSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1VOTE9DS19QSSB3
aXRoIG5vIGxvY2sgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSwgc3RyZXJyb3IoRVBFUk0pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIGlmICh0cnlsb2NrKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKSYoc2ht
ZW0tPmYzKSwgRlVURVhfVFJZTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7
CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykp
OwogICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAgICBlbHNlCiAg
ICAgICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfVFJZTE9DS19QSSBy
ZXR1cm5lZCAlZCBpbnN0ZWFkIG9mIDBcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgICAgIH0K
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGlmIChzaG1lbS0+
ZjMgIT0gcGFyZW50X3BpZCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
VFJZTE9DS19QSSBzZXQgKmFyZzEgdG8gJWQgaW5zdGVhZCBvZiAlZFxuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzaG1lbS0+
ZjMsIHBhcmVudF9waWQpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIHIgPSBmdXRl
eCgmKHNobWVtLT5mMyksIEZVVEVYX0xPQ0tfUEksIDAsIE5VTEwsIE5VTEws
IDApOwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChyICE9IEVE
RUFETEspKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9MT0NLX1BJIHdp
dGggZGVhZGxvY2sgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVERUFETEspKTsKICAgICAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9UUllMT0NLX1BJLCAw
LCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlmICgociA+PSAw
KSB8fCAociAhPSBFREVBRExLKSkKICAgICAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfVFJZTE9DS19QSSB3aXRoIGRlYWRsb2NrIHJldHVybmVkICVzIGluc3Rl
YWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFREVBRExLKSk7CiAg
ICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAg
fQogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVU
RVhfVU5MT0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAg
ICAgIGlmIChyKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICAg
ICAgfQogICAgICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgcmV0dXJuZWQgJWQgaW5z
dGVhZCBvZiAwXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICB9CiAgICAgICAgICAgICAgICBpZiAoc2htZW0tPmYzKQogICAgICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9VTkxPQ0tfUEkgd2l0aCBubyB3YWl0ZXJzIGRp
ZCBub3QgY2xlYXIgKmFyZzEgKCVpKVxuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzaG1lbS0+ZjMpOwogICAgICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAg
ICAgfQogICAgICAgICAgICBmMSA9IGZvcmsoKTsKICAgICAgICAgICAgaWYg
KGYxIDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZvcmsgZmFpbGVkICVzXG4iLCBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UgaWYgKGYxID09IDAp
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGV4aXQoMCk7CiAgICAg
ICAgICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBpbnQgc3RhdHVzOwogICAgICAgICAgICAgICAgciA9IHdh
aXRwaWQoZjEsICZzdGF0dXMsIDApOwogICAgICAgICAgICAgICAgaWYgKHIg
PCAwKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCB3YWl0cGlkIGZhaWxlZCAlc1xu
IiwgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAg
ICB9CiAgICAgICAgICAgIC8qIEF0IHRoaXMgcG9pbnQgZjEgaXMgdGhlIHBp
ZCBvZiBhIHByb2Nlc3Mgd2hpY2ggaGFzIGp1c3QgZXhpdGVkLgogICAgICAg
ICAgICAgKiBVbmxlc3MgdGhlIHN5c3RlbSBpcyAqdmVyeSogYnVzeSBhbmQg
aGFzIGFscmVhZHkgcmVjeWNsZWQgaXQuCiAgICAgICAgICAgICAqIGYxIGlz
IG5vdCB0aGUgcGlkIG9mIGFueSBwcm9jZXNzLgogICAgICAgICAgICAgKi8K
ICAgICAgICAgICAgc2htZW0tPmYzID0gZjE7CiAgICAgICAgICAgIHIgPSBm
dXRleCgmZjEsIEZVVEVYX0xPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwog
ICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVTUkNIKSkK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX0xPQ0tfUEkgd2l0aCBpbnZhbGlkIHBpZCBy
ZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihF
U1JDSCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfTE9D
S19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRVNSQ0gpKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
TE9DS19QSSB3aXRoIGludmFsaWQgcGlkIHJldHVybmVkICVzIGluc3RlYWQg
b2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVTUkNIKSk7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBpZiAodHJ5
bG9jaykKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZjEgPSBmb3Jr
KCk7CiAgICAgICAgICAgICAgICBpZiAoZjEgPCAwKQogICAgICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBmb3JrIGZhaWxlZCAlc1xuIiwgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZSBpZiAoZjEgPT0g
MCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBleGl0
KDApOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGludCBzdGF0
dXM7CiAgICAgICAgICAgICAgICAgICAgciA9IHdhaXRwaWQoZjEsICZzdGF0
dXMsIDApOwogICAgICAgICAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAg
ICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCB3YWl0cGlkIGZhaWxlZCAlc1xuIiwg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICAgICAgfQog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgc2htZW0tPmYzID0g
ZjE7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9UUllM
T0NLX1BJLCAwLCBOVUxMLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVNSQ0gpKQogICAgICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9UUllMT0NLX1BJIHdpdGggaW52YWxpZCBwaWQgcmV0
dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9y
KEVTUkNIKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlk
LCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2ht
ZW0tPmYzKSwgRlVURVhfVFJZTE9DS19QSSwgMCwgTlVMTCwgTlVMTCwgMCk7
CiAgICAgICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVT
UkNIKSkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfVFJZTE9DS19QSSB3
aXRoIGludmFsaWQgcGlkIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFU1JDSCkpOwogICAgICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAg
fQogICAgICAgICAgICBmMSA9IGZvcmsoKTsKICAgICAgICAgICAgaWYgKGYx
IDwgMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZvcmsgZmFpbGVkICVzXG4iLCBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UgaWYgKGYxID09IDApCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGV4aXQoMCk7CiAgICAgICAg
ICAgIH0KICAgICAgICAgICAgZWxzZQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBpbnQgc3RhdHVzOwogICAgICAgICAgICAgICAgciA9IHdhaXRw
aWQoZjEsICZzdGF0dXMsIDApOwogICAgICAgICAgICAgICAgaWYgKHIgPCAw
KQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCB3YWl0cGlkIGZhaWxlZCAlc1xuIiwg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9
CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0xPQ0tfUElfUFJJ
VkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRVNSQ0gpKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
TE9DS19QSV9QUklWQVRFIHdpdGggaW52YWxpZCBwaWQgcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRVNSQ0gpKTsKICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAg
IGlmICh0cnlsb2NrKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBm
MSA9IGZvcmsoKTsKICAgICAgICAgICAgICAgIGlmIChmMSA8IDApCiAgICAg
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRl
cnIsICJBdCBsaW5lICVkIGZvcmsgZmFpbGVkICVzXG4iLCBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlIGlm
IChmMSA9PSAwKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ICAgIGV4aXQoMCk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICBlbHNlCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAg
aW50IHN0YXR1czsKICAgICAgICAgICAgICAgICAgICByID0gd2FpdHBpZChm
MSwgJnN0YXR1cywgMCk7CiAgICAgICAgICAgICAgICAgICAgaWYgKHIgPCAw
KQogICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIHdhaXRwaWQgZmFpbGVk
ICVzXG4iLCBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAg
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICByID0g
ZnV0ZXgoJmYxLCBGVVRFWF9UUllMT0NLX1BJX1BSSVZBVEUsIDAsIE5VTEws
IE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChl
cnJubyAhPSBFU1JDSCkpCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1RS
WUxPQ0tfUElfUFJJVkFURSB3aXRoIGludmFsaWQgcGlkIHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFU1JDSCkp
OwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
ICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAgICBmMSA9IDA7CiAgICAg
ICAgICAgIHRocmVhZF9hY3Rpb24gPSA3OwogICAgICAgICAgICB3YWl0X2Zv
cl90aHJlYWQoKTsKICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhf
TE9DS19QSSwgMCwgJlRFTl9tcywgTlVMTCwgMCk7CiAgICAgICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVRJTUVET1VUKSkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX0xPQ0tfUEkgc2hvdWxkIHRpbWUgb3V0IHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVUSU1FRE9VVCkp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICAgICAgaWYgKHRyeWxvY2spCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1RSWUxPQ0tfUEksIDAsIE5VTEws
IE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChl
cnJubyAhPSBFV09VTERCTE9DSykpCiAgICAgICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1RSWUxPQ0tfUEkgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVXT1VMREJMT0NLKSk7CiAgICAgICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICB9CiAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxMDsKICAgICAg
ICAgICAgaW50IGNvdW50OwogICAgICAgICAgICBmb3IgKGNvdW50ID0gMDsg
Y291bnQgPCAxMDA7ICsrY291bnQpCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX0xPQ0tfUEksIDAsICZPTkVf
c2VjLCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlmIChyKQogICAgICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGlmICgoZXJybm8gPT0g
RVRJTUVET1VUKSAmJiAoY291bnQgPCA5OSkpCiAgICAgICAgICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgICAgICAgICBpZiAoKGNvdW50ID09IDAp
ICYmICh0aHJlYWRfYWN0aW9uID09IDEwKSkKICAgICAgICAgICAgICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJLRVJORUxCVUc/IEZVVEVYX0xPQ0tfUEkgd2l0aCB0aW1lciBy
ZXR1cm5zIEVUSU1FRE9VVCBpbW1lZGlhdGVseVxuIik7CiAgICAgICAgICAg
ICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAgICAgICAgLyogR2l2
ZSB0aGUgdGhyZWFkIHNvbWUgdGltZSB0byBkbyBpdC4gKi8KICAgICAgICAg
ICAgICAgICAgICAgICAgaWYgKG5hbm9zbGVlcCgmVEVOX21zLCBOVUxMKSkK
ICAgICAgICAgICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIG5hbm9zbGVl
cCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAgICAgICAgY29u
dGludWU7CiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAg
ICAgIGVsc2UKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBm
YWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICAgICAgfQog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgYnJlYWs7CiAgICAg
ICAgICAgIH0KICAgICAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDE2OwogICAg
ICAgICAgICB3YWl0X2Zvcl90aHJlYWQoKTsKICAgICAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfV0FLRSwgMSwgTlVMTCwgTlVMTCwgMCk7CiAgICAg
ICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0Ugb24gcGktbG9ja2VkIHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9CSVRTRVQsIDEsIE5VTEws
IE5VTEwsIDEpOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKChlcnJu
byAhPSBFSU5WQUwpICYmIChlcnJubyAhPSBFTk9TWVMpKSkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBS0VfQklUU0VUIG9uIHBpLWxvY2tlZCByZXR1cm5lZCAl
cyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsK
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAg
ICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1VOTE9DS19QSSwgMCwgTlVMTCwg
TlVMTCwgMCk7CiAgICAgICAgICAgIGlmIChyKQogICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0
ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJ
TkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAx
OTsKICAgICAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAg
IGlmIChmMSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGYxIGlzICVkIGluc3RlYWQgb2YgemVy
byBhZnRlciB1bmxvY2tpbmdcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBmMSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9w
aWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgfQogICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gODsKICAgICAg
ICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIHIgPSBmdXRl
eCgmZjEsIEZVVEVYX0xPQ0tfUElfUFJJVkFURSwgMCwgJlRFTl9tcywgTlVM
TCwgMCk7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0g
RVRJTUVET1VUKSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX0xPQ0tfUElfUFJJVkFU
RSBzaG91bGQgdGltZSBvdXQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSwgc3RyZXJyb3IoRVRJTUVET1VUKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBpZiAodHJ5bG9j
aykKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfVFJZTE9DS19QSV9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAw
KTsKICAgICAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0g
RVdPVUxEQkxPQ0spKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9UUllM
T0NLX1BJX1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubyksIHN0cmVycm9yKEVXT1VMREJMT0NLKSk7CiAgICAgICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICB9CiAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxMTsKICAgICAg
ICAgICAgZm9yIChjb3VudCA9IDA7IGNvdW50IDwgMTAwOyArK2NvdW50KQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBG
VVRFWF9MT0NLX1BJX1BSSVZBVEUsIDAsICZPTkVfc2VjLCBOVUxMLCAwKTsK
ICAgICAgICAgICAgICAgIGlmIChyKQogICAgICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgICAgIGlmICgoZXJybm8gPT0gRVRJTUVET1VUKSAmJiAo
Y291bnQgPCA5OSkpCiAgICAgICAgICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgICAgICAgICBpZiAoKGNvdW50ID09IDApICYmICh0aHJlYWRfYWN0
aW9uID09IDExKSkKICAgICAgICAgICAgICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJLRVJORUxC
VUc/IEZVVEVYX0xPQ0tfUElfUFJJVkFURSB3aXRoIHRpbWVyIHJldHVybnMg
RVRJTUVET1VUIGltbWVkaWF0ZWx5XG4iKTsKICAgICAgICAgICAgICAgICAg
ICAgICAgfQogICAgICAgICAgICAgICAgICAgICAgICAvKiBHaXZlIHRoZSB0
aHJlYWQgc29tZSB0aW1lIHRvIGRvIGl0LiAqLwogICAgICAgICAgICAgICAg
ICAgICAgICBpZiAobmFub3NsZWVwKCZURU5fbXMsIE5VTEwpKQogICAgICAg
ICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgbmFub3NsZWVwIGZhaWxl
ZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAg
ICAgICAgICAgfQogICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsK
ICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgZWxz
ZQogICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAg
ICAgICAgICB9CiAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgICAg
fQogICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gMTc7CiAgICAgICAgICAg
IHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgICAgICByID0gZnV0ZXgoJmYx
LCBGVVRFWF9XQUtFX1BSSVZBVEUsIDEsIE5VTEwsIE5VTEwsIDApOwogICAg
ICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9XQUtFX1BSSVZBVEUgb24gcGktbG9ja2VkIHJl
dHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJ
TlZBTCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdL
SUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0K
ICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9CSVRTRVRf
UFJJVkFURSwgMSwgTlVMTCwgTlVMTCwgMSk7CiAgICAgICAgICAgIGlmICgo
ciA+PSAwKSB8fCAoKGVycm5vICE9IEVJTlZBTCkgJiYgKGVycm5vICE9IEVO
T1NZUykpKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9CSVRTRVRfUFJJVkFU
RSBvbiBwaS1sb2NrZWQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBG
VVRFWF9VTkxPQ0tfUElfUFJJVkFURSwgMCwgTlVMTCwgTlVMTCwgMCk7CiAg
ICAgICAgICAgIGlmIChyKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxOTsKICAgICAgICAg
ICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIGlmIChmMSkKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGYxIGlzICVkIGluc3RlYWQgb2YgemVybyBhZnRlciB1bmxv
Y2tpbmdcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBm
MSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwp
OwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAg
ICAgICAgICBzaG1lbS0+ZjMgPSAwOwogICAgICAgICAgICB0aHJlYWRfYWN0
aW9uID0gOTsKICAgICAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAg
ICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX0xPQ0tfUEks
IDAsICZURU5fbXMsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIgPj0g
MCkgfHwgKGVycm5vICE9IEVUSU1FRE9VVCkpCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9MT0NLX1BJIHNob3VsZCB0aW1lIG91dCByZXR1cm5lZCAlcyBpbnN0ZWFk
IG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFVElNRURPVVQpKTsKICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGlm
ICh0cnlsb2NrKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICByID0g
ZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9UUllMT0NLX1BJLCAwLCBOVUxM
LCBOVUxMLCAwKTsKICAgICAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAo
ZXJybm8gIT0gRVdPVUxEQkxPQ0spKQogICAgICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9UUllMT0NLX1BJIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFV09VTERCTE9DSykpOwogICAgICAgICAg
ICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAg
ICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgfQogICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gMTI7CiAgICAg
ICAgICAgIGZvciAoY291bnQgPSAwOyBjb3VudCA8IDEwMDsgKytjb3VudCkK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2ht
ZW0tPmYzKSwgRlVURVhfTE9DS19QSSwgMCwgJk9ORV9zZWMsIE5VTEwsIDAp
OwogICAgICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICAgICAgaWYgKChlcnJubyA9PSBFVElNRURPVVQpICYm
IChjb3VudCA8IDk5KSkKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICAgICAgICAgIC8qIEdpdmUgdGhlIHRocmVhZCBzb21lIHRpbWUg
dG8gZG8gaXQuICovCiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChuYW5v
c2xlZXAoJlRFTl9tcywgTlVMTCkpCiAgICAgICAgICAgICAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBuYW5vc2xlZXAgZmFpbGVkICVzXG4iLAogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgICAgICAgICB9CiAgICAg
ICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOwogICAgICAgICAgICAgICAg
ICAgIH0KICAgICAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
bykpOwogICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICB9CiAgICAgICAgICAgIHRo
cmVhZF9hY3Rpb24gPSAxODsKICAgICAgICAgICAgd2FpdF9mb3JfdGhyZWFk
KCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVY
X1dBS0UsIDEsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAoKHIg
Pj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9XQUtFIG9uIHBpLWxvY2tlZCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgm
KHNobWVtLT5mMyksIEZVVEVYX1dBS0VfQklUU0VULCAxLCBOVUxMLCBOVUxM
LCAxKTsKICAgICAgICAgICAgaWYgKChyID49IDApIHx8ICgoZXJybm8gIT0g
RUlOVkFMKSAmJiAoZXJybm8gIT0gRU5PU1lTKSkpCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBG
VVRFWF9XQUtFX0JJVFNFVCBvbiBwaS1sb2NrZWQgcmV0dXJuZWQgJXMgaW5z
dGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9VTkxPQ0tfUEksIDAsIE5V
TEwsIE5VTEwsIDApOwogICAgICAgICAgICBpZiAocikKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICB0aHJlYWRfYWN0aW9u
ID0gMTk7CiAgICAgICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAg
ICAgICBpZiAoc2htZW0tPmYzKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgc2htZW0tPmYzIGlz
ICVkIGluc3RlYWQgb2YgemVybyBhZnRlciB1bmxvY2tpbmdcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBmMSk7CiAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBzaG1lbS0+
Y2hpbGRfYWN0aW9uID0gOTsKICAgICAgICAgICAgd2FpdF9mb3JfY2hpbGQo
KTsKICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhf
TE9DS19QSSwgMCwgJlRFTl9tcywgTlVMTCwgMCk7CiAgICAgICAgICAgIGlm
ICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVRJTUVET1VUKSkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX0xPQ0tfUEkgc2hvdWxkIHRpbWUgb3V0IHJldHVybmVkICVz
IGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9f
TElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVUSU1FRE9VVCkp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICAgICAgaWYgKHRyeWxvY2spCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1RSWUxPQ0tfUEks
IDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICAgICAgaWYgKChyID49
IDApIHx8IChlcnJubyAhPSBFV09VTERCTE9DSykpCiAgICAgICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1RSWUxPQ0tfUEkgcmV0dXJuZWQgJXMgaW5zdGVhZCBv
ZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVXT1VMREJMT0NLKSk7CiAg
ICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAg
fQogICAgICAgICAgICB9CiAgICAgICAgICAgIHNobWVtLT5jaGlsZF9hY3Rp
b24gPSAxMjsKICAgICAgICAgICAgZm9yIChjb3VudCA9IDA7IGNvdW50IDwg
MTAwOyArK2NvdW50KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9MT0NLX1BJLCAwLCAmT05F
X3NlYywgTlVMTCwgMCk7CiAgICAgICAgICAgICAgICBpZiAocikKICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpZiAoKGVycm5vID09
IEVUSU1FRE9VVCkgJiYgKGNvdW50IDwgOTkpKQogICAgICAgICAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAgLyogR2l2ZSB0aGUgY2hp
bGQgc29tZSB0aW1lIHRvIGRvIGl0LiAqLwogICAgICAgICAgICAgICAgICAg
ICAgICBpZiAobmFub3NsZWVwKCZURU5fbXMsIE5VTEwpKQogICAgICAgICAg
ICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgbmFub3NsZWVwIGZhaWxlZCAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgICAg
ICAgICAgfQogICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsKICAg
ICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gMTg7CiAgICAgICAg
ICAgIHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgm
KHNobWVtLT5mMyksIEZVVEVYX1dBS0UsIDEsIE5VTEwsIE5VTEwsIDApOwog
ICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkp
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFIG9uIHBpLWxvY2tlZCByZXR1cm5l
ZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFSU5WQUwp
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1dBS0VfQklU
U0VULCAxLCBOVUxMLCBOVUxMLCAxKTsKICAgICAgICAgICAgaWYgKChyID49
IDApIHx8ICgoZXJybm8gIT0gRUlOVkFMKSAmJiAoZXJybm8gIT0gRU5PU1lT
KSkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCBvbiBwaS1sb2Nr
ZWQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJy
b3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAg
ICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRF
WF9VTkxPQ0tfUEksIDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgICAgICBp
ZiAocikKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICBzaG1lbS0+Y2hpbGRfYWN0aW9uID0gMTk7CiAgICAgICAgICAgIHdh
aXRfZm9yX2NoaWxkKCk7CiAgICAgICAgICAgIGlmIChzaG1lbS0+ZjMpCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBzaG1lbS0+ZjMgaXMgJWQgaW5zdGVhZCBvZiB6ZXJvIGFm
dGVyIHVubG9ja2luZ1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHNobWVtLT5mMyk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgIH0KICAgIH0KICAgIC8qIEZVVEVYX1dBSVRf
QklUU0VUIGFuZCBGVVRFWF9XQUtFX0JJVFNFVCBhcmUgYWxzbyBub3QgZG9j
dW1lbnRlZC4KICAgICAqIExvb2tpbmcgYXQgdGhlIGtlcm5lbCBjb2RlLAog
ICAgICogd2UgZmluZCB0aGF0IEZVVEVYX1dBSVRfQklUU0VUIGRvZXM6LQog
ICAgICogSWYgYXJnNiBpcyB6ZXJvLCAtRUlOVkFMIGlzIHJldHVybmVkLgog
ICAgICogSWYgKmFyZzEgaXMgbm90IGVxdWFsIHRvIGFyZzMsIC1FV09VTERC
TE9DSyBpcyByZXR1cm5lZC4KICAgICAqIElmIGFyZzQgaXMgbm90IE5VTEwg
aXQgaXMgcG9pbnRlciB0byBhIHRpbWVvdXQ6IGlmIHRoZSB0aW1lb3V0IGV4
cGlyZXMKICAgICAqICAgICBiZWZvcmUgd2UgYXJlIHdva2VuIGFzIGJlbG93
LCAtRVRJTUVET1VUIGlzIHJldHVybmVkLgogICAgICogT3RoZXJ3aXNlIHdh
aXQgZm9yIHNvbWUgb3RoZXIgcHJvY2VzcyB0byBkbyBGVVRFWF9XQUtFX0JJ
VFNFVAogICAgICogICAgIG9uIGFyZzEgd2l0aCBpdHMgYXJnNiBoYXZpbmcg
c29tZSBiaXQocykgc2V0IHdoaWNoIHdlcmUgYWxzbwogICAgICogICAgIHNl
dCBpbiBvdXIgYXJnNi4gSWYgdGhhdCBoYXBwZW5zLCB3ZSByZXR1cm4gMC4K
ICAgICAqIHdlIGZpbmQgdGhhdCBGVVRFWF9XQUlUX0JJVFNFVCBkb2VzOi0K
ICAgICAqIElmIGFyZzYgaXMgemVybywgLUVJTlZBTCBpcyByZXR1cm5lZC4K
ICAgICAqIElmIHNvbWUgcHJvY2VzcyBob2xkcyBhIFBJIGxvY2sgb24gYXJn
MSwgLUVJTlZBTCBpcyByZXR1cm5lZAogICAgICogICAgICh0aGlzIGlzIHRl
c3RlZCB1bmRlciBGVVRFWF9MT0NLX1BJIGFib3ZlKS4KICAgICAqIE90aGVy
d2lzZSwgd2FrZSB1cCB0byBhcmczIHByb2Nlc3NlcyB3aGljaCB3ZXJlIHdh
aXRpbmcgaW4KICAgICAqICAgICBGVVRFWF9XQUlUX0JJVFNFVCBmb3IgdGhl
IHNhbWUgYXJnMSB3aXRoIHRoZWlyIGFyZzYgaGF2aW5nIHNvbWUKICAgICAq
ICAgICBiaXQocykgc2V0IHdoaWNoIHdlcmUgYWxzbyBzZXQgaW4gb3VyIGFy
ZzYsIGFuZCByZXR1cm4gdGhlIG51bWJlcgogICAgICogICAgIG9mIHByb2Nl
c3NlcyBhd2FrZW5lZC4KICAgICAqIE5vdGUgYWxsIHRoaXMgaXMgZXhhY3Rs
eSBsaWtlIEZVVEVYX1dBSVQgYW5kIEZVVEVYX1dBS0UgZXhjZXB0IGZvcgog
ICAgICogdGhlIGFyZzYgbWFza2luZywgYW5kIGluIGZhY3QgdGhlc2UgYXJl
IGltcGxlbWVudGVkIGJ5IHRoZSBrZXJuZWwgYXMKICAgICAqIGlmIHRoZXkg
d2VyZSBGVVRFWF9XQUlUX0JJVFNFVCBhbmQgRlVURVhfV0FLRV9CSVRTRVQg
d2l0aCBhcmc2IHNldCB0bwogICAgICogYWxsIG9uZXM6IHRodXMgaXQgaXMg
cG9zc2libGUgZm9yIEZVVEVYX1dBS0VfQklUU0VUIHRvIHdha2UgYSBwcm9j
ZXNzCiAgICAgKiB3aGljaCBpcyBzbGVlcGluZyBpbiBGVVRFWF9XQUlUIG9y
IEZVVEVYX1dBS0UgdG8gd2FrZSBhIHByb2Nlc3Mgd2hpY2gKICAgICAqIGlz
IHNsZWVwaW5nIGluIEZVVEVYX1dBSVRfQklUU0VULgogICAgICovCiAgICBm
MSA9IDA7CiAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUlUX0JJVFNFVCwg
MCwgTlVMTCwgTlVMTCwgMCk7CiAgICBpZiAoKHIgPCAwKSAmJiAoZXJybm8g
PT0gRU5PU1lTKSkKICAgIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkZV
VEVYX1dBSVRfQklUU0VUIG5vdCBzdXBwb3J0ZWQgaW4gdGhpcyBrZXJuZWxc
biIpOwogICAgICAgIC8qIG5vdCBmYXRhbCAqLwogICAgfQogICAgZWxzZQog
ICAgewogICAgICAgIGlmIChyID49IDApCiAgICAgICAgewogICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJVF9CSVRT
RVQgcmV0dXJuZWQgJWQgaW5zdGVhZCBvZiBFSU5WQUxcbiIsCiAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICBleGl0KDEpOwogICAg
ICAgIH0KICAgICAgICBlbHNlIGlmIChlcnJubyAhPSBFSU5WQUwpCiAgICAg
ICAgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQg
RlVURVhfV0FJVF9CSVRTRVQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICB9CiAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FLRV9CSVRTRVQs
IDAsIE5VTEwsIE5VTEwsIDApOwogICAgICAgIGlmICgociA8IDApICYmIChl
cnJubyA9PSBFTk9TWVMpKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJGVVRFWF9XQUtFX0JJVFNFVCBub3Qgc3VwcG9ydGVkIGlu
IHRoaXMga2VybmVsXG4iKTsKICAgICAgICAgICAgLyogbm90IGZhdGFsICov
CiAgICAgICAgfQogICAgICAgIGVsc2UKICAgICAgICB7CiAgICAgICAgICAg
IGlmIChyID49IDApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCBy
ZXR1cm5lZCAlZCBpbnN0ZWFkIG9mIEVJTlZBTFxuIiwKICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgZWxzZSBpZiAoZXJybm8g
IT0gRUlOVkFMKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9CSVRTRVQgcmV0
dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUlO
VkFMKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICByID0gZnV0ZXgoTlVMTCwgRlVURVhfV0FJVF9CSVRTRVQs
IDAsIE5VTEwsIE5VTEwsIDEgPDwgMCk7CiAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBSVRfQklUU0VUIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
byksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KE5VTEwsIEZV
VEVYX1dBSVRfQklUU0VUX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDEgPDwg
MSk7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZB
VUxUKSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVRfQklUU0VUX1BSSVZBVEUg
cmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3Io
RUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAg
fQogICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKTgsIEZVVEVYX1dBSVRf
QklUU0VULCAwLCBOVUxMLCBOVUxMLCAxIDw8IDIpOwogICAgICAgICAgICBp
ZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUlUX0JJVFNFVCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgo
aW50ICopOCwgRlVURVhfV0FJVF9CSVRTRVRfUFJJVkFURSwgMCwgTlVMTCwg
TlVMTCwgMSA8PCAzKTsKICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChl
cnJubyAhPSBFRkFVTFQpKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJVF9CSVRT
RVRfUFJJVkFURSByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
LCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgoaW50ICopdXBy
aXYsIEZVVEVYX1dBSVRfQklUU0VULCAwLCBOVUxMLCBOVUxMLCAxIDw8IDQp
OwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVM
VCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUlUX0JJVFNFVCByZXR1cm5lZCAl
cyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsK
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAg
ICAgIHIgPSBmdXRleCgoaW50ICopdXByaXYsIEZVVEVYX1dBSVRfQklUU0VU
X1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDEgPDwgNSk7CiAgICAgICAgICAg
IGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBSVRfQklUU0VUX1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5z
dGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoKGludCAqKSgxICsgKGNoYXIgKikmZjEpLCBGVVRFWF9XQUlU
X0JJVFNFVCwgMCwgTlVMTCwgTlVMTCwgMSA8PCA2KTsKICAgICAgICAgICAg
aWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FJVF9CSVRTRVQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgo
KGludCAqKSgxICsgKGNoYXIgKikmZjEpLCBGVVRFWF9XQUlUX0JJVFNFVF9Q
UklWQVRFLCAwLCBOVUxMLCBOVUxMLCAxIDw8IDcpOwogICAgICAgICAgICBp
ZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUlUX0JJVFNFVF9QUklWQVRFIHJldHVybmVkICVzIGluc3Rl
YWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgc2ht
ZW0tPmYzID0gMDsKICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoMSAr
IChjaGFyICopJihzaG1lbS0+ZjMpKSwgRlVURVhfV0FJVF9CSVRTRVQsIDAs
IE5VTEwsIE5VTEwsIDEgPDwgOCk7CiAgICAgICAgICAgIGlmICgociA+PSAw
KSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dB
SVRfQklUU0VUIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyks
IHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoNDA5
NCArIChjaGFyICopJihzaG1lbS0+ZjMpKSwgRlVURVhfV0FJVF9CSVRTRVQs
IDAsIE5VTEwsIE5VTEwsIDEgPDwgOCk7CiAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBSVRfQklUU0VUIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJu
byksIHN0cmVycm9yKEVJTlZBTCkpOwogICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7
CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVU
RVhfV0FJVF9CSVRTRVQsIDEsIE5VTEwsIE5VTEwsIDEgPDwgOSk7CiAgICAg
ICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVdPVUxEQkxPQ0sp
KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJVF9CSVRTRVQgcmV0dXJuZWQgJXMg
aW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRVdPVUxEQkxPQ0sp
KTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7
CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAg
ICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBSVRfQklUU0VUX1BSSVZB
VEUsIDEsIE5VTEwsIE5VTEwsIDEgPDwgMTApOwogICAgICAgICAgICBpZiAo
KHIgPj0gMCkgfHwgKGVycm5vICE9IEVXT1VMREJMT0NLKSkKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBSVRfQklUU0VUX1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5z
dGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRVdPVUxEQkxPQ0spKTsK
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAg
ICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1dBSVRfQklUU0VU
LCAyLCBOVUxMLCBOVUxMLCAxIDw8IDExKTsKICAgICAgICAgICAgaWYgKChy
ID49IDApIHx8IChlcnJubyAhPSBFV09VTERCTE9DSykpCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUlUX0JJVFNFVCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFV09VTERCTE9DSykpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1
dGV4KCZmMSwgRlVURVhfV0FJVF9CSVRTRVQsIDAsIChzdHJ1Y3QgdGltZXNw
ZWMgKik4LCBOVUxMLCAxIDw8IDEyKTsKICAgICAgICAgICAgaWYgKChyID49
IDApIHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgICAgICB7CiAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhf
V0FJVF9CSVRTRVQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5v
KSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRF
WF9XQUlUX0JJVFNFVF9QUklWQVRFLCAwLCAoc3RydWN0IHRpbWVzcGVjICop
OCwgTlVMTCwgMSA8PCAxMyk7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8
fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVRf
QklUU0VUX1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSwgc3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1l
bS0+ZjMpLCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwgKHN0cnVjdCB0aW1lc3Bl
YyAqKTgsIE5VTEwsIDEgPDwgMTQpOwogICAgICAgICAgICBpZiAoKHIgPj0g
MCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9X
QUlUX0JJVFNFVCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
LCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVY
X1dBSVRfQklUU0VULCAwLCAoc3RydWN0IHRpbWVzcGVjICopdXByaXYsIE5V
TEwsIDEgPDwgMTUpOwogICAgICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVy
cm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUlUX0JJVFNF
VCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBzdHJlcnJv
cihFRkFVTFQpKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAg
ICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBSVRfQklU
U0VUX1BSSVZBVEUsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKil1cHJpdiwgTlVM
TCwgMSA8PCAxNik7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJy
bm8gIT0gRUZBVUxUKSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBSVRfQklUU0VU
X1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwg
c3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMp
LCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwgKHN0cnVjdCB0aW1lc3BlYyAqKXVw
cml2LCBOVUxMLCAxIDw8IDE3KTsKICAgICAgICAgICAgaWYgKChyID49IDAp
IHx8IChlcnJubyAhPSBFRkFVTFQpKQogICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FJ
VF9CSVRTRVQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwg
c3RyZXJyb3IoRUZBVUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9X
QUlUX0JJVFNFVCwgMCwgJlRFTl9tcywgTlVMTCwgMSA8PCAxOSk7CiAgICAg
ICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRVRJTUVET1VUKSkK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIs
ICJBdCBsaW5lICVkIEZVVEVYX1dBSVRfQklUU0VUIHJldHVybmVkICVzIGlu
c3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElO
RV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVUSU1FRE9VVCkpOwog
ICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVF9CSVRTRVRfUFJJVkFURSwg
MCwgJlRFTl9tcywgTlVMTCwgMSA8PCAyMCk7CiAgICAgICAgICAgIGlmICgo
ciA+PSAwKSB8fCAoZXJybm8gIT0gRVRJTUVET1VUKSkKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVk
IEZVVEVYX1dBSVRfQklUU0VUX1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5zdGVh
ZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRVRJTUVET1VUKSk7CiAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwg
JlRFTl9tcywgTlVMTCwgMSA8PCAyMSk7CiAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRVRJTUVET1VUKSkKICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZV
VEVYX1dBSVRfQklUU0VUIHJldHVybmVkICVzIGluc3RlYWQgb2YgJXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubyksIHN0cmVycm9yKEVUSU1FRE9VVCkpOwogICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgdGhyZWFkX2FjdGlv
biA9IDE7CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBSVRf
QklUU0VULCAwLCAmT05FX3NlYywgJmYyLCAxIDw8IDIyKTsKICAgICAgICAg
ICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChl
cnJubyA9PSBFVElNRURPVVQpCiAgICAgICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICAgICAgaW50IHRhID0gdGhyZWFkX2FjdGlvbjsKICAgICAgICAg
ICAgICAgICAgICAvKiBUcnkgd2l0aG91dCB0aW1lciwgbWF5IHdhaXQgZm9y
ZXZlci4gKi8KICAgICAgICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBG
VVRFWF9XQUlUX0JJVFNFVCwgMCwgTlVMTCwgJmYyLCAxIDw8IDIyKTsKICAg
ICAgICAgICAgICAgICAgICBpZiAodGEgPT0gMSkKICAgICAgICAgICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiS0VSTkVMQlVHPyBGVVRFWF9XQUlUX0JJVFNFVCB3aXRoIHRpbWVyIHJl
dHVybnMgRVRJTUVET1VUIGltbWVkaWF0ZWx5XG4iKTsKICAgICAgICAgICAg
ICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgaWYgKHIpCiAgICAgICAg
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJv
cihlcnJubykpOwogICAgICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGls
ZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIH0K
ICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0
ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAg
ICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAg
ICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9
CiAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxOwogICAgICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwgJk9ORV9zZWMs
IE5VTEwsIDEgPDwgMjMpOwogICAgICAgICAgICBpZiAocikKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgaWYgKGVycm5vID09IEVUSU1FRE9VVCkK
ICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICByID0gZnV0
ZXgoJmYxLCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwgTlVMTCwgTlVMTCwgMSA8
PCAyMyk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihl
cnJubykpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAgICB0aHJlYWRf
YWN0aW9uID0gMTsKICAgICAgICAgICAgciA9IGZ1dGV4KCZmMSwgRlVURVhf
V0FJVF9CSVRTRVQsIDAsICZPTkVfc2VjLCAoaW50ICopOCwgMSA8PCAyNCk7
CiAgICAgICAgICAgIGlmIChyKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBpZiAoKGVycm5vID09IEVUSU1FRE9VVCkgJiYgKHRocmVhZF9hY3Rp
b24gPT0gMSkpCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAg
ICAgciA9IGZ1dGV4KCZmMSwgRlVURVhfV0FJVF9CSVRTRVQsIDAsIE5VTEws
IChpbnQgKik4LCAxIDw8IDI0KTsKICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAg
ICAgICAgIHRocmVhZF9hY3Rpb24gPSAxOwogICAgICAgICAgICByID0gZnV0
ZXgoJmYxLCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwgJk9ORV9zZWMsIChpbnQg
Kil1cHJpdiwgMSA8PCAyNSk7CiAgICAgICAgICAgIGlmIChyKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBpZiAoZXJybm8gPT0gRVRJTUVET1VU
KQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIHIgPSBm
dXRleCgmZjEsIEZVVEVYX1dBSVRfQklUU0VULCAwLCBOVUxMLCAoaW50ICop
dXByaXYsIDEgPDwgMjUpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAg
ICAgICAgZWxzZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgdGhyZWFkX2FjdGlvbiA9IDI7CiAgICAgICAgICAgIHIgPSBmdXRleCgm
ZjEsIEZVVEVYX1dBSVRfQklUU0VUX1BSSVZBVEUsIDAsICZPTkVfc2VjLCBO
VUxMLCAxIDw8IDI2KTsKICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGlmIChlcnJubyA9PSBFVElNRURPVVQpCiAg
ICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWYgKHRocmVh
ZF9hY3Rpb24gPT0gMikKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAg
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiS0VSTkVMQlVHPyBG
VVRFWF9XQUlUX0JJVFNFVF9QUklWQVRFIHdpdGggdGltZXIgcmV0dXJucyBF
VElNRURPVVQgaW1tZWRpYXRlbHlcbiIpOwogICAgICAgICAgICAgICAgICAg
IH0KICAgICAgICAgICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9X
QUlUX0JJVFNFVF9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAxIDw8IDI2KTsK
ICAgICAgICAgICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lH
S0lMTCk7CiAgICAgICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgfQogICAgICAgICAg
ICAgICAgZWxzZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQg
JXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywg
c3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChj
aGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQo
MSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAg
ICAgdGhyZWFkX2FjdGlvbiA9IDM7CiAgICAgICAgICAgIHIgPSBmdXRleCgm
KHNobWVtLT5mMyksIEZVVEVYX1dBSVRfQklUU0VULCAwLCAmT05FX3NlYywg
TlVMTCwgMSA8PCAyNyk7CiAgICAgICAgICAgIGlmIChyKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBpZiAoZXJybm8gPT0gRVRJTUVET1VUKQog
ICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIHIgPSBmdXRl
eCgmKHNobWVtLT5mMyksIEZVVEVYX1dBSVRfQklUU0VULCAwLCBOVUxMLCBO
VUxMLCAxIDw8IDI3KTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAg
ICAgIGVsc2UKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAg
ICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0
cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hp
bGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgICAg
IHNobWVtLT5jaGlsZF9hY3Rpb24gPSAzOwogICAgICAgICAgICByID0gZnV0
ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUlUX0JJVFNFVCwgMCwgJk9ORV9z
ZWMsIE5VTEwsIDEgPDwgMjgpOwogICAgICAgICAgICBpZiAocikKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgaWYgKGVycm5vID09IEVUSU1FRE9V
VCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAvKiBH
aXZlIHRoZSB0aHJlYWQgc29tZSB0aW1lIHRvIGRvIGl0LiAqLwogICAgICAg
ICAgICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVYX1dB
SVRfQklUU0VULCAwLCBOVUxMLCBOVUxMLCAxIDw8IDI4KTsKICAgICAgICAg
ICAgICAgIH0KICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAg
ICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleChOVUxMLCBGVVRFWF9X
QUtFX0JJVFNFVCwgMCwgTlVMTCwgTlVMTCwgMSA8PCAyOSk7CiAgICAgICAg
ICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0gRUZBVUxUKSkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1dBS0VfQklUU0VUIHJldHVybmVkICVzIGluc3RlYWQg
b2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBz
dHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVGQVVMVCkpOwogICAgICAgICAg
ICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1
dGV4KE5VTEwsIEZVVEVYX1dBS0VfQklUU0VUX1BSSVZBVEUsIDAsIE5VTEws
IE5VTEwsIDEgPDwgMzApOwogICAgICAgICAgICBpZiAocikKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgo
KGludCAqKTgsIEZVVEVYX1dBS0VfQklUU0VULCAwLCBOVUxMLCBOVUxMLCAx
IDw8IDMxKTsKICAgICAgICAgICAgaWYgKChyID49IDApIHx8IChlcnJubyAh
PSBFRkFVTFQpKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9CSVRTRVQgcmV0
dXJuZWQgJXMgaW5zdGVhZCBvZiAlc1xuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSwgc3RyZXJyb3IoRUZB
VUxUKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICByID0gZnV0ZXgoKGludCAqKTgsIEZVVEVYX1dBS0VfQklU
U0VUX1BSSVZBVEUsIDAsIE5VTEwsIE5VTEwsIDMgPDwgMCk7CiAgICAgICAg
ICAgIGlmIChyKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lM
TCk7CiAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICB9CiAg
ICAgICAgICAgIHIgPSBmdXRleCgoaW50ICopdXByaXYsIEZVVEVYX1dBS0Vf
QklUU0VULCAwLCBOVUxMLCBOVUxMLCAzIDw8IDEpOwogICAgICAgICAgICBp
ZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVGQVVMVCkpCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVz
XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJy
b3IoZXJybm8pLCBzdHJlcnJvcihFRkFVTFQpKTsKICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgo
aW50ICopdXByaXYsIEZVVEVYX1dBS0VfQklUU0VUX1BSSVZBVEUsIDAsIE5V
TEwsIE5VTEwsIDMgPDwgMik7CiAgICAgICAgICAgIGlmIChyKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxp
bmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAg
ICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRl
eCgoaW50ICopKDEgKyAoY2hhciAqKSZmMSksIEZVVEVYX1dBS0VfQklUU0VU
LCAwLCBOVUxMLCBOVUxMLCAzIDw8IDMpOwogICAgICAgICAgICBpZiAoKHIg
Pj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRF
WF9XQUtFX0JJVFNFVCByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgoaW50ICop
KDEgKyAoY2hhciAqKSZmMSksIEZVVEVYX1dBS0VfQklUU0VUX1BSSVZBVEUs
IDAsIE5VTEwsIE5VTEwsIDMgPDwgNCk7CiAgICAgICAgICAgIGlmICgociA+
PSAwKSB8fCAoZXJybm8gIT0gRUlOVkFMKSkKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVY
X1dBS0VfQklUU0VUX1BSSVZBVEUgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgo
KGludCAqKSgxICsgKGNoYXIgKikmKHNobWVtLT5mMykpLCBGVVRFWF9XQUtF
X0JJVFNFVCwgMCwgTlVMTCwgTlVMTCwgMyA8PCA1KTsKICAgICAgICAgICAg
aWYgKChyID49IDApIHx8IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgRlVURVhfV0FLRV9CSVRTRVQgcmV0dXJuZWQgJXMgaW5zdGVhZCBvZiAl
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSwgc3RyZXJyb3IoRUlOVkFMKSk7CiAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAgICAgICByID0gZnV0ZXgo
KGludCAqKSgxICsgKGNoYXIgKikmKHNobWVtLT5mMykpLCBGVVRFWF9XQUtF
X0JJVFNFVF9QUklWQVRFLCAwLCBOVUxMLCBOVUxMLCAzIDw8IDYpOwogICAg
ICAgICAgICBpZiAoKHIgPj0gMCkgfHwgKGVycm5vICE9IEVJTlZBTCkpCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
QXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVF9QUklWQVRFIHJldHVybmVk
ICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAg
IF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZBTCkp
OwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsK
ICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAg
ICAgICAgciA9IGZ1dGV4KChpbnQgKikoNDA5NCArIChjaGFyICopJihzaG1l
bS0+ZjMpKSwgRlVURVhfV0FLRV9CSVRTRVQsIDAsIE5VTEwsIE5VTEwsIDMg
PDwgNSk7CiAgICAgICAgICAgIGlmICgociA+PSAwKSB8fCAoZXJybm8gIT0g
RUlOVkFMKSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfQklUU0VUIHJldHVy
bmVkICVzIGluc3RlYWQgb2YgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAg
ICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHN0cmVycm9yKEVJTlZB
TCkpOwogICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAg
ICAgICAgICAgciA9IGZ1dGV4KChpbnQgKikoNDA5NCArIChjaGFyICopJihz
aG1lbS0+ZjMpKSwgRlVURVhfV0FLRV9CSVRTRVRfUFJJVkFURSwgMCwgTlVM
TCwgTlVMTCwgMyA8PCA2KTsKICAgICAgICAgICAgaWYgKChyID49IDApIHx8
IChlcnJubyAhPSBFSU5WQUwpKQogICAgICAgICAgICB7CiAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9C
SVRTRVRfUFJJVkFURSByZXR1cm5lZCAlcyBpbnN0ZWFkIG9mICVzXG4iLAog
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pLCBzdHJlcnJvcihFSU5WQUwpKTsKICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICBleGl0KDEp
OwogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZV
VEVYX1dBS0VfQklUU0VULCAzLCAoc3RydWN0IHRpbWVzcGVjICopdXByaXYs
IChpbnQgKil1cHJpdiwgMyA8PCA3KTsKICAgICAgICAgICAgaWYgKHIpCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7
CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAg
ICAgfQogICAgICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAl
ZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1cm5lZCAlZCB3aGVuIG5vIHByb2Nl
c3NlcyB0byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAgICBy
ID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX0JJVFNFVF9QUklWQVRFLCAzLCAo
c3RydWN0IHRpbWVzcGVjICopdXByaXYsIChpbnQgKil1cHJpdiwgMyA8PCA4
KTsKICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXgg
ZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAg
ZWxzZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVF9Q
UklWQVRFIHJldHVybmVkICVkIHdoZW4gbm8gcHJvY2Vzc2VzIHRvIHdha2Vc
biIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7
CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxM
KTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAg
ICAgfQogICAgICAgICAgICB9CiAgICAgICAgICAgIHIgPSBmdXRleCgmKHNo
bWVtLT5mMyksIEZVVEVYX1dBS0VfQklUU0VULCAzLCAoc3RydWN0IHRpbWVz
cGVjICopdXByaXYsIChpbnQgKil1cHJpdiwgMyA8PCA5KTsKICAgICAgICAg
ICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChy
IDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4i
LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVy
cm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQogICAgICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1cm5lZCAlZCB3
aGVuIG5vIHByb2Nlc3NlcyB0byB3YWtlXG4iLAogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgICAg
IHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAg
ICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQog
ICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gNDsKICAgICAgICAgICAgd2Fp
dF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZV
VEVYX1dBS0VfQklUU0VULCAzLCAoc3RydWN0IHRpbWVzcGVjICopdXByaXYs
IChpbnQgKil1cHJpdiwgMyA8PCAxMCk7CiAgICAgICAgICAgIGlmIChyICE9
IDEpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGlmIChyIDwgMCkK
ICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBT
SUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAg
ICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQg
bGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1cm5lZCAlZCB3aGVuIDEg
cHJvY2VzcyB0byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNo
aWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgx
KTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAg
ICB0aHJlYWRfYWN0aW9uID0gNTsKICAgICAgICAgICAgd2FpdF9mb3JfdGhy
ZWFkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZVVEVYX1dBS0Vf
QklUU0VUX1BSSVZBVEUsIDMsIChzdHJ1Y3QgdGltZXNwZWMgKil1cHJpdiwg
KGludCAqKXVwcml2LCAzIDw8IDExKTsKICAgICAgICAgICAgaWYgKHIgIT0g
MSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWYgKHIgPCAwKQog
ICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJy
bm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJ
R0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAg
ICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBs
aW5lICVkIEZVVEVYX1dBS0VfQklUU0VUX1BSSVZBVEUgcmV0dXJuZWQgJWQg
d2hlbiAxIHByb2Nlc3MgdG8gd2FrZVxuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAg
ICAgICAgICAgdGhyZWFkX2FjdGlvbiA9IDY7CiAgICAgICAgICAgIHdhaXRf
Zm9yX3RocmVhZCgpOwogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+
ZjMpLCBGVVRFWF9XQUtFX0JJVFNFVCwgMywgKHN0cnVjdCB0aW1lc3BlYyAq
KXVwcml2LCAoaW50ICopdXByaXYsIDMgPDwgMTIpOwogICAgICAgICAgICBp
ZiAociAhPSAxKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpZiAo
ciA8IDApCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xu
IiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGVsc2UKICAgICAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9CSVRTRVQgcmV0dXJuZWQgJWQg
d2hlbiAxIHByb2Nlc3MgdG8gd2FrZVxuIiwKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAgICAgICAgICAgICB0
a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAg
IGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAg
ICAgICAgICAgc2htZW0tPmNoaWxkX2FjdGlvbiA9IDY7CiAgICAgICAgICAg
IHdhaXRfZm9yX2NoaWxkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmKHNo
bWVtLT5mMyksIEZVVEVYX1dBS0VfQklUU0VULCAzLCAoc3RydWN0IHRpbWVz
cGVjICopdXByaXYsIChpbnQgKil1cHJpdiwgMyA8PCAxMyk7CiAgICAgICAg
ICAgIGlmIChyICE9IDEpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1cm5l
ZCAlZCB3aGVuIDEgcHJvY2VzcyB0byB3YWtlXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAg
fQogICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gNjsKICAgICAgICAgICAg
d2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIHNobWVtLT5jaGlsZF9h
Y3Rpb24gPSA2OwogICAgICAgICAgICB3YWl0X2Zvcl9jaGlsZCgpOwogICAg
ICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9XQUtFX0JJ
VFNFVCwgMywgKHN0cnVjdCB0aW1lc3BlYyAqKXVwcml2LCAoaW50ICopdXBy
aXYsIDMgPDwgMTQpOwogICAgICAgICAgICBpZiAociAhPSAyKQogICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICBpZiAociA8IDApCiAgICAgICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIGZ1dGV4IGZhaWxlZCAlc1xuIiwKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF9fTElORV9fLCBzdHJlcnJvcihlcnJubykpOwogICAg
ICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAg
ICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0K
ICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgIHsKICAgICAg
ICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVU
RVhfV0FLRV9CSVRTRVQgcmV0dXJuZWQgJWQgd2hlbiAyIHByb2Nlc3NlcyB0
byB3YWtlXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHIpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwg
U0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAg
ICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgICAgICB0aHJlYWRf
YWN0aW9uID0gNjsKICAgICAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAg
ICAgICAgICAgIHNobWVtLT5jaGlsZF9hY3Rpb24gPSA2OwogICAgICAgICAg
ICB3YWl0X2Zvcl9jaGlsZCgpOwogICAgICAgICAgICByID0gZnV0ZXgoJihz
aG1lbS0+ZjMpLCBGVVRFWF9XQUtFX0JJVFNFVCwgMSwgKHN0cnVjdCB0aW1l
c3BlYyAqKXVwcml2LCAoaW50ICopdXByaXYsIDMgPDwgMTUpOwogICAgICAg
ICAgICBpZiAociAhPSAxKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICBpZiAociA8IDApCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIGZ1dGV4IGZhaWxl
ZCAlc1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9f
LCBzdHJlcnJvcihlcnJubykpOwogICAgICAgICAgICAgICAgICAgIHRraWxs
KGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhp
dCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9CSVRTRVQgcmV0dXJu
ZWQgJWQgd2hlbiBvbmx5IHdha2luZyBvbmUgcHJvY2Vzc1xuIiwKICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCByKTsKICAgICAgICAg
ICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAg
ICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAg
ICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwg
RlVURVhfV0FLRV9CSVRTRVQsIDAsIChzdHJ1Y3QgdGltZXNwZWMgKil1cHJp
diwgKGludCAqKXVwcml2LCAzIDw8IDE2KTsKICAgICAgICAgICAgaWYgKHIg
IT0gMSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWYgKHIgPCAw
KQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfQklUU0VUIHJldHVybmVkICVkIHdoZW4g
b25seSB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAg
ICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxMzsKICAgICAgICAgICAgd2Fp
dF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZV
VEVYX1dBS0VfQklUU0VULCAzLCBOVUxMLCBOVUxMLCAweEZGRkZGRkZDKTsK
ICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxz
ZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1
cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAg
ICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJmYxLCBGVVRFWF9XQUtFX0JJ
VFNFVCwgMywgTlVMTCwgTlVMTCwgMHg2KTsKICAgICAgICAgICAgaWYgKHIg
IT0gMSkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWYgKHIgPCAw
KQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3Io
ZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQs
IFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAg
ICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAg
ICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfQklUU0VUIHJldHVybmVkICVkIHdoZW4g
b25seSB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAg
ICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxNDsKICAgICAgICAgICAgd2Fp
dF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmZjEsIEZV
VEVYX1dBS0VfQklUU0VUX1BSSVZBVEUsIDMsIE5VTEwsIE5VTEwsIDB4RkZG
RkZGQzApOwogICAgICAgICAgICBpZiAocikKICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICAgICAgewogICAg
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBm
dXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAg
ICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAg
ICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAg
ICAgICBlbHNlCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfQklU
U0VUX1BSSVZBVEUgcmV0dXJuZWQgJWQgd2hlbiB3YWtpbmcgbm8gcHJvY2Vz
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fTElORV9fLCBy
KTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgICAgciA9IGZ1dGV4KCZm
MSwgRlVURVhfV0FLRV9CSVRTRVRfUFJJVkFURSwgMywgTlVMTCwgTlVMTCwg
MHgxRik7CiAgICAgICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUg
JWQgZnV0ZXggZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAg
ICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAg
ICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAg
ICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtF
X0JJVFNFVF9QUklWQVRFIHJldHVybmVkICVkIHdoZW4gb25seSB3YWtpbmcg
b25lIHByb2Nlc3NcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgcik7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwoY2hpbGRf
cGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0KDEpOwog
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgICAgIHRo
cmVhZF9hY3Rpb24gPSAxNTsKICAgICAgICAgICAgd2FpdF9mb3JfdGhyZWFk
KCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZVVEVY
X1dBS0VfQklUU0VULCAzLCBOVUxMLCBOVUxMLCAweEZGRkZGQzAwKTsKICAg
ICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFpbGVk
ICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18s
IHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtpbGwo
Y2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBleGl0
KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxzZQog
ICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYo
c3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1cm5l
ZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzXG4iLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAg
ICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAg
fQogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRFWF9X
QUtFX0JJVFNFVCwgMywgTlVMTCwgTlVMTCwgMHhGRkZGRkQwMCk7CiAgICAg
ICAgICAgIGlmIChyICE9IDEpCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxz
ZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1
cm5lZCAlZCB3aGVuIG9ubHkgd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAg
ICAgICAgICAgfQogICAgICAgICAgICB0aHJlYWRfYWN0aW9uID0gMTU7CiAg
ICAgICAgICAgIHdhaXRfZm9yX3RocmVhZCgpOwogICAgICAgICAgICBzaG1l
bS0+Y2hpbGRfYWN0aW9uID0gMTU7CiAgICAgICAgICAgIHdhaXRfZm9yX2No
aWxkKCk7CiAgICAgICAgICAgIHIgPSBmdXRleCgmKHNobWVtLT5mMyksIEZV
VEVYX1dBS0VfQklUU0VULCAzLCBOVUxMLCBOVUxMLCAweEZGRkZGQzAwKTsK
ICAgICAgICAgICAgaWYgKHIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXggZmFp
bGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5F
X18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAgdGtp
bGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAgICBl
eGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgZWxz
ZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmlu
dGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCByZXR1
cm5lZCAlZCB3aGVuIHdha2luZyBubyBwcm9jZXNzXG4iLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAgICAgICAg
ICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAg
ICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAg
ICAgfQogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMpLCBGVVRF
WF9XQUtFX0JJVFNFVCwgMywgTlVMTCwgTlVMTCwgMHhGRkZGRkQwMCk7CiAg
ICAgICAgICAgIGlmIChyICE9IDIpCiAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgIGlmIChyIDwgMCkKICAgICAgICAgICAgICAgIHsKICAgICAgICAg
ICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIkF0IGxpbmUgJWQgZnV0ZXgg
ZmFpbGVkICVzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgX19M
SU5FX18sIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgICAgICAgICAgICAg
dGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAgICAgICAgICAgICAg
ICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAg
ZWxzZQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZw
cmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBGVVRFWF9XQUtFX0JJVFNFVCBy
ZXR1cm5lZCAlZCB3aGVuIDIgcHJvY2Vzc2VzIHRvIHdha2VcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAg
ICAgICAgICB9CiAgICAgICAgICAgIHRocmVhZF9hY3Rpb24gPSAxNTsKICAg
ICAgICAgICAgd2FpdF9mb3JfdGhyZWFkKCk7CiAgICAgICAgICAgIHNobWVt
LT5jaGlsZF9hY3Rpb24gPSAxNjsKICAgICAgICAgICAgd2FpdF9mb3JfY2hp
bGQoKTsKICAgICAgICAgICAgciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVU
RVhfV0FLRV9CSVRTRVQsIDMsIE5VTEwsIE5VTEwsIDB4MzAwKTsKICAgICAg
ICAgICAgaWYgKHIgIT0gMSkKICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgaWYgKHIgPCAwKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAg
ICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWls
ZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVf
Xywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAgICB0a2ls
bChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgZnByaW50
ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfQklUU0VUIHJldHVy
bmVkICVkIHdoZW4gb25seSB3YWtpbmcgb25lIHByb2Nlc3NcbiIsCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgcik7CiAgICAgICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgICAgICBleGl0KDEpOwogICAgICAgICAgICAgICAgfQogICAg
ICAgICAgICB9CiAgICAgICAgICAgIGlmIChzaG1lbS0+Y2hpbGRfYWN0aW9u
KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkF0IGxpbmUgJWQgRlVURVhfV0FLRV9CSVRTRVQgd29rZSB3cm9uZyBw
cm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXyk7
CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwog
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQogICAgICAg
ICAgICB0aHJlYWRfYWN0aW9uID0gMTU7CiAgICAgICAgICAgIHdhaXRfZm9y
X3RocmVhZCgpOwogICAgICAgICAgICByID0gZnV0ZXgoJihzaG1lbS0+ZjMp
LCBGVVRFWF9XQUtFX0JJVFNFVCwgMywgTlVMTCwgTlVMTCwgMHgzMDAwKTsK
ICAgICAgICAgICAgaWYgKHIgIT0gMSkKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgaWYgKHIgPCAwKQogICAgICAgICAgICAgICAgewogICAgICAg
ICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiQXQgbGluZSAlZCBmdXRl
eCBmYWlsZWQgJXNcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBf
X0xJTkVfXywgc3RyZXJyb3IoZXJybm8pKTsKICAgICAgICAgICAgICAgICAg
ICB0a2lsbChjaGlsZF9waWQsIFNJR0tJTEwpOwogICAgICAgICAgICAgICAg
ICAgIGV4aXQoMSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICBlbHNlCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRlcnIsICJBdCBsaW5lICVkIEZVVEVYX1dBS0VfQklUU0VU
IHJldHVybmVkICVkIG9ubHkgd2FraW5nIG9uZSBwcm9jZXNzXG4iLAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHIpOwogICAgICAg
ICAgICAgICAgICAgIHRraWxsKGNoaWxkX3BpZCwgU0lHS0lMTCk7CiAgICAg
ICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgICAgIH0KICAg
ICAgICAgICAgfQogICAgICAgICAgICBpZiAobmFub3NsZWVwKCZURU5fbXMs
IE5VTEwpKQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBmcHJpbnRm
KHN0ZGVyciwgIkF0IGxpbmUgJWQgbmFub3NsZWVwIGZhaWxlZCAlc1xuIiwK
ICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18sIHN0cmVycm9yKGVy
cm5vKSk7CiAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBpZiAoc2htZW0tPmNoaWxkX2FjdGlvbiAhPSAxNykKICAg
ICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJB
dCBsaW5lICVkIEZVVEVYX1dBS0VfQklUU0VUIHdva2Ugd3JvbmcgcHJvY2Vz
c1xuIiwKICAgICAgICAgICAgICAgICAgICAgICAgX19MSU5FX18pOwogICAg
ICAgICAgICAgICAgdGtpbGwoY2hpbGRfcGlkLCBTSUdLSUxMKTsKICAgICAg
ICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAgIH0KICAgICAgICAgICAg
ciA9IGZ1dGV4KCYoc2htZW0tPmYzKSwgRlVURVhfV0FLRV9CSVRTRVQsIDMs
IE5VTEwsIE5VTEwsIDB4MzAwKTsKICAgICAgICAgICAgaWYgKHIgIT0gMSkK
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3Rk
ZXJyLCAiQXQgbGluZSAlZCBmdXRleCBmYWlsZWQgJXNcbiIsCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8p
KTsKICAgICAgICAgICAgICAgICAgICB0a2lsbChjaGlsZF9waWQsIFNJR0tJ
TEwpOwogICAgICAgICAgICAgICAgICAgIGV4aXQoMSk7CiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICB7
CiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJBdCBsaW5l
ICVkIEZVVEVYX1dBS0VfQklUU0VUIHJldHVybmVkICVkIG9ubHkgd2FraW5n
IG9uZSBwcm9jZXNzXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAg
X19MSU5FX18sIHIpOwogICAgICAgICAgICAgICAgICAgIHRraWxsKGNoaWxk
X3BpZCwgU0lHS0lMTCk7CiAgICAgICAgICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgIH0KICAg
IH0KICAgIGZwcmludGYoc3Rkb3V0LCAiVGVzdCBzdWNjZWVkZWRcbiIpOwog
ICAgZXhpdCgwKTsKfQo=

--0-204985010-1263374560=:49075--
