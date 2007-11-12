Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbXKLGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbXKLGrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 01:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXKLGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 01:47:11 -0500
Received: from eazy.amigager.de ([213.239.192.238]:44990 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbXKLGrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 01:47:10 -0500
Date: Mon, 12 Nov 2007 07:47:06 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: XFS related Oops
Message-ID: <20071112064706.GA23595@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after resume from suspend with 2.6.23.1, I got the following Oops:

BUG: unable to handle kernel paging request at virtual address 3e0d204c
 printing eip:
c022807f
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: dvb_usb_cinergyT2 i915 drm cpufreq_stats usblp
firewire_ohci firewire_core dvb_usb crc_itu_t evdev snd_hda_intel
rtc_cmos sky2 dvb_core applesmc led_class coretemp hwmon
CPU:    0
EIP:    0060:[<c022807f>]    Not tainted VLI
EFLAGS: 00010202   (2.6.23.1 #4)
EIP is at xfs_iget_core+0x6f/0x690
eax: 0033f000   ebx: 3e0d2010   ecx: f7826000   edx: 0033f000
esi: 001346d7   edi: 00000000   ebp: f7525214   esp: f68b7cb4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process squid (pid: 2967, ti=f68b6000 task=f6833030 task.ti=f68b6000)
Stack: c024f1b1 00000001 f6a3d6c0 001346d7 f789ce00 c18993d8 c04fb280
f7525218 
       00000000 00000000 f7826000 e652c240 00000000 3e0d2010 e652c25c
e652c240 
       001346d7 f7826000 c0228774 001346d7 00000000 00000000 00000000
f68b7d80 
Call Trace:
 [<c024f1b1>] kmem_zone_alloc+0x51/0xb0
 [<c0228774>] xfs_iget+0xd4/0x160
 [<c024474b>] xfs_dir_lookup_int+0x9b/0x100
 [<c0247ec5>] xfs_lookup+0x75/0xa0
 [<c0256874>] xfs_vn_lookup+0x54/0x90
 [<c0177a32>] do_lookup+0x122/0x1a0
 [<c01794d4>] __link_path_walk+0x784/0xd80
 [<c0273072>] __next_cpu+0x12/0x30
 [<c0121dbd>] find_busiest_group+0x19d/0x6a0
 [<c0179b15>] link_path_walk+0x45/0xc0
 [<c0131350>] process_timeout+0x0/0x10
 [<c016eb62>] get_unused_fd_flags+0x52/0xc0
 [<c0179db3>] do_path_lookup+0x73/0x1b0
 [<c01719b8>] get_empty_filp+0x58/0x120
 [<c017a9d1>] __path_lookup_intent_open+0x51/0xa0
 [<c017aab0>] path_lookup_open+0x20/0x30
 [<c017abb6>] open_namei+0x66/0x640
 [<c0131697>] lock_timer_base+0x27/0x60
 [<c0131715>] try_to_del_timer_sync+0x45/0x50
 [<c016ee7e>] do_filp_open+0x2e/0x60
 [<c0131350>] process_timeout+0x0/0x10
 [<c016eb62>] get_unused_fd_flags+0x52/0xc0
 [<c016eefc>] do_sys_open+0x4c/0xe0
 [<c016efcc>] sys_open+0x1c/0x20
 [<c010428e>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 44 24 1c 8b 44 24 1c e8 60 92 1b 00 8b 5d 00 85 db 89 5c 24 34 75
14 e9 90 00 00 00 8b 5b 04 85 db 89 5c 24 34 0f 84 81 00 00 00 <8b> 53
3c 8b 43 38 31 fa 31 f0 09 c2 75 e3 8d 83 dc 00 00 00 e8 
EIP: [<c022807f>] xfs_iget_core+0x6f/0x690 SS:ESP 0068:f68b7cb4

Does this ring any bells?

Regards,
Tino
