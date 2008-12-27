Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYL0JTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYL0JTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYL0JS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:18:57 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3265 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYL0JS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:18:56 -0500
Message-ID: <4955F2F8.2040606@xs4all.nl>
Date: Sat, 27 Dec 2008 10:18:48 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG on EN12000 w/ 2.6.28?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my VIA Epia EN12000 with 2.6.28 I found:

Dec 27 04:03:20 recorder kernel: kernel BUG at fs/dcache.c:474!
Dec 27 04:03:20 recorder kernel: invalid opcode: 0000 [#1] PREEMPT
Dec 27 04:03:20 recorder kernel: last sysfs file: 
/sys/devices/platform/w83627hf.656/fan1_min
Dec 27 04:03:20 recorder kernel: Modules linked in: nfsd lockd nfs_acl 
exportfs w83627hf hwmon_vid eeprom sunrpc binfmt_misc tda1004x 
snd_via82xx snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi
_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer 
snd_page_alloc budget_av snd_mpu401_uart saa7146_vv videobuf_dma_sg 
snd_rawmidi videobuf_core snd_seq_device budget_core saa7146 snd 
ttpci_eeprom i2c
_viapro sg ohci1394 ieee1394 fan thermal processor button ata_generic 
uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Dec 27 04:03:20 recorder kernel:
Dec 27 04:03:20 recorder kernel: Pid: 225, comm: kswapd0 Not tainted 
(2.6.28 #1)
Dec 27 04:03:20 recorder kernel: EIP: 0060:[<c01657ba>] EFLAGS: 00010283 
CPU: 0
Dec 27 04:03:20 recorder kernel: EIP is at __shrink_dcache_sb+0xae/0x2f1
Dec 27 04:03:20 recorder kernel: EAX: 00000000 EBX: e1b431ec ECX: 
e1b43210 EDX: f70cbee8
Dec 27 04:03:20 recorder kernel: ESI: f684f000 EDI: f684f098 EBP: 
f70cbf0c ESP: f70cbed4
Dec 27 04:03:20 recorder kernel: DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 
0068
Dec 27 04:03:20 recorder kernel: Process kswapd0 (pid: 225, ti=f70ca000 
task=f70377b0 task.ti=f70ca000)
Dec 27 04:03:20 recorder kernel: Stack:
Dec 27 04:03:20 recorder kernel: f70cbee0 00000008 00000037 f6c3b138 
f6c168f8 c98ebc5c e1b4368c f684f000
Dec 27 04:03:20 recorder kernel: 00000070 0000005a 000000d5 c0165adf 
00006a9a f684f03c 0000005a c03e6dd0
Dec 27 04:03:20 recorder kernel: 00006a40 00000083 00000000 c0144c7f 
0000000f 00000000 00037015 000000d0
Dec 27 04:03:20 recorder kernel: Call Trace:
Dec 27 04:03:20 recorder kernel: [<c0165adf>] 
shrink_dcache_memory+0xe2/0x193
Dec 27 04:03:20 recorder kernel: [<c0144c7f>] shrink_slab+0xdd/0x146
Dec 27 04:03:20 recorder kernel: [<c0144fff>] kswapd+0x317/0x408
Dec 27 04:03:20 recorder kernel: [<c014324a>] isolate_pages_global+0x0/0x1f2
Dec 27 04:03:20 recorder kernel: [<c0129406>] 
autoremove_wake_function+0x0/0x2d
Dec 27 04:03:20 recorder kernel: [<c0144ce8>] kswapd+0x0/0x408
Dec 27 04:03:20 recorder kernel: [<c01290d0>] kthread+0x36/0x5a
Dec 27 04:03:20 recorder kernel: [<c012909a>] kthread+0x0/0x5a
Dec 27 04:03:20 recorder kernel: [<c010388f>] kernel_thread_helper+0x7/0x10
Dec 27 04:03:20 recorder kernel: Code: 89 43 04 89 5c 24 0c 89 51 04 89 
0a 89 be 9c 00 00 00 89 be 98 00 00 00 e9 e3 01 00 00 8b 8e 9c 00 00 00 
8d 59 dc 39 73 4c 74 04 <0f> 0b eb fe 89 e0 25 00 e0 ff ff ff 40
  14 83 7c 24 04 00 74 43
Dec 27 04:03:20 recorder kernel: EIP: [<c01657ba>] 
__shrink_dcache_sb+0xae/0x2f1 SS:ESP 0068:f70cbed4
Dec 27 04:03:20 recorder kernel: ---[ end trace 2ffb2cae40aa10f4 ]---
Dec 27 04:03:20 recorder kernel: note: kswapd0[225] exited with 
preempt_count 1


Really a bug or something else?

Kind regards,
Udo
