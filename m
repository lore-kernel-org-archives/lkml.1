Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYEMIKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYEMIKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYEMIJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:09:55 -0400
Received: from ns.store20.com ([212.7.7.16]:59733 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbYEMIJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:09:52 -0400
Subject: OOPS in ov511 driver
From: Priit Laes <plaes@plaes.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: mmcclell@bigfoot.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 May 2008 11:09:57 +0300
Message-Id: <1210666197.30196.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!

I got following oops when unplugging some Creative-labeled webcam using
ov511 driver. Machine is Core2 Duo 64-bit, Gentoo Linux, kernel is
2.6.25-05301-gc3bf9bc, gcc is 4.2.3 (Gentoo 4.2.3 p1.0)

usb 2-1: USB disconnect, address 7
ov511: ERROR: urb->status=-108: Unknown
ov511: usb_submit_urb() ret -19
ov511: ERROR: urb->status=-108: Unknown
ov511: usb_submit_urb() ret -19
usb 2-1: new full speed USB device using uhci_hcd and address 8
usb 2-1: configuration #1 chosen from 1 choice
ov511: USB OV511+ video device found
ov511: model: Creative Labs WebCam 3
ov511: Sensor is an OV7620
ov511: Device at usb-0000:00:1d.0-1 registered to minor 0
BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
IP: [<ffffffff8051487e>] mutex_lock+0x0/0xb
PGD 33b6a067 PUD 2e462067 PMD 0
Oops: 0002 [1] PREEMPT SMP
CPU 0
Modules linked in: ov511 videodev v4l1_compat iwl3945
Pid: 26378, comm: python Not tainted 2.6.25-05301-gc3bf9bc #59
RIP: 0010:[<ffffffff8051487e>]  [<ffffffff8051487e>] mutex_lock+0x0/0xb
RSP: 0018:ffff810022cefee0  EFLAGS: 00010293
RAX: ffff810022df9800 RBX: 00000000000000a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff81002990c540 RDI: 00000000000000a8
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000009 R11: 0000000000000202 R12: ffff81002990c540
R13: ffff81003dd9a000 R14: ffff81003eabc900 R15: 00007f1bccd47b44
FS:  00007f1bd3f0a6f0(0000) GS:ffffffff806c2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000a8 CR3: 000000002e79b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python (pid: 26378, threadinfo ffff810022cee000, task ffff81001dc72690)
Stack:  ffffffffa002a067 0000000000000008 ffff81002990c540 ffff81001ffc2960
 ffffffff80279453 ffff81002990c540 ffff81002635b340 0000000000000000
 ffff81002635b3c0 00007f1bcdb02d80 ffffffff80276c7e ffff81002635b340
Call Trace:
 [<ffffffffa002a067>] :ov511:ov51x_v4l1_close+0x47/0x133
 [<ffffffff80279453>] __fput+0xa1/0x147
 [<ffffffff80276c7e>] filp_close+0x5d/0x65
 [<ffffffff80277e54>] sys_close+0x76/0xb9
 [<ffffffff8020b40b>] system_call_after_swapgs+0x7b/0x80


Code: 1c 24 44 89 64 24 08 48 c7 44 24 20 45 25 24 80 48 89 44 24 28 48 89 44 24 30 e8 23 ff ff ff 48 83 c4 48 5b 41 5c 41 5d 41 5e c3 <f0> ff 0f 79 05 e8 68 01 00 00 c3 f0 ff 07 7f 05 e8 6d 01 00 00
RIP  [<ffffffff8051487e>] mutex_lock+0x0/0xb
 RSP <ffff810022cefee0>
CR2: 00000000000000a8
---[ end trace ca143223eefdc828 ]---

