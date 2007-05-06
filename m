Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXEFTum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXEFTum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXEFTum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:50:42 -0400
Received: from smtp1.oregonstate.edu ([128.193.0.11]:37775 "EHLO
	smtp1.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbXEFTul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:50:41 -0400
X-Greylist: delayed 1219 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 May 2007 15:50:40 EDT
X-Spam-Score: 1.253
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Sun, 06 May 2007 12:30:21 -0700
Subject: [BUG] mixing 8250/16550 and AT91 serial ports causes oops
From: Ryan Ordway <ryan.ordway@oregonstate.edu>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C2637ADD.CD26%ryan.ordway@oregonstate.edu>
Thread-Topic: [BUG] mixing 8250/16550 and AT91 serial ports causes oops
Thread-Index: AceQFPxNOtHLSPwIEduMQwAX8s6OAA==
In-Reply-To: <20070506190039.GA24881@martell.zuzino.mipt.ru>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 06 May 2007 19:30:19.0892 (UTC) FILETIME=[FBA3F340:01C79014]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I tracked down my oops. It looks to be a problem with mixing 8250/16550
serial ports and the AT91 ports on the Atmel AT91SAM9260-EK board. Here is
the oops:





Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000     
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1]
Modules linked in: 
CPU: 0             
PC is at init_dev+0x28/0x4e8
LR is at tty_open+0x120/0x304
pc : [<c00f8a18>]    lr : [<c00fbce4>]    Not tainted
sp : c12e1e08  ip : c12e1e50  fp : c12e1e4c
r10: 00000002  r9 : 00000000  r8 : c12e0000
r7 : 00000001  r6 : c1237c00  r5 : c0299c38  r4 : c12fb8a0
r3 : 00000000  r2 : c12e1e54  r1 : 00000000  r0 : c1237c00
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
Control: 5317F     
Table: 20004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc12e0258)
Stack: (0xc12e1e08 to 0xc12e2000)
1e00:                   c12e1e54 c025fce8 c12e1e50 c1237c00 00000000
c12e0000
1e20: c12e1e4c c12fb8a0 c0299c38 00500001 00000001 c12e0000 00000000
00000002
1e40: c12e1e7c c12e1e50 c00fbce4 c00f8a00 00000000 c3d78a40 00000000
c0299c38
1e60: c3d78a40 c12fb8a0 c1257bc8 00000000 c12e1ea4 c12e1e80 c0080d7c
c00fbbd4
1e80: c12e1ea4 00000000 c12fb8a0 c3d78a40 c0080c2c c12d3220 c12e1ecc
c12e1ea8
1ea0: c007c758 c0080c3c c12fb8a0 c12e1ef8 c03a4000 00000000 ffffff9c
00000000
1ec0: c12e1eec c12e1ed0 c007c8f4 c007c674 00000000 ffffff9c 00000000
00000002
1ee0: c12e1f5c c12e1ef0 c007c950 c007c8d0 c12e1ef8 c00ef830 c1257bc8
c12d3220
1f00: c0065970 00000002 c12e0000 00000101 00000001 00000000 c12e1f34
c12e1f28
1f20: c01d74f0 c00ef830 c12e1f5c c12e1f38 c007c658 c01d74f0 00000002
00000003
1f40: 00000000 c12fb8a0 00000002 00000000 c12e1f84 c12e1f60 c007c9ac
c007c91c
1f60: c0029be8 c0269f98 c001f87c c12e0000 00000000 00000000 c12e1f94
c12e1f88
1f80: c007ca28 c007c968 c12e1fac c12e1f98 c002205c c007ca14 c0269f98
c0269f98
1fa0: c12e1ff4 c12e1fb0 c000886c c002203c 00000000 00000000 c00086fc
c00406bc
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
00000000
1fe0: 00000000 00000000 00000000 c12e1ff8 c00406bc c000870c 00220008
00020015
Backtrace:
[<c00f89f0>] (init_dev+0x0/0x4e8) from [<c00fbce4>] (tty_open+0x120/0x304)
[<c00fbbc4>] (tty_open+0x0/0x304) from [<c0080d7c>]
(chrdev_open+0x150/0x1a0)
[<c0080c2c>] (chrdev_open+0x0/0x1a0) from [<c007c758>]
(__dentry_open+0xf4/0x1e4)
 r7 = C12D3220  r6 = C0080C2C  r5 = C3D78A40  r4 = C12FB8A0
[<c007c664>] (__dentry_open+0x0/0x1e4) from [<c007c8f4>]
(nameidata_to_filp+0x34/0x4c)
[<c007c8c0>] (nameidata_to_filp+0x0/0x4c) from [<c007c950>]
(do_filp_open+0x44/0x4c)
 r4 = 00000002     
[<c007c90c>] (do_filp_open+0x0/0x4c) from [<c007c9ac>]
(do_sys_open+0x54/0x98)
 r5 = 00000000  r4 = 00000002
[<c007c958>] (do_sys_open+0x0/0x98) from [<c007ca28>] (sys_open+0x24/0x28)
 r8 = 00000000  r7 = 00000000  r6 = C12E0000  r5 = C001F87C
 r4 = C0269F98     
[<c007ca04>] (sys_open+0x0/0x28) from [<c002205c>] (init_post+0x30/0xe8)
[<c002202c>] (init_post+0x0/0xe8) from [<c000886c>] (init+0x170/0x1b8)
 r4 = C0269F98     
[<c00086fc>] (init+0x0/0x1b8) from [<c00406bc>] (do_exit+0x0/0x808)
 r7 = 00000000  r6 = 00000000  r5 = 00000000  r4 = 00000000
Code: e3130010 059030c8 e1a06000 e1a09001 (07935101)
Kernel panic - not syncing: Attempted to kill init!


-- 
Ryan Ordway                          E-mail:   rordway@oregonstate.edu
Unix Systems Administrator             rordway@library.oregonstate.edu
OSU Libraries, Corvallis, OR 97370        Office: Valley Library #4657


