Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbZJONMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbZJONMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 09:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbZJONMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 09:12:47 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:37411 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbZJONMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 09:12:46 -0400
Message-ID: <4AD71FA3.8080801@wpkg.org>
Date: Thu, 15 Oct 2009 15:12:03 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091009)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.31.4: WARNING: at drivers/usb/serial/usb-serial.c:446 serial_unthrottle
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see my minicom segfaulted for some reason (probably as I closed konsole window without exiting minicom first).

And I see this warning in dmesg - anything useful?


[12966.137519] minicom[16738]: segfault at 624fff ip 00000000004174d9 sp 00007ffff5e81b30 error 4 in minicom[400000+26000]
[12966.512773] ------------[ cut here ]------------
[12966.512785] WARNING: at drivers/usb/serial/usb-serial.c:446 serial_unthrottle+0xab/0xb0 [usbserial]()
[12966.512787] Hardware name:
[12966.512788] Modules linked in: bridge stp tun af_packet radeon drm ipv6 coretemp binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table kvm_intel kvm snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device e1000e pl2303 snd_pcm_oss i2c_i801 snd_pcm usbserial serio_raw pcspkr snd_timer sr_mod sg joydev i2c_core wmi snd_mixer_oss evdev thermal processor button snd iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]
[12966.512818] Pid: 16738, comm: minicom Not tainted 2.6.31.4-server-0.rc2.1mnb #1
[12966.512819] Call Trace:
[12966.512825]  [<ffffffff8106cc95>] warn_slowpath_common+0x85/0xd0
[12966.512828]  [<ffffffff8106cd07>] warn_slowpath_null+0x27/0x50
[12966.512832]  [<ffffffffa02444bb>] serial_unthrottle+0xab/0xb0 [usbserial]
[12966.512835]  [<ffffffff812d3ce4>] tty_unthrottle+0x54/0x80
[12966.512838]  [<ffffffff812d2024>] reset_buffer_flags+0xe4/0x120
[12966.512841]  [<ffffffff812d208c>] n_tty_flush_buffer+0x2c/0xb0
[12966.512843]  [<ffffffff812d4f6d>] ? tty_ldisc_try+0x5d/0x80
[12966.512845]  [<ffffffff812d5715>] tty_ldisc_flush+0x45/0x80
[12966.512847]  [<ffffffff812d6d3a>] tty_port_close_end+0x3a/0x120
[12966.512851]  [<ffffffffa0244a91>] serial_close+0xa1/0xe0 [usbserial]
[12966.512854]  [<ffffffff812ceb93>] tty_release_dev+0x163/0x600
[12966.512858]  [<ffffffff81235f78>] ? _atomic_dec_and_lock+0x78/0xa0
[12966.512860]  [<ffffffff81235f78>] ? _atomic_dec_and_lock+0x78/0xa0
[12966.512862]  [<ffffffff812cf05d>] tty_release+0x2d/0x50
[12966.512866]  [<ffffffff81151ace>] __fput+0xee/0x220
[12966.512868]  [<ffffffff81151c2d>] fput+0x2d/0x50
[12966.512870]  [<ffffffff8114d3cc>] filp_close+0x6c/0xb0
[12966.512873]  [<ffffffff8106f52f>] put_files_struct+0x8f/0x110
[12966.512875]  [<ffffffff8106f608>] exit_files+0x58/0x80
[12966.512877]  [<ffffffff81070141>] do_exit+0x161/0x7d0
[12966.512880]  [<ffffffff81081003>] ? __dequeue_signal+0xf3/0x220
[12966.512882]  [<ffffffff81070810>] do_group_exit+0x60/0xe0
[12966.512884]  [<ffffffff8108174c>] get_signal_to_deliver+0x1bc/0x3c0
[12966.512888]  [<ffffffff8101268b>] do_notify_resume+0xeb/0x7f0
[12966.512890]  [<ffffffff8123cb88>] ? rb_erase+0x1e8/0x350
[12966.512894]  [<ffffffff81043226>] ? bad_area+0x26/0x50
[12966.512898]  [<ffffffff81430799>] ? do_page_fault+0x379/0x3a0
[12966.512901]  [<ffffffff81013e1c>] retint_signal+0x48/0x8c
[12966.512903] ---[ end trace 9324d74be25813f7 ]---



-- 
Tomasz Chmielewski
http://wpkg.org
