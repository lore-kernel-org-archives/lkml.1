Return-Path: <linux-kernel-owner+w=401wt.eu-S1752006AbZGYJQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbZGYJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 05:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZGYJQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 05:16:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:4270 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZGYJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 05:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=O1k9+ge2CsnCbbqxoslMJ+B35T5vND9BnG0hgzfoOpWbWjpNJntnXT/stlmknsfdeF
         Mp2A84a2Gd68Fd5YMyrSiay56+KOhu6QfbhL+uV+Njd6ss/9Nbsiyw70doHGSm/KIt5N
         Pgi7TWeUvN1VC+8X3SKTxfpt2TkrP96qQh7+A=
Message-ID: <4A6ACD80.5090307@googlemail.com>
Date: Sat, 25 Jul 2009 11:16:48 +0200
From: e9hack <e9hack@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] Linux-2.6.31-rc4 fails to open a USB serial port
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

if I open a USB serial port (FT232RL from FTDI), I got a mutex problem. It occurs
immediately during the open call. The USB converter is always plugged in. With 2.6.31-rc3,
I don't see this problem.

Regards,
Hartmut

Jul 25 10:26:43 vdr kernel: [   24.931403] WARNING: at
/usr/src/linux-2.6.31-rc4/kernel/mutex-debug.c:77 debug_mutex_unlock+0x8c/0xd2()
Jul 25 10:26:43 vdr kernel: [   24.932025] Hardware name: MS-7207PV
Jul 25 10:26:43 vdr kernel: [   24.932025] Modules linked in: aes_x86_64 aes_generic
af_packet cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave
powernow_k8 freq_table ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat
iptable_filter nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables fuse nls_iso8859_1 nls_cp437 vfat fat loop dm_mod tda10021 stv0297 arc4
ecb budget_av dvb_ttpci saa7146_vv zd1211rw videodev v4l1_compat firmware_class
budget_core v4l2_compat_ioctl32 parport_pc dvb_core mac80211 videobuf_dma_sg ppdev
ftdi_sio saa7146 videobuf_core usb_storage rtc_cmos parport cfg80211 rtc_core ttpci_eeprom
button usbserial usb_libusual k8temp rtc_lib sr_mod rfkill forcedeth i2c_nforce2 cdrom
evdev sg ehci_hcd ohci_hcd sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan pata_amd
sata_nv libata scsi_mod thermal processor thermal_sys hwmon
Jul 25 10:26:43 vdr kernel: [   24.932025] Pid: 3270, comm: vdr Not tainted
2.6.31-rc4-64-mp-suse-11 #1
Jul 25 10:26:43 vdr kernel: [   24.932025] Call Trace:
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff81066bbc>] ?
debug_mutex_unlock+0x8c/0xd2
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff8104475e>]
warn_slowpath_common+0x77/0xa4
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff8104479a>] warn_slowpath_null+0xf/0x11
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff81066bbc>] debug_mutex_unlock+0x8c/0xd2
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff812aa3c3>]
__mutex_unlock_slowpath+0xad/0x100
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff812aa41f>] mutex_unlock+0x9/0xb
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffffa01b0552>] serial_open+0x1f8/0x256
[usbserial]
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff811dbfe1>] tty_open+0x301/0x424
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810d9c55>] chrdev_open+0x18d/0x1ae
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810d9ac8>] ? chrdev_open+0x0/0x1ae
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810d552f>] __dentry_open+0x18f/0x2b4
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810d5721>] nameidata_to_filp+0x41/0x52
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810e2dde>] do_filp_open+0x533/0xa3a
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff81223099>] ? sys_sendto+0xf1/0x107
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff812abc5e>] ? _spin_unlock+0x13/0x2c
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810ebc02>] ? alloc_fd+0x11d/0x12e
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810d52bc>] do_sys_open+0x5d/0x104
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff810d538c>] sys_open+0x1b/0x1d
Jul 25 10:26:43 vdr kernel: [   24.932025]  [<ffffffff8100baab>]
system_call_fastpath+0x16/0x1b
Jul 25 10:26:43 vdr kernel: [   24.932025] ---[ end trace f090009acc376d07 ]---
Jul 25 10:26:43 vdr kernel: [   24.946809] general protection fault: 0000 [#1] PREEMPT SMP
Jul 25 10:26:43 vdr kernel: [   24.947012] last sysfs file: /sys/class/firmware/2-5/loading
Jul 25 10:26:43 vdr kernel: [   24.947012] CPU 0
Jul 25 10:26:43 vdr kernel: [   24.947012] Modules linked in: aes_x86_64 aes_generic
af_packet cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave
powernow_k8 freq_table ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat
iptable_filter nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables fuse nls_iso8859_1 nls_cp437 vfat fat loop dm_mod tda10021 stv0297 arc4
ecb budget_av dvb_ttpci saa7146_vv zd1211rw videodev v4l1_compat firmware_class
budget_core v4l2_compat_ioctl32 parport_pc dvb_core mac80211 videobuf_dma_sg ppdev
ftdi_sio saa7146 videobuf_core usb_storage rtc_cmos parport cfg80211 rtc_core ttpci_eeprom
button usbserial usb_libusual k8temp rtc_lib sr_mod rfkill forcedeth i2c_nforce2 cdrom
evdev sg ehci_hcd ohci_hcd sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan pata_amd
sata_nv libata scsi_mod thermal processor thermal_sys hwmon
Jul 25 10:26:43 vdr kernel: [   24.947012] Pid: 3270, comm: vdr Tainted: G        W
2.6.31-rc4-64-mp-suse-11 #1 MS-7207PV
Jul 25 10:26:43 vdr kernel: [   24.947012] RIP: 0010:[<ffffffff811dbed9>]
[<ffffffff811dbed9>] tty_open+0x1f9/0x424
Jul 25 10:26:43 vdr kernel: [   24.947012] RSP: 0018:ffff880039dd3ce8  EFLAGS: 00010206
Jul 25 10:26:43 vdr kernel: [   24.947012] RAX: ffff88003746d580 RBX: ffff880039817000
RCX: ffff8800392a5708
Jul 25 10:26:43 vdr kernel: [   24.947012] RDX: 3a36323a30312035 RSI: ffff880039dd3c68
RDI: ffff88003752b804
Jul 25 10:26:43 vdr kernel: [   24.947012] RBP: ffff880039dd3d38 R08: ffff880039dd3ba8
R09: 0000000000000000
Jul 25 10:26:43 vdr kernel: [   24.947012] R10: ffff88003a8518e8 R11: ffff8800335635c8
R12: ffff88003752b800
Jul 25 10:26:43 vdr kernel: [   24.947012] R13: 00000000fffffe00 R14: ffff88003746d580
R15: 0000000000000100
Jul 25 10:26:43 vdr kernel: [   24.947012] FS:  000000004b0b1950(0063)
GS:ffff8800015dc000(0000) knlGS:0000000000000000
Jul 25 10:26:43 vdr kernel: [   24.947012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 25 10:26:43 vdr kernel: [   24.947012] CR2: 00007f52b50bf558 CR3: 0000000039c0d000
CR4: 00000000000006f0
Jul 25 10:26:43 vdr kernel: [   24.947012] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Jul 25 10:26:43 vdr kernel: [   24.947012] DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Jul 25 10:26:43 vdr kernel: [   24.947012] Process vdr (pid: 3270, threadinfo
ffff880039dd2000, task ffff880039ca5800)
Jul 25 10:26:43 vdr kernel: [   24.947012] Stack:
Jul 25 10:26:43 vdr kernel: [   24.947012]  000000000bc00000 ffff880037d59130
0bc0000000008182 00000000fffffffa
Jul 25 10:26:43 vdr kernel: [   24.947012] <0> 000000003752b808 0000000000000000
0000000000000000 0000000000000000
Jul 25 10:26:43 vdr kernel: [   24.947012] <0> ffff88003752b808 ffff880037d59130
ffff880039dd3d88 ffffffff810d9c55
Jul 25 10:26:43 vdr kernel: [   24.947012] Call Trace:
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810d9c55>] chrdev_open+0x18d/0x1ae
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810d9ac8>] ? chrdev_open+0x0/0x1ae
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810d552f>] __dentry_open+0x18f/0x2b4
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810d5721>] nameidata_to_filp+0x41/0x52
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810e2dde>] do_filp_open+0x533/0xa3a
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff81223099>] ? sys_sendto+0xf1/0x107
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff812abc5e>] ? _spin_unlock+0x13/0x2c
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810ebc02>] ? alloc_fd+0x11d/0x12e
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810d52bc>] do_sys_open+0x5d/0x104
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff810d538c>] sys_open+0x1b/0x1d
Jul 25 10:26:43 vdr kernel: [   24.947012]  [<ffffffff8100baab>]
system_call_fastpath+0x16/0x1b
Jul 25 10:26:43 vdr kernel: [   24.947012] Code: 81 fb 00 f0 ff ff 76 11 48 c7 c7 80 a1 44
81 e8 54 e5 0c 00 e9 b6 00 00 00 48 85 db 74 69 80 bb 38 01 00 00 00 48 8b 53 08 78 71
<81> ba 9c 00 00 00 04 00 01 00 75 16 83 bb 40 01 00 00 00 75 5c
Jul 25 10:26:43 vdr kernel: [   24.947012] RIP  [<ffffffff811dbed9>] tty_open+0x1f9/0x424
Jul 25 10:26:43 vdr kernel: [   24.947012]  RSP <ffff880039dd3ce8>

