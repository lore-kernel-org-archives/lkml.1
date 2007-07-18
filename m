Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbXGRFvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbXGRFvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXGRFvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:51:42 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:36052 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXGRFvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BxXb3nSga+N0atEz21Upwbeu/txrXwoN8SXV1lGjx19JpJPz/RQx0rGoNVcd87ejbmWFoEEhzUk0Cb0AFNctLRQ8VzhDqz/lfCUOSLT9ucUYDKqfByMhVDdzQfuxaNJsJ4GWniHsobkdLbyszcFx+drXWFI2gWUPc+5J56WX+VE=
Message-ID: <469DAA89.5030301@gmail.com>
Date: Wed, 18 Jul 2007 07:52:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: oops with 2.6.22.1 - bad magic number for tty struct
References: <c4e36d110707170814y682cefa6t58ab08f1cad6c6ac@mail.gmail.com>	<c4e36d110707170828s15a2e43ai9e3df37fb419aed6@mail.gmail.com> <18077.8844.37996.592932@stoffel.org>
In-Reply-To: <18077.8844.37996.592932@stoffel.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel napsal(a):
> Zdenek> I get kernel oopses when I run powertop on my old BP6 SMP dual
> Zdenek> Celeron board.
> 
> Zdenek> In case more details are needed - send me a replay.
> 
> Since it's tainted with a proprietary module, we can't do anything
> here.  Please re-create the oops without that module and we'll be able
> to help.

maybe...

> Zdenek> The machine with problem is -
> Zdenek> 2xCPU400MHz Celerons running at 450MHz (stable - compiles kernel
> Zdenek> without any problems, thought it takes more than hour nowadays :(...)
> Zdenek> 512MB RAM
> Zdenek> 120&30GB Hard drivers (all should be visible in the boot log that
> Zdenek> follows oops trace)
> Zdenek> In Bp6 bios - PnP enabled, Serial&Parallel ports disabled.
> Zdenek> Atheros WiFi driver is used - but this shall hopefully not influence
> Zdenek> this problem.
> 
> Zdenek> bye
> 
> Zdenek> Zdenek
> 
> 
> Zdenek> Jul 16 21:16:35 bad magic number for tty struct (136:3) in tty_poll

Hmm, pts tty struct broken 4 minutes before the oops? Is it reproducible?

> Zdenek> Jul 16 21:20:56 BUG: unable to handle kernel NULL pointer dereference
> Zdenek> at virtual address 0000007c
> Zdenek> Jul 16 21:20:56  printing eip:
> Zdenek> Jul 16 21:20:56 c0260c23
> Zdenek> Jul 16 21:20:56 *pde = 00000000
> Zdenek> Jul 16 21:20:56 Oops: 0000 [#1]
> Zdenek> Jul 16 21:20:56 PREEMPT SMP
> Zdenek> Jul 16 21:20:56 Modules linked in: cpufreq_stats freq_table mga drm
> Zdenek> binfmt_misc autofs4 nfsd exportfs lockd sunrpc thermal fan button
> Zdenek> processor ac battery ipv6 iptable_filter ip_tables x_tables fuse
> Zdenek> dm_snapshot dm_mirror dm_mod w83781d hwmon_vid hwmon tuner tvaudio
> Zdenek> snd_emu10k1 wlan_scan_sta snd_rawmidi ath_rate_sample snd_ac97_codec
> Zdenek> ac97_bus bttv video_buf firmware_class snd_bt87x ir_common snd_pcm_oss
> Zdenek> snd_mixer_oss compat_ioctl32 i2c_algo_bit snd_pcm btcx_risc
> Zdenek> snd_util_mem tveeprom videodev snd_hwdep 8139too snd_timer uhci_hcd
> Zdenek> v4l2_common v4l1_compat mii floppy emu10k1_gp snd_page_alloc ath_pci
> Zdenek> wlan ath_hal(P) pata_hpt366 libata i2c_piix4 snd intel_agp soundcore
> Zdenek> rtc usbcore gameport i2c_core scsi_mod agpgart evdev
> Zdenek> Jul 16 21:20:56 CPU:    0
> Zdenek> Jul 16 21:20:56 EIP:    0060:[<c0260c23>]    Tainted: P       VLI
> Zdenek> Jul 16 21:20:56 EFLAGS: 00010046   (2.6.22.1 #1)
> Zdenek> Jul 16 21:20:56 EIP is at tty_devnum+0x3/0x20
> Zdenek> Jul 16 21:20:56 eax: d7b3f800   ebx: d7b0c030   ecx: 00000000   edx: 00000000
> Zdenek> Jul 16 21:20:56 esi: cf9ac000   edi: df1aa7c0   ebp: d7b0c030   esp: c94a3db8
> Zdenek> Jul 16 21:20:56 ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Zdenek> Jul 16 21:20:56 Process top (pid: 6260, ti=c94a2000 task=c9a5ba90
> Zdenek> task.ti=c94a2000)
> Zdenek> Jul 16 21:20:56 Stack: c01adca0 c0186934 df00ce0c c94a3e08 c017e42d
> Zdenek> c7c0200b 00000101 01c5a71f
> Zdenek> Jul 16 21:20:56        c94a3e44 dffcbf20 c01f5340 dffce6b8 c94a3e38
> Zdenek> c0186934 c66b7b8c c94a3e38
> Zdenek> Jul 16 21:20:56        c017e42d c7c02006 00000001 00000000 01c5a71f
> Zdenek> 00000004 c7c0200b dffcbf20
> Zdenek> Jul 16 21:20:56 Call Trace:
> Zdenek> Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
> Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
> Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
> Zdenek> Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
> Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
> Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
> Zdenek> Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
> Zdenek> Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
> Zdenek> Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
> Zdenek> Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
> Zdenek> Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
> Zdenek> Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
> Zdenek> Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
> Zdenek> Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
> Zdenek> Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
> Zdenek> Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
> Zdenek> Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
> Zdenek> Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
> Zdenek> Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
> Zdenek> Jul 16 21:20:56  =======================
> Zdenek> Jul 16 21:20:56 Code: 2c 01 00 00 8b 4a 54 89 88 30 01 00 00 8b 4a 58
> Zdenek> 89 88 34 01 00 00 8b 52 5c 89 90 38 01 00 00 c3 90 8d b4 26 00 00 00
> Zdenek> 00 8b 48 04 <8b> 51 7c c1 e2 14 0b 91 80 00 00 00 8b 48 08 01 ca 89 d0
> Zdenek> c3 89
> Zdenek> Jul 16 21:20:56 EIP: [<c0260c23>] tty_devnum+0x3/0x20 SS:ESP 0068:c94a3db8


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
