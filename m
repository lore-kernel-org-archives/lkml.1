Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZJHKie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZJHKie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbZJHKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:38:33 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:41983 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbZJHKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:38:31 -0400
Message-ID: <4ACDC0F7.2060809@wpkg.org>
Date: Thu, 08 Oct 2009 12:37:43 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, xorg@lists.freedesktop.org
Subject: total freeze when shutting down X with 2 graphics cards
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a machine with Intel DX58SO mainboard equipped with two ATI graphics cards:

02:00.0 VGA compatible controller: ATI Technologies Inc RV730XT [Radeon HD 4670]
02:00.1 Audio device: ATI Technologies Inc R700 Audio Device [Radeon HD 4000 Series]
03:00.0 VGA compatible controller: ATI Technologies Inc RV730XT [Radeon HD 4670]
03:00.1 Audio device: ATI Technologies Inc R700 Audio Device [Radeon HD 4000 Series]


These cards run two separate X servers (multiseat workstation).

When I shutdown X, with a proprietary fglrx driver, the machine "freezes" for about 4 minutes.

When I shutdown X with open-source ati driver, the machine freezes for good and stays unresponsive until I reboot.

Another open source driver, "radeonhd", is unable to start two separate X sessions on this hardware.


X.Org X Server 1.6.4; kernel is 2.6.31.1, although I saw this problem with much earlier kernels.

Not sure where the bug lies - X shouldn't bring down the kernel and the whole machine, should it?


Below, a part of the log when shutting down X with proprietary fglrx driver.

With open source ati driver, unfortunately the machine freezes for good and nothing shows up in logs or on console.


Oct  8 11:15:52 dom klogd: [ 9174.051088] BUG: soft lockup - CPU#3 stuck for 61s! [X:3379]
Oct  8 11:15:52 dom klogd: [ 9174.051090] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9174.051123] CPU 3:
Oct  8 11:15:52 dom klogd: [ 9174.051124] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9174.051153] Pid: 3379, comm: X Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9174.051155] RIP: 0010:[<ffffffffa04e35a4>]  [<ffffffffa04e35a4>] _ZN4Asic16Is_WPTR_equ_RPTR19ConditionSuccessfulEv+0x54/0x60 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051203] RSP: 0018:ffff88021d1e5bb0  EFLAGS: 00000292
Oct  8 11:15:52 dom klogd: [ 9174.051205] RAX: 0000000000000000 RBX: 00000001008987d4 RCX: 0000000000030620
Oct  8 11:15:52 dom klogd: [ 9174.051206] RDX: ffffc90002706000 RSI: ffffc90002706020 RDI: ffffc90003d1ed40
Oct  8 11:15:52 dom klogd: [ 9174.051208] RBP: ffffffff81013eee R08: ffffc90002706940 R09: 0000000000000043
Oct  8 11:15:52 dom klogd: [ 9174.051209] R10: 0f40000000000000 R11: 0000000000000001 R12: 0f40000000000000
Oct  8 11:15:52 dom klogd: [ 9174.051211] R13: 0000000000000001 R14: 00000001008987d4 R15: ffffffff81013d4e
Oct  8 11:15:52 dom klogd: [ 9174.051213] FS:  00007f1548f796f0(0000) GS:ffff88002808c000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9174.051215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9174.051217] CR2: 00007ff4add54290 CR3: 000000023cc34000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9174.051219] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9174.051222] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9174.051224] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9174.051266]  [<ffffffffa04e287f>] ? _ZN4Asic9WaitUntil15WaitForCompleteEv+0x1f/0xb0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051305]  [<ffffffffa04e7ff2>] ? _ZN8AsicR60016ASICIdleInternalEN4Asic15idle_WaitMethodE+0xa2/0x1e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051309]  [<ffffffff8113967e>] ? __slab_free+0xce/0x350
Oct  8 11:15:52 dom klogd: [ 9174.051334]  [<ffffffffa0484682>] ? firegl_trace+0x72/0x1e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051372]  [<ffffffffa04e11f5>] ? _ZN4Asic7PM4idleENS_15idle_WaitMethodE+0x55/0x90 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051409]  [<ffffffffa04da9a6>] ? _ZN15QS_PRIVATE_CORE7PM4idleEN4Asic15idle_WaitMethodE+0x26/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051444]  [<ffffffffa04c77b9>] ? _ZN10QS_PRIVATE11synchronizeEv+0x29/0x30 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051470]  [<ffffffffa0486b9d>] ? firegl_cmmqs_WaitForIdle+0x4d/0xd0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051492]  [<ffffffffa0467363>] ? firegl_lock_device+0x463/0x6e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051514]  [<ffffffffa0467682>] ? firegl_lock+0xa2/0x1c0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051535]  [<ffffffffa04675e0>] ? firegl_lock+0x0/0x1c0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051555]  [<ffffffffa0464cda>] ? firegl_ioctl+0x1ea/0x250 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051559]  [<ffffffff81234b8f>] ? __clear_user+0x2f/0x90
Oct  8 11:15:52 dom klogd: [ 9174.051578]  [<ffffffffa04598d9>] ? ip_firegl_ioctl+0x29/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9174.051581]  [<ffffffff81154a24>] ? vfs_ioctl+0xa4/0xd0
Oct  8 11:15:52 dom klogd: [ 9174.051583]  [<ffffffff81154fd2>] ? do_vfs_ioctl+0xa2/0x5c0
Oct  8 11:15:52 dom klogd: [ 9174.051586]  [<ffffffff8141560e>] ? thread_return+0x4e/0x700
Oct  8 11:15:52 dom klogd: [ 9174.051588]  [<ffffffff81155591>] ? sys_ioctl+0xa1/0xc0
Oct  8 11:15:52 dom klogd: [ 9174.051592]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9175.124281] BUG: soft lockup - CPU#2 stuck for 61s! [X:1757]
Oct  8 11:15:52 dom klogd: [ 9175.124283] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9175.124324] CPU 2:
Oct  8 11:15:52 dom klogd: [ 9175.124326] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9175.124366] Pid: 1757, comm: X Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9175.124368] RIP: 0010:[<ffffffff81418d84>]  [<ffffffff81418d84>] lock_kernel+0x44/0x70
Oct  8 11:15:52 dom klogd: [ 9175.124374] RSP: 0018:ffff88023d551c68  EFLAGS: 00000297
Oct  8 11:15:52 dom klogd: [ 9175.124376] RAX: 0000000000005c5b RBX: ffff88023d551c78 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9175.124378] RDX: ffffffff812bbcf0 RSI: ffff8801e0494a80 RDI: ffff88023f3d8710
Oct  8 11:15:52 dom klogd: [ 9175.124381] RBP: ffffffff81013eee R08: ffff8802304f4320 R09: ffff88021560ccc0
Oct  8 11:15:52 dom klogd: [ 9175.124383] R10: ffff88023ec6a000 R11: 0000000000003246 R12: ffff88023ec6a000
Oct  8 11:15:52 dom klogd: [ 9175.124385] R13: ffff88023d551cb8 R14: 000000007c90cd2f R15: ffff88023d551be8
Oct  8 11:15:52 dom klogd: [ 9175.124388] FS:  00007f8cea8926f0(0000) GS:ffff88002806f000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9175.124390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9175.124393] CR2: 00007f6180e38000 CR3: 00000002329f8000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9175.124395] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9175.124397] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9175.124399] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9175.124404]  [<ffffffff812bbd23>] ? memory_open+0x33/0xd0
Oct  8 11:15:52 dom klogd: [ 9175.124408]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9175.124410]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9175.124414]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9175.124417]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9175.124421]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9175.124424]  [<ffffffff81234b8f>] ? __clear_user+0x2f/0x90
Oct  8 11:15:52 dom klogd: [ 9175.124428]  [<ffffffff8101dec6>] ? save_i387_xstate+0xe6/0x240
Oct  8 11:15:52 dom klogd: [ 9175.124432]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9175.124435]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9175.124438]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9175.124441]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9176.198596] BUG: soft lockup - CPU#5 stuck for 61s! [gpm:1242]
Oct  8 11:15:52 dom klogd: [ 9176.198599] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9176.198639] CPU 5:
Oct  8 11:15:52 dom klogd: [ 9176.198641] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9176.198680] Pid: 1242, comm: gpm Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9176.198682] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9176.198687] RSP: 0018:ffff880230ccdc38  EFLAGS: 00000293
Oct  8 11:15:52 dom klogd: [ 9176.198689] RAX: 0000000000005d5b RBX: ffff880230ccdc48 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9176.198692] RDX: ffffffff812c21f0 RSI: ffff8802094df800 RDI: ffff88023f3db2d0
Oct  8 11:15:52 dom klogd: [ 9176.198694] RBP: ffffffff81013eee R08: ffff88023d66c320 R09: ffff88023d78b740
Oct  8 11:15:52 dom klogd: [ 9176.198696] R10: ffff88023eca1200 R11: 0000000000000246 R12: 0000000000000004
Oct  8 11:15:52 dom klogd: [ 9176.198698] R13: 0000000430ccdcb8 R14: ffff8801ea503005 R15: ffff880230ccdbc8
Oct  8 11:15:52 dom klogd: [ 9176.198701] FS:  00007f391afa76f0(0000) GS:ffff8800280c6000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9176.198704] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct  8 11:15:52 dom klogd: [ 9176.198706] CR2: 00007faa529a8c37 CR3: 0000000230c9e000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9176.198708] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9176.198710] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9176.198712] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9176.198716]  [<ffffffff812c2221>] ? tty_open+0x31/0x540
Oct  8 11:15:52 dom klogd: [ 9176.198719]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9176.198722]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9176.198725]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9176.198728]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9176.198732]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9176.198736]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9176.198739]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9176.198742]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9176.198745]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9184.788257] BUG: soft lockup - CPU#1 stuck for 61s! [mount:14682]
Oct  8 11:15:52 dom klogd: [ 9184.788259] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9184.788298] CPU 1:
Oct  8 11:15:52 dom klogd: [ 9184.788300] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9184.788340] Pid: 14682, comm: mount Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9184.788342] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9184.788346] RSP: 0018:ffff880189481c68  EFLAGS: 00000293
Oct  8 11:15:52 dom klogd: [ 9184.788348] RAX: 0000000000005e5b RBX: ffff880189481c78 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9184.788351] RDX: ffffffff812bbcf0 RSI: ffff880208153ec0 RDI: ffff88023f3d8d50
Oct  8 11:15:52 dom klogd: [ 9184.788353] RBP: ffffffff81013eee R08: ffff88017916acc0 R09: ffff8801ea601ec0
Oct  8 11:15:52 dom klogd: [ 9184.788355] R10: ffff88023ec6a180 R11: 0000000000000246 R12: ffff88023ec6a180
Oct  8 11:15:52 dom klogd: [ 9184.788358] R13: ffff880189481cb8 R14: 000000009122aa34 R15: ffff880189481be8
Oct  8 11:15:52 dom klogd: [ 9184.788360] FS:  00007f6a13403730(0000) GS:ffff880028052000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9184.788363] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9184.788365] CR2: 000000000061b160 CR3: 000000015708f000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9184.788367] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9184.788369] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9184.788371] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9184.788375]  [<ffffffff812bbd23>] ? memory_open+0x33/0xd0
Oct  8 11:15:52 dom klogd: [ 9184.788378]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9184.788380]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9184.788384]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9184.788387]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9184.788390]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9184.788394]  [<ffffffff81112838>] ? __inc_zone_page_state+0x48/0x70
Oct  8 11:15:52 dom klogd: [ 9184.788398]  [<ffffffff81104a64>] ? lru_cache_add_lru+0x34/0x60
Oct  8 11:15:52 dom klogd: [ 9184.788402]  [<ffffffff81121dd5>] ? page_add_new_anon_rmap+0x75/0x80
Oct  8 11:15:52 dom klogd: [ 9184.788405]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9184.788408]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9184.788411]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9184.788414]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9206.262878] BUG: soft lockup - CPU#6 stuck for 61s! [sshd:14683]
Oct  8 11:15:52 dom klogd: [ 9206.262880] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9206.262919] CPU 6:
Oct  8 11:15:52 dom klogd: [ 9206.262920] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9206.262959] Pid: 14683, comm: sshd Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9206.262962] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9206.262966] RSP: 0018:ffff88017c9dfc68  EFLAGS: 00000297
Oct  8 11:15:52 dom klogd: [ 9206.262968] RAX: 0000000000005f5b RBX: ffff88017c9dfc78 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9206.262970] RDX: ffffffff812bbcf0 RSI: ffff8801e94a3ec0 RDI: ffff88023f3d8d50
Oct  8 11:15:52 dom klogd: [ 9206.262972] RBP: ffffffff81013eee R08: ffff880179168000 R09: ffff8801e94a3080
Oct  8 11:15:52 dom klogd: [ 9206.262975] R10: ffff88023ec6a180 R11: 0000000000000246 R12: ffff88023ec6a180
Oct  8 11:15:52 dom klogd: [ 9206.262977] R13: ffff88017c9dfcb8 R14: 00000000724ff917 R15: ffff88017c9dfc68
Oct  8 11:15:52 dom klogd: [ 9206.262980] FS:  00007fefa8033710(0000) GS:ffff8800280e3000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9206.262982] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9206.262984] CR2: 000000000044fa10 CR3: 0000000209552000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9206.262987] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9206.262989] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9206.262991] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9206.262994]  [<ffffffff812bbd23>] ? memory_open+0x33/0xd0
Oct  8 11:15:52 dom klogd: [ 9206.262997]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9206.262999]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9206.263002]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9206.263005]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9206.263009]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9206.263012]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9206.263015]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9206.263018]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9206.263021]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9208.410263] BUG: soft lockup - CPU#4 stuck for 61s! [nxserver:12643]
Oct  8 11:15:52 dom klogd: [ 9208.410265] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9208.410301] CPU 4:
Oct  8 11:15:52 dom klogd: [ 9208.410302] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9208.410337] Pid: 12643, comm: nxserver Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9208.410339] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9208.410344] RSP: 0018:ffff880179163e88  EFLAGS: 00000283
Oct  8 11:15:52 dom klogd: [ 9208.410346] RAX: 000000000000605b RBX: ffff880179163e98 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9208.410348] RDX: 0000000000000000 RSI: ffff88023c915a98 RDI: ffff8801e2215680
Oct  8 11:15:52 dom klogd: [ 9208.410349] RBP: ffffffff81013eee R08: ffff8800280bb1a0 R09: 00000000000000b0
Oct  8 11:15:52 dom klogd: [ 9208.410351] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000bd7f1cad
Oct  8 11:15:52 dom klogd: [ 9208.410353] R13: 0000000000000000 R14: 00000007f8edae08 R15: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9208.410355] FS:  00007f8edacdc6f0(0000) GS:ffff8800280a9000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9208.410357] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9208.410359] CR2: 0000000001555738 CR3: 000000017c842000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9208.410361] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9208.410364] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9208.410365] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9208.410370]  [<ffffffff8118a61e>] ? flock_lock_file_wait+0x4e/0x390
Oct  8 11:15:52 dom klogd: [ 9208.410372]  [<ffffffff81189a0d>] ? locks_alloc_lock+0x2d/0x50
Oct  8 11:15:52 dom klogd: [ 9208.410375]  [<ffffffff8118ab3b>] ? sys_flock+0x1db/0x1f0
Oct  8 11:15:52 dom klogd: [ 9208.410378]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9239.548704] BUG: soft lockup - CPU#3 stuck for 61s! [X:3379]
Oct  8 11:15:52 dom klogd: [ 9239.548705] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9239.548733] CPU 3:
Oct  8 11:15:52 dom klogd: [ 9239.548734] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9239.548762] Pid: 3379, comm: X Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9239.548764] RIP: 0010:[<ffffffffa04e3561>]  [<ffffffffa04e3561>] _ZN4Asic16Is_WPTR_equ_RPTR19ConditionSuccessfulEv+0x11/0x60 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.548805] RSP: 0018:ffff88021d1e5b98  EFLAGS: 00000292
Oct  8 11:15:52 dom klogd: [ 9239.548806] RAX: ffffffffa0554730 RBX: 00000001008987d4 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9239.548808] RDX: 0000000000000000 RSI: ffffffffa0554730 RDI: ffff88021d1e5c28
Oct  8 11:15:52 dom klogd: [ 9239.548809] RBP: ffffffff81013eee R08: ffffc90002706940 R09: 0000000000000043
Oct  8 11:15:52 dom klogd: [ 9239.548811] R10: 0f40000000000000 R11: 0000000000000001 R12: ffff88020818ea68
Oct  8 11:15:52 dom klogd: [ 9239.548812] R13: ffffc90002667470 R14: 0000000000000c23 R15: ffff88020818ea68
Oct  8 11:15:52 dom klogd: [ 9239.548814] FS:  00007f1548f796f0(0000) GS:ffff88002808c000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9239.548816] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9239.548817] CR2: 00007ff4add54290 CR3: 000000023cc34000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9239.548819] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9239.548820] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9239.548821] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9239.548863]  [<ffffffffa04e3588>] ? _ZN4Asic16Is_WPTR_equ_RPTR19ConditionSuccessfulEv+0x38/0x60 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.548902]  [<ffffffffa04e287f>] ? _ZN4Asic9WaitUntil15WaitForCompleteEv+0x1f/0xb0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.548940]  [<ffffffffa04e7ff2>] ? _ZN8AsicR60016ASICIdleInternalEN4Asic15idle_WaitMethodE+0xa2/0x1e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.548943]  [<ffffffff8113967e>] ? __slab_free+0xce/0x350
Oct  8 11:15:52 dom klogd: [ 9239.548968]  [<ffffffffa0484682>] ? firegl_trace+0x72/0x1e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549006]  [<ffffffffa04e11f5>] ? _ZN4Asic7PM4idleENS_15idle_WaitMethodE+0x55/0x90 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549043]  [<ffffffffa04da9a6>] ? _ZN15QS_PRIVATE_CORE7PM4idleEN4Asic15idle_WaitMethodE+0x26/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549078]  [<ffffffffa04c77b9>] ? _ZN10QS_PRIVATE11synchronizeEv+0x29/0x30 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549103]  [<ffffffffa0486b9d>] ? firegl_cmmqs_WaitForIdle+0x4d/0xd0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549125]  [<ffffffffa0467363>] ? firegl_lock_device+0x463/0x6e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549146]  [<ffffffffa0467682>] ? firegl_lock+0xa2/0x1c0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549168]  [<ffffffffa04675e0>] ? firegl_lock+0x0/0x1c0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549188]  [<ffffffffa0464cda>] ? firegl_ioctl+0x1ea/0x250 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549191]  [<ffffffff81234b8f>] ? __clear_user+0x2f/0x90
Oct  8 11:15:52 dom klogd: [ 9239.549209]  [<ffffffffa04598d9>] ? ip_firegl_ioctl+0x29/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9239.549212]  [<ffffffff81154a24>] ? vfs_ioctl+0xa4/0xd0
Oct  8 11:15:52 dom klogd: [ 9239.549214]  [<ffffffff81154fd2>] ? do_vfs_ioctl+0xa2/0x5c0
Oct  8 11:15:52 dom klogd: [ 9239.549217]  [<ffffffff8141560e>] ? thread_return+0x4e/0x700
Oct  8 11:15:52 dom klogd: [ 9239.549219]  [<ffffffff81155591>] ? sys_ioctl+0xa1/0xc0
Oct  8 11:15:52 dom klogd: [ 9239.549221]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9240.622894] BUG: soft lockup - CPU#2 stuck for 61s! [X:1757]
Oct  8 11:15:52 dom klogd: [ 9240.622896] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9240.622935] CPU 2:
Oct  8 11:15:52 dom klogd: [ 9240.622936] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9240.622976] Pid: 1757, comm: X Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9240.622978] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9240.622982] RSP: 0018:ffff88023d551c68  EFLAGS: 00000297
Oct  8 11:15:52 dom klogd: [ 9240.622984] RAX: 0000000000005c5b RBX: ffff88023d551c78 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9240.622987] RDX: ffffffff812bbcf0 RSI: ffff8801e0494a80 RDI: ffff88023f3d8710
Oct  8 11:15:52 dom klogd: [ 9240.622989] RBP: ffffffff81013eee R08: ffff8802304f4320 R09: ffff88021560ccc0
Oct  8 11:15:52 dom klogd: [ 9240.622991] R10: ffff88023ec6a000 R11: 0000000000003246 R12: ffff88023ec6a000
Oct  8 11:15:52 dom klogd: [ 9240.622993] R13: ffff88023d551cb8 R14: 000000007c90cd2f R15: ffff88023d551be8
Oct  8 11:15:52 dom klogd: [ 9240.622996] FS:  00007f8cea8926f0(0000) GS:ffff88002806f000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9240.622998] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9240.623000] CR2: 00007f6180e38000 CR3: 00000002329f8000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9240.623003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9240.623005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9240.623007] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9240.623010]  [<ffffffff812bbd23>] ? memory_open+0x33/0xd0
Oct  8 11:15:52 dom klogd: [ 9240.623012]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9240.623015]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9240.623018]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9240.623022]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9240.623025]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9240.623028]  [<ffffffff81234b8f>] ? __clear_user+0x2f/0x90
Oct  8 11:15:52 dom klogd: [ 9240.623031]  [<ffffffff8101dec6>] ? save_i387_xstate+0xe6/0x240
Oct  8 11:15:52 dom klogd: [ 9240.623034]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9240.623037]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9240.623040]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9240.623044]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9241.696212] BUG: soft lockup - CPU#5 stuck for 61s! [gpm:1242]
Oct  8 11:15:52 dom klogd: [ 9241.696214] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9241.696253] CPU 5:
Oct  8 11:15:52 dom klogd: [ 9241.696255] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9241.696294] Pid: 1242, comm: gpm Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9241.696296] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9241.696300] RSP: 0018:ffff880230ccdc38  EFLAGS: 00000293
Oct  8 11:15:52 dom klogd: [ 9241.696302] RAX: 0000000000005d5b RBX: ffff880230ccdc48 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9241.696304] RDX: ffffffff812c21f0 RSI: ffff8802094df800 RDI: ffff88023f3db2d0
Oct  8 11:15:52 dom klogd: [ 9241.696307] RBP: ffffffff81013eee R08: ffff88023d66c320 R09: ffff88023d78b740
Oct  8 11:15:52 dom klogd: [ 9241.696309] R10: ffff88023eca1200 R11: 0000000000000246 R12: 0000000000000004
Oct  8 11:15:52 dom klogd: [ 9241.696311] R13: 0000000430ccdcb8 R14: ffff8801ea503005 R15: ffff880230ccdbc8
Oct  8 11:15:52 dom klogd: [ 9241.696314] FS:  00007f391afa76f0(0000) GS:ffff8800280c6000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9241.696316] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct  8 11:15:52 dom klogd: [ 9241.696318] CR2: 00007faa529a8c37 CR3: 0000000230c9e000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9241.696321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9241.696323] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9241.696325] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9241.696327]  [<ffffffff812c2221>] ? tty_open+0x31/0x540
Oct  8 11:15:52 dom klogd: [ 9241.696330]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9241.696333]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9241.696336]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9241.696339]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9241.696342]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9241.696346]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9241.696349]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9241.696352]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9241.696355]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9250.285873] BUG: soft lockup - CPU#1 stuck for 61s! [mount:14682]
Oct  8 11:15:52 dom klogd: [ 9250.285875] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9250.285914] CPU 1:
Oct  8 11:15:52 dom klogd: [ 9250.285915] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9250.285955] Pid: 14682, comm: mount Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9250.285957] RIP: 0010:[<ffffffff81418d7e>]  [<ffffffff81418d7e>] lock_kernel+0x3e/0x70
Oct  8 11:15:52 dom klogd: [ 9250.285961] RSP: 0018:ffff880189481c68  EFLAGS: 00000293
Oct  8 11:15:52 dom klogd: [ 9250.285964] RAX: 0000000000005e5b RBX: ffff880189481c78 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9250.285966] RDX: ffffffff812bbcf0 RSI: ffff880208153ec0 RDI: ffff88023f3d8d50
Oct  8 11:15:52 dom klogd: [ 9250.285968] RBP: ffffffff81013eee R08: ffff88017916acc0 R09: ffff8801ea601ec0
Oct  8 11:15:52 dom klogd: [ 9250.285970] R10: ffff88023ec6a180 R11: 0000000000000246 R12: ffff88023ec6a180
Oct  8 11:15:52 dom klogd: [ 9250.285972] R13: ffff880189481cb8 R14: 000000009122aa34 R15: ffff880189481be8
Oct  8 11:15:52 dom klogd: [ 9250.285975] FS:  00007f6a13403730(0000) GS:ffff880028052000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9250.285978] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9250.285980] CR2: 000000000061b160 CR3: 000000015708f000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9250.285982] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9250.285984] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9250.285986] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9250.285989]  [<ffffffff812bbd23>] ? memory_open+0x33/0xd0
Oct  8 11:15:52 dom klogd: [ 9250.285992]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9250.285994]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9250.285998]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9250.286001]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9250.286004]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9250.286007]  [<ffffffff81112838>] ? __inc_zone_page_state+0x48/0x70
Oct  8 11:15:52 dom klogd: [ 9250.286010]  [<ffffffff81104a64>] ? lru_cache_add_lru+0x34/0x60
Oct  8 11:15:52 dom klogd: [ 9250.286013]  [<ffffffff81121dd5>] ? page_add_new_anon_rmap+0x75/0x80
Oct  8 11:15:52 dom klogd: [ 9250.286017]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9250.286020]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9250.286023]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9250.286026]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9271.761491] BUG: soft lockup - CPU#6 stuck for 61s! [sshd:14683]
Oct  8 11:15:52 dom klogd: [ 9271.761493] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9271.761533] CPU 6:
Oct  8 11:15:52 dom klogd: [ 9271.761534] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9271.761574] Pid: 14683, comm: sshd Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9271.761576] RIP: 0010:[<ffffffff81418d78>]  [<ffffffff81418d78>] lock_kernel+0x38/0x70
Oct  8 11:15:52 dom klogd: [ 9271.761580] RSP: 0018:ffff88017c9dfc68  EFLAGS: 00000297
Oct  8 11:15:52 dom klogd: [ 9271.761582] RAX: 0000000000005f5b RBX: ffff88017c9dfc78 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9271.761585] RDX: ffffffff812bbcf0 RSI: ffff8801e94a3ec0 RDI: ffff88023f3d8d50
Oct  8 11:15:52 dom klogd: [ 9271.761587] RBP: ffffffff81013eee R08: ffff880179168000 R09: ffff8801e94a3080
Oct  8 11:15:52 dom klogd: [ 9271.761589] R10: ffff88023ec6a180 R11: 0000000000000246 R12: ffff88023ec6a180
Oct  8 11:15:52 dom klogd: [ 9271.761591] R13: ffff88017c9dfcb8 R14: 00000000724ff917 R15: ffff88017c9dfc68
Oct  8 11:15:52 dom klogd: [ 9271.761594] FS:  00007fefa8033710(0000) GS:ffff8800280e3000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9271.761597] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9271.761599] CR2: 000000000044fa10 CR3: 0000000209552000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9271.761601] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9271.761603] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9271.761605] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9271.761608]  [<ffffffff812bbd23>] ? memory_open+0x33/0xd0
Oct  8 11:15:52 dom klogd: [ 9271.761611]  [<ffffffff81147356>] ? chrdev_open+0x116/0x1d0
Oct  8 11:15:52 dom klogd: [ 9271.761613]  [<ffffffff81147240>] ? chrdev_open+0x0/0x1d0
Oct  8 11:15:52 dom klogd: [ 9271.761616]  [<ffffffff81140c7a>] ? __dentry_open+0xfa/0x310
Oct  8 11:15:52 dom klogd: [ 9271.761619]  [<ffffffff81140fd7>] ? nameidata_to_filp+0x77/0x90
Oct  8 11:15:52 dom klogd: [ 9271.761623]  [<ffffffff81152fba>] ? do_filp_open+0x2fa/0xc00
Oct  8 11:15:52 dom klogd: [ 9271.761626]  [<ffffffff8115f773>] ? alloc_fd+0x63/0x160
Oct  8 11:15:52 dom klogd: [ 9271.761629]  [<ffffffff8114098b>] ? do_sys_open+0x7b/0x190
Oct  8 11:15:52 dom klogd: [ 9271.761632]  [<ffffffff81140b13>] ? sys_open+0x33/0x50
Oct  8 11:15:52 dom klogd: [ 9271.761635]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9273.908876] BUG: soft lockup - CPU#4 stuck for 61s! [nxserver:12643]
Oct  8 11:15:52 dom klogd: [ 9273.908878] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9273.908916] CPU 4:
Oct  8 11:15:52 dom klogd: [ 9273.908917] Modules linked in: tun usblp af_packet fglrx(P) coretemp ipv6 binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi joydev usbhid hid mt2060 dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common snd_hda_codec_realtek dvb_usb dvb_core snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss i2c_i801 snd i2c_core e1000e iTCO_wdt iTCO_vendor_support ehci_hcd sr_mod sg wmi evdev uhci_hcd soundcore snd_page_alloc rtc_cmos pcspkr serio_raw thermal processor button usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
Oct  8 11:15:52 dom klogd: [ 9273.908952] Pid: 12643, comm: nxserver Tainted: P           2.6.31.1-desktop-1mnb #1         
Oct  8 11:15:52 dom klogd: [ 9273.908954] RIP: 0010:[<ffffffff81418d84>]  [<ffffffff81418d84>] lock_kernel+0x44/0x70
Oct  8 11:15:52 dom klogd: [ 9273.908959] RSP: 0018:ffff880179163e88  EFLAGS: 00000283
Oct  8 11:15:52 dom klogd: [ 9273.908960] RAX: 000000000000605b RBX: ffff880179163e98 RCX: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9273.908962] RDX: 0000000000000000 RSI: ffff88023c915a98 RDI: ffff8801e2215680
Oct  8 11:15:52 dom klogd: [ 9273.908964] RBP: ffffffff81013eee R08: ffff8800280bb1a0 R09: 00000000000000b0
Oct  8 11:15:52 dom klogd: [ 9273.908966] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000bd7f1cad
Oct  8 11:15:52 dom klogd: [ 9273.908968] R13: 0000000000000000 R14: 00000007f8edae08 R15: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9273.908970] FS:  00007f8edacdc6f0(0000) GS:ffff8800280a9000(0000) knlGS:0000000000000000
Oct  8 11:15:52 dom klogd: [ 9273.908972] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  8 11:15:52 dom klogd: [ 9273.908974] CR2: 0000000001555738 CR3: 000000017c842000 CR4: 00000000000026e0
Oct  8 11:15:52 dom klogd: [ 9273.908977] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 11:15:52 dom klogd: [ 9273.908979] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 11:15:52 dom klogd: [ 9273.908981] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9273.908984]  [<ffffffff8118a61e>] ? flock_lock_file_wait+0x4e/0x390
Oct  8 11:15:52 dom klogd: [ 9273.908987]  [<ffffffff81189a0d>] ? locks_alloc_lock+0x2d/0x50
Oct  8 11:15:52 dom klogd: [ 9273.908989]  [<ffffffff8118ab3b>] ? sys_flock+0x1db/0x1f0
Oct  8 11:15:52 dom klogd: [ 9273.908993]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9289.294058] [fglrx] ASIC hang happened
Oct  8 11:15:52 dom klogd: [ 9289.294061] Pid: 3379, comm: X Tainted: P           2.6.31.1-desktop-1mnb #1
Oct  8 11:15:52 dom klogd: [ 9289.294062] Call Trace:
Oct  8 11:15:52 dom klogd: [ 9289.294083]  [<ffffffffa045b051>] KCL_DEBUG_OsDump+0x21/0x40 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294105]  [<ffffffffa046904c>] firegl_hardwareHangRecovery+0x1c/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294143]  [<ffffffffa04e2919>] ? _ZN4Asic9WaitUntil15ResetASICIfHungEv+0x9/0x10 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294180]  [<ffffffffa04e28cc>] ? _ZN4Asic9WaitUntil15WaitForCompleteEv+0x6c/0xb0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294235]  [<ffffffffa04e7ff2>] ? _ZN8AsicR60016ASICIdleInternalEN4Asic15idle_WaitMethodE+0xa2/0x1e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294238]  [<ffffffff8113967e>] ? __slab_free+0xce/0x350
Oct  8 11:15:52 dom klogd: [ 9289.294263]  [<ffffffffa0484682>] ? firegl_trace+0x72/0x1e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294301]  [<ffffffffa04e11f5>] ? _ZN4Asic7PM4idleENS_15idle_WaitMethodE+0x55/0x90 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294338]  [<ffffffffa04da9a6>] ? _ZN15QS_PRIVATE_CORE7PM4idleEN4Asic15idle_WaitMethodE+0x26/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294373]  [<ffffffffa04c77b9>] ? _ZN10QS_PRIVATE11synchronizeEv+0x29/0x30 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294398]  [<ffffffffa0486b9d>] ? firegl_cmmqs_WaitForIdle+0x4d/0xd0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294420]  [<ffffffffa0467363>] ? firegl_lock_device+0x463/0x6e0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294441]  [<ffffffffa0467682>] ? firegl_lock+0xa2/0x1c0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294462]  [<ffffffffa04675e0>] ? firegl_lock+0x0/0x1c0 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294483]  [<ffffffffa0464cda>] ? firegl_ioctl+0x1ea/0x250 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294486]  [<ffffffff81234b8f>] ? __clear_user+0x2f/0x90
Oct  8 11:15:52 dom klogd: [ 9289.294504]  [<ffffffffa04598d9>] ? ip_firegl_ioctl+0x29/0x50 [fglrx]
Oct  8 11:15:52 dom klogd: [ 9289.294507]  [<ffffffff81154a24>] ? vfs_ioctl+0xa4/0xd0
Oct  8 11:15:52 dom klogd: [ 9289.294509]  [<ffffffff81154fd2>] ? do_vfs_ioctl+0xa2/0x5c0
Oct  8 11:15:52 dom klogd: [ 9289.294511]  [<ffffffff8141560e>] ? thread_return+0x4e/0x700
Oct  8 11:15:52 dom klogd: [ 9289.294513]  [<ffffffff81155591>] ? sys_ioctl+0xa1/0xc0
Oct  8 11:15:52 dom klogd: [ 9289.294516]  [<ffffffff81013342>] ? system_call_fastpath+0x16/0x1b
Oct  8 11:15:52 dom klogd: [ 9289.294520] pubdev:0xffffffffa066a160, num of device:2 , name:fglrx, major 8, minor 65. 
Oct  8 11:15:52 dom klogd: [ 9289.294522] device 0 : 0xffff880230424000 .
Oct  8 11:15:52 dom klogd: [ 9289.294523] Asic ID:0x9490, revision:0x17, MMIOReg:0xffffc90001840000.
Oct  8 11:15:52 dom klogd: [ 9289.294525] FB phys addr: 0xd0000000, MC :0xf00000000, Total FB size :0x20000000.
Oct  8 11:15:52 dom klogd: [ 9289.294528] gart table MC:0xf0fbfe000, Physical:0xdfbfe000, size:0x401000.
Oct  8 11:15:52 dom klogd: [ 9289.294530] mc_node :FB, total 1 zones
Oct  8 11:15:52 dom klogd: [ 9289.294531]     MC start:0xf00000000, Physical:0xd0000000, size:0x10000000.
Oct  8 11:15:52 dom klogd: [ 9289.294534]     Mapped heap -- Offset:0x0, size:0xfbfe000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294536]     Mapped heap -- Offset:0x0, size:0x1000000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294538]     Mapped heap -- Offset:0xfbfe000, size:0x402000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294540] mc_node :INV_FB, total 1 zones
Oct  8 11:15:52 dom klogd: [ 9289.294542]     MC start:0xf10000000, Physical:0xe0000000, size:0x10000000.
Oct  8 11:15:52 dom klogd: [ 9289.294544]     Mapped heap -- Offset:0xfffb000, size:0x5000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294545] mc_node :GART_USWC, total 2 zones
Oct  8 11:15:52 dom klogd: [ 9289.294547]     MC start:0x40100000, Physical:0x0, size:0x4ff00000.
Oct  8 11:15:52 dom klogd: [ 9289.294549]     Mapped heap -- Offset:0x0, size:0x2000000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294551] mc_node :GART_CACHEABLE, total 3 zones
Oct  8 11:15:52 dom klogd: [ 9289.294553]     MC start:0x10400000, Physical:0x0, size:0x2fd00000.
Oct  8 11:15:52 dom klogd: [ 9289.294555]     Mapped heap -- Offset:0x0, size:0x200000, reference count:2, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294557] device 1 : 0xffff8802304c0000 .
Oct  8 11:15:52 dom klogd: [ 9289.294558] Asic ID:0x9490, revision:0x17, MMIOReg:0xffffc90003740000.
Oct  8 11:15:52 dom klogd: [ 9289.294560] FB phys addr: 0xe0000000, MC :0xf00000000, Total FB size :0x20000000.
Oct  8 11:15:52 dom klogd: [ 9289.294562] gart table MC:0xf0fbfe000, Physical:0xefbfe000, size:0x401000.
Oct  8 11:15:52 dom klogd: [ 9289.294564] mc_node :FB, total 1 zones
Oct  8 11:15:52 dom klogd: [ 9289.294566]     MC start:0xf00000000, Physical:0xe0000000, size:0x10000000.
Oct  8 11:15:52 dom klogd: [ 9289.294568]     Mapped heap -- Offset:0x0, size:0xfbfe000, reference count:8, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294570]     Mapped heap -- Offset:0x0, size:0x1000000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294572]     Mapped heap -- Offset:0xfbfe000, size:0x402000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294574] mc_node :INV_FB, total 1 zones
Oct  8 11:15:52 dom klogd: [ 9289.294575]     MC start:0xf10000000, Physical:0xf0000000, size:0x10000000.
Oct  8 11:15:52 dom klogd: [ 9289.294578]     Mapped heap -- Offset:0xfffd000, size:0x3000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294579] mc_node :GART_USWC, total 2 zones
Oct  8 11:15:52 dom klogd: [ 9289.294581]     MC start:0x40100000, Physical:0x0, size:0x4ff00000.
Oct  8 11:15:52 dom klogd: [ 9289.294583]     Mapped heap -- Offset:0x3000000, size:0x800000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294585]     Mapped heap -- Offset:0x2800000, size:0x800000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294587]     Mapped heap -- Offset:0x2000000, size:0x800000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294589]     Mapped heap -- Offset:0x0, size:0x2000000, reference count:9, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294591] mc_node :GART_CACHEABLE, total 3 zones
Oct  8 11:15:52 dom klogd: [ 9289.294593]     MC start:0x10400000, Physical:0x0, size:0x2fd00000.
Oct  8 11:15:52 dom klogd: [ 9289.294595]     Mapped heap -- Offset:0x0, size:0x200000, reference count:3, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294597]     Mapped heap -- Offset:0xef000, size:0x11000, reference count:1, mapping count:0,
Oct  8 11:15:52 dom klogd: [ 9289.294599] mc_node :PEER_FB_GART, total 1 zones
Oct  8 11:15:52 dom klogd: [ 9289.294600]     MC start:0x90000000, Physical:0x0, size:0x1000.
Oct  8 11:15:52 dom klogd: [ 9289.294602] Dump the trace queue.
Oct  8 11:15:52 dom klogd: [ 9289.294603] End of dump


-- 
Tomasz Chmielewski
http://wpkg.org
