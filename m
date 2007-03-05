Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXCEIcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXCEIcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXCEIcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:32:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:40085 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbXCEIcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Z+ZMeT43U0z+pYdchEy34nU/usTX10zFKj2QjdHtQks/muWGMdmcmWZSRiiattPPjkxGxqGzp9sc8g1ixBBHhxH5UbZiBkdzh93+x7y5KZNqGclAOLZ1RyWYo/n+lxenxo9UElqufBYtCdWYSfoOPuSIn/Zwe3acX3t3lryoQPM=
Message-ID: <29c147bd0703050032k71a06603p89d541071be5d656@mail.gmail.com>
Date: Mon, 5 Mar 2007 09:32:04 +0100
From: "Lorenzo Milesi" <lorenzo.milesi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem with skbuff.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

In the latest months (it started around nov/dec 2006) I experienced
some random kernel panics.
After some time I managed to work out what was happening.

Feb 23 18:38:54 [kernel] kernel BUG at net/core/skbuff.c:94!
Feb 23 18:38:54 [kernel] CPU 0
Feb 23 18:38:54 [kernel] Modules linked in: rlocate
cpufreq_performance snd_seq snd_pcm_oss snd_mixer_oss loop tun
asus_acpi backlight af_packet powernow_k8 freq_table ndiswrapper
snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device snd_hwdep 8139cp
nvidia(P) i2c_core 8139too mii sdhci mmc_core k8temp hwmon
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore
snd_page_alloc ehci_hcd ohci_hcd pcmcia
Feb 23 18:38:54 [kernel] Pid: 7893, comm: dhclient Tainted: P
2.6.20-gentoo-ginger #1
Feb 23 18:38:54 [kernel] RIP: 0010:[<ffffffff803de68c>]
[<ffffffff803de68c>] skb_over_panic+0x5c/0x70
Feb 23 18:38:54 [kernel] RSP: 0018:ffff810013fa7c78  EFLAGS: 00010292
Feb 23 18:38:54 [kernel] RAX: 000000000000009b RBX: ffff810013a51182
RCX: ffffffff805028c0
Feb 23 18:38:54 [kernel] RDX: ffffffff805028c0 RSI: 0000000000000001
RDI: ffff81001e2a9860
Feb 23 18:38:54 [kernel] RBP: ffff810013fa7f28 R08: 0000000000000000
R09: 000000000000000d
Feb 23 18:38:54 [kernel] R10: 000000000000000e R11: 0000000000000006
R12: ffff81001faf4000
Feb 23 18:38:54 [kernel] R13: 0000000000000156 R14: ffff81001f42ecc0
R15: ffff8100157b1000
Feb 23 18:38:54 [kernel] FS:  00002b3ded0046f0(0000)
GS:ffffffff80531000(0000) knlGS:0000000000000000
Feb 23 18:38:54 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 23 18:38:54 [kernel] CR2: 00002b3dece5359e CR3: 0000000013ebc000
CR4: 00000000000006e0
Feb 23 18:38:54 [kernel] Process dhclient (pid: 7893, threadinfo
ffff810013fa6000, task ffff81001e201140)
Feb 23 18:38:54 [kernel] Stack:  ffff810013a51002 ffff810013a512d8
ffffffff804b1b1e ffffffff8888ced6
Feb 23 18:38:54 [kernel]  0000810013fa7d88 ffff810012fa55c0
0000000000000000 ffff810012ef2880
Feb 23 18:38:54 [kernel]  ffff810013fa7e68 00007fffbddfb590
0000000000000010 ffffffff803d942b
Feb 23 18:38:54 [kernel] Call Trace:
Feb 23 18:38:54 [kernel]  [<ffffffff8888ced6>]
:af_packet:packet_sendmsg_spkt+0x186/0x220
Feb 23 18:38:54 [kernel]  [<ffffffff803d942b>] sock_sendmsg+0xcb/0xf0
Feb 23 18:38:54 [kernel]  [<ffffffff80282954>] mntput_no_expire+0x24/0xa0
Feb 23 18:38:54 [kernel]  [<ffffffff8023ce80>] autoremove_wake_function+0x0/0x30
Feb 23 18:38:54 [kernel]  [<ffffffff80276da8>] do_path_lookup+0x178/0x1a0
Feb 23 18:38:54 [kernel]  [<ffffffff8027e8cf>] dput+0x2f/0x160
Feb 23 18:38:54 [kernel]  [<ffffffff80282954>] mntput_no_expire+0x24/0xa0
Feb 23 18:38:54 [kernel]  [<ffffffff803d84b5>] move_addr_to_kernel+0x25/0x40
Feb 23 18:38:54 [kernel]  [<ffffffff803d98c2>] sys_sendto+0x142/0x1a0
Feb 23 18:38:54 [kernel]  [<ffffffff80209e3e>] system_call+0x7e/0x83
Feb 23 18:38:54 [kernel] Code: 0f 0b 66 90 eb fe 66 66 66 90 66 66 66
90 66 66 90 66 66 90
Feb 23 18:38:54 [kernel] RIP  [<ffffffff803de68c>] skb_over_panic+0x5c/0x70
Feb 23 18:38:54 [kernel]  RSP <ffff810013fa7c78>
Feb 23 18:40:07 [kernel] kernel BUG at net/core/skbuff.c:112!
Feb 23 18:40:07 [kernel] CPU 0
Feb 23 18:40:07 [kernel] Modules linked in: rlocate
cpufreq_performance snd_seq snd_pcm_oss snd_mixer_oss loop tun
asus_acpi backlight af_packet powernow_k8 freq_table ndiswrapper
snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device snd_hwdep 8139cp
nvidia(P) i2c_core 8139too mii sdhci mmc_core k8temp hwmon
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore
snd_page_alloc ehci_hcd ohci_hcd pcmcia
Feb 23 18:40:07 [kernel] Pid: 8475, comm: arping Tainted: P
2.6.20-gentoo-ginger #1
Feb 23 18:40:07 [kernel] RIP: 0010:[<ffffffff803de61c>]
[<ffffffff803de61c>] skb_under_panic+0x5c/0x70
Feb 23 18:40:07 [kernel] RSP: 0018:ffff81000d199c08  EFLAGS: 00010296
Feb 23 18:40:07 [kernel] RAX: 000000000000009a RBX: ffff81001e32d880
RCX: ffffffff805028c0
Feb 23 18:40:07 [kernel] RDX: ffffffff805028c0 RSI: 0000000000000001
RDI: ffff81001e2a9860
Feb 23 18:40:07 [kernel] RBP: ffff81001b3af9f2 R08: 0000000000000000
R09: 00000000ffffffff
Feb 23 18:40:07 [kernel] R10: 0000000000000000 R11: 00000000ffffffff
R12: 0000000000000000
Feb 23 18:40:07 [kernel] R13: ffff81001ef82800 R14: 0000000000000806
R15: 000000000000001c
Feb 23 18:40:07 [kernel] FS:  00002b648aaa1b00(0000)
GS:ffffffff80531000(0000) knlGS:0000000000000000
Feb 23 18:40:07 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 23 18:40:07 [kernel] CR2: 00002b648a8ea0a0 CR3: 000000000d193000
CR4: 00000000000006e0
Feb 23 18:40:07 [kernel] Process arping (pid: 8475, threadinfo
ffff81000d198000, task ffff81001d6247e0)
Feb 23 18:40:07 [kernel] Stack:  ffff81001b3afa10 ffff81001b3afa50
ffffffff804b1b1e ffffffff803f1985
Feb 23 18:40:07 [kernel]  ffff81000d199e74 ffff81001ef82800
ffff81000d199ee8 ffff81000f8ccd00
Feb 23 18:40:07 [kernel]  ffff81001e32d880 000000000000001c
ffff81000f1d4000 ffffffff8888be62
Feb 23 18:40:07 [kernel] Call Trace:
Feb 23 18:40:07 [kernel]  [<ffffffff803f1985>] eth_header+0x65/0x120
Feb 23 18:40:07 [kernel]  [<ffffffff8888be62>]
:af_packet:packet_sendmsg+0x182/0x2c0
Feb 23 18:40:07 [kernel]  [<ffffffff803d942b>] sock_sendmsg+0xcb/0xf0
Feb 23 18:40:07 [kernel]  [<ffffffff8023ce80>] autoremove_wake_function+0x0/0x30
Feb 23 18:40:07 [kernel]  [<ffffffff80250207>] filemap_nopage+0x177/0x330
Feb 23 18:40:07 [kernel]  [<ffffffff8025a5ce>] __handle_mm_fault+0x3fe/0x9d0
Feb 23 18:40:07 [kernel]  [<ffffffff803d84b5>] move_addr_to_kernel+0x25/0x40
Feb 23 18:40:07 [kernel]  [<ffffffff803d98c2>] sys_sendto+0x142/0x1a0
Feb 23 18:40:07 [kernel]  [<ffffffff8025ec7d>] do_mmap_pgoff+0x67d/0x800
Feb 23 18:40:07 [kernel]  [<ffffffff80209e3e>] system_call+0x7e/0x83
Feb 23 18:40:07 [kernel] Code: 0f 0b 66 90 eb fe 66 66 66 90 66 66 66
90 66 66 90 66 66 90
Feb 23 18:40:07 [kernel] RIP  [<ffffffff803de61c>] skb_under_panic+0x5c/0x70
Feb 23 18:40:07 [kernel]  RSP <ffff81000d199c08>

I found this patch
http://lkml.org/lkml/2006/11/29/335 and actually seems to fix the
problem. I'm running the latest 2.6.20 with the following patch since
1 week and I'm not having panics anymore.

I hope this helps.
Maxxer

ps please CC me as I'm not in the list.
