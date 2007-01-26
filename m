Return-Path: <linux-kernel-owner+w=401wt.eu-S1751644AbXAZVhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbXAZVhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXAZVhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:37:54 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:55795 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbXAZVhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:37:53 -0500
Message-ID: <45BA743B.2080401@joow.be>
Date: Fri, 26 Jan 2007 22:35:55 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Linux1394-Devel <linux1394-devel@lists.sourceforge.net>
Subject: 2.6.20-rc6-rt2: kernel oops when ejecting cardbus firewire card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: oola 20001; Body=2 Fuz1=2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following Oops when ejecting a firewire cardbus controller.
The kernel is a 2.6.20-rc6 (git pull from a few hours ago), patched with 
Ingo's -rt2 patch.

cc'ing linux1394-devel because it seems to be a problem in the ieee1394 
stack.

Pieter

Jan 26 22:29:37 localhost kernel: pccard: card ejected from slot 0
Jan 26 22:29:37 localhost kernel: BUG: unable to handle kernel NULL 
pointer dereference at virtual address 00000000
Jan 26 22:29:37 localhost kernel:  printing eip:
Jan 26 22:29:37 localhost kernel: f91c8a6d
Jan 26 22:29:37 localhost kernel: *pde = 05c64067
Jan 26 22:29:37 localhost kernel: stopped custom tracer.
Jan 26 22:29:37 localhost kernel: Oops: 0000 [#1]
Jan 26 22:29:37 localhost kernel: PREEMPT
Jan 26 22:29:37 localhost kernel: Modules linked in: raw1394 dv1394 
ohci1394 ieee1394 nfsd exportfs lockd nfs_acl autofs4 hidp rfcomm l2cap 
bluetooth sunrp
c vfat fat radeon drm nvram snd_intel8x0m snd_intel8x0 snd_ac97_codec 
ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device snd_pcm_
oss snd_mixer_oss snd_pcm joydev snd_timer snd uhci_hcd i2c_i801 
soundcore ipw2200 ieee80211 ieee80211_crypt 8139too mii i2c_core pcspkr 
snd_page_alloc rng
_core ext3 jbd
Jan 26 22:29:37 localhost kernel: CPU:    0
Jan 26 22:29:37 localhost kernel: EIP:    0060:[<f91c8a6d>]    Not 
tainted VLI
Jan 26 22:29:37 localhost kernel: EFLAGS: 00010286   (2.6.20-rc6-rt2 #9)
Jan 26 22:29:37 localhost kernel: EIP is at dv1394_remove_host+0x17/0xc0 
[dv1394]
Jan 26 22:29:37 localhost kernel: eax: f88fd140   ebx: 00000001   ecx: 
00000000   edx: f91c8a56
Jan 26 22:29:37 localhost kernel: esi: 00000000   edi: f91c9910   ebp: 
00000000   esp: f7e49ebc
Jan 26 22:29:37 localhost kernel: ds: 007b   es: 007b   ss: 0068 
preempt: 00000001
Jan 26 22:29:37 localhost kernel: Process pccardd (pid: 284, ti=f7e48000 
task=f7f68ab0 task.ti=f7e48000)
Jan 26 22:29:37 localhost kernel: Stack: f91cb540 ee588000 f91cb540 
f88ea50f d4142180 ee588000 00000000 f91cb540
Jan 26 22:29:37 localhost kernel:        ee588000 00000000 ee589a84 
f88ea759 ee588000 f8950e94 f88ea18a f7e71400
Jan 26 22:29:37 localhost kernel:        f894a213 f8950f14 ee5880bc 
f7e71400 f8950e94 00000000 f7eae048 c01c0caf
Jan 26 22:29:37 localhost kernel: Call Trace:
Jan 26 22:29:37 localhost kernel:  [<f88ea50f>] 
__unregister_host+0x18/0x8f [ieee1394]
Jan 26 22:29:38 localhost kernel:  [<f88ea759>] 
highlevel_remove_host+0x21/0x42 [ieee1394]
Jan 26 22:29:38 localhost kernel:  [<f88ea18a>] 
hpsb_remove_host+0x37/0x55 [ieee1394]
Jan 26 22:29:38 localhost kernel:  [<f894a213>] 
ohci1394_pci_remove+0x47/0x1e4 [ohci1394]
Jan 26 22:29:38 localhost kernel:  [<c01c0caf>] pci_device_remove+0x16/0x35
Jan 26 22:29:38 localhost kernel:  [<c020fadc>] 
__device_release_driver+0x71/0x87
Jan 26 22:29:38 localhost kernel:  [<c020fba2>] 
device_release_driver+0x18/0x21
Jan 26 22:29:38 localhost kernel:  [<c020f6af>] bus_remove_device+0x70/0x80
Jan 26 22:29:38 localhost kernel:  [<c020e0a9>] device_del+0x13a/0x197
Jan 26 22:29:38 localhost kernel:  [<c020e10e>] device_unregister+0x8/0x10
Jan 26 22:29:38 localhost kernel:  [<c01be718>] pci_stop_dev+0x20/0x4e
Jan 26 22:29:38 localhost kernel:  [<c01be803>] 
pci_remove_bus_device+0x28/0x8c
Jan 26 22:29:38 localhost kernel:  [<c01be881>] 
pci_remove_behind_bridge+0x1a/0x2d
Jan 26 22:29:38 localhost kernel:  [<c022895a>] socket_shutdown+0x6d/0xb3
Jan 26 22:29:38 localhost kernel:  [<c02289bc>] socket_remove+0x1c/0x26
Jan 26 22:29:38 localhost kernel:  [<c0228f97>] pccardd+0x129/0x1ea
Jan 26 22:29:38 localhost kernel:  [<c010e56c>] 
default_wake_function+0x0/0x16
Jan 26 22:29:38 localhost kernel:  [<c0228e6e>] pccardd+0x0/0x1ea
Jan 26 22:29:38 localhost kernel:  [<c01216ce>] kthread+0xa0/0xca
Jan 26 22:29:38 localhost kernel:  [<c012162e>] kthread+0x0/0xca
Jan 26 22:29:38 localhost kernel:  [<c0102fe7>] 
kernel_thread_helper+0x7/0x10
Jan 26 22:29:38 localhost kernel:  =======================
Jan 26 22:29:38 localhost kernel: Code: 1c f9 e8 7f 6c 0e c7 89 da 89 9e 
a8 00 00 00 eb d9 5b 5e c3 57 bf 10 99 1c f9 56 53 8b 98 b0 00 00 00 8b 
80 b4 00 0
0 00 8b 70 04 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 85 c0 0f 
85 8d
Jan 26 22:29:38 localhost kernel: EIP: [<f91c8a6d>] 
dv1394_remove_host+0x17/0xc0 [dv1394] SS:ESP 0068:f7e49ebc
