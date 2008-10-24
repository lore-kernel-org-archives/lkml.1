Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYJXJAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYJXJAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYJXI7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:59:55 -0400
Received: from mailove.nx.uz ([91.188.134.131]:35485 "EHLO mailove.nx.uz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYJXI7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:59:50 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 04:59:48 EDT
Date: Fri, 24 Oct 2008 13:00:07 +0500
From: Terleev Roman <lost@nx.uz>
X-Mailer: SecureBat! Lite (v2.10.02)
Reply-To: Terleev Roman <lost@nx.uz>
Organization: InterNEXT
X-Priority: 3 (Normal)
Message-ID: <11610630312.20081024130007@nx.uz>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: too much RX drop packets on kernel 2.6.26 and 2.6.27.x
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------4D1C011818CC7836"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------4D1C011818CC7836
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

hello, linux-kernel.

[1.] One line summary of the problem:
too much RX drop packets

[2.] Full description of the problem/report:
"Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit
Ethernet controller" - network is up and working, but too much more drop
packets:

working int:
#ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 00:1F:D0:5C:1A:5A  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:7323 errors:0 dropped:7564458177891 overruns:0 frame:0
          TX packets:8388 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:688493 (672.3 KiB)  TX bytes:5088993 (4.8 MiB)
          Interrupt:251 Base address:0x4000 

not active int and network cable unplug:
#ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 00:1F:D0:80:06:5E  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:250 Base address:0x6000

then i add ip on eth1:
[root@wax ~]# ifconfig eth1 40.40.40.1/24 up
[root@wax ~]# ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 00:1F:D0:80:06:5E  
          inet addr:40.40.40.1  Bcast:40.40.40.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:485645351 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:250 Base address:0x6000 
p.s. network cable unplug!!!

p.p.s. i found old PCI ether card realtek RTL-8129 and compile modules.
ether working fine and drop packets is "0":
[root@wax ~]# ifconfig eth2 50.50.50.1/24 up
[root@wax ~]# ifconfig eth2
eth2      Link encap:Ethernet  HWaddr 00:00:00:00:00:00  
          inet addr:50.50.50.1  Bcast:50.50.50.255  Mask:255.255.255.0
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:5 Base address:0xd000

if i use default kernel: 2.6.25-14.fc9.x86_64 - link up, but any
packets reject.
          
[3.] Keywords (i.e., modules, networking, kernel):
modules

[4.] Kernel version (from):
#cat /proc/version
Linux version 2.6.27.3 (root@wax.infonet.uz) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #6 SMP Thu Oct 23 19:39:33 UZT 2008


[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)
no information

[6.] A small shell script or example program which triggers the
     problem (if possible)
no information

[7.] Environment
no information

[7.1.] Software (add the output of the ver_linux script here)
./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux wax.infonet.uz 2.6.27.3 #6 SMP Thu Oct 23 19:39:33 UZT 2008 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.3.0
Gnu make               3.81
binutils               2.18.50.0.6
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.8
reiserfsprogs          3.6.19
pcmciautils            014
quota-tools            3.15.
PPP                    2.4.4
isdn4k-utils           3.9
Linux C Library        2.8
Dynamic linker (ldd)   2.8
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.10
udev                   120
wireless-tools         29
Modules Loaded 8021q reiserfs loop dm_multipath i2c_i801 pata_jmicron
rtc_cmos intel_agp rtc_core pcspkr 8139too i2c_core sg button rtc_lib
r8169 mii dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix
ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd
ohci_hcd ehci_hcd

[7.2.] Processor information (from /proc/cpuinfo):
cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping        : 10
cpu MHz         : 2666.344
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips        : 5332.68
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping        : 10
cpu MHz         : 2666.344
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips        : 5332.52
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping        : 10
cpu MHz         : 2666.344
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips        : 5332.54
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping        : 10
cpu MHz         : 2666.344
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips        : 5332.54
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
cat /proc/modules
8021q 24080 0 - Live 0xffffffffa0172000
reiserfs 227544 1 - Live 0xffffffffa0139000
loop 18572 0 - Live 0xffffffffa0133000
dm_multipath 18840 0 - Live 0xffffffffa012d000
i2c_i801 13724 0 - Live 0xffffffffa0128000
pata_jmicron 8064 0 - Live 0xffffffffa0125000
rtc_cmos 14776 0 - Live 0xffffffffa0120000
intel_agp 32112 0 - Live 0xffffffffa0117000
rtc_core 20148 1 rtc_cmos, Live 0xffffffffa0111000
pcspkr 6912 0 - Live 0xffffffffa010c000
8139too 29184 0 - Live 0xffffffffa0101000
i2c_core 25248 1 i2c_i801, Live 0xffffffffa00f7000
sg 36176 0 - Live 0xffffffffa00ed000
button 11680 0 - Live 0xffffffffa00e7000
rtc_lib 6912 1 rtc_core, Live 0xffffffffa00e4000
r8169 32388 0 - Live 0xffffffffa00db000
mii 8960 1 8139too, Live 0xffffffffa00d7000
dm_snapshot 20552 0 - Live 0xffffffffa00d0000
dm_zero 6144 0 - Live 0xffffffffa00cd000
dm_mirror 21376 0 - Live 0xffffffffa00c6000
dm_log 13572 1 dm_mirror, Live 0xffffffffa00c1000
dm_mod 56928 10 dm_multipath,dm_snapshot,dm_zero,dm_mirror,dm_log, Live 0xffffffffa00b2000
ata_piix 24324 6 - Live 0xffffffffa00ab000
ata_generic 9860 0 - Live 0xffffffffa00a7000
pata_acpi 8960 0 - Live 0xffffffffa00a3000
libata 155040 4 pata_jmicron,ata_piix,ata_generic,pata_acpi, Live 0xffffffffa007c000
sd_mod 30632 7 - Live 0xffffffffa0073000
scsi_mod 149336 3 sg,libata,sd_mod, Live 0xffffffffa004d000
ext3 125712 5 - Live 0xffffffffa002d000
jbd 50984 1 ext3, Live 0xffffffffa001f000
mbcache 12164 1 ext3, Live 0xffffffffa001b000
uhci_hcd 26400 0 - Live 0xffffffffa0013000
ohci_hcd 27292 0 - Live 0xffffffffa000b000
ehci_hcd 37900 0 - Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat /proc/ioports
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
0170-0177 : 0000:00:1f.2
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : ata_piix
0290-029f : pnp 00:01
  0290-0294 : pnp 00:01
0376-0376 : 0000:00:1f.2
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : ata_piix
03f8-03ff : serial
0400-04bf : pnp 00:09
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
a000-afff : PCI Bus 0000:02
  a000-a007 : 0000:02:00.0
    a000-a007 : pata_jmicron
  a100-a103 : 0000:02:00.0
    a100-a103 : pata_jmicron
  a200-a207 : 0000:02:00.0
    a200-a207 : pata_jmicron
  a300-a303 : 0000:02:00.0
    a300-a303 : pata_jmicron
  a400-a40f : 0000:02:00.0
    a400-a40f : pata_jmicron
b000-bfff : PCI Bus 0000:03
  b000-b0ff : 0000:03:00.0
    b000-b0ff : r8169
c000-cfff : PCI Bus 0000:04
  c000-c0ff : 0000:04:00.0
    c000-c0ff : r8169
d000-dfff : PCI Bus 0000:05
  d000-d0ff : 0000:05:00.0
    d000-d0ff : 8139too
e000-e01f : 0000:00:1a.1
  e000-e01f : uhci_hcd
e100-e11f : 0000:00:1a.2
  e100-e11f : uhci_hcd
e200-e21f : 0000:00:1d.0
  e200-e21f : uhci_hcd
e300-e31f : 0000:00:1d.1
  e300-e31f : uhci_hcd
e400-e41f : 0000:00:1d.2
  e400-e41f : uhci_hcd
e500-e51f : 0000:00:1a.0
  e500-e51f : uhci_hcd
e700-e707 : 0000:00:1f.5
  e700-e707 : ata_piix
e800-e803 : 0000:00:1f.5
  e800-e803 : ata_piix
e900-e907 : 0000:00:1f.5
  e900-e907 : ata_piix
ea00-ea03 : 0000:00:1f.5
  ea00-ea03 : ata_piix
eb00-eb0f : 0000:00:1f.5
  eb00-eb0f : ata_piix
ec00-ec0f : 0000:00:1f.5
  ec00-ec0f : ata_piix
f000-f00f : 0000:00:1f.2
  f000-f00f : ata_piix
f100-f10f : 0000:00:1f.2
  f100-f10f : ata_piix

cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000f0000-000fffff : reserved
00100000-efedffff : System RAM
  00200000-0043f7ad : Kernel code
  0043f7ae-005a11ef : Kernel data
  00b1f000-00b92867 : Kernel bss
efee0000-efee2fff : ACPI Non-volatile Storage
efee3000-efeeffff : ACPI Tables
efef0000-efefffff : reserved
f0000000-f3ffffff : PCI MMCONFIG 0
  f0000000-f3ffffff : reserved
f4000000-f4ffffff : PCI Bus 0000:02
f5000000-f5ffffff : PCI Bus 0000:03
f6000000-f6ffffff : PCI Bus 0000:04
f7000000-f8ffffff : PCI Bus 0000:05
  f7000000-f7ffffff : 0000:05:01.0
  f8000000-f80000ff : 0000:05:00.0
    f8000000-f80000ff : 8139too
f9000000-f9ffffff : PCI Bus 0000:05
  f9000000-f9ffffff : 0000:05:01.0
fa000000-fa0fffff : PCI Bus 0000:03
  fa000000-fa00ffff : 0000:03:00.0
    fa000000-fa00ffff : r8169
  fa010000-fa010fff : 0000:03:00.0
    fa010000-fa010fff : r8169
  fa020000-fa02ffff : 0000:03:00.0
fa100000-fa1fffff : PCI Bus 0000:04
  fa100000-fa10ffff : 0000:04:00.0
    fa100000-fa10ffff : r8169
  fa110000-fa110fff : 0000:04:00.0
    fa110000-fa110fff : r8169
  fa120000-fa12ffff : 0000:04:00.0
fa200000-fa2003ff : 0000:00:1a.7
  fa200000-fa2003ff : ehci_hcd
fa201000-fa2013ff : 0000:00:1d.7
  fa201000-fa2013ff : ehci_hcd
fa202000-fa2020ff : 0000:00:1f.3
fec00000-ffffffff : reserved
  fed00000-fed003ff : HPET 0
  fee00000-fee00fff : Local APIC
100000000-10fffffff : System RAM

[7.5.] PCI information ('lspci -vvv' as root)
see attach "lspci.txt"

[7.6.] SCSI information (from /proc/scsi/scsi)
cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG HD161HJ  Rev: JF10
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
no information

[X.] Other notes, patches, fixes, workarounds:
no information

-- 
 Terleev                          mailto:lost@nx.uz
------------4D1C011818CC7836
Content-Type: text/plain; name="lspci.txt"
Content-transfer-encoding: base64
Content-Disposition: attachment; filename="lspci.txt"

bHNwY2kgLXZ2dg0KMDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gRWFn
bGVsYWtlIERSQU0gQ29udHJvbGxlciAocmV2IDAyKQ0KICAgICAgICBTdWJzeXN0ZW06IEdp
Z2EtYnl0ZSBUZWNobm9sb2d5IFVua25vd24gZGV2aWNlIDUwMDANCiAgICAgICAgQ29udHJv
bDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0NCiAgICAgICAgU3Rh
dHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPlNFUlItIDxQRVJSKyBJTlR4LQ0KICAgICAgICBM
YXRlbmN5OiAwDQogICAgICAgIENhcGFiaWxpdGllczogW2UwXSBWZW5kb3IgU3BlY2lmaWMg
SW5mb3JtYXRpb24gPD8+DQogICAgICAgIEtlcm5lbCBtb2R1bGVzOiBpbnRlbC1hZ3ANCg0K
MDA6MWEuMCBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgVVNCIFVI
Q0kgQ29udHJvbGxlciAjNCAocHJvZy1pZiAwMCBbVUhDSV0pDQogICAgICAgIFN1YnN5c3Rl
bTogR2lnYS1ieXRlIFRlY2hub2xvZ3kgVW5rbm93biBkZXZpY2UgNTAwNA0KICAgICAgICBD
b250cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQ0KICAgICAg
ICBTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVk
aXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAg
ICAgICAgTGF0ZW5jeTogMA0KICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJ
UlEgMTINCiAgICAgICAgUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCBlNTAwIFtzaXplPTMyXQ0K
ICAgICAgICBDYXBhYmlsaXRpZXM6IFs1MF0gUENJZSBhZHZhbmNlZCBmZWF0dXJlcyA8Pz4N
CiAgICAgICAgS2VybmVsIGRyaXZlciBpbiB1c2U6IHVoY2lfaGNkDQogICAgICAgIEtlcm5l
bCBtb2R1bGVzOiB1aGNpLWhjZA0KDQowMDoxYS4xIFVTQiBDb250cm9sbGVyOiBJbnRlbCBD
b3Jwb3JhdGlvbiBJQ0gxMCBVU0IgVUhDSSBDb250cm9sbGVyICM1IChwcm9nLWlmIDAwIFtV
SENJXSkNCiAgICAgICAgU3Vic3lzdGVtOiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBVbmtub3du
IGRldmljZSA1MDA0DQogICAgICAgIENvbnRyb2w6IEkvTysgTWVtLSBCdXNNYXN0ZXIrIFNw
ZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZh
c3RCMkItIERpc0lOVHgtDQogICAgICAgIFN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0
QjJCKyBQYXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0g
PlNFUlItIDxQRVJSLSBJTlR4LQ0KICAgICAgICBMYXRlbmN5OiAwDQogICAgICAgIEludGVy
cnVwdDogcGluIEIgcm91dGVkIHRvIElSUSA5DQogICAgICAgIFJlZ2lvbiA0OiBJL08gcG9y
dHMgYXQgZTAwMCBbc2l6ZT0zMl0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNTBdIFBDSWUg
YWR2YW5jZWQgZmVhdHVyZXMgPD8+DQogICAgICAgIEtlcm5lbCBkcml2ZXIgaW4gdXNlOiB1
aGNpX2hjZA0KICAgICAgICBLZXJuZWwgbW9kdWxlczogdWhjaS1oY2QNCg0KMDA6MWEuMiBV
U0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgVVNCIFVIQ0kgQ29udHJv
bGxlciAjNiAocHJvZy1pZiAwMCBbVUhDSV0pDQogICAgICAgIFN1YnN5c3RlbTogR2lnYS1i
eXRlIFRlY2hub2xvZ3kgVW5rbm93biBkZXZpY2UgNTAwNA0KICAgICAgICBDb250cm9sOiBJ
L08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJF
cnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQ0KICAgICAgICBTdGF0dXM6
IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAgICAgICAgTGF0
ZW5jeTogMA0KICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgMw0KICAg
ICAgICBSZWdpb24gNDogSS9PIHBvcnRzIGF0IGUxMDAgW3NpemU9MzJdDQogICAgICAgIENh
cGFiaWxpdGllczogWzUwXSBQQ0llIGFkdmFuY2VkIGZlYXR1cmVzIDw/Pg0KICAgICAgICBL
ZXJuZWwgZHJpdmVyIGluIHVzZTogdWhjaV9oY2QNCiAgICAgICAgS2VybmVsIG1vZHVsZXM6
IHVoY2ktaGNkDQoNCjAwOjFhLjcgVVNCIENvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9u
IElDSDEwIFVTQjIgRUhDSSBDb250cm9sbGVyICMyIChwcm9nLWlmIDIwIFtFSENJXSkNCiAg
ICAgICAgU3Vic3lzdGVtOiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBVbmtub3duIGRldmljZSA1
MDA2DQogICAgICAgIENvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0g
TWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERp
c0lOVHgtDQogICAgICAgIFN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJF
cnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLSBJTlR4LQ0KICAgICAgICBMYXRlbmN5OiAwDQogICAgICAgIEludGVycnVwdDogcGlu
IEMgcm91dGVkIHRvIElSUSAzDQogICAgICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQgZmEyMDAw
MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MUtdDQogICAgICAgIENhcGFi
aWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMg0KICAgICAgICAgICAg
ICAgIEZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAt
LEQxLSxEMi0sRDNob3QtLEQzY29sZC0pDQogICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBQ
TUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQ0KICAgICAgICBLZXJuZWwgZHJpdmVy
IGluIHVzZTogZWhjaV9oY2QNCiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGVoY2ktaGNkDQoN
CjAwOjFjLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgUENJIEV4cHJl
c3MgUG9ydCAxIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkNCiAgICAgICAgQ29udHJv
bDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeCsNCiAgICAgICAgU3Rh
dHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQ0KICAgICAgICBM
YXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDMyIGJ5dGVzDQogICAgICAgIEJ1czogcHJp
bWFyeT0wMCwgc2Vjb25kYXJ5PTAxLCBzdWJvcmRpbmF0ZT0wMSwgc2VjLWxhdGVuY3k9MA0K
ICAgICAgICBJL08gYmVoaW5kIGJyaWRnZTogMDAwMGYwMDAtMDAwMDBmZmYNCiAgICAgICAg
TWVtb3J5IGJlaGluZCBicmlkZ2U6IGZmZjAwMDAwLTAwMGZmZmZmDQogICAgICAgIFByZWZl
dGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmZmYwMDAwMC0wMDAwMDAw
MDAwMGZmZmZmDQogICAgICAgIFNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQ
YXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8
UEVSUi0NCiAgICAgICAgQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1B
Ym9ydC0gPlJlc2V0LSBGYXN0QjJCLQ0KICAgICAgICAgICAgICAgIFByaURpc2NUbXItIFNl
Y0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQ0KICAgICAgICBDYXBhYmls
aXRpZXM6IFs0MF0gRXhwcmVzcyAodjEpIFJvb3QgUG9ydCAoU2xvdCspLCBNU0kgMDANCiAg
ICAgICAgICAgICAgICBEZXZDYXA6IE1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMg
MCwgTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwxdXMNCiAgICAgICAgICAgICAgICAgICAgICAg
IEV4dFRhZy0gUkJFKyBGTFJlc2V0LQ0KICAgICAgICAgICAgICAgIERldkN0bDogUmVwb3J0
IGVycm9yczogQ29ycmVjdGFibGUrIE5vbi1GYXRhbCsgRmF0YWwrIFVuc3VwcG9ydGVkKw0K
ICAgICAgICAgICAgICAgICAgICAgICAgUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1
eFB3ci0gTm9Tbm9vcC0NCiAgICAgICAgICAgICAgICAgICAgICAgIE1heFBheWxvYWQgMTI4
IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcw0KICAgICAgICAgICAgICAgIERldlN0YTog
Q29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5z
UGVuZC0NCiAgICAgICAgICAgICAgICBMbmtDYXA6IFBvcnQgIzEsIFNwZWVkIDIuNUdUL3Ms
IFdpZHRoIHgxLCBBU1BNIEwwcywgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8NHVzDQogICAgICAg
ICAgICAgICAgICAgICAgICBDbG9ja1BNLSBTdXByaXNlLSBMTEFjdFJlcCsgQndOb3QtDQog
ICAgICAgICAgICAgICAgTG5rQ3RsOiBBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlz
YWJsZWQtIFJldHJhaW4tIENvbW1DbGstDQogICAgICAgICAgICAgICAgICAgICAgICBFeHRT
eW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtDQogICAgICAgICAg
ICAgICAgTG5rU3RhOiBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MCwgVHJFcnItIFRyYWluLSBT
bG90Q2xrKyBETEFjdGl2ZS0gQldNZ210LSBBQldNZ210LQ0KICAgICAgICAgICAgICAgIFNs
dENhcDogQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhvdFBsdWcr
IFN1cnBpc2UrDQogICAgICAgICAgICAgICAgICAgICAgICBTbG90ICMgMTAsIFBvd2VyTGlt
aXQgMTAuMDAwMDAwOyBJbnRlcmxvY2stIE5vQ29tcGwtDQogICAgICAgICAgICAgICAgU2x0
Q3RsOiBFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0LSBI
UElycS0gTGlua0NoZy0NCiAgICAgICAgICAgICAgICAgICAgICAgIENvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stDQogICAgICAg
ICAgICAgICAgU2x0U3RhOiBTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENw
bHQtIFByZXNEZXQtIEludGVybG9jay0NCiAgICAgICAgICAgICAgICAgICAgICAgIENoYW5n
ZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlLQ0KICAgICAgICAgICAgICAgIFJvb3RDdGw6
IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENS
U1Zpc2libGUtDQogICAgICAgICAgICAgICAgUm9vdENhcDogQ1JTVmlzaWJsZS0NCiAgICAg
ICAgICAgICAgICBSb290U3RhOiBQTUUgUmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5k
aW5nLQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFs4MF0gTWVzc2FnZSBTaWduYWxsZWQgSW50
ZXJydXB0czogTWFzay0gNjRiaXQtIFF1ZXVlPTAvMCBFbmFibGUrDQogICAgICAgICAgICAg
ICAgQWRkcmVzczogZmVlMGYwMGMgIERhdGE6IDQxNDkNCiAgICAgICAgQ2FwYWJpbGl0aWVz
OiBbOTBdIFN1YnN5c3RlbTogR2lnYS1ieXRlIFRlY2hub2xvZ3kgVW5rbm93biBkZXZpY2Ug
NTAwMQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJz
aW9uIDINCiAgICAgICAgICAgICAgICBGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4
Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQ0KICAgICAgICAg
ICAgICAgIFN0YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0NCiAg
ICAgICAgQ2FwYWJpbGl0aWVzOiBbMTAwXSBWaXJ0dWFsIENoYW5uZWwgPD8+DQogICAgICAg
IENhcGFiaWxpdGllczogWzE4MF0gUm9vdCBDb21wbGV4IExpbmsgPD8+DQogICAgICAgIEtl
cm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydC1kcml2ZXINCg0KMDA6MWMuMyBQQ0kgYnJp
ZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiBJQ0gxMCBQQ0kgRXhwcmVzcyBQb3J0IDQgKHByb2ct
aWYgMDAgW05vcm1hbCBkZWNvZGVdKQ0KICAgICAgICBDb250cm9sOiBJL08rIE1lbSsgQnVz
TWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4Kw0KICAgICAgICBTdGF0dXM6IENhcCsgNjZNSHot
IFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtDQogICAgICAgIExhdGVuY3k6IDAsIENhY2hl
IExpbmUgU2l6ZTogMzIgYnl0ZXMNCiAgICAgICAgQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRh
cnk9MDIsIHN1Ym9yZGluYXRlPTAyLCBzZWMtbGF0ZW5jeT0wDQogICAgICAgIEkvTyBiZWhp
bmQgYnJpZGdlOiAwMDAwYTAwMC0wMDAwYWZmZg0KICAgICAgICBNZW1vcnkgYmVoaW5kIGJy
aWRnZTogZjQwMDAwMDAtZjRmZmZmZmYNCiAgICAgICAgUHJlZmV0Y2hhYmxlIG1lbW9yeSBi
ZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGZmZjAwMDAwLTAwMDAwMDAwMDAwZmZmZmYNCiAgICAg
ICAgU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZh
c3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQ0KICAgICAgICBC
cmlkZ2VDdGw6IFBhcml0eS0gU0VSUi0gTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZh
c3RCMkItDQogICAgICAgICAgICAgICAgUHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1Rt
clN0YXQtIERpc2NUbXJTRVJSRW4tDQogICAgICAgIENhcGFiaWxpdGllczogWzQwXSBFeHBy
ZXNzICh2MSkgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMA0KICAgICAgICAgICAgICAgIERl
dkNhcDogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8
NjRucywgTDEgPDF1cw0KICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBSQkUrIEZM
UmVzZXQtDQogICAgICAgICAgICAgICAgRGV2Q3RsOiBSZXBvcnQgZXJyb3JzOiBDb3JyZWN0
YWJsZSsgTm9uLUZhdGFsKyBGYXRhbCsgVW5zdXBwb3J0ZWQrDQogICAgICAgICAgICAgICAg
ICAgICAgICBSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQ0K
ICAgICAgICAgICAgICAgICAgICAgICAgTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRS
ZXEgMTI4IGJ5dGVzDQogICAgICAgICAgICAgICAgRGV2U3RhOiBDb3JyRXJyLSBVbmNvcnJF
cnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQ0KICAgICAgICAg
ICAgICAgIExua0NhcDogUG9ydCAjNCwgU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIEFTUE0g
TDBzLCBMYXRlbmN5IEwwIDwyNTZucywgTDEgPDR1cw0KICAgICAgICAgICAgICAgICAgICAg
ICAgQ2xvY2tQTS0gU3VwcmlzZS0gTExBY3RSZXArIEJ3Tm90LQ0KICAgICAgICAgICAgICAg
IExua0N0bDogQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWlu
LSBDb21tQ2xrKw0KICAgICAgICAgICAgICAgICAgICAgICAgRXh0U3luY2gtIENsb2NrUE0t
IEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQ0KICAgICAgICAgICAgICAgIExua1N0YTog
U3BlZWQgMi41R1QvcywgV2lkdGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3Rp
dmUrIEJXTWdtdC0gQUJXTWdtdC0NCiAgICAgICAgICAgICAgICBTbHRDYXA6IEF0dG5CdG4t
IFB3ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnKyBTdXJwaXNlKw0KICAg
ICAgICAgICAgICAgICAgICAgICAgU2xvdCAjIDEzLCBQb3dlckxpbWl0IDEwLjAwMDAwMDsg
SW50ZXJsb2NrLSBOb0NvbXBsLQ0KICAgICAgICAgICAgICAgIFNsdEN0bDogRW5hYmxlOiBB
dHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0gQ21kQ3BsdC0gSFBJcnEtIExpbmtDaGct
DQogICAgICAgICAgICAgICAgICAgICAgICBDb250cm9sOiBBdHRuSW5kIFVua25vd24sIFB3
ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQ0KICAgICAgICAgICAgICAgIFNsdFN0
YTogU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJ
bnRlcmxvY2stDQogICAgICAgICAgICAgICAgICAgICAgICBDaGFuZ2VkOiBNUkwtIFByZXNE
ZXQrIExpbmtTdGF0ZSsNCiAgICAgICAgICAgICAgICBSb290Q3RsOiBFcnJDb3JyZWN0YWJs
ZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQ0KICAg
ICAgICAgICAgICAgIFJvb3RDYXA6IENSU1Zpc2libGUtDQogICAgICAgICAgICAgICAgUm9v
dFN0YTogUE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0NCiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbODBdIE1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6IE1hc2st
IDY0Yml0LSBRdWV1ZT0wLzAgRW5hYmxlKw0KICAgICAgICAgICAgICAgIEFkZHJlc3M6IGZl
ZTBmMDBjICBEYXRhOiA0MTUxDQogICAgICAgIENhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0
ZW06IEdpZ2EtYnl0ZSBUZWNobm9sb2d5IFVua25vd24gZGV2aWNlIDUwMDENCiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyDQogICAgICAg
ICAgICAgICAgRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykNCiAgICAgICAgICAgICAgICBTdGF0dXM6
IEQwIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtDQogICAgICAgIENhcGFiaWxp
dGllczogWzEwMF0gVmlydHVhbCBDaGFubmVsIDw/Pg0KICAgICAgICBDYXBhYmlsaXRpZXM6
IFsxODBdIFJvb3QgQ29tcGxleCBMaW5rIDw/Pg0KICAgICAgICBLZXJuZWwgZHJpdmVyIGlu
IHVzZTogcGNpZXBvcnQtZHJpdmVyDQoNCjAwOjFjLjQgUENJIGJyaWRnZTogSW50ZWwgQ29y
cG9yYXRpb24gSUNIMTAgUENJIEV4cHJlc3MgUG9ydCA1IChwcm9nLWlmIDAwIFtOb3JtYWwg
ZGVjb2RlXSkNCiAgICAgICAgQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5
Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIy
Qi0gRGlzSU5UeCsNCiAgICAgICAgU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIt
IFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlIt
IDxQRVJSLSBJTlR4LQ0KICAgICAgICBMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDMy
IGJ5dGVzDQogICAgICAgIEJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTAzLCBzdWJvcmRp
bmF0ZT0wMywgc2VjLWxhdGVuY3k9MA0KICAgICAgICBJL08gYmVoaW5kIGJyaWRnZTogMDAw
MGIwMDAtMDAwMGJmZmYNCiAgICAgICAgTWVtb3J5IGJlaGluZCBicmlkZ2U6IGY1MDAwMDAw
LWY1ZmZmZmZmDQogICAgICAgIFByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTog
MDAwMDAwMDBmYTAwMDAwMC0wMDAwMDAwMGZhMGZmZmZmDQogICAgICAgIFNlY29uZGFyeSBz
dGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxU
QWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0NCiAgICAgICAgQnJpZGdlQ3RsOiBQYXJp
dHktIFNFUlItIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQ0KICAgICAg
ICAgICAgICAgIFByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1y
U0VSUkVuLQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFs0MF0gRXhwcmVzcyAodjEpIFJvb3Qg
UG9ydCAoU2xvdCspLCBNU0kgMDANCiAgICAgICAgICAgICAgICBEZXZDYXA6IE1heFBheWxv
YWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwxdXMN
CiAgICAgICAgICAgICAgICAgICAgICAgIEV4dFRhZy0gUkJFKyBGTFJlc2V0LQ0KICAgICAg
ICAgICAgICAgIERldkN0bDogUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUrIE5vbi1GYXRh
bCsgRmF0YWwrIFVuc3VwcG9ydGVkKw0KICAgICAgICAgICAgICAgICAgICAgICAgUmx4ZE9y
ZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0NCiAgICAgICAgICAgICAg
ICAgICAgICAgIE1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcw0K
ICAgICAgICAgICAgICAgIERldlN0YTogQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0g
VW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5zUGVuZC0NCiAgICAgICAgICAgICAgICBMbmtDYXA6
IFBvcnQgIzUsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcywgTGF0ZW5jeSBM
MCA8MjU2bnMsIEwxIDw0dXMNCiAgICAgICAgICAgICAgICAgICAgICAgIENsb2NrUE0tIFN1
cHJpc2UtIExMQWN0UmVwKyBCd05vdC0NCiAgICAgICAgICAgICAgICBMbmtDdGw6IEFTUE0g
RGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysNCiAg
ICAgICAgICAgICAgICAgICAgICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJX
SW50LSBBdXRCV0ludC0NCiAgICAgICAgICAgICAgICBMbmtTdGE6IFNwZWVkIDIuNUdUL3Ms
IFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQtIEFC
V01nbXQtDQogICAgICAgICAgICAgICAgU2x0Q2FwOiBBdHRuQnRuLSBQd3JDdHJsLSBNUkwt
IEF0dG5JbmQtIFB3ckluZC0gSG90UGx1ZysgU3VycGlzZSsNCiAgICAgICAgICAgICAgICAg
ICAgICAgIFNsb3QgIyAxNCwgUG93ZXJMaW1pdCAxMC4wMDAwMDA7IEludGVybG9jay0gTm9D
b21wbC0NCiAgICAgICAgICAgICAgICBTbHRDdGw6IEVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0
LSBNUkwtIFByZXNEZXQtIENtZENwbHQtIEhQSXJxLSBMaW5rQ2hnLQ0KICAgICAgICAgICAg
ICAgICAgICAgICAgQ29udHJvbDogQXR0bkluZCBVbmtub3duLCBQd3JJbmQgVW5rbm93biwg
UG93ZXItIEludGVybG9jay0NCiAgICAgICAgICAgICAgICBTbHRTdGE6IFN0YXR1czogQXR0
bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0gUHJlc0RldCsgSW50ZXJsb2NrLQ0KICAg
ICAgICAgICAgICAgICAgICAgICAgQ2hhbmdlZDogTVJMLSBQcmVzRGV0KyBMaW5rU3RhdGUr
DQogICAgICAgICAgICAgICAgUm9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRh
bC0gRXJyRmF0YWwtIFBNRUludEVuYS0gQ1JTVmlzaWJsZS0NCiAgICAgICAgICAgICAgICBS
b290Q2FwOiBDUlNWaXNpYmxlLQ0KICAgICAgICAgICAgICAgIFJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctDQogICAgICAgIENhcGFiaWxpdGllczog
WzgwXSBNZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiBNYXNrLSA2NGJpdC0gUXVldWU9
MC8wIEVuYWJsZSsNCiAgICAgICAgICAgICAgICBBZGRyZXNzOiBmZWUwZjAwYyAgRGF0YTog
NDE1OQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFs5MF0gU3Vic3lzdGVtOiBHaWdhLWJ5dGUg
VGVjaG5vbG9neSBVbmtub3duIGRldmljZSA1MDAxDQogICAgICAgIENhcGFiaWxpdGllczog
W2EwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMg0KICAgICAgICAgICAgICAgIEZsYWdz
OiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxLSxEMi0s
RDNob3QrLEQzY29sZCspDQogICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBQTUUtRW5hYmxl
LSBEU2VsPTAgRFNjYWxlPTAgUE1FLQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFsxMDBdIFZp
cnR1YWwgQ2hhbm5lbCA8Pz4NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbMTgwXSBSb290IENv
bXBsZXggTGluayA8Pz4NCiAgICAgICAgS2VybmVsIGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0
LWRyaXZlcg0KDQowMDoxYy41IFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIElDSDEw
IFBDSSBFeHByZXNzIFBvcnQgNiAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pDQogICAg
ICAgIENvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrDQog
ICAgICAgIFN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNF
TD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0N
CiAgICAgICAgTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiAzMiBieXRlcw0KICAgICAg
ICBCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wNCwgc3Vib3JkaW5hdGU9MDQsIHNlYy1s
YXRlbmN5PTANCiAgICAgICAgSS9PIGJlaGluZCBicmlkZ2U6IDAwMDBjMDAwLTAwMDBjZmZm
DQogICAgICAgIE1lbW9yeSBiZWhpbmQgYnJpZGdlOiBmNjAwMDAwMC1mNmZmZmZmZg0KICAg
ICAgICBQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZmExMDAw
MDAtMDAwMDAwMDBmYTFmZmZmZg0KICAgICAgICBTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0g
RmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA8U0VSUi0gPFBFUlItDQogICAgICAgIEJyaWRnZUN0bDogUGFyaXR5LSBTRVJSLSBOb0lT
QS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0NCiAgICAgICAgICAgICAgICBQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0NCiAgICAg
ICAgQ2FwYWJpbGl0aWVzOiBbNDBdIEV4cHJlc3MgKHYxKSBSb290IFBvcnQgKFNsb3QrKSwg
TVNJIDAwDQogICAgICAgICAgICAgICAgRGV2Q2FwOiBNYXhQYXlsb2FkIDEyOCBieXRlcywg
UGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzDQogICAgICAgICAgICAg
ICAgICAgICAgICBFeHRUYWctIFJCRSsgRkxSZXNldC0NCiAgICAgICAgICAgICAgICBEZXZD
dGw6IFJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlKyBOb24tRmF0YWwrIEZhdGFsKyBVbnN1
cHBvcnRlZCsNCiAgICAgICAgICAgICAgICAgICAgICAgIFJseGRPcmQtIEV4dFRhZy0gUGhh
bnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtDQogICAgICAgICAgICAgICAgICAgICAgICBNYXhQ
YXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMNCiAgICAgICAgICAgICAg
ICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4
UHdyKyBUcmFuc1BlbmQtDQogICAgICAgICAgICAgICAgTG5rQ2FwOiBQb3J0ICM2LCBTcGVl
ZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMsIExhdGVuY3kgTDAgPDI1Nm5zLCBMMSA8
NHVzDQogICAgICAgICAgICAgICAgICAgICAgICBDbG9ja1BNLSBTdXByaXNlLSBMTEFjdFJl
cCsgQndOb3QtDQogICAgICAgICAgICAgICAgTG5rQ3RsOiBBU1BNIERpc2FibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrDQogICAgICAgICAgICAgICAg
ICAgICAgICBFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQt
DQogICAgICAgICAgICAgICAgTG5rU3RhOiBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJF
cnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZSsgQldNZ210LSBBQldNZ210LQ0KICAgICAg
ICAgICAgICAgIFNsdENhcDogQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJ
bmQtIEhvdFBsdWcrIFN1cnBpc2UrDQogICAgICAgICAgICAgICAgICAgICAgICBTbG90ICMg
MTUsIFBvd2VyTGltaXQgMTAuMDAwMDAwOyBJbnRlcmxvY2stIE5vQ29tcGwtDQogICAgICAg
ICAgICAgICAgU2x0Q3RsOiBFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0
LSBDbWRDcGx0LSBIUElycS0gTGlua0NoZy0NCiAgICAgICAgICAgICAgICAgICAgICAgIENv
bnRyb2w6IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxv
Y2stDQogICAgICAgICAgICAgICAgU2x0U3RhOiBTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0
LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIEludGVybG9jay0NCiAgICAgICAgICAgICAgICAg
ICAgICAgIENoYW5nZWQ6IE1STC0gUHJlc0RldCsgTGlua1N0YXRlKw0KICAgICAgICAgICAg
ICAgIFJvb3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQ
TUVJbnRFbmEtIENSU1Zpc2libGUtDQogICAgICAgICAgICAgICAgUm9vdENhcDogQ1JTVmlz
aWJsZS0NCiAgICAgICAgICAgICAgICBSb290U3RhOiBQTUUgUmVxSUQgMDAwMCwgUE1FU3Rh
dHVzLSBQTUVQZW5kaW5nLQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFs4MF0gTWVzc2FnZSBT
aWduYWxsZWQgSW50ZXJydXB0czogTWFzay0gNjRiaXQtIFF1ZXVlPTAvMCBFbmFibGUrDQog
ICAgICAgICAgICAgICAgQWRkcmVzczogZmVlMGYwMGMgIERhdGE6IDQxNjENCiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogR2lnYS1ieXRlIFRlY2hub2xvZ3kgVW5r
bm93biBkZXZpY2UgNTAwMQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFthMF0gUG93ZXIgTWFu
YWdlbWVudCB2ZXJzaW9uIDINCiAgICAgICAgICAgICAgICBGbGFnczogUE1FQ2xrLSBEU0kt
IEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQr
KQ0KICAgICAgICAgICAgICAgIFN0YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2Fs
ZT0wIFBNRS0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbMTAwXSBWaXJ0dWFsIENoYW5uZWwg
PD8+DQogICAgICAgIENhcGFiaWxpdGllczogWzE4MF0gUm9vdCBDb21wbGV4IExpbmsgPD8+
DQogICAgICAgIEtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydC1kcml2ZXINCg0KMDA6
MWQuMCBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgVVNCIFVIQ0kg
Q29udHJvbGxlciAjMSAocHJvZy1pZiAwMCBbVUhDSV0pDQogICAgICAgIFN1YnN5c3RlbTog
R2lnYS1ieXRlIFRlY2hub2xvZ3kgVW5rbm93biBkZXZpY2UgNTAwNA0KICAgICAgICBDb250
cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29w
LSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQ0KICAgICAgICBT
dGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVt
ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAgICAg
ICAgTGF0ZW5jeTogMA0KICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEg
Nw0KICAgICAgICBSZWdpb24gNDogSS9PIHBvcnRzIGF0IGUyMDAgW3NpemU9MzJdDQogICAg
ICAgIENhcGFiaWxpdGllczogWzUwXSBQQ0llIGFkdmFuY2VkIGZlYXR1cmVzIDw/Pg0KICAg
ICAgICBLZXJuZWwgZHJpdmVyIGluIHVzZTogdWhjaV9oY2QNCiAgICAgICAgS2VybmVsIG1v
ZHVsZXM6IHVoY2ktaGNkDQoNCjAwOjFkLjEgVVNCIENvbnRyb2xsZXI6IEludGVsIENvcnBv
cmF0aW9uIElDSDEwIFVTQiBVSENJIENvbnRyb2xsZXIgIzIgKHByb2ctaWYgMDAgW1VIQ0ld
KQ0KICAgICAgICBTdWJzeXN0ZW06IEdpZ2EtYnl0ZSBUZWNobm9sb2d5IFVua25vd24gZGV2
aWNlIDUwMDQNCiAgICAgICAgQ29udHJvbDogSS9PKyBNZW0tIEJ1c01hc3RlcisgU3BlY0N5
Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIy
Qi0gRGlzSU5UeC0NCiAgICAgICAgU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIr
IFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtDQogICAgICAgIExhdGVuY3k6IDANCiAgICAgICAgSW50ZXJydXB0
OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDExDQogICAgICAgIFJlZ2lvbiA0OiBJL08gcG9ydHMg
YXQgZTMwMCBbc2l6ZT0zMl0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNTBdIFBDSWUgYWR2
YW5jZWQgZmVhdHVyZXMgPD8+DQogICAgICAgIEtlcm5lbCBkcml2ZXIgaW4gdXNlOiB1aGNp
X2hjZA0KICAgICAgICBLZXJuZWwgbW9kdWxlczogdWhjaS1oY2QNCg0KMDA6MWQuMiBVU0Ig
Q29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgVVNCIFVIQ0kgQ29udHJvbGxl
ciAjMyAocHJvZy1pZiAwMCBbVUhDSV0pDQogICAgICAgIFN1YnN5c3RlbTogR2lnYS1ieXRl
IFRlY2hub2xvZ3kgVW5rbm93biBkZXZpY2UgNTAwNA0KICAgICAgICBDb250cm9sOiBJL08r
IE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnIt
IFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQ0KICAgICAgICBTdGF0dXM6IENh
cCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQt
IDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAgICAgICAgTGF0ZW5j
eTogMA0KICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgMw0KICAgICAg
ICBSZWdpb24gNDogSS9PIHBvcnRzIGF0IGU0MDAgW3NpemU9MzJdDQogICAgICAgIENhcGFi
aWxpdGllczogWzUwXSBQQ0llIGFkdmFuY2VkIGZlYXR1cmVzIDw/Pg0KICAgICAgICBLZXJu
ZWwgZHJpdmVyIGluIHVzZTogdWhjaV9oY2QNCiAgICAgICAgS2VybmVsIG1vZHVsZXM6IHVo
Y2ktaGNkDQoNCjAwOjFkLjcgVVNCIENvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIElD
SDEwIFVTQjIgRUhDSSBDb250cm9sbGVyICMxIChwcm9nLWlmIDIwIFtFSENJXSkNCiAgICAg
ICAgU3Vic3lzdGVtOiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBVbmtub3duIGRldmljZSA1MDA2
DQogICAgICAgIENvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVt
V0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lO
VHgtDQogICAgICAgIFN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnIt
IERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQ0KICAgICAgICBMYXRlbmN5OiAwDQogICAgICAgIEludGVycnVwdDogcGluIEEg
cm91dGVkIHRvIElSUSA3DQogICAgICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQgZmEyMDEwMDAg
KDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MUtdDQogICAgICAgIENhcGFiaWxp
dGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMg0KICAgICAgICAgICAgICAg
IEZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQx
LSxEMi0sRDNob3QtLEQzY29sZC0pDQogICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBQTUUt
RW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQ0KICAgICAgICBLZXJuZWwgZHJpdmVyIGlu
IHVzZTogZWhjaV9oY2QNCiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGVoY2ktaGNkDQoNCjAw
OjFlLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDEgUENJIEJyaWRnZSAo
cmV2IDkwKSAocHJvZy1pZiAwMSBbU3VidHJhY3RpdmUgZGVjb2RlXSkNCiAgICAgICAgQ29u
dHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9v
cC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0NCiAgICAgICAg
U3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3Qg
PlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQ0KICAgICAg
ICBMYXRlbmN5OiAwDQogICAgICAgIEJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTA1LCBz
dWJvcmRpbmF0ZT0wNSwgc2VjLWxhdGVuY3k9MzINCiAgICAgICAgSS9PIGJlaGluZCBicmlk
Z2U6IDAwMDBkMDAwLTAwMDBkZmZmDQogICAgICAgIE1lbW9yeSBiZWhpbmQgYnJpZGdlOiBm
NzAwMDAwMC1mOGZmZmZmZg0KICAgICAgICBQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBi
cmlkZ2U6IDAwMDAwMDAwZjkwMDAwMDAtMDAwMDAwMDBmOWZmZmZmZg0KICAgICAgICBTZWNv
bmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUisNCiAgICAgICAgQnJpZGdl
Q3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0ErIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJC
LQ0KICAgICAgICAgICAgICAgIFByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0
LSBEaXNjVG1yU0VSUkVuLQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFs1MF0gU3Vic3lzdGVt
OiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBVbmtub3duIGRldmljZSA1MDAwDQoNCjAwOjFmLjAg
SVNBIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgTFBDIEludGVyZmFjZSBDb250
cm9sbGVyDQogICAgICAgIFN1YnN5c3RlbTogR2lnYS1ieXRlIFRlY2hub2xvZ3kgVW5rbm93
biBkZXZpY2UgNTAwMQ0KICAgICAgICBDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBG
YXN0QjJCLSBEaXNJTlR4LQ0KICAgICAgICBTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAgICAgICAgTGF0ZW5jeTogMA0KICAgICAgICBDYXBh
YmlsaXRpZXM6IFtlMF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uIDw/Pg0KDQowMDox
Zi4yIElERSBpbnRlcmZhY2U6IEludGVsIENvcnBvcmF0aW9uIElDSDEwIDQgcG9ydCBTQVRB
IElERSBDb250cm9sbGVyIChwcm9nLWlmIDhhIFtNYXN0ZXIgU2VjUCBQcmlQXSkNCiAgICAg
ICAgU3Vic3lzdGVtOiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBVbmtub3duIGRldmljZSBiMDAy
DQogICAgICAgIENvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVt
V0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lO
VHgtDQogICAgICAgIFN0YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnIt
IERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQ0KICAgICAgICBMYXRlbmN5OiAwDQogICAgICAgIEludGVycnVwdDogcGluIEIg
cm91dGVkIHRvIElSUSAxMQ0KICAgICAgICBSZWdpb24gMDogSS9PIHBvcnRzIGF0IDAxZjAg
W3NpemU9OF0NCiAgICAgICAgUmVnaW9uIDE6IEkvTyBwb3J0cyBhdCAwM2Y0IFtzaXplPTFd
DQogICAgICAgIFJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgMDE3MCBbc2l6ZT04XQ0KICAgICAg
ICBSZWdpb24gMzogSS9PIHBvcnRzIGF0IDAzNzQgW3NpemU9MV0NCiAgICAgICAgUmVnaW9u
IDQ6IEkvTyBwb3J0cyBhdCBmMDAwIFtzaXplPTE2XQ0KICAgICAgICBSZWdpb24gNTogSS9P
IHBvcnRzIGF0IGYxMDAgW3NpemU9MTZdDQogICAgICAgIENhcGFiaWxpdGllczogWzcwXSBQ
b3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMw0KICAgICAgICAgICAgICAgIEZsYWdzOiBQTUVD
bGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3Qt
LEQzY29sZC0pDQogICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBQTUUtRW5hYmxlLSBEU2Vs
PTAgRFNjYWxlPTAgUE1FLQ0KICAgICAgICBDYXBhYmlsaXRpZXM6IFtiMF0gUENJZSBhZHZh
bmNlZCBmZWF0dXJlcyA8Pz4NCiAgICAgICAgS2VybmVsIGRyaXZlciBpbiB1c2U6IGF0YV9w
aWl4DQogICAgICAgIEtlcm5lbCBtb2R1bGVzOiBhdGFfcGlpeCwgYXRhX2dlbmVyaWMsIHBh
dGFfYWNwaQ0KDQowMDoxZi4zIFNNQnVzOiBJbnRlbCBDb3Jwb3JhdGlvbiBJQ0gxMCBTTUJ1
cyBDb250cm9sbGVyDQogICAgICAgIFN1YnN5c3RlbTogR2lnYS1ieXRlIFRlY2hub2xvZ3kg
VW5rbm93biBkZXZpY2UgNTAwMQ0KICAgICAgICBDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4LQ0KICAgICAgICBTdGF0dXM6IENhcC0gNjZNSHotIFVE
Ri0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxN
QWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAgICAgICAgSW50ZXJydXB0OiBwaW4gQyBy
b3V0ZWQgdG8gSVJRIDMNCiAgICAgICAgUmVnaW9uIDA6IE1lbW9yeSBhdCBmYTIwMjAwMCAo
NjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yNTZdDQogICAgICAgIFJlZ2lvbiA0
OiBJL08gcG9ydHMgYXQgMDUwMCBbc2l6ZT0zMl0NCiAgICAgICAgS2VybmVsIGRyaXZlciBp
biB1c2U6IGk4MDFfc21idXMNCiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGkyYy1pODAxDQoN
CjAwOjFmLjUgSURFIGludGVyZmFjZTogSW50ZWwgQ29ycG9yYXRpb24gSUNIMTAgMiBwb3J0
IFNBVEEgSURFIENvbnRyb2xsZXIgKHByb2ctaWYgODUgW01hc3RlciBTZWNPIFByaU9dKQ0K
ICAgICAgICBTdWJzeXN0ZW06IEdpZ2EtYnl0ZSBUZWNobm9sb2d5IFVua25vd24gZGV2aWNl
IGIwMDINCiAgICAgICAgQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xl
LSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0g
RGlzSU5UeC0NCiAgICAgICAgU3RhdHVzOiBDYXArIDY2TUh6KyBVREYtIEZhc3RCMkIrIFBh
ckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItIElOVHgtDQogICAgICAgIExhdGVuY3k6IDANCiAgICAgICAgSW50ZXJydXB0OiBw
aW4gQiByb3V0ZWQgdG8gSVJRIDExDQogICAgICAgIFJlZ2lvbiAwOiBJL08gcG9ydHMgYXQg
ZTcwMCBbc2l6ZT04XQ0KICAgICAgICBSZWdpb24gMTogSS9PIHBvcnRzIGF0IGU4MDAgW3Np
emU9NF0NCiAgICAgICAgUmVnaW9uIDI6IEkvTyBwb3J0cyBhdCBlOTAwIFtzaXplPThdDQog
ICAgICAgIFJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgZWEwMCBbc2l6ZT00XQ0KICAgICAgICBS
ZWdpb24gNDogSS9PIHBvcnRzIGF0IGViMDAgW3NpemU9MTZdDQogICAgICAgIFJlZ2lvbiA1
OiBJL08gcG9ydHMgYXQgZWMwMCBbc2l6ZT0xNl0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBb
NzBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzDQogICAgICAgICAgICAgICAgRmxhZ3M6
IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxE
M2hvdC0sRDNjb2xkLSkNCiAgICAgICAgICAgICAgICBTdGF0dXM6IEQwIFBNRS1FbmFibGUt
IERTZWw9MCBEU2NhbGU9MCBQTUUtDQogICAgICAgIENhcGFiaWxpdGllczogW2IwXSBQQ0ll
IGFkdmFuY2VkIGZlYXR1cmVzIDw/Pg0KICAgICAgICBLZXJuZWwgZHJpdmVyIGluIHVzZTog
YXRhX3BpaXgNCiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGF0YV9waWl4LCBhdGFfZ2VuZXJp
YywgcGF0YV9hY3BpDQoNCjAyOjAwLjAgSURFIGludGVyZmFjZTogSk1pY3JvbiBUZWNobm9s
b2dpZXMsIEluYy4gSk1CMzY4IElERSBjb250cm9sbGVyIChwcm9nLWlmIDg1IFtNYXN0ZXIg
U2VjTyBQcmlPXSkNCiAgICAgICAgU3Vic3lzdGVtOiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBV
bmtub3duIGRldmljZSBiMDAwDQogICAgICAgIENvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0
ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNF
UlItIEZhc3RCMkItIERpc0lOVHgtDQogICAgICAgIFN0YXR1czogQ2FwKyA2Nk1Iei0gVURG
LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJv
cnQtID5TRVJSLSA8UEVSUi0gSU5UeC0NCiAgICAgICAgTGF0ZW5jeTogMCwgQ2FjaGUgTGlu
ZSBTaXplOiAzMiBieXRlcw0KICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJ
UlEgMTENCiAgICAgICAgUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBhMDAwIFtzaXplPThdDQog
ICAgICAgIFJlZ2lvbiAxOiBJL08gcG9ydHMgYXQgYTEwMCBbc2l6ZT00XQ0KICAgICAgICBS
ZWdpb24gMjogSS9PIHBvcnRzIGF0IGEyMDAgW3NpemU9OF0NCiAgICAgICAgUmVnaW9uIDM6
IEkvTyBwb3J0cyBhdCBhMzAwIFtzaXplPTRdDQogICAgICAgIFJlZ2lvbiA0OiBJL08gcG9y
dHMgYXQgYTQwMCBbc2l6ZT0xNl0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNjhdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyDQogICAgICAgICAgICAgICAgRmxhZ3M6IFBNRUNsay0g
RFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdC0sRDNj
b2xkLSkNCiAgICAgICAgICAgICAgICBTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9MCBE
U2NhbGU9MCBQTUUtDQogICAgICAgIENhcGFiaWxpdGllczogWzUwXSBFeHByZXNzICh2MSkg
TGVnYWN5IEVuZHBvaW50LCBNU0kgMDENCiAgICAgICAgICAgICAgICBEZXZDYXA6IE1heFBh
eWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwx
dXMNCiAgICAgICAgICAgICAgICAgICAgICAgIEV4dFRhZy0gQXR0bkJ0bi0gQXR0bkluZC0g
UHdySW5kLSBSQkUtIEZMUmVzZXQtDQogICAgICAgICAgICAgICAgRGV2Q3RsOiBSZXBvcnQg
ZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtDQog
ICAgICAgICAgICAgICAgICAgICAgICBSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4
UHdyLSBOb1Nub29wLQ0KICAgICAgICAgICAgICAgICAgICAgICAgTWF4UGF5bG9hZCAxMjgg
Ynl0ZXMsIE1heFJlYWRSZXEgNTEyIGJ5dGVzDQogICAgICAgICAgICAgICAgRGV2U3RhOiBD
b3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3ci0gVHJhbnNQ
ZW5kLQ0KICAgICAgICAgICAgICAgIExua0NhcDogUG9ydCAjMSwgU3BlZWQgMi41R1Qvcywg
V2lkdGggeDEsIEFTUE0gTDBzLCBMYXRlbmN5IEwwIHVubGltaXRlZCwgTDEgdW5saW1pdGVk
DQogICAgICAgICAgICAgICAgICAgICAgICBDbG9ja1BNLSBTdXByaXNlLSBMTEFjdFJlcC0g
QndOb3QtDQogICAgICAgICAgICAgICAgTG5rQ3RsOiBBU1BNIERpc2FibGVkOyBSQ0IgNjQg
Ynl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGstDQogICAgICAgICAgICAgICAgICAg
ICAgICBFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtDQog
ICAgICAgICAgICAgICAgTG5rU3RhOiBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnIt
IFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210LSBBQldNZ210LQ0KICAgICAgICBL
ZXJuZWwgZHJpdmVyIGluIHVzZTogcGF0YV9qbWljcm9uDQogICAgICAgIEtlcm5lbCBtb2R1
bGVzOiBhdGFfZ2VuZXJpYywgcGF0YV9qbWljcm9uLCBwYXRhX2FjcGkNCg0KMDM6MDAuMCBF
dGhlcm5ldCBjb250cm9sbGVyOiBSZWFsdGVrIFNlbWljb25kdWN0b3IgQ28uLCBMdGQuIFJU
TDgxMTEvODE2OEIgUENJIEV4cHJlc3MgR2lnYWJpdCBFdGhlcm5ldCBjb250cm9sbGVyIChy
ZXYgMDIpDQogICAgICAgIFN1YnN5c3RlbTogR2lnYS1ieXRlIFRlY2hub2xvZ3kgVW5rbm93
biBkZXZpY2UgZTAwMA0KICAgICAgICBDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4Kw0KICAgICAgICBTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtDQogICAgICAgIExhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6
ZTogMzIgYnl0ZXMNCiAgICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDEy
NzUNCiAgICAgICAgUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBiMDAwIFtzaXplPTI1Nl0NCiAg
ICAgICAgUmVnaW9uIDI6IE1lbW9yeSBhdCBmYTAxMDAwMCAoNjQtYml0LCBwcmVmZXRjaGFi
bGUpIFtzaXplPTRLXQ0KICAgICAgICBSZWdpb24gNDogTWVtb3J5IGF0IGZhMDAwMDAwICg2
NC1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9NjRLXQ0KICAgICAgICBbdmlydHVhbF0gRXhw
YW5zaW9uIFJPTSBhdCBmYTAyMDAwMCBbZGlzYWJsZWRdIFtzaXplPTY0S10NCiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbNDBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzDQogICAgICAg
ICAgICAgICAgRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsgRDIrIEF1eEN1cnJlbnQ9Mzc1bUEg
UE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQrKQ0KICAgICAgICAgICAgICAgIFN0YXR1
czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0NCiAgICAgICAgQ2FwYWJp
bGl0aWVzOiBbNTBdIE1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6IE1hc2stIDY0Yml0
KyBRdWV1ZT0wLzEgRW5hYmxlKw0KICAgICAgICAgICAgICAgIEFkZHJlc3M6IDAwMDAwMDAw
ZmVlMDIwMGMgIERhdGE6IDQxNjkNCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNzBdIEV4cHJl
c3MgKHYxKSBFbmRwb2ludCwgTVNJIDAxDQogICAgICAgICAgICAgICAgRGV2Q2FwOiBNYXhQ
YXlsb2FkIDI1NiBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw1MTJucywgTDEg
PDh1cw0KICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5k
LSBQd3JJbmQtIFJCRSsgRkxSZXNldC0NCiAgICAgICAgICAgICAgICBEZXZDdGw6IFJlcG9y
dCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0N
CiAgICAgICAgICAgICAgICAgICAgICAgIFJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBB
dXhQd3ItIE5vU25vb3AtDQogICAgICAgICAgICAgICAgICAgICAgICBNYXhQYXlsb2FkIDEy
OCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMNCiAgICAgICAgICAgICAgICBEZXZTdGE6
IENvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFu
c1BlbmQtDQogICAgICAgICAgICAgICAgTG5rQ2FwOiBQb3J0ICMwLCBTcGVlZCAyLjVHVC9z
LCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8NjR1cw0K
ICAgICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQTSsgU3VwcmlzZS0gTExBY3RSZXAtIEJ3
Tm90LQ0KICAgICAgICAgICAgICAgIExua0N0bDogQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5
dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQ0KICAgICAgICAgICAgICAgICAgICAg
ICAgRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQ0KICAg
ICAgICAgICAgICAgIExua1N0YTogU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIFRyRXJyLSBU
cmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0NCiAgICAgICAgQ2Fw
YWJpbGl0aWVzOiBbYjBdIE1TSS1YOiBFbmFibGUtIE1hc2stIFRhYlNpemU9Mg0KICAgICAg
ICAgICAgICAgIFZlY3RvciB0YWJsZTogQkFSPTQgb2Zmc2V0PTAwMDAwMDAwDQogICAgICAg
ICAgICAgICAgUEJBOiBCQVI9NCBvZmZzZXQ9MDAwMDA4MDANCiAgICAgICAgQ2FwYWJpbGl0
aWVzOiBbZDBdIFZpdGFsIFByb2R1Y3QgRGF0YSA8Pz4NCiAgICAgICAgQ2FwYWJpbGl0aWVz
OiBbMTAwXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRpbmcgPD8+DQogICAgICAgIENhcGFiaWxp
dGllczogWzE0MF0gVmlydHVhbCBDaGFubmVsIDw/Pg0KICAgICAgICBDYXBhYmlsaXRpZXM6
IFsxNjBdIERldmljZSBTZXJpYWwgTnVtYmVyIDc4LTU2LTM0LTEyLTc4LTU2LTM0LTEyDQog
ICAgICAgIEtlcm5lbCBkcml2ZXIgaW4gdXNlOiByODE2OQ0KICAgICAgICBLZXJuZWwgbW9k
dWxlczogcjgxNjkNCg0KMDQ6MDAuMCBFdGhlcm5ldCBjb250cm9sbGVyOiBSZWFsdGVrIFNl
bWljb25kdWN0b3IgQ28uLCBMdGQuIFJUTDgxMTEvODE2OEIgUENJIEV4cHJlc3MgR2lnYWJp
dCBFdGhlcm5ldCBjb250cm9sbGVyIChyZXYgMDIpDQogICAgICAgIFN1YnN5c3RlbTogR2ln
YS1ieXRlIFRlY2hub2xvZ3kgVW5rbm93biBkZXZpY2UgZTAwMA0KICAgICAgICBDb250cm9s
OiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4Kw0KICAgICAgICBTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFi
b3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtDQogICAgICAgIExh
dGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMNCiAgICAgICAgSW50ZXJydXB0
OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDEyNzQNCiAgICAgICAgUmVnaW9uIDA6IEkvTyBwb3J0
cyBhdCBjMDAwIFtzaXplPTI1Nl0NCiAgICAgICAgUmVnaW9uIDI6IE1lbW9yeSBhdCBmYTEx
MDAwMCAoNjQtYml0LCBwcmVmZXRjaGFibGUpIFtzaXplPTRLXQ0KICAgICAgICBSZWdpb24g
NDogTWVtb3J5IGF0IGZhMTAwMDAwICg2NC1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9NjRL
XQ0KICAgICAgICBbdmlydHVhbF0gRXhwYW5zaW9uIFJPTSBhdCBmYTEyMDAwMCBbZGlzYWJs
ZWRdIFtzaXplPTY0S10NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNDBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAzDQogICAgICAgICAgICAgICAgRmxhZ3M6IFBNRUNsay0gRFNJLSBE
MSsgRDIrIEF1eEN1cnJlbnQ9Mzc1bUEgUE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQr
KQ0KICAgICAgICAgICAgICAgIFN0YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2Fs
ZT0wIFBNRS0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNTBdIE1lc3NhZ2UgU2lnbmFsbGVk
IEludGVycnVwdHM6IE1hc2stIDY0Yml0KyBRdWV1ZT0wLzEgRW5hYmxlKw0KICAgICAgICAg
ICAgICAgIEFkZHJlc3M6IDAwMDAwMDAwZmVlMGYwMGMgIERhdGE6IDQxNzENCiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbNzBdIEV4cHJlc3MgKHYxKSBFbmRwb2ludCwgTVNJIDAxDQogICAg
ICAgICAgICAgICAgRGV2Q2FwOiBNYXhQYXlsb2FkIDI1NiBieXRlcywgUGhhbnRGdW5jIDAs
IExhdGVuY3kgTDBzIDw1MTJucywgTDEgPDh1cw0KICAgICAgICAgICAgICAgICAgICAgICAg
RXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldC0NCiAgICAg
ICAgICAgICAgICBEZXZDdGw6IFJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0
YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0NCiAgICAgICAgICAgICAgICAgICAgICAgIFJseGRP
cmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtDQogICAgICAgICAgICAg
ICAgICAgICAgICBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMN
CiAgICAgICAgICAgICAgICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnIt
IFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQtDQogICAgICAgICAgICAgICAgTG5rQ2Fw
OiBQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVu
Y3kgTDAgPDUxMm5zLCBMMSA8NjR1cw0KICAgICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQ
TSsgU3VwcmlzZS0gTExBY3RSZXAtIEJ3Tm90LQ0KICAgICAgICAgICAgICAgIExua0N0bDog
QVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xr
LQ0KICAgICAgICAgICAgICAgICAgICAgICAgRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERp
cy0gQldJbnQtIEF1dEJXSW50LQ0KICAgICAgICAgICAgICAgIExua1N0YTogU3BlZWQgMi41
R1QvcywgV2lkdGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdt
dC0gQUJXTWdtdC0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbYjBdIE1TSS1YOiBFbmFibGUt
IE1hc2stIFRhYlNpemU9Mg0KICAgICAgICAgICAgICAgIFZlY3RvciB0YWJsZTogQkFSPTQg
b2Zmc2V0PTAwMDAwMDAwDQogICAgICAgICAgICAgICAgUEJBOiBCQVI9NCBvZmZzZXQ9MDAw
MDA4MDANCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbZDBdIFZpdGFsIFByb2R1Y3QgRGF0YSA8
Pz4NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbMTAwXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRp
bmcgPD8+DQogICAgICAgIENhcGFiaWxpdGllczogWzE0MF0gVmlydHVhbCBDaGFubmVsIDw/
Pg0KICAgICAgICBDYXBhYmlsaXRpZXM6IFsxNjBdIERldmljZSBTZXJpYWwgTnVtYmVyIDc4
LTU2LTM0LTEyLTc4LTU2LTM0LTEyDQogICAgICAgIEtlcm5lbCBkcml2ZXIgaW4gdXNlOiBy
ODE2OQ0KICAgICAgICBLZXJuZWwgbW9kdWxlczogcjgxNjkNCg0KMDU6MDAuMCBFdGhlcm5l
dCBjb250cm9sbGVyOiBSZWFsdGVrIFNlbWljb25kdWN0b3IgQ28uLCBMdGQuIFJUTC04MTI5
IChyZXYgMTApDQogICAgICAgIFN1YnN5c3RlbTogQ29yZWNvIEluYyBSVDgxMjkgRmFzdCBF
dGhlcm5ldCBBZGFwdGVyDQogICAgICAgIENvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIr
IFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIt
IEZhc3RCMkItIERpc0lOVHgtDQogICAgICAgIFN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBG
YXN0QjJCLSBQYXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9y
dC0gPlNFUlItIDxQRVJSKyBJTlR4LQ0KICAgICAgICBMYXRlbmN5OiA2NCAoODAwMG5zIG1p
biwgODAwMG5zIG1heCkNCiAgICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJR
IDUNCiAgICAgICAgUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBkMDAwIFtzaXplPTI1Nl0NCiAg
ICAgICAgUmVnaW9uIDE6IE1lbW9yeSBhdCBmODAwMDAwMCAoMzItYml0LCBub24tcHJlZmV0
Y2hhYmxlKSBbc2l6ZT0yNTZdDQogICAgICAgIEtlcm5lbCBkcml2ZXIgaW4gdXNlOiA4MTM5
dG9vDQogICAgICAgIEtlcm5lbCBtb2R1bGVzOiByODE2OSwgODEzOXRvbw0KDQowNTowMS4w
IFZHQSBjb21wYXRpYmxlIGNvbnRyb2xsZXI6IENpcnJ1cyBMb2dpYyBHRCA1NDMwLzQwIFtB
bHBpbmVdIChyZXYgMjIpIChwcm9nLWlmIDAwIFtWR0EgY29udHJvbGxlcl0pDQogICAgICAg
IENvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXItIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdB
U25vb3ArIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtDQogICAg
ICAgIFN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1t
ZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQ0K
ICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTENCiAgICAgICAgUmVn
aW9uIDA6IE1lbW9yeSBhdCBmOTAwMDAwMCAoMzItYml0LCBwcmVmZXRjaGFibGUpIFtzaXpl
PTE2TV0NCiAgICAgICAgW3ZpcnR1YWxdIEV4cGFuc2lvbiBST00gYXQgZjcwMDAwMDAgW2Rp
c2FibGVkXSBbc2l6ZT0xNk1dDQogICAgICAgIEtlcm5lbCBtb2R1bGVzOiBjaXJydXNmYg==

------------4D1C011818CC7836--

