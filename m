Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXICIHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXICIHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXICIGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:06:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:33851 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbXICIGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hQU9El8/4/ZMaMNxzzSI5blSt494EhtxVdimA1PYI7fmSxLX4FoR9w7pN3zqiMop29UdarpUj0CRKOiqcbZ0YIwDS2VohPOscVGEe6Y/2iKqOCc9gXjQ1zvMS/nbgV3blSfOn+7T4gSkEdxnrhqFONPjTO2IWTnUhUtf/Stt+5U=
Message-ID: <d0065bd80709030106i27b5ed3bw120fdbcd3a790177@mail.gmail.com>
Date: Mon, 3 Sep 2007 10:06:33 +0200
From: "David Bezuidenhout" <davidb@restricted.co.za>
To: linux-kernel@vger.kernel.org
Subject: Fwd: BUG: soft lockup detected on CPU#0 -> ext3
In-Reply-To: <d0065bd80709030104l30827164gb33b53b3bec85052@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d0065bd80709030104l30827164gb33b53b3bec85052@mail.gmail.com>
X-Google-Sender-Auth: 05eedf891da28c91
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem with a server that was not set up by me however
receive the following error on some occasions after it has been up and
running sometimes up to 30 days if not more.

The message will occur a few times and then the machine will
completely stop to respond. I have added most of the log at the end of
the mail.

If I missed out on any important information that is not below let me know.

[root@control ~]# uname -r
2.6.21.1

[root@control ~]# lspci
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x8 Port 2-3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x8 Port 4-5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x8 Port 6-7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error
Reporting Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error
Reporting Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error
Reporting Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD
Registers (rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD
Registers (rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 (rev 09)
00:1d.2  USB Controller: Intel Corporation 631xESB/632xESB/3100
Chipset UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE
Controller (rev 09)
00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset
SATA Storage Controller IDE (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E3 (rev 01)
04:00.0 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN
Controller Copper (rev 01)
04:00.1 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN
Controller Copper (rev 01)
08:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI
Bridge A (rev 09)
0a:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

[root@control ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5160  @ 3.00GHz
stepping        : 6
cpu MHz         : 3000.190
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
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca
lahf_lm
bogomips        : 6002.52
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5160  @  3.00GHz
stepping        : 6
cpu MHz         : 3000.190
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
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca
lahf_lm
bogomips        : 5999.37
clflush size    : 64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5160  @  3.00GHz
stepping        : 6
cpu MHz         : 3000.190
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
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca
lahf_lm
bogomips        : 5999.41
clflush size    : 64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5160  @  3.00GHz
stepping        : 6
cpu MHz         : 3000.190
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
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca
lahf_lm
bogomips        : 5999.41
clflush size    : 64



Sep  3 07:41:19 control kernel: BUG: soft lockup detected on CPU#0!
Sep  3 07:42:33 control kernel:  [<c013841f>] softlockup_tick+0x9e/0xac
 Sep  3 07:42:37 control kernel:  [<c011f8c7>] update_process_times+0x3b/0x5e
Sep  3 07:42:39 control kernel:  [<c012c91d>] tick_periodic+0x60/0x6a
Sep  3 07:44:19 control kernel:  [<c012c93d>] tick_handle_periodic+0x16/0x65
Sep  3 07:44:20 control kernel:  [<c010bd84>]
local_apic_timer_interrupt+0x4c/0x50
Sep  3 07:44:21 control kernel:  [<c010bdaf>] smp_apic_timer_interrupt+0x27/0x35
Sep  3 07:44:22 control kernel:  [<c0102fd8>] apic_timer_interrupt+0x28/0x30
Sep  3 07:44:22 control kernel:  [<c017cef5>] add_dquot_ref+0x6f/0x85
Sep  3 07:44:22 control kernel:  [<c017e0b3>] vfs_quota_on_inode+0x1cc/0x235
Sep  3 07:44:22 control kernel:  [<c017e15c>] vfs_quota_on+0x40/0x53
Sep  3 07:44:22 control kernel:  [<c015ae45>] do_lookup+0x45/0xa2
Sep  3 07:44:22 control kernel:  [<c015b826>] __link_path_walk+0x984/0xa72
Sep  3 07:44:22 control kernel:  [<c0141847>] pagevec_lookup+0x1a/0x20
Sep  3 07:44:22 control kernel:  [<c0141c61>] invalidate_mapping_pages+0xa1/0xaf
Sep  3 07:44:22 control kernel:  [<f885c9a9>] ext3_quota_on+0x98/0xa0 [ext3]
Sep  3 07:44:22 control kernel:  [<c016686b>] mntput_no_expire+0x11/0x5d
Sep  3 07:44:22 control kernel:  [<c015b9af>] link_path_walk+0x9b/0xa4
Sep  3 07:44:22 control kernel:  [<c015a800>] do_getname+0x40/0x5d
Sep  3 07:44:22 control kernel:  [<c017fde6>] do_quotactl+0xd4/0x2d5
Sep  3 07:44:22 control kernel:  [<c015bc94>] do_path_lookup+0x16f/0x18a
Sep  3 07:44:22 control kernel:  [<c016686b>] mntput_no_expire+0x11/0x5d
Sep  3 07:44:22 control kernel:  [<c0173dec>] lookup_bdev+0x66/0x74
Sep  3 07:44:22 control kernel:  [<c01107f0>] do_page_fault+0x29f/0x537
Sep  3 07:44:22 control kernel:  [<c011e24d>] __capable+0x8/0x1b
Sep  3 07:44:22 control kernel:  [<c017fa16>]
generic_quotactl_valid+0x142/0x152
Sep  3 07:44:22 control kernel:  [<c0180095>] sys_quotactl+0xae/0xc5
Sep  3 07:44:22 control kernel:  [<c010250a>] sysenter_past_esp+0x5f/0x85
Sep  3 07:44:22 control kernel:  =======================
Sep  3 07:44:22 control kernel: BUG: soft lockup detected on CPU#0!
Sep  3 07:44:22 control kernel:  [<c013841f>] softlockup_tick+0x9e/0xac
Sep  3 07:44:22 control kernel:  [<c011f8c7>] update_process_times+0x3b/0x5e
Sep  3 07:44:22 control kernel:  [<c012c91d>] tick_periodic+0x60/0x6a
Sep  3 07:44:22 control kernel:  [<c012c93d>] tick_handle_periodic+0x16/0x65
Sep  3 07:44:22 control kernel:  [<c010bd84>]
local_apic_timer_interrupt+0x4c/0x50
Sep  3 07:44:22 control kernel:  [<c010bdaf>] smp_apic_timer_interrupt+0x27/0x35
Sep  3 07:44:22 control kernel:  [<c0102fd8>] apic_timer_interrupt+0x28/0x30
Sep  3 07:44:22 control kernel:  [<c017cef5>] add_dquot_ref+0x6f/0x85
Sep  3 07:44:22 control kernel:  [<c017e0b3>] vfs_quota_on_inode+0x1cc/0x235
Sep  3 07:44:22 control kernel:  [<c017e15c>] vfs_quota_on+0x40/0x53
Sep  3 07:44:22 control kernel:  [<c015ae45>] do_lookup+0x45/0xa2
Sep  3 07:44:22 control kernel:  [<c015b826>] __link_path_walk+0x984/0xa72
Sep  3 07:44:22 control kernel:  [<c0141847>] pagevec_lookup+0x1a/0x20
Sep  3 07:44:22 control kernel:  [<c0141c61>]
invalidate_mapping_pages+0xa1/0xaf
Sep  3 07:44:22 control kernel:  [<f885c9a9>] ext3_quota_on+0x98/0xa0 [ext3]
Sep  3 07:44:22 control kernel:  [<c016686b>] mntput_no_expire+0x11/0x5d
Sep  3 07:44:22 control kernel:  [<c015b9af>] link_path_walk+0x9b/0xa4
Sep  3 07:44:22 control kernel:  [<c015a800>] do_getname+0x40/0x5d
Sep  3 07:44:22 control kernel:  [<c017fde6>] do_quotactl+0xd4/0x2d5
Sep  3 07:44:22 control kernel:  [<c015bc94>] do_path_lookup+0x16f/0x18a
Sep  3 07:44:22 control kernel:  [<c016686b>] mntput_no_expire+0x11/0x5d
Sep  3 07:44:22 control kernel:  [<c0173dec>] lookup_bdev+0x66/0x74
Sep  3 07:44:22 control kernel:  [<c01107f0>] do_page_fault+0x29f/0x537
Sep  3 07:44:22 control kernel:  [<c011e24d>] __capable+0x8/0x1b
Sep  3 07:44:22 control kernel:  [<c017fa16>] generic_quotactl_valid+0x142/0x152
Sep  3 07:44:22 control kernel:  [<c0180095>] sys_quotactl+0xae/0xc5
Sep  3 07:44:22 control kernel:  [<c010250a>] sysenter_past_esp+0x5f/0x85
Sep  3 07:44:22 control kernel:  =======================
Sep  3 07:44:22 control kernel: BUG: soft lockup detected on CPU#0!
Sep  3 07:44:22 control kernel:  [<c013841f>] softlockup_tick+0x9e/0xac
Sep  3 07:44:22 control kernel:  [<c011f8c7>] update_process_times+0x3b/0x5e
Sep  3 07:44:22 control kernel:  [<c012c91d>] tick_periodic+0x60/0x6a
Sep  3 07:44:22 control kernel:  [<c012c93d>] tick_handle_periodic+0x16/0x65
Sep  3 07:44:22 control kernel:  [<c010bd84>]
local_apic_timer_interrupt+0x4c/0x50
Sep  3 07:44:22 control kernel:  [<c010bdaf>] smp_apic_timer_interrupt+0x27/0x35
Sep  3 07:44:22 control kernel:  [<c0102fd8>] apic_timer_interrupt+0x28/0x30
Sep  3 07:44:22 control kernel:  [<c017ceb2>] add_dquot_ref+0x2c/0x85
Sep  3 07:44:22 control kernel:  [<c017e0b3>] vfs_quota_on_inode+0x1cc/0x235
Sep  3 07:44:22 control kernel:  [<c017e15c>] vfs_quota_on+0x40/0x53
Sep  3 07:44:22 control kernel:  [<c015ae45>] do_lookup+0x45/0xa2
Sep  3 07:44:22 control kernel:  [<c015b826>] __link_path_walk+0x984/0xa72
Sep  3 07:44:22 control kernel:  [<c0141847>] pagevec_lookup+0x1a/0x20
Sep  3 07:44:22 control kernel:  [<c0141c61>] invalidate_mapping_pages+0xa1/0xaf
Sep  3 07:44:22 control kernel:  [<f885c9a9>] ext3_quota_on+0x98/0xa0 [ext3]
Sep  3 07:44:22 control kernel:  [<c016686b>] mntput_no_expire+0x11/0x5d
Sep  3 07:44:22 control kernel:  [<c015b9af>] link_path_walk+0x9b/0xa4
Sep  3 07:44:22 control kernel:  [<c015a800>] do_getname+0x40/0x5d
Sep  3 07:44:22 control kernel:  [<c017fde6>] do_quotactl+0xd4/0x2d5
Sep  3 07:44:22 control kernel:  [<c015bc94>] do_path_lookup+0x16f/0x18a
Sep  3 07:44:22 control kernel:  [<c016686b>] mntput_no_expire+0x11/0x5d
Sep  3 07:44:22 control kernel:  [<c0173dec>] lookup_bdev+0x66/0x74
Sep  3 07:44:22 control kernel:  [<c01107f0>] do_page_fault+0x29f/0x537
Sep  3 07:44:22 control kernel:  [<c011e24d>] __capable+0x8/0x1b
Sep  3 07:44:22 control kernel:  [<c017fa16>]
generic_quotactl_valid+0x142/0x152
Sep  3 07:44:22 control kernel:  [<c0180095>] sys_quotactl+0xae/0xc5
Sep  3 07:44:22 control kernel:  [<c010250a>] sysenter_past_esp+0x5f/0x85
Sep  3 07:44:22 control kernel:  =======================

Regards,
David
