Return-Path: <linux-kernel-owner+w=401wt.eu-S934161AbZC0BEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbZC0BEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbZC0BDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:03:55 -0400
Received: from mail001.aei.ca ([206.123.6.130]:42693 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934037AbZC0BDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:03:53 -0400
From: Ed Tomlinson <edt@aei.ca>
To: ngupta@vflare.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] compressed in-memory swapping take3
Date: Thu, 26 Mar 2009 21:03:47 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.29-crc-00006-gcff995c; KDE/4.2.1; x86_64; ; )
References: <49C92E14.5060802@vflare.org>
In-Reply-To: <49C92E14.5060802@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903262103.47919.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009 15:01:40 Nitin Gupta wrote:
> Hi,
> 
> Project home: http://code.google.com/p/compcache/

I applied this to 2.6.29 and its not working correctly

I end up with lots of:

[69054.063788] Write-error on swap-device (254:0:13912)
[69054.063820] Write-error on swap-device (254:0:13920)
[69054.063853] Write-error on swap-device (254:0:13928)
[69054.063888] Write-error on swap-device (254:0:13936)
[69054.063904] Write-error on swap-device (254:0:13944)

type messages and trying to cat /proc/ramzswap causes an opps

[85235.133090] divide error: 0000 [#1] PREEMPT SMP
[85235.133510] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/enable
[85235.133510] CPU 0
[85235.133510] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables btrfs zlib_deflate zlib_inflate crc32c libcrc32c radeon drm ramzswap xvmalloc lzo_decompress lzo_compress bridge stp llc rfcomm bnep l2cap bluetooth tun sit tunnel4 ipv6 af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 edac_core tuner tvp5150 kvm_amd v4l2_common kvm video1394 sbp2 em28xx ir_common videodev v4l2_compat_ioctl32 videobuf_vmalloc videobuf_core tveeprom i2c_core pl2303 usbserial usbhid snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec sr_mod usb_storage cdrom snd_pcm ohci1394 snd_timer ieee1394 psmouse snd ata_generic thermal sky2 processor wmi button soundcore pata_atiixp rtc snd_page_alloc pcspkr ehci_hcd ohci_hcd evdev unix [last unloaded: floppy]
[85235.217935] Pid: 3910, comm: cat Not tainted 2.6.29-crc-00006-gcff995c #5 System Product Name
[85235.217935] RIP: 0010:[<ffffffffa0364146>]  [<ffffffffa0364146>] proc_ramzswap_read+0xe6/0x1e0 [ramzswap]
[85235.217935] RSP: 0018:ffff8800ce1a3dc8  EFLAGS: 00010246
[85235.217935] RAX: 0000000000000000 RBX: 000000000000002c RCX: 00000000000006b5
[85235.217935] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000064
[85235.217935] RBP: ffff8800ce1a3e48 R08: 0000000000000064 R09: 0000000000000665
[85235.217935] R10: ffff8800ed84f015 R11: ffff8800ce1a3ce8 R12: ffff8800ce1a3e8c
[85235.217935] R13: 0000000000000000 R14: ffff88006d84f000 R15: 0000000000665000
[85235.217935] FS:  00007fb6ae1e66f0(0000) GS:ffffffff8073c040(0000) knlGS:00000000f071bb90
[85235.217935] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[85235.217935] CR2: 000000000060c438 CR3: 0000000007bae000 CR4: 00000000000006e0
[85235.217935] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[85235.217935] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[85235.217935] Process cat (pid: 3910, threadinfo ffff8800ce1a2000, task ffff880148071620)
[85235.217935] Stack:
[85235.217935]  000a00d0000800d0 0000000000000001 0000000200000010 0000000000000000
[85235.217935]  ffffffff806b5f88 ffffffff8050ca15 ffff880149029a80 0000000000000001
[85235.217935]  ffff8801445e4060 0000000000000000 0000000000000400 0000000000000000
[85235.217935] Call Trace:
[85235.217935]  [<ffffffff8050ca15>] ? do_page_fault+0x345/0xa90
[85235.217935]  [<ffffffff80309d5f>] proc_file_read+0x1af/0x2e0
[85235.217935]  [<ffffffff80309bb0>] ? proc_file_read+0x0/0x2e0
[85235.217935]  [<ffffffff8030439c>] proc_reg_read+0x7c/0xc0
[85235.217935]  [<ffffffff802bcb88>] vfs_read+0xc8/0x180
[85235.217935]  [<ffffffff802bcd30>] sys_read+0x50/0x90
[85235.217935]  [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[85235.217935] Code: 0d 20 27 00 00 4c 39 c9 0f 84 ff 00 00 00 8b 05 31 27 00 00 41 b8 64 00 00 00 8b 35 21 27 00 00 31 d2 bf 64 00 00 00 41 0f af c0 <f7> f6 31 d2 41 89 c2 8b 05 11 27 00 00 0f af c7 f7 f6 41 89 c0
[85235.217935] RIP  [<ffffffffa0364146>] proc_ramzswap_read+0xe6/0x1e0 [ramzswap]
[85235.217935]  RSP <ffff8800ce1a3dc8>
[85235.218474] ---[ end trace aa4e537802c34b22 ]---

System is amd64 with 3 cpus, 8G with hugepa and page migration enabled and used by java (always active) and kvm (on demand).

I start it with (sdb2 is a 1G swapfile):

modprobe ramzswap backing_swap=/dev/sdb2
swapon /dev/ramzswap0 -p 100

After its loaded /proc/ramzcat works.  Once I've seen write error on swapdevice message it fails.

I would love to see this working. 

Thanks,
Ed Tomlinson
