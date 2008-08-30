Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYH3NHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYH3NHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 09:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYH3NHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 09:07:06 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:46903 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYH3NHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 09:07:02 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2008 09:07:01 EDT
Message-ID: <48B94120.1010108@mandriva.org>
Date: Sat, 30 Aug 2008 15:46:24 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080808)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, (please cc me as I'm not subscribed)

thought I would post this right now, I'll try to reproduce it with 
vanilla 2.6.27-rc5 as soon as the buildhost is back up...

(vanilla 2.6.27-rc5 x86_64 also locked up my laptop wich is a
  Core2 Duo T8300 during kernel build with make -j3, but
  I dont have any logs of that yet)

Kernel: 2.6.27-rc5 + Mandriva patches
Config: 
http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/branches/rebase-to-2.6.27/PATCHES/configs/x86_64.config?revision=276760&view=markup
Arch: x86_64

System: Intel Quad Core Q9300

getting this with netconsole while building kernel rpms with make -j5:


BUG: soft lockup - CPU#0 stuck for 61s! [sh:24555]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 0:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24555, comm: sh Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801ee5cbb68  EFLAGS: 00000287
RAX: 000000000000f0ef RBX: ffff8801ee5cbb68 RCX: 0000000000000f9f
RDX: ffff88022a538000 RSI: ffff88022d9e0600 RDI: ffffffff8068da00
RBP: ffff88022a05bd48 R08: 0000000000000000 R09: ffff88022a538000
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8034bfcc
R13: ffff8801ee5cbad8 R14: ffff88022d9e0600 R15: ffff88022a0dc0c8
FS:  00002ba3cce3cf40(0000) GS:ffffffff8068dd80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006b7550 CR3: 00000001cc5d4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff803319c0>] ? ccs_realpath_from_dentry2+0x140/0x430
  [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
  [<ffffffff80331d8f>] ? ccs_realpath_from_dentry+0x3f/0x60
  [<ffffffff80331dff>] ? ccs_realpath_nofollow+0x4f/0x60
  [<ffffffff803306de>] ? ccs_check_flags+0x1e/0x30
  [<ffffffff8032c888>] ? find_next_domain+0x98/0x970
  [<ffffffff8029c6b2>] ? handle_mm_fault+0x322/0x960
  [<ffffffff8029adb7>] ? follow_page+0x2f7/0x350
  [<ffffffff8029cdf8>] ? get_user_pages+0x108/0x450
  [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
  [<ffffffff8032da76>] ? search_binary_handler_with_transition+0x406/0x4d0
  [<ffffffff802c5c0d>] ? do_execve+0x1fd/0x240
  [<ffffffff8020a2d9>] ? sys_execve+0x49/0x70
  [<ffffffff8020ca4a>] ? stub_execve+0x6a/0xc0

BUG: soft lockup - CPU#1 stuck for 61s! [cc1:24471]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 1:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24471, comm: cc1 Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801f691dd48  EFLAGS: 00000293
RAX: 0000000000007774 RBX: ffff8801f691dd48 RCX: 0000000000000000
RDX: 0000000000000005 RSI: ffff8801bf4a9019 RDI: ffffffff8068d900
RBP: ffff88022e8ba7c8 R08: 0000000000000000 R09: ffff8801f695dd80
R10: 0000000000000000 R11: 000000000000002b R12: ffffffff802c8beb
R13: ffff8801f691dd28 R14: ffffffff802c7881 R15: ffff8801f691dca8
FS:  00002ba4b8f766f0(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004f5b90 CR3: 00000001e28c5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d34a3>] ? d_alloc+0x133/0x1d0
  [<ffffffff802c7b50>] ? __lookup_hash+0xe0/0x140
  [<ffffffff802c7bf0>] ? lookup_hash+0x40/0x50
  [<ffffffff802cc199>] ? do_filp_open+0x239/0x8c0
  [<ffffffff802d7d26>] ? alloc_fd+0x116/0x140
  [<ffffffff802bd50e>] ? do_sys_open+0x5e/0xf0
  [<ffffffff802bd5cb>] ? sys_open+0x1b/0x20
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#2 stuck for 61s! [cc1:24472]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 2:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24472, comm: cc1 Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801e289bbe8  EFLAGS: 00000293
RAX: 0000000000007674 RBX: ffff8801e289bbe8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88022ac2b019 RDI: ffffffff8068d900
RBP: 0000000000000020 R08: ffff8800280549c0 R09: ffff8801c886b240
R10: 0000000000000000 R11: 000000000000001f R12: ffffffff8028c451
R13: ffff8801e289bb88 R14: 00000000015ec06f R15: 0000000000000002
FS:  00002b5291ef56f0(0000) GS:ffff88022fc02d00(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002b529385f018 CR3: 00000001ee580000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d34a3>] ? d_alloc+0x133/0x1d0
  [<ffffffff802c8a9c>] ? do_lookup+0x17c/0x240
  [<ffffffff802c90bb>] ? __link_path_walk+0x55b/0x830
  [<ffffffff802c93e7>] ? path_walk+0x57/0xb0
  [<ffffffff802c9583>] ? do_path_lookup+0x83/0x1c0
  [<ffffffff8034b001>] ? security_file_alloc+0x11/0x20
  [<ffffffff802c9837>] ? __path_lookup_intent_open+0x67/0xc0
  [<ffffffff802c989c>] ? path_lookup_open+0xc/0x10
  [<ffffffff802cc01e>] ? do_filp_open+0xbe/0x8c0
  [<ffffffff8023bc33>] ? hrtick_start_fair+0x173/0x190
  [<ffffffff80373cc6>] ? __up_read+0x46/0xb0
  [<ffffffff8025c229>] ? up_read+0x9/0x10
  [<ffffffff8022a89b>] ? do_page_fault+0x3eb/0xa80
  [<ffffffff802d7d26>] ? alloc_fd+0x116/0x140
  [<ffffffff802bd50e>] ? do_sys_open+0x5e/0xf0
  [<ffffffff802bd5cb>] ? sys_open+0x1b/0x20
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#0 stuck for 61s! [sh:24555]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 0:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24555, comm: sh Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801ee5cbb68  EFLAGS: 00000287
RAX: 000000000000f0ef RBX: ffff8801ee5cbb68 RCX: 0000000000000f9f
RDX: ffff88022a538000 RSI: ffff88022d9e0600 RDI: ffffffff8068da00
RBP: ffff88022a05bd48 R08: 0000000000000000 R09: ffff88022a538000
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8034bfcc
R13: ffff8801ee5cbad8 R14: ffff88022d9e0600 R15: ffff88022a0dc0c8
FS:  00002ba3cce3cf40(0000) GS:ffffffff8068dd80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006b7550 CR3: 00000001cc5d4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff803319c0>] ? ccs_realpath_from_dentry2+0x140/0x430
  [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
  [<ffffffff80331d8f>] ? ccs_realpath_from_dentry+0x3f/0x60
  [<ffffffff80331dff>] ? ccs_realpath_nofollow+0x4f/0x60
  [<ffffffff803306de>] ? ccs_check_flags+0x1e/0x30
  [<ffffffff8032c888>] ? find_next_domain+0x98/0x970
  [<ffffffff8029c6b2>] ? handle_mm_fault+0x322/0x960
  [<ffffffff8029adb7>] ? follow_page+0x2f7/0x350
  [<ffffffff8029cdf8>] ? get_user_pages+0x108/0x450
  [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
  [<ffffffff8032da76>] ? search_binary_handler_with_transition+0x406/0x4d0
  [<ffffffff802c5c0d>] ? do_execve+0x1fd/0x240
  [<ffffffff8020a2d9>] ? sys_execve+0x49/0x70
  [<ffffffff8020ca4a>] ? stub_execve+0x6a/0xc0

BUG: soft lockup - CPU#1 stuck for 61s! [cc1:24471]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 1:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24471, comm: cc1 Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801f691dd48  EFLAGS: 00000293
RAX: 0000000000007774 RBX: ffff8801f691dd48 RCX: 0000000000000000
RDX: 0000000000000005 RSI: ffff8801bf4a9019 RDI: ffffffff8068d900
RBP: ffff88022e8ba7c8 R08: 0000000000000000 R09: ffff8801f695dd80
R10: 0000000000000000 R11: 000000000000002b R12: ffffffff802c8beb
R13: ffff8801f691dd28 R14: ffffffff802c7881 R15: ffff8801f691dca8
FS:  00002ba4b8f766f0(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004f5b90 CR3: 00000001e28c5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d34a3>] ? d_alloc+0x133/0x1d0
  [<ffffffff802c7b50>] ? __lookup_hash+0xe0/0x140
  [<ffffffff802c7bf0>] ? lookup_hash+0x40/0x50
  [<ffffffff802cc199>] ? do_filp_open+0x239/0x8c0
  [<ffffffff802d7d26>] ? alloc_fd+0x116/0x140
  [<ffffffff802bd50e>] ? do_sys_open+0x5e/0xf0
  [<ffffffff802bd5cb>] ? sys_open+0x1b/0x20
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#3 stuck for 61s! [make:24549]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 3:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24549, comm: make Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801cc42de98  EFLAGS: 00000297
RAX: 0000000000007574 RBX: ffff8801cc42de98 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff804f83c1 RDI: ffffffff8068d900
RBP: ffff8801cc42deb8 R08: ffff8801cc42dec8 R09: ffffffff804f83c0
R10: 0000000000000002 R11: 0000000000000202 R12: ffff880000002c00
R13: 00000000000200d0 R14: 0000000000000000 R15: ffff8801ee574290
FS:  00002b71862d66f0(0000) GS:ffff88022f0ce080(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000004217ba CR3: 00000001f6856000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d2ade>] ? __d_path+0x5e/0x1e0
  [<ffffffff802d3e76>] ? sys_getcwd+0x106/0x170
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#2 stuck for 61s! [cc1:24472]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 2:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24472, comm: cc1 Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f0>]  [<ffffffff802246f0>] 
__ticket_spin_lock+0x10/0x20
RSP: 0018:ffff8801e289bbe8  EFLAGS: 00000293
RAX: 0000000000007674 RBX: ffff8801e289bbe8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88022ac2b019 RDI: ffffffff8068d900
RBP: 0000000000000020 R08: ffff8800280549c0 R09: ffff8801c886b240
R10: 0000000000000000 R11: 000000000000001f R12: ffffffff8028c451
R13: ffff8801e289bb88 R14: 00000000015ec06f R15: 0000000000000002
FS:  00002b5291ef56f0(0000) GS:ffff88022fc02d00(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002b529385f018 CR3: 00000001ee580000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d34a3>] ? d_alloc+0x133/0x1d0
  [<ffffffff802c8a9c>] ? do_lookup+0x17c/0x240
  [<ffffffff802c90bb>] ? __link_path_walk+0x55b/0x830
  [<ffffffff802c93e7>] ? path_walk+0x57/0xb0
  [<ffffffff802c9583>] ? do_path_lookup+0x83/0x1c0
  [<ffffffff8034b001>] ? security_file_alloc+0x11/0x20
  [<ffffffff802c9837>] ? __path_lookup_intent_open+0x67/0xc0
  [<ffffffff802c989c>] ? path_lookup_open+0xc/0x10
  [<ffffffff802cc01e>] ? do_filp_open+0xbe/0x8c0
  [<ffffffff8023bc33>] ? hrtick_start_fair+0x173/0x190
  [<ffffffff80373cc6>] ? __up_read+0x46/0xb0
  [<ffffffff8025c229>] ? up_read+0x9/0x10
  [<ffffffff8022a89b>] ? do_page_fault+0x3eb/0xa80
  [<ffffffff802d7d26>] ? alloc_fd+0x116/0x140
  [<ffffffff802bd50e>] ? do_sys_open+0x5e/0xf0
  [<ffffffff802bd5cb>] ? sys_open+0x1b/0x20
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#0 stuck for 61s! [sh:24555]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 0:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24555, comm: sh Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801ee5cbb68  EFLAGS: 00000287
RAX: 000000000000f0ef RBX: ffff8801ee5cbb68 RCX: 0000000000000f9f
RDX: ffff88022a538000 RSI: ffff88022d9e0600 RDI: ffffffff8068da00
RBP: ffff88022a05bd48 R08: 0000000000000000 R09: ffff88022a538000
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8034bfcc
R13: ffff8801ee5cbad8 R14: ffff88022d9e0600 R15: ffff88022a0dc0c8
FS:  00002ba3cce3cf40(0000) GS:ffffffff8068dd80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006b7550 CR3: 00000001cc5d4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff803319c0>] ? ccs_realpath_from_dentry2+0x140/0x430
  [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
  [<ffffffff80331d8f>] ? ccs_realpath_from_dentry+0x3f/0x60
  [<ffffffff80331dff>] ? ccs_realpath_nofollow+0x4f/0x60
  [<ffffffff803306de>] ? ccs_check_flags+0x1e/0x30
  [<ffffffff8032c888>] ? find_next_domain+0x98/0x970
  [<ffffffff8029c6b2>] ? handle_mm_fault+0x322/0x960
  [<ffffffff8029adb7>] ? follow_page+0x2f7/0x350
  [<ffffffff8029cdf8>] ? get_user_pages+0x108/0x450
  [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
  [<ffffffff8032da76>] ? search_binary_handler_with_transition+0x406/0x4d0
  [<ffffffff802c5c0d>] ? do_execve+0x1fd/0x240
  [<ffffffff8020a2d9>] ? sys_execve+0x49/0x70
  [<ffffffff8020ca4a>] ? stub_execve+0x6a/0xc0

BUG: soft lockup - CPU#1 stuck for 61s! [cc1:24471]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 1:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
Pid: 24471, comm: cc1 Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f6>]  [<ffffffff802246f6>] 
__ticket_spin_lock+0x16/0x20
RSP: 0018:ffff8801f691dd48  EFLAGS: 00000293
RAX: 0000000000007774 RBX: ffff8801f691dd48 RCX: 0000000000000000
RDX: 0000000000000005 RSI: ffff8801bf4a9019 RDI: ffffffff8068d900
RBP: ffff88022e8ba7c8 R08: 0000000000000000 R09: ffff8801f695dd80
R10: 0000000000000000 R11: 000000000000002b R12: ffffffff802c8beb
R13: ffff8801f691dd28 R14: ffffffff802c7881 R15: ffff8801f691dca8
FS:  00002ba4b8f766f0(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004f5b90 CR3: 00000001e28c5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d34a3>] ? d_alloc+0x133/0x1d0
  [<ffffffff802c7b50>] ? __lookup_hash+0xe0/0x140
  [<ffffffff802c7bf0>] ? lookup_hash+0x40/0x50
  [<ffffffff802cc199>] ? do_filp_open+0x239/0x8c0
  [<ffffffff802d7d26>] ? alloc_fd+0x116/0x140
  [<ffffffff802bd50e>] ? do_sys_open+0x5e/0xf0
  [<ffffffff802bd5cb>] ? sys_open+0x1b/0x20
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#3 stuck for 61s! [make:24549]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 3:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_core ata_piix ahci libata dock 
sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy async_tx xor 
raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: 
scsi_wait_scan]
Pid: 24549, comm: make Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f4>]  [<ffffffff802246f4>] 
__ticket_spin_lock+0x14/0x20
RSP: 0018:ffff8801cc42de98  EFLAGS: 00000297
RAX: 0000000000007574 RBX: ffff8801cc42de98 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff804f83c1 RDI: ffffffff8068d900
RBP: ffff8801cc42deb8 R08: ffff8801cc42dec8 R09: ffffffff804f83c0
R10: 0000000000000002 R11: 0000000000000202 R12: ffff880000002c00
R13: 00000000000200d0 R14: 0000000000000000 R15: ffff8801ee574290
FS:  00002b71862d66f0(0000) GS:ffff88022f0ce080(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000004217ba CR3: 00000001f6856000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d2ade>] ? __d_path+0x5e/0x1e0
  [<ffffffff802d3e76>] ? sys_getcwd+0x106/0x170
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#2 stuck for 61s! [cc1:24472]
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_disk ide_core ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy 
async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last 
unloaded: scsi_wait_scan]
CPU 2:
Modules linked in: af_packet ipv6 binfmt_misc loop jfs xfs dm_mod 
pata_marvell floppy cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table netconsole configfs raid0 
snd_hda_intel snd_pcm snd_timer thermal snd_page_alloc usbhid snd_hwdep 
ohci1394 sky2 skge button ff_memless snd processor ieee1394 rtc_cmos 
evdev i2c_i801 i2c_core soundcore sg ide_core ata_piix ahci libata dock 
sd_mod scsi_mod crc_t10dif raid456 async_xor async_memcpy async_tx xor 
raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: 
scsi_wait_scan]
Pid: 24472, comm: cc1 Not tainted 2.6.27-desktop-0.rc5.1mnb #1
RIP: 0010:[<ffffffff802246f6>]  [<ffffffff802246f6>] 
__ticket_spin_lock+0x16/0x20
RSP: 0018:ffff8801e289bbe8  EFLAGS: 00000293
RAX: 0000000000007674 RBX: ffff8801e289bbe8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88022ac2b019 RDI: ffffffff8068d900
RBP: 0000000000000020 R08: ffff8800280549c0 R09: ffff8801c886b240
R10: 0000000000000000 R11: 000000000000001f R12: ffffffff8028c451
R13: ffff8801e289bb88 R14: 00000000015ec06f R15: 0000000000000002
FS:  00002b5291ef56f0(0000) GS:ffff88022fc02d00(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002b529385f018 CR3: 00000001ee580000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
  [<ffffffff802d34a3>] ? d_alloc+0x133/0x1d0
  [<ffffffff802c8a9c>] ? do_lookup+0x17c/0x240
  [<ffffffff802c90bb>] ? __link_path_walk+0x55b/0x830
  [<ffffffff802c93e7>] ? path_walk+0x57/0xb0
  [<ffffffff802c9583>] ? do_path_lookup+0x83/0x1c0
  [<ffffffff8034b001>] ? security_file_alloc+0x11/0x20
  [<ffffffff802c9837>] ? __path_lookup_intent_open+0x67/0xc0
  [<ffffffff802c989c>] ? path_lookup_open+0xc/0x10
  [<ffffffff802cc01e>] ? do_filp_open+0xbe/0x8c0
  [<ffffffff8023bc33>] ? hrtick_start_fair+0x173/0x190
  [<ffffffff80373cc6>] ? __up_read+0x46/0xb0
  [<ffffffff8025c229>] ? up_read+0x9/0x10
  [<ffffffff8022a89b>] ? do_page_fault+0x3eb/0xa80
  [<ffffffff802d7d26>] ? alloc_fd+0x116/0x140
  [<ffffffff802bd50e>] ? do_sys_open+0x5e/0xf0
  [<ffffffff802bd5cb>] ? sys_open+0x1b/0x20
  [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b

--
Thomas
