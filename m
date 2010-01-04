Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518Ab0ADPrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0ADPrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0ADPrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:47:47 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:41908 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0ADPrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:47:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=n3liiHsGbrBx4nNmX7mjZ0UB8JVCy9RSmmILoUAF2J0RhB+kJ2ijaxCNvV6aowAQyC
         49z73fSwyMbhtP6buOatitjxEPQjNVpXe6eDIEgmebj5XNMLQGHnJUWlWthkwsmb1mkA
         ECzAlFxs1dyCtBq5famdbH7rwb2h1+cVvnkIY=
MIME-Version: 1.0
Date: Mon, 4 Jan 2010 16:47:44 +0100
Message-ID: <c4e36d111001040747n2c9dbd52p1b9147ae186f3597@mail.gmail.com>
Subject: Oops in uart_resume_port() on resume 2.6.32/33-rc
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dsaxena@laptop.org, alan@linux.intel.com, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I wanted to trace some oops from i915 module via serial console log
and instead I'm getting this oops from resume:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
IP: [<ffffffff812eee55>] uart_resume_port+0x1f5/0x270
PGD 1396b6067 PUD 13baf4067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/power/state
CPU 1
Pid: 1909, comm: pm-suspend Not tainted 2.6.33-rc2-00269-g04ca05b #48
6464CTO/6464CTO
RIP: 0010:[<ffffffff812eee55>]  [<ffffffff812eee55>]
uart_resume_port+0x1f5/0x270
RSP: 0000:ffff880139df7c98  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8248db80 RCX: 0000000000000000
RDX: ffffffff81866c00 RSI: ffffffff8140a713 RDI: ffff880139df7cc0
RBP: ffff880139df7cf8 R08: 0000000000000000 R09: 0000000000000000
R10: 2222222222222222 R11: 2222222222222222 R12: ffff880138968000
R13: ffff880138968150 R14: ffff880139df7c98 R15: ffff88013896dc70
FS:  00007fc83fe3d700(0000) GS:ffff88002c000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000198 CR3: 000000013bf1c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pm-suspend (pid: 1909, threadinfo ffff880139df6000, task
ffff880138a28000)
Stack:
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
<0> 0000000000000000 ffff880100000000 ffffffff8248db80 ffffffff81866c60
<0> 0000000000000000 ffffffff8248db80 ffff88013896dc10 ffffffff8163f620
Call Trace:
 [<ffffffff812f06e6>] serial8250_resume_port+0x86/0xa0
 [<ffffffff812f0758>] serial8250_resume+0x58/0x60
 [<ffffffff812f9974>] platform_legacy_resume+0x24/0x40
 [<ffffffff812f9acd>] platform_pm_resume+0x3d/0x50
 [<ffffffff812fcf63>] pm_op+0xf3/0x1b0
 [<ffffffff812fd779>] dpm_resume_end+0x129/0x430
 [<ffffffff81092ae4>] suspend_devices_and_enter+0x124/0x1a0
 [<ffffffff81092c3a>] enter_state+0xda/0xf0
 [<ffffffff810922f9>] state_store+0x99/0x100
 [<ffffffff81244237>] kobj_attr_store+0x17/0x20
 [<ffffffff81185fb6>] sysfs_write_file+0xe6/0x170
 [<ffffffff811222d8>] vfs_write+0xb8/0x1a0
 [<ffffffff81122d31>] sys_write+0x51/0x90
 [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b
Code: 84 00 00 00 00 00 31 c0 4c 8d 75 a0 b9 05 00 00 00 4c 89 f7 f3
48 ab c7 07 00 00 00 00 8b 42 44 89 45 a8 85 c0 75 5f 49 8b 04 24 <48>
8b 80 98 01 00 00 48 8b 10 48 89 55 a0 48 8b 50 08 48 89 55
RIP  [<ffffffff812eee55>] uart_resume_port+0x1f5/0x270
 RSP <ffff880139df7c98>
CR2: 0000000000000198
---[ end trace 95c3962d37751a5e ]---


>From my debugger it looks like this:

0000000000003697 <uart_resume_port+0x1e7> mov    0x44(%rdx),%eax
000000000000369a <uart_resume_port+0x1ea> mov    %eax,-0x58(%rbp)
		/*
		 * If that's unset, use the tty termios setting.
		 */
		if (termios.c_cflag == 0)
000000000000369d <uart_resume_port+0x1ed> test   %eax,%eax
000000000000369f <uart_resume_port+0x1ef> jne    0000000000003700
<uart_resume_port+0x250>
			termios = *state->port.tty->termios;
00000000000036a1 <uart_resume_port+0x1f1> mov    (%r12),%rax
00000000000036a5 <uart_resume_port+0x1f5> mov    0x198(%rax),%rax
00000000000036ac <uart_resume_port+0x1fc> mov    (%rax),%rdx
00000000000036af <uart_resume_port+0x1ff> mov    %rdx,-0x60(%rbp)
00000000000036b3 <uart_resume_port+0x203> mov    0x8(%rax),%rdx

So I assume it is related to commit:

ba15ab0e8de0d4439a91342ad52d55ca9e313f3d

which adds access through  *state->port.tty->termios  without checking for NULL.

I'm using T61, 4GB and boot options:  console=ttyS0,115200n8 console=tty

Zdenek
