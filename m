Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYEZKnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYEZKnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYEZKnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:43:25 -0400
Received: from terman.e-hosting.lu ([80.92.79.12]:51705 "EHLO
	terman.e-hosting.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYEZKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:43:23 -0400
X-Greylist: delayed 1720 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 06:43:22 EDT
Authentication-Results: terman.e-hosting.lu; dkim=pass (1024-bit key) header.i=@trypill.org
Authentication-Results: terman.e-hosting.lu from=georges@trypill.org; domainkeys=pass (testing)
DomainKey-Signature: a=rsa-sha1; s=2008; d=trypill.org; c=nofws; q=dns;
	b=RIqDxjBJwyOC6FbZ+Q6lE0DFqmL8b/9gHwsuQM5uDjc+bPgzPLOMZa7d2uWnuuK6n
	9Mz+IRGQjL1U4InDsotLRH5b61iy3xBaQfEq9DOF5Z2UBYjo9vj+xNsGIuncvJtQqdq
	UU1B/H2ceXm8BZ13sKKNV0rz1oDIe82t87KN/Wo=
Message-ID: <483A8D59.2070302@trypill.org>
Date: Mon, 26 May 2008 12:13:45 +0200
From: Georges Toth <georges@trypill.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: BUG: unable to handle kernel paging request at ffff81013a612000
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please CC me with any replies as I'm not subscribed to the list.

I'm running a vanilla 2.6.25.4 kernel.

I apparently hit a bug in the kernel.
When the problem starts my system becomes very unstable, many programs 
crash others I can barely shut down correctly and a reboot fails.

I've hit the problem once trying to do "echo disk > /sys/power/state" 
and another time while writing do the disk inside a vmware guest.
And a couple of times it happened randomly, e.g. while converting some 
files to mp3's and writing them to a usb device.


(More details about my system at the end of the mail)
dmesg output:

BUG: unable to handle kernel paging request at ffff81013a612000
IP: [<ffffffff8027391b>] __slab_alloc+0x24a/0x4f8
PGD 8063 PUD d063 PMD 800040013a6001e3
Oops: 000b [1] SMP
CPU 0
Modules linked in: vmnet(PF) vmmon(PF) vmblock pwc compat_ioctl32 
videodev v4l1_compat snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep 
it87 hwmon_vid xts gf128mul dm_crypt bridge llc tun vfat fat usb_storage 
nvidia(P) i2c_i801 snd_hda_intel
Pid: 15862, comm: pdflush Tainted: PF        2.6.25.4 #5
RIP: 0010:[<ffffffff8027391b>]  [<ffffffff8027391b>] 
__slab_alloc+0x24a/0x4f8
RSP: 0018:ffff81006b28b860  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81013a612000 RCX: 000000000000000e
RDX: ffff81013a612000 RSI: ffffe200044c53f0 RDI: ffffffff8061cea0
RBP: ffffffff8061cea0 R08: ffffffff805e4e6a R09: 0000000000000989
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81013a612000
R13: ffffe200044c53f0 R14: ffff81013a612000 R15: 0000000000011200
FS:  0000000000000000(0000) GS:ffffffff80610000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81013a612000 CR3: 000000014a7d8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000002c56 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pdflush (pid: 15862, threadinfo ffff81006b28a000, task 
ffff8100a59ef6b0)
Stack:  ffffffff80257dae ffffffff2ec56000 0000000000011200 0000000000000206
  ffff8100010065d0 0000000000011200 0000000000011210 ffff81006b28b8e0
  ffff81022e6444b0 ffffffff80273df8 0000000000000010 ffff81022e644480
Call Trace:
  [<ffffffff80257dae>] ? mempool_alloc+0x50/0x104
  [<ffffffff80273df8>] ? kmem_cache_alloc+0x35/0x65
  [<ffffffff80257dae>] ? mempool_alloc+0x50/0x104
  [<ffffffff80297b24>] ? bio_alloc_bioset+0x95/0xea
  [<ffffffff8040c7be>] ? clone_bio+0x37/0x7a
  [<ffffffff8040d54d>] ? __split_bio+0x13d/0x378
  [<ffffffff803157a1>] ? xfs_convert_page+0x2ed/0x30f
  [<ffffffff8040dccd>] ? dm_request+0x104/0x126
  [<ffffffff80330b92>] ? generic_make_request+0x1e1/0x21c
  [<ffffffff80331f97>] ? submit_bio+0xc8/0xcf
  [<ffffffff803150d6>] ? xfs_submit_ioend_bio+0x1e/0x27
  [<ffffffff8031519b>] ? xfs_submit_ioend+0xa7/0xc6
  [<ffffffff80315f3c>] ? xfs_page_state_convert+0x4f1/0x540
  [<ffffffff803160d4>] ? xfs_vm_writepage+0xa5/0xdd
  [<ffffffff8025ad57>] ? __writepage+0xa/0x23
  [<ffffffff8025b1d6>] ? write_cache_pages+0x182/0x2cb
  [<ffffffff8025ad4d>] ? __writepage+0x0/0x23
  [<ffffffff8025b35b>] ? do_writepages+0x20/0x2d
  [<ffffffff802907e9>] ? __writeback_single_inode+0x140/0x294
  [<ffffffff8040eef9>] ? dm_table_any_congested+0x46/0x6c
  [<ffffffff80290cc8>] ? sync_sb_inodes+0x1c2/0x2ad
  [<ffffffff802910fd>] ? writeback_inodes+0x67/0xb8
  [<ffffffff8025bbc5>] ? wb_kupdate+0xa0/0x113
  [<ffffffff8025bf42>] ? pdflush+0x0/0x1e5
  [<ffffffff8025c081>] ? pdflush+0x13f/0x1e5
  [<ffffffff8025bb25>] ? wb_kupdate+0x0/0x113
  [<ffffffff8023dcf5>] ? kthread+0x47/0x76
  [<ffffffff8022810c>] ? schedule_tail+0x28/0x5c
  [<ffffffff8020bd58>] ? child_rip+0xa/0x12
  [<ffffffff8021b3b7>] ? lapic_next_event+0x0/0xa
  [<ffffffff8023dcae>] ? kthread+0x0/0x76
  [<ffffffff8020bd4e>] ? child_rip+0x0/0x12


Code: 00 be 5a 00 00 00 4c 89 f7 48 d3 e2 e8 8f c7 0c 00 4d 89 f4 4c 89 
f3 eb 20 4c 89 e2 4c 89 ee 48 89 ef e8 fa ec ff ff 48 63 45 10 <49> 89 
1c 04 48 63 45 08 49 89 dc 48 01 c3 8b 45 08 0f af 45 50
RIP  [<ffffffff8027391b>] __slab_alloc+0x24a/0x4f8
  RSP <ffff81006b28b860>
CR2: ffff81013a612000
---[ end trace bf8cedeb8138fc52 ]---
BUG: unable to handle kernel paging request at ffff81013a613000
IP: [<ffffffff8033f947>] clear_page_c+0x7/0x10
PGD 8063 PUD d063 PMD 800040013a6001e3
Oops: 000b [2] SMP
CPU 3
Modules linked in: vmnet(PF) vmmon(PF) vmblock pwc compat_ioctl32 
videodev v4l1_compat snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep 
it87 hwmon_vid xts gf128mul dm_crypt bridge llc tun vfat fat usb_storage 
nvidia(P) i2c_i801 snd_hda_intel
Pid: 18392, comm: bash Tainted: PF     D  2.6.25.4 #5
RIP: 0010:[<ffffffff8033f947>]  [<ffffffff8033f947>] clear_page_c+0x7/0x10
RSP: 0000:ffff8101348f3d60  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffe200044c5428 RCX: 0000000000000200
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff81013a613000
RBP: 00000000044c5428 R08: 0000000000000000 R09: 0000000000000870
R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
R13: ffff810000000000 R14: 6db6db6db6db6db7 R15: 00000000001280d2
FS:  00007f782f83e6f0(0000) GS:ffff81022fc0e680(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff81013a613000 CR3: 0000000186308000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 18392, threadinfo ffff8101348f2000, task 
ffff81006b1b6f20)
Stack:  ffffffff8025a269 0000000000000044 00000000805e5ae8 0000000000000001
  ffffffff80664340 0010000000000001 0000000000000000 ffffffff805e4f40
  0000000000000002 0000000000000044 ffffffff805e5b18 0000000100000002
Call Trace:
  [<ffffffff8025a269>] ? get_page_from_freelist+0x361/0x3f6
  [<ffffffff8025a54e>] ? __alloc_pages+0xa4/0x32a
  [<ffffffff80263d86>] ? handle_mm_fault+0x230/0x6ab
  [<ffffffff802660ac>] ? __vma_link+0x42/0x4b
  [<ffffffff8021f667>] ? do_page_fault+0x36d/0x72e
  [<ffffffff8033df15>] ? __up_write+0x21/0x110
  [<ffffffff804e40e9>] ? error_exit+0x0/0x51


Code: af 74 08 48 83 ef 08 48 0f bc 07 48 29 d7 48 c1 e7 03 48 01 f8 c3 
90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 
ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f
RIP  [<ffffffff8033f947>] clear_page_c+0x7/0x10
  RSP <ffff8101348f3d60>
CR2: ffff81013a613000
---[ end trace bf8cedeb8138fc52 ]---
note: bash[18392] exited with preempt_count 1

-------------------------------------------------



linux # scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux simon 2.6.25.4 #6 SMP Sun May 25 22:17:29 CEST 2008 x86_64 
Intel(R) Core(TM)2 Quad CPU Q9300 @ 2.50GHz GenuineIntel GNU/Linux

Gnu C                  4.2.4
Gnu make               3.81
binutils               2.18
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.40.8
xfsprogs               2.9.7
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.10
udev                   119
Modules Loaded         cifs bridge llc tun pwc i2c_i801 snd_usb_audio 
compat_ioctl32 videodev snd_usb_lib v4l1_compat snd_rawmidi snd_hwdep 
snd_hda_intel nvidia



linux # cat /proc/ioports
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
0290-029f : pnp 00:01
   0290-0294 : pnp 00:01
03c0-03df : vesafb
03f8-03ff : serial
0400-047f : 0000:00:1f.0
   0400-0403 : ACPI PM1a_EVT_BLK
   0404-0405 : ACPI PM1a_CNT_BLK
   0408-040b : ACPI PM_TMR
   0410-0415 : ACPI CPU throttle
   0420-042f : ACPI GPE0_BLK
0480-04bf : 0000:00:1f.0
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
   0500-051f : i801_smbus
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
a000-afff : PCI Bus #05
b000-bfff : PCI Bus #02
c000-cfff : PCI Bus #03
   c000-c007 : 0000:03:00.1
     c000-c007 : pata_jmicron
   c100-c103 : 0000:03:00.1
     c100-c103 : pata_jmicron
   c200-c207 : 0000:03:00.1
     c200-c207 : pata_jmicron
   c300-c303 : 0000:03:00.1
     c300-c303 : pata_jmicron
   c400-c40f : 0000:03:00.1
     c400-c40f : pata_jmicron
d000-dfff : PCI Bus #04
   d000-d0ff : 0000:04:00.0
     d000-d0ff : r8169
e000-e01f : 0000:00:1a.2
   e000-e01f : uhci_hcd
e100-e11f : 0000:00:1a.0
   e100-e11f : uhci_hcd
e200-e21f : 0000:00:1a.1
   e200-e21f : uhci_hcd
e300-e31f : 0000:00:1d.0
   e300-e31f : uhci_hcd
e400-e41f : 0000:00:1d.1
   e400-e41f : uhci_hcd
e500-e51f : 0000:00:1d.2
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



linux # cat /proc/iomem
00000000-0009e7ff : System RAM
0009f800-0009ffff : reserved
000d5000-000d7fff : pnp 00:0b
000e0000-000effff : pnp 00:0b
000f0000-000fffff : reserved
00100000-cfedffff : System RAM
   00200000-004e6b4e : Kernel code
   004e6b4f-0060fe27 : Kernel data
   0066a000-006a73cf : Kernel bss
cfee0000-cfee2fff : ACPI Non-volatile Storage
cfee3000-cfeeffff : ACPI Tables
cfef0000-cfefffff : reserved
d0000000-dfffffff : PCI Bus #01
   d0000000-dfffffff : 0000:01:00.0
     d0000000-dfffffff : vesafb
e0000000-e7ffffff : PCI Bus #01
   e0000000-e3ffffff : 0000:01:00.0
     e0000000-e3ffffff : nvidia
   e4000000-e4ffffff : 0000:01:00.0
e8000000-ebffffff : PCI MMCONFIG 0
   e8000000-ebffffff : reserved
ec000000-edffffff : PCI Bus #04
   ed000000-ed000fff : 0000:04:00.0
     ed000000-ed000fff : r8169
ee000000-ee0fffff : PCI Bus #03
   ee000000-ee001fff : 0000:03:00.0
     ee000000-ee001fff : ahci
ee100000-ee103fff : 0000:00:1b.0
   ee100000-ee103fff : ICH HD audio
ee104000-ee1043ff : 0000:00:1a.7
   ee104000-ee1043ff : ehci_hcd
ee105000-ee1053ff : 0000:00:1d.7
   ee105000-ee1053ff : ehci_hcd
ee106000-ee1067ff : 0000:00:1f.2
   ee106000-ee1067ff : ahci
ee107000-ee1070ff : 0000:00:1f.3
fec00000-fec00fff : IOAPIC 0
   fec00000-fec00fff : pnp 00:0b
fed00000-fed003ff : HPET 0
fed10000-fed1dfff : pnp 00:0b
fed20000-fed8ffff : pnp 00:0b
fee00000-fee00fff : Local APIC
ffb00000-ffb7ffff : pnp 00:0b
fff00000-ffffffff : pnp 00:0b
100000000-22fffffff : System RAM


Should you need any more information please let me know.

-- 
regards,

Georges Toth
