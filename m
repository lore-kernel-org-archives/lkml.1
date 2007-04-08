Return-Path: <linux-kernel-owner+w=401wt.eu-S966005AbXDHAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005AbXDHAU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966011AbXDHAU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 20:20:27 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38020 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966005AbXDHAU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 20:20:26 -0400
Message-ID: <4618356D.70303@lwfinger.net>
Date: Sat, 07 Apr 2007 19:21:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: rusty@rustcorp.com.au
Subject: kernel oops with badly formatted module option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the following line in /etc/modprobe.conf.local:

options bcm43xx fwpostfix = ".fw3" locale=8

the kernel oops below is generated. I realize that the line should have no whitespace around the 
"=", but I do not feel that an oops is the best way to report the syntax error. Could there be a 
more gentle failure?

This is an x86_64 system running 2.6.16-rc5 from Linville's wireless-2.6 tree. The "dirty" refers to 
patches for the bcm43xx driver that are under test.

Larry

kernel: Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
kernel:  [<ffffffff80242b76>] param_set_copystring+0x15/0x4b
kernel: PGD 3ce82067 PUD 34b0c067 PMD 0
kernel: Oops: 0000 [1] SMP
kernel: CPU 0
kernel: Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
cpufreq_conservative cpuf
req_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table button battery ac loop
snd_hda_intel snd_hda_codec snd_pcm snd_t
imer snd ohci1394 soundcore snd_page_alloc ieee1394 ide_cd cdrom ehci_hcd ohci_hcd sdhci mmc_core
usbcore forcedeth i2c_nforce2 firmware
_class ieee80211softmac ieee80211 ieee80211_crypt ext3 mbcache jbd sg edd fan sata_nv libata amd74xx
thermal processor sd_mod scsi_mod i
de_disk ide_core
kernel: Pid: 4325, comm: modprobe Not tainted 2.6.21-rc5-L2.6-gae6ff7a1-dirty #5
kernel: RIP: 0010:[<ffffffff80242b76>]  [<ffffffff80242b76>] param_set_copystring+0x15/0x4b
kernel: RSP: 0018:ffff81003dee3dd8  EFLAGS: 00010286
kernel: RAX: 0000000000000000 RBX: ffff810053736c7a RCX: ffffffffffffffff
kernel: RDX: 0000000000000040 RSI: ffffffff882fee68 RDI: 0000000000000000
kernel: RBP: ffff81003dee3dd8 R08: ffffffff88307ea0 R09: 0000000000000000
kernel: R10: 0000000000000006 R11: ffffffff88307e88 R12: 0000000000000028
kernel: R13: ffff810053736c70 R14: 0000000000000000 R15: ffffffff88308098
kernel: FS:  00002ae7eb6246f0(0000) GS:ffffffff80505000(0000) knlGS:00000000f70686d0
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000000000 CR3: 0000000036ff8000 CR4: 00000000000006e0
kernel: Process modprobe (pid: 4325, threadinfo ffff81003dee2000, task ffff810035d31140)
kernel: Stack:  ffff81003dee3e38 ffffffff802430ff ffffffff88308080 0000000000000000
kernel:  00000007003b74d8 ffffffff882fed78 0000000000000202 ffffc200003b77d8
kernel:  0000000000000028 ffffffff88308080 ffffffff88304c78 ffffc200003b7498
kernel: Call Trace:
kernel:  [<ffffffff802430ff>] parse_args+0x139/0x216
kernel:  [<ffffffff80253a2f>] sys_init_module+0x1376/0x1744
kernel:  [<ffffffff802446f3>] autoremove_wake_function+0x0/0x38
kernel:  [<ffffffff80350d5a>] device_remove_file+0x0/0x33
kernel:  [<ffffffff803d44bc>] trace_hardirqs_on_thunk+0x35/0x37
kernel:  [<ffffffff80209fae>] system_call+0x7e/0x83
kernel:
kernel: Code: f2 ae 89 d0 48 f7 d1 48 39 c1 76 1a 48 8b 36 ff ca 48 c7 c7
kernel: RIP  [<ffffffff80242b76>] param_set_copystring+0x15/0x4b
kernel:  RSP <ffff81003dee3dd8>

