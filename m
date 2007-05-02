Return-Path: <linux-kernel-owner+w=401wt.eu-S1766961AbXEBRvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766961AbXEBRvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766964AbXEBRvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:51:55 -0400
Received: from nn7.de ([85.214.94.156]:37269 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766961AbXEBRvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:51:54 -0400
Subject: oops in 2.6.21...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 May 2007 17:29:32 +0000
Message-Id: <1178126972.24565.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

happened unfortunately with a tainted kernel (fglrx,ath_pci), although
the machine survived a couple of s2ram/resume cycles before:

BUG: unable to handle kernel paging request at virtual address 07ff800d
 printing eip:
c01880a4
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: sky2 ath_pci uinput snd_usb_audio snd_usb_lib snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi snd_seq_device snd_hwdep wlan_tkip fglrx(P) hci_usb rfcomm hidp l2cap blue
CPU:    0
EIP:    0060:[<c01880a4>]    Tainted: P       VLI
EFLAGS: 00010283   (2.6.21-sonne #2)
EIP is at iput+0x14/0x70
eax: 07ff7fed   ebx: c008fd70   ecx: c008fd88   edx: c008fd88
esi: f7d6a03c   edi: 00000000   ebp: d4f95f78   esp: dfca7edc
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kswapd0 (pid: 219, ti=dfca6000 task=dfc60580 task.ti=dfca6000)
Stack: d4f95f70 c0186d43 d4f95f70 f7d6a03c c0186f60 0000002f 00041f14 00000112 
       dfffe560 000000d0 c018703a c015f855 00005803 00000000 00000000 00000093 
       00000000 c04dcd00 00000000 00000080 0001c9e7 00000000 00000001 c04729c0 
Call Trace:
 [<c0186d43>] prune_one_dentry+0x53/0x80
 [<c0186f60>] prune_dcache+0xf0/0x190
 [<c018703a>] shrink_dcache_memory+0x3a/0x40
 [<c015f855>] shrink_slab+0x135/0x1a0
 [<c015fcf7>] kswapd+0x377/0x480
 [<c013fb60>] autoremove_wake_function+0x0/0x50
 [<c015f980>] kswapd+0x0/0x480
 [<c013f99b>] kthread+0xbb/0xf0
 [<c013f8e0>] kthread+0x0/0xf0
 [<c0104eb3>] kernel_thread_helper+0x7/0x14
 =======================
Code: ff ff ff 8d 74 26 00 e8 ab 9a 22 00 31 c0 c3 90 8d b4 26 00 00 00 00 85 c0 53 89 c3 74 55 8b 80 a4 00 00 00 83 bb 50 01 00 00 20 <8b> 40 20 74 45 85 c0 74 0b 8b 50 14 85 d2 74 04 89 d8 ff d2 8d 
EIP: [<c01880a4>] iput+0x14/0x70 SS:ESP 0068:dfca7edc

-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
