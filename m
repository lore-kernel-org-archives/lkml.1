Return-Path: <linux-kernel-owner+w=401wt.eu-S965896AbXCFOwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965896AbXCFOwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965898AbXCFOwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:52:51 -0500
Received: from main.gmane.org ([80.91.229.2]:53431 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965896AbXCFOwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:52:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dirk Schoebel <dirk@liji-und-dirk.de>
Subject: Re: [linux-usb-devel] OOPS with 2.6.20 and 2.6.21-rc2 (mos7720)
Followup-To: gmane.linux.usb.devel
Date: Tue, 06 Mar 2007 15:52:24 +0100
Message-ID: <esjv78$g3h$1@sea.gmane.org>
References: <esjg1h$l8d$1@sea.gmane.org> <200703061207.53484.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-91-111.dynamic.qsc.de
User-Agent: KNode/0.10.4
Cc: linux-usb-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:

> Am Dienstag, 6. März 2007 11:33 schrieb Dirk Schoebel:
>> when trying to access /dev/ttyUSB0, which is a port on a dual port
>> usb-serial cable (mos7720 based) an kernel OOPS happens
>> the driver loads ok, first access via minicom -> OOPS

> 
> Please apply:
>
ftp://ftp.kernel.org/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/usb-fix-usb-serial-device-naming-bug.patch
>
ftp://ftp.kernel.org/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/usb-further-fix-for-usb-serial.patch
> 
> HTH
> Oliver

hmm, applied these patches, still crashes


Mar  6 15:46:30 emerald Unable to handle kernel NULL pointer dereference at
0000000000000070 RIP:
Mar  6 15:46:30 emerald
[<ffffffff8813b606>] :mos7720:mos7720_open+0x406/0x5a0
Mar  6 15:46:30 emerald PGD 13d489067 PUD 10ffe4067 PMD 0
Mar  6 15:46:30 emerald Oops: 0000 [1] SMP
Mar  6 15:46:30 emerald CPU 0
Mar  6 15:46:30 emerald Modules linked in: snd_rtctimer snd_seq_midi
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul
snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq nls_iso8859_15 vmnet(PF) vmmon(PF) it87 hwmon_vid i2c_isa rfcomm
eeprom l2cap lm90 fuse nls_iso8859_1 nls_cp850 eth1394 kqemu capability
dazuko commoncap tuner tvaudio msp3400 psmouse nvidia(P) snd_emu10k1
snd_rawmidi snd_seq_device snd_util_mem snd_hwdep mos7720 usbserial
ohci1394 i2c_nforce2 skge snd_bt87x bttv video_buf ir_common compat_ioctl32
btcx_risc tveeprom videodev v4l2_common v4l1_compat k8temp forcedeth
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc
zaurus cdc_ether usbnet hci_usb bluetooth
Mar  6 15:46:30 emerald Pid: 11881, comm: minicom Tainted: PF     
2.6.21-rc2-emi #1
Mar  6 15:46:30 emerald RIP: 0010:[<ffffffff8813b606>] 
[<ffffffff8813b606>] :mos7720:mos7720_open+0x406/0x5a0
Mar  6 15:46:30 emerald RSP: 0018:ffff810122757d58  EFLAGS: 00010202
Mar  6 15:46:30 emerald RAX: 0000000040000780 RBX: ffff81013dfc5800 RCX:
ffff81013ffe8000
Mar  6 15:46:30 emerald RDX: 0000000000000000 RSI: ffff810001000110 RDI:
0000000000000000
Mar  6 15:46:30 emerald RBP: ffff810122757d6f R08: ffff810122756000 R09:
ffff810122757b58
Mar  6 15:46:30 emerald R10: 0000000000000000 R11: 0000000000000000 R12:
ffff81013dfc5800
Mar  6 15:46:30 emerald R13: ffff81013d868bc0 R14: ffff81013cf43b00 R15:
ffff81013d688580
Mar  6 15:46:30 emerald FS:  00002ba10338cda0(0000) GS:ffffffff808a200
(0000) knlGS:00000000f64af9c0
Mar  6 15:46:30 emerald CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  6 15:46:30 emerald CR2: 0000000000000070 CR3: 000000013e55e000 CR4:
00000000000006e0
Mar  6 15:46:30 emerald Process minicom (pid: 11881, threadinfo
ffff810122756000, task ffff810100074730)
Mar  6 15:46:30 emerald Stack:  ffff81013dfc5800 ffff81013d774ff0
0c00000000000282 ffff81013dfc5800
Mar  6 15:46:30 emerald ffff81013d868bc0 ffff810139607000 ffff81013dfc5818
00000000ffffffed
Mar  6 15:46:30 emerald ffff8100bdabb2c0 ffffffff8812f487 ffff810109b6c900
000000000bc00000
Mar  6 15:46:30 emerald Call Trace:
Mar  6 15:46:30 emerald
[<ffffffff8812f487>] :usbserial:serial_open+0x117/0x190
Mar  6 15:46:30 emerald [<ffffffff805253a6>] tty_open+0x1b6/0x360
Mar  6 15:46:30 emerald [<ffffffff8024afe2>] chrdev_open+0x182/0x1e0
Mar  6 15:46:30 emerald [<ffffffff8024ae60>] chrdev_open+0x0/0x1e0
Mar  6 15:46:30 emerald [<ffffffff8021eccd>] __dentry_open+0xed/0x1e0
Mar  6 15:46:30 emerald [<ffffffff8022855d>] do_filp_open+0x2d/0x40
Mar  6 15:46:30 emerald [<ffffffff80234c6f>] do_setitimer+0x16f/0x350
Mar  6 15:46:30 emerald [<ffffffff802199ca>] do_sys_open+0x5a/0x100
Mar  6 15:46:30 emerald [<ffffffff802601ce>] system_call+0x7e/0x83
Mar  6 15:46:30 emerald
Mar  6 15:46:30 emerald
Mar  6 15:46:30 emerald Code: 44 8b 47 70 09 c2 48 8b 43 38 c7 47 04 01 00
00 00 48 89 4f
Mar  6 15:46:30 emerald RIP 
[<ffffffff8813b606>] :mos7720:mos7720_open+0x406/0x5a0
Mar  6 15:46:30 emerald RSP <ffff810122757d58>
Mar  6 15:46:30 emerald CR2: 0000000000000070


