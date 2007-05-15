Return-Path: <linux-kernel-owner+w=401wt.eu-S965695AbXEORj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbXEORj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbXEORjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:39:23 -0400
Received: from mail1.wesleyan.edu ([129.133.6.127]:35246 "EHLO
	mail1.wesleyan.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbXEORjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:39:22 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 13:39:22 EDT
Date: Tue, 15 May 2007 13:28:20 -0400 (EDT)
From: "Eric R. Buddington" <ebuddington@wesleyan.edu>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21.1 panic in sis900_interrupt
Message-ID: <Pine.GSO.4.53.0705151319160.27688@alumni.wesleyan.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Wesleyan-MailScanner-Information: Please contact the ISP for more information
X-Wesleyan-MailScanner: Found to be clean
X-MailScanner-From: ebuddington@wesleyan.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(my apologies if this is a duplicate. Verizon has been losing or delaying
my mail, and refuses to address the problem until I switch from
mutt (or telnet to port 25) to Outlook Express.)

My kernel, on an Athlon XP system:
Linux version 2.6.21.1 (eric@pool-71-123-104-7.spfdma.east.verizon.net)
(gcc version 4.1.1) #1 Sun Apr 29 16:13:06 EDT 2007

This is repeatable 2 out of 2 times, during boot. It did not happen in
2.6.20-mm2.

The BUG (apologies for the linewrapping):
-------------------------------------------------------------------
BUG: unable to handle kernel NULL pointer dereference at virtual
address 000001c0
 printing eip:
c03ebe1a
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: ppp_synctty ppp_async crc_ccitt ppp_generic slhc
netconsole r128 drm softdog keyspan_pda usbserial sch_tbf raw1
394 dv1394 ohci1394 ieee1394 snd_ice1712 snd_ice17xx_ak4xxx
snd_ak4xxx_adda snd_cs8427 snd_i2c snd_mpu401_uart snd_rawmidi usbnet
snd_intel8x0 snd_ac97_codec ac97_bus ipt_tos ipt_owner iptable_nat
nf_conntrack_ipv4 ipt_MASQUERADE nf_nat nf_conntrack nfnetlink
ipt_TOS iptable_filter iptable_mangle ip_tables x_tables 8139too
sis900 sis5595 hwmon i2c_isa i2c_core sis_agp agpgart ide_scsi
CPU:    0
EIP:    0060:[<c03ebe1a>]    Not tainted VLI
EFLAGS: 00010212   (2.6.21.1 #1)
EIP is at netif_rx+0x7/0xec
eax: 00000000   ebx: f5e3e600   ecx: 0000aa12   edx: 000012aa
esi: f5e3e600   edi: 00800000   ebp: 000000ba   esp: c0697f84
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process httpd (pid: 3808, ti=c0697000 task=f14bb550 task.ti=f14be000)
Stack: f5e3e600 f5da0b40 f8911e5e ffffffff 00000086 c0709340 00000296
0000d410
       f5da0800 f5da0b40 00000028 0000d400 00000009 f5e3e600 0000000f
00000000
       0000d400 00000000 f2150d60 00000000 00000000 00000014 c0136a5e
c0637480
Call Trace:
 [<f8911e5e>] sis900_interrupt+0x240/0x59e [sis900]
 [<c0136a5e>] handle_IRQ_event+0x1a/0x3f
 [<c013766c>] handle_fasteoi_irq+0x0/0x77
 [<c01376bd>] handle_fasteoi_irq+0x51/0x77
 [<c01069d7>] do_IRQ+0xa5/0xca
 [<c0158d2a>] do_path_lookup+0x146/0x161
 [<c0157147>] generic_permission+0x55/0xca
 [<c01054bf>] common_interrupt+0x23/0x28
 [<c0138675>] find_get_page+0x21/0x22
 [<c013a6a2>] filemap_nopage+0x98/0x2af
 [<c015065c>] __dentry_open+0xd4/0x160
 [<c014249a>] __handle_mm_fault+0x13a/0x79c
 [<c0478cc0>] do_page_fault+0x20d/0x4d1
 [<c0478ab3>] do_page_fault+0x0/0x4d1
 [<c0477914>] error_code+0x74/0x7c
 =======================
Code: 82 8a 00 00 00 f6 c4 01 0f 85 d1 fd ff ff e9 e2 fd ff ff 31 db
e9 ee fe ff ff 83 c4 14 89 d8 5b 5e 5f 5d 8b 40 <8b> c0 01 00
 c0 74 83 78 0c 75 83 08 00 74 Kernel panic - not syncing: Fatal
exception in interrupt

