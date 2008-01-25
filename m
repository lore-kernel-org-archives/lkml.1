Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYAYVFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYAYVFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYAYVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:05:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:34205 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYAYVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nAKfEAiqv/uuFhVt2aLlAMqsdt+6I3r0ciTZf6fZyAaM/1cJL9FvI7ZGF6SkqoJ55ELeda4236DJkHgYORXeU+RZoDdIZEIHCQRRTWilzD3p4Bud6UnOuEezLpwPZCtSVfVmUso/KpKgyx0V2RV/l2Kbll2V/gIHXrmdLfMqN4Q=
Message-ID: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com>
Date: Fri, 25 Jan 2008 13:05:40 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: threshold_init_device/kobject_uevent_env oops
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current linus tree + x86.git

got

Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-g075f8dcd-dirty #2
RIP: 0010:[<ffffffff80458e20>]  [<ffffffff80458e20>]
kobject_uevent_env+0x2a/0x3d9
RSP: 0000:ffff81042643db50  EFLAGS: 00010286
RAX: 0000000000000018 RBX: 0000000000000000 RCX: 00000000c0000410
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
RBP: 0000000000000018 R08: ffff810824964410 R09: 0000000024964410
R10: ffffc20002c0a6a8 R11: ffff810824964410 R12: 0000000000000000
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffffffff80b42000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000040 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81042643c000, task ffff81082643a000)
Stack:  ffff810824964410 00000000802c5ca6 ffffffff809961f5 ffffffff80a8ad00
 ffff810824964500 0000000000000000 ffff810824964410 ffff81082653f0c0
 0000000000000004 ffffffff802c5842 0000000024964410 00000000c000040f
Call Trace:
 [<ffffffff802c5842>] ? sysfs_add_file+0x5b/0x81
 [<ffffffff802180dc>] ? allocate_threshold_blocks+0x190/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff802180ca>] ? allocate_threshold_blocks+0x17e/0x1bc
 [<ffffffff80218349>] ? threshold_create_device+0x241/0x330
 [<ffffffff8023bd80>] ? __mod_timer+0xbd/0xcd
 [<ffffffff80b93dae>] ? threshold_init_device+0x16/0x3f
 [<ffffffff80b8b6e3>] ? kernel_init+0x175/0x2e1
 [<ffffffff8020ccd8>] ? child_rip+0xa/0x12
 [<ffffffff80b8b56e>] ? kernel_init+0x0/0x2e1
 [<ffffffff8020ccce>] ? child_rip+0x0/0x12


Code: c3 41 57 89 f0 41 56 41 55 41 54 55 48 89 fd 53 48 89 d3 48 83
ec 58 48 8b 04 c5 00 11 84 80 89 74 24 0c 48 89 44 24 10 48 89 f8 <4c>
8b 70 28 4d 85 f6 75 14 48 8b 40 20 48 85 c0 75 ee 41 bd ea
RIP  [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
 RSP <ffff81042643db50>
CR2: 0000000000000040
---[ end trace 778e504de7e3b1e3 ]---
