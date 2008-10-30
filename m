Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbYJ3QNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbYJ3QNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYJ3QMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:12:33 -0400
Received: from 5-25-251-64.serverpronto.com ([64.251.25.5]:4404 "EHLO
	mail.kaylix.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757179AbYJ3QM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:12:28 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 12:12:28 EDT
Message-Id: <C56C1A70-4E26-4D12-A1BC-4E744BCD51C5@kaylix.net>
From: Wesley Leggette <wleggette@kaylix.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Kernel panic in kcryptd
Date: Thu, 30 Oct 2008 11:02:19 -0500
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When performing large IO, seemingly only when over the network, I  
receive a kernel panic that seems to be happening in the kcryptd module.

Here's two scenarios I've encountered this:

ietd -> kcryptd -> mdadm raid6



LUKS header information for /dev/kaylixvg/pollux-storage

Version:       	1
Cipher name:   	aes
Cipher mode:   	cbc-essiv:sha256
Hash spec:     	sha1


         Version : 01.00.03
   Creation Time : Sun Sep 30 09:14:07 2007
      Raid Level : raid6
      Array Size : 6349009472 (6054.89 GiB 6501.39 GB)
     Device Size : 976770688 (465.76 GiB 500.11 GB)
    Raid Devices : 15
   Total Devices : 14
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Oct 30 10:40:37 2008
           State : clean, degraded
  Active Devices : 14
Working Devices : 14
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 64K


Linux version 2.6.26-bpo.1-686-bigmem (Debian 2.6.26-4~bpo40+1) (nobse@debian.org 
) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP  
Tue Sep 2 18:42:50 UTC 2008



Oct 29 04:55:15 fargo kernel: [4285317.219492] ------------[ cut  
here ]------------
Oct 29 04:55:15 fargo kernel: [4285317.219492] kernel BUG at mm/slab.c: 
3008!
Oct 29 04:55:15 fargo kernel: [4285317.219492] invalid opcode: 0000  
[#1] SMP
Oct 29 04:55:15 fargo kernel: [4285317.219492] Modules linked in:  
usb_storage iscsi_trgt crc32c libcrc32c ipv6 ib_iser
  rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi  
scsi_transport_iscsi ac battery xt_tcpudp nf_conn
track_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables  
ext3 jbd mbcache loop snd_hda_intel i2c_i801 i2c_co
re snd_pcm snd_timer snd soundcore iTCO_wdt intel_agp agpgart button  
snd_page_alloc parport_pc parport evdev pcspkr fl
oppy reiserfs sha256_generic aes_i586 aes_generic cbc dm_crypt  
crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ra
id456 async_xor async_memcpy async_tx xor raid1 md_mod ide_generic  
jmicron ide_core sd_mod sata_promise ata_generic ah
ci r8169 libata scsi_mod uhci_hcd dock ehci_hcd usbcore thermal  
processor fan thermal_sys [last unloaded: libcrc32c]
Oct 29 04:55:15 fargo kernel: [4285317.219492]
Oct 29 04:55:15 fargo kernel: [4285317.219492] Pid: 4191, comm:  
kcryptd Not tainted (2.6.26-bpo.1-686-bigmem #1)
Oct 29 04:55:15 fargo kernel: [4285317.219492] EIP: 0060:[<c017b8e8>]  
EFLAGS: 00010046 CPU: 0
Oct 29 04:55:15 fargo kernel: [4285317.219492] EIP is at  
cache_alloc_refill+0xeb/0x48b
Oct 29 04:55:15 fargo kernel: [4285317.219492] EAX: 0000003b EBX:  
00000012 ECX: f6d4d1c0 EDX: df32c000
Oct 29 04:55:15 fargo kernel: [4285317.219492] ESI: c0878000 EDI:  
00000012 EBP: f540cac0 ESP: e70b5d78
Oct 29 04:55:15 fargo kernel: [4285317.219492]  DS: 007b ES: 007b FS:  
00d8 GS: 0000 SS: 0068
Oct 29 04:55:15 fargo kernel: [4285317.219492] Process kcryptd (pid:  
4191, ti=e70b4000 task=f696ba00 task.ti=e70b4000)
Oct 29 04:55:15 fargo kernel: [4285317.219492] Stack: 00000000  
0000003b 00011200 f6d4d1c0 f5443e00 00000000 c0136139 f
51011ec
Oct 29 04:55:15 fargo kernel: [4285317.219492]        e70b5de8  
00000202 c0136194 00000000 f6d4d1c0 00000206 00011200 c
017b7b6
Oct 29 04:55:15 fargo kernel: [4285317.219492]        00000000  
f540ca80 00000000 00011210 c015f909 f8935be2 df32c4c8 f
6430e40
Oct 29 04:55:15 fargo kernel: [4285317.219492] Call Trace:
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c0136139>]  
__queue_work+0x1c/0x28
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c0136194>] queue_work 
+0x33/0x3c
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c017b7b6>]  
kmem_cache_alloc+0x47/0x8e
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c015f909>]  
mempool_alloc+0x1c/0xba
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8935be2>]  
copy_callback+0x0/0x2c [dm_snapshot]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f893533e>]  
__find_pending_exception+0x62/0x122 [dm_snapshot]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89355c1>] origin_map 
+0x105/0x23f [dm_snapshot]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89064e2>] __map_bio 
+0x4d/0x12a [dm_mod]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8906309>] clone_bio 
+0x3f/0x6f [dm_mod]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8906ff1>]  
__split_bio+0x156/0x3f7 [dm_mod]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f896e33f>]  
crypto_cbc_encrypt+0x12b/0x13f [cbc]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f894d6d8>]  
aes_encrypt+0x0/0xc [aes_i586]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89076ff>] dm_request 
+0xd3/0xf2 [dm_mod]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01dc365>]  
generic_make_request+0x34d/0x37b
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89488a9>]  
crypt_convert+0x20f/0x240 [dm_crypt]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8948a98>]  
kcryptd_crypt+0x1be/0x267 [dm_crypt]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89488da>]  
kcryptd_crypt+0x0/0x267 [dm_crypt]
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c0135d32>]  
run_workqueue+0x74/0xf2
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c013640d>]  
worker_thread+0x0/0xbd
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01364c0>]  
worker_thread+0xb3/0xbd
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01386ac>]  
autoremove_wake_function+0x0/0x2d
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01385eb>] kthread 
+0x38/0x5d
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01385b3>] kthread 
+0x0/0x5d
Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01094ff>]  
kernel_thread_helper+0x7/0x10
Oct 29 04:55:15 fargo kernel: [4285317.219492]  =======================
Oct 29 04:55:15 fargo kernel: [4285317.219492] Code: 8b 75 00 39 ee 75  
15 8b 75 10 8d 45 10 c7 45 34 01 00 00 00 39 c6
  0f 84 a5 00 00 00 8b 4c 24 0c 8b 81 98 00 00 00 39 46 10 72 37 <0f>  
0b eb fe 8b 44 24 10 8b 5e 14 8b 08 8b 44 24 0c 8
b 90 8c 00
Oct 29 04:55:15 fargo kernel: [4285317.219492] EIP: [<c017b8e8>]  
cache_alloc_refill+0xeb/0x48b SS:ESP 0068:e70b5d78
Oct 29 04:55:15 fargo kernel: [4285317.219492] ---[ end trace  
0bb16d783d7c2616 ]---








fargo:~# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 2400.082
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov  
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm  
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2  
ssse3 cx16 xtpr lahf_lm
bogomips	: 4803.78
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 2400.082
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov  
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm  
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2  
ssse3 cx16 xtpr lahf_lm
bogomips	: 4799.93
clflush size	: 64
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 2400.082
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov  
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm  
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2  
ssse3 cx16 xtpr lahf_lm
bogomips	: 4799.95
clflush size	: 64
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 2400.082
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov  
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm  
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2  
ssse3 cx16 xtpr lahf_lm
bogomips	: 4799.95
clflush size	: 64
power management:



fargo:~# cat /proc/modules
iscsi_trgt 56476 8 - Live 0xf9805000
crc32c 2656 0 - Live 0xf9754000
libcrc32c 3488 1 crc32c, Live 0xf952f000
ib_iser 26868 0 - Live 0xf97a0000
rdma_cm 24576 1 ib_iser, Live 0xf9765000
ib_cm 30188 1 rdma_cm, Live 0xf9797000
iw_cm 8420 1 rdma_cm, Live 0xf951c000
ib_sa 17800 2 rdma_cm,ib_cm, Live 0xf976d000
ib_mad 31448 2 ib_cm,ib_sa, Live 0xf9782000
ib_core 47136 6 ib_iser,rdma_cm,ib_cm,iw_cm,ib_sa,ib_mad, Live  
0xf9775000
ib_addr 6436 1 rdma_cm, Live 0xf9751000
ipv6 237796 16 - Live 0xf97b4000
iscsi_tcp 15876 0 - Live 0xf9760000
libiscsi 24576 2 ib_iser,iscsi_tcp, Live 0xf950c000
scsi_transport_iscsi 26040 4 ib_iser,iscsi_tcp,libiscsi, Live 0xf9758000
ac 5060 0 - Live 0xf94f2000
battery 11076 0 - Live 0xf9518000
xt_tcpudp 3712 8 - Live 0xf94fe000
nf_conntrack_ipv4 13196 1 - Live 0xf9513000
xt_state 2880 1 - Live 0xf94fc000
nf_conntrack 56564 2 nf_conntrack_ipv4,xt_state, Live 0xf9520000
iptable_filter 3520 1 - Live 0xf94f5000
ip_tables 11088 1 iptable_filter, Live 0xf94f8000
x_tables 14180 3 xt_tcpudp,xt_state,ip_tables, Live 0xf8b52000
ext3 106312 0 - Live 0xf9531000
jbd 40468 1 ext3, Live 0xf9501000
mbcache 8068 1 ext3, Live 0xf94ef000
loop 13708 0 - Live 0xf8a99000
snd_hda_intel 324600 0 - Live 0xf8b60000
snd_pcm 63684 1 snd_hda_intel, Live 0xf8ad6000
snd_timer 18824 1 snd_pcm, Live 0xf8abf000
snd 46532 3 snd_hda_intel,snd_pcm,snd_timer, Live 0xf8ae7000
soundcore 7232 1 snd, Live 0xf89af000
i2c_i801 8816 0 - Live 0xf8abb000
intel_agp 23396 0 - Live 0xf8acf000
agpgart 29800 1 intel_agp, Live 0xf8ac6000
button 6960 0 - Live 0xf8aaf000
snd_page_alloc 8744 2 snd_hda_intel,snd_pcm, Live 0xf8aab000
i2c_core 20820 1 i2c_i801, Live 0xf8ab4000
evdev 8896 0 - Live 0xf8a9e000
parport_pc 23588 0 - Live 0xf8aa4000
iTCO_wdt 10468 0 - Live 0xf89ba000
parport 31948 1 parport_pc, Live 0xf89c0000
floppy 48644 0 - Live 0xf89c9000
pcspkr 3296 0 - Live 0xf89b2000
reiserfs 190528 1 - Live 0xf89d8000
sha256_generic 12192 0 - Live 0xf8999000
aes_i586 8640 9 - Live 0xf896e000
aes_generic 30120 1 aes_i586, Live 0xf8990000
cbc 4128 5 - Live 0xf8966000
dm_crypt 12036 1 - Live 0xf8962000
crypto_blkcipher 16164 7 cbc,dm_crypt, Live 0xf895d000
dm_mirror 16032 0 - Live 0xf8936000
dm_log 9380 1 dm_mirror, Live 0xf8932000
dm_snapshot 15236 2 - Live 0xf892d000
dm_mod 47144 64 dm_crypt,dm_mirror,dm_log,dm_snapshot, Live 0xf8950000
raid456 118288 1 - Live 0xf8972000
async_xor 3264 1 raid456, Live 0xf889c000
async_memcpy 2624 1 raid456, Live 0xf889a000
async_tx 3232 1 raid456, Live 0xf8898000
xor 15624 2 raid456,async_xor, Live 0xf88ad000
raid1 18880 1 - Live 0xf88a7000
md_mod 67996 4 raid456,raid1, Live 0xf893e000
ide_generic 3296 0 [permanent], Live 0xf882f000
sd_mod 23128 18 - Live 0xf88a0000
usb_storage 76832 0 - Live 0xf8912000
jmicron 3072 0 [permanent], Live 0xf8829000
ide_core 93876 2 ide_generic,jmicron, Live 0xf88fa000
sata_promise 10724 10 - Live 0xf8857000
ahci 24200 6 - Live 0xf8888000
ata_generic 5540 0 - Live 0xf8826000
r8169 24804 0 - Live 0xf885c000
libata 141504 3 sata_promise,ahci,ata_generic, Live 0xf88d6000
scsi_mod 130412 7  
ib_iser 
,iscsi_tcp,libiscsi,scsi_transport_iscsi,sd_mod,usb_storage,libata,  
Live 0xf88b5000
dock 9168 1 libata, Live 0xf882b000
ehci_hcd 29484 0 - Live 0xf8846000
uhci_hcd 19696 0 - Live 0xf8840000
usbcore 119184 4 usb_storage,ehci_hcd,uhci_hcd, Live 0xf8869000
thermal 16060 0 - Live 0xf883b000
processor 33824 1 thermal, Live 0xf8831000
fan 5028 0 - Live 0xf8820000
thermal_sys 11752 3 thermal,processor,fan, Live 0xf881c000



fargo:~# cat /proc/ioports
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
0170-0177 : ide_generic
01f0-01f7 : ide_generic
0290-029f : pnp 00:01
   0290-0294 : pnp 00:01
0376-0376 : ide_generic
0378-037a : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : ide_generic
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
a000-afff : PCI Bus 0000:02
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
   d000-d07f : 0000:05:00.0
   d100-d1ff : 0000:05:00.0
   d200-d27f : 0000:05:01.0
   d300-d3ff : 0000:05:01.0
   d400-d47f : 0000:05:02.0
   d500-d5ff : 0000:05:02.0
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




fargo:~# cat /proc/iomem
00000000-000953ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cedff : Video ROM
000d0000-000d51ff : Adapter ROM
000d6000-000db3ff : Adapter ROM
000db400-000dbfff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : System ROM
00100000-dfedffff : System RAM
   00100000-002cade2 : Kernel code
   002cade3-0038fabf : Kernel data
   003d7000-00443cdf : Kernel bss
dfee0000-dfee2fff : ACPI Non-volatile Storage
dfee3000-dfeeffff : ACPI Tables
dfef0000-dfefffff : reserved
e0000000-efffffff : PCI Bus 0000:01
   e0000000-efffffff : 0000:01:00.0
f0000000-f3ffffff : PCI MMCONFIG 0
   f0000000-f3ffffff : reserved
f4000000-f6ffffff : PCI Bus 0000:01
   f4000000-f4ffffff : 0000:01:00.0
   f5000000-f5ffffff : 0000:01:00.0
   f6000000-f601ffff : 0000:01:00.0
f7000000-f8ffffff : PCI Bus 0000:04
   f8000000-f8000fff : 0000:04:00.0
     f8000000-f8000fff : r8169
f9000000-faffffff : PCI Bus 0000:05
   fa000000-fa01ffff : 0000:05:00.0
   fa020000-fa03ffff : 0000:05:01.0
   fa040000-fa05ffff : 0000:05:02.0
   fa060000-fa060fff : 0000:05:00.0
     fa060000-fa060fff : sata_promise
   fa061000-fa061fff : 0000:05:02.0
     fa061000-fa061fff : sata_promise
   fa062000-fa062fff : 0000:05:01.0
     fa062000-fa062fff : sata_promise
fb000000-fb0fffff : PCI Bus 0000:03
   fb000000-fb001fff : 0000:03:00.0
     fb000000-fb001fff : ahci
fb100000-fb103fff : 0000:00:1b.0
   fb100000-fb103fff : ICH HD audio
fb104000-fb1043ff : 0000:00:1d.7
   fb104000-fb1043ff : ehci_hcd
fb105000-fb1053ff : 0000:00:1a.7
   fb105000-fb1053ff : ehci_hcd
fb106000-fb1067ff : 0000:00:1f.2
   fb106000-fb1067ff : ahci
fb107000-fb1070ff : 0000:00:1f.3
fb200000-fb2fffff : PCI Bus 0000:04
   fb200000-fb21ffff : 0000:04:00.0
fb300000-fb3fffff : PCI Bus 0000:05
   fb300000-fb307fff : 0000:05:00.0
   fb308000-fb30ffff : 0000:05:01.0
   fb310000-fb317fff : 0000:05:02.0
fec00000-ffffffff : reserved
   fed00000-fed003ff : HPET 0
100000000-11fffffff : System RAM




fargo:~# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST3808110AS      Rev: 2AAA
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST3120213AS      Rev: 3.AH
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi9 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi10 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 07.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi11 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi12 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi13 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi14 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi15 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi16 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
   Vendor: Hitachi  Model: HTS722020K9SA00  Rev: C77A
   Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi17 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi18 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi20 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-2 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05




