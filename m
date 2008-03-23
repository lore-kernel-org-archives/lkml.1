Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYCWQUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYCWQUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 12:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYCWQUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 12:20:00 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:37818 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYCWQUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:20:00 -0400
Date: Sun, 23 Mar 2008 17:19:50 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc6: BUG: soft lockup - CPU#0 stuck for 61s!
Message-ID: <alpine.DEB.1.00.0803231647570.13579@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems that I have bad luck with 2.6.25 - one problem down, another one 
is coming up :-\

The box was running 2.6.25-rc6 (+ two patches: [0]+[1]) for a few hours. I 
was trying to generate some more load on the box and startet "make -j16" 
on a kernel tree - something must have gone wrong, because when I woke up, 
the box hung, answering to SYSRQ though - but nothing got written to the 
disks any more.

While I've seen a lot of "CPU# ...stuck for ..s!" on the net, the 
backtrace of this one looks a bit different. Here's what I typed off the 
console:

Bus soft lockup - CPU#0 stuck for 61s! [bash: 1115]
PID: 1115 comm: bash  Tainted: G      D
EIP: 0060:[<c0107858>] EFLAGS: 0000 0246 CPU: 0
EIP is at native_read_tsc+0xb/0x10
EAX: 3300 6182 EBX: 3300 6177 ECX: 0000 0000 EDX: 0000 72a8
ESI: 0000 0001 EDI: 0000 0000 EBP: 721f 5e60 ESP: f5ab 7f24
  DS: 007b  ES: 007b  FS: 0000   GS: 0023  SS: 0068
CR0: 8005 0038 CR2: b7d9 4050 CR3: 14b2 1000
CR4: 0000 0650
DR0: 0000 0000 DR1: 0000 0000 DR2: 0000 0000 DR3: 0000 0000
DR6: fff0 ff0? DR7: 0000 6400
[<c02c99c6 ? delay_tsc+0x0/0x20               *
[<c02c9a09 ? delay+0x6/0x10
[<c02d73d6 ? _raw_spin_lock+0xc6/0x150
[<c017b104 ? _new_inode+0x24/0x70
[<c016dee2 ? create_write_pipe+0x42/0x100
[<c016e9aa ? do_pipe+0x1a/0xc0
[<c0106822 ? sys_pipe+0x12/0x40
[<c0102e29 ? sysenter_past_esp+0x9a/0xa5      #
[<c0102dee ? sysenter_past_esp+0x5f/0xa5      #

The backtrace was printed out again, every minuted or so: the line marked 
with '*' where sometimes printed, sometimes not.

I am not sure about the last two lines (marked with '#') - I'm sure about 
the address, but not about the names any more :(

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/17/214
[1] http://lkml.org/lkml/2008/3/22/8
-- 
BOFH excuse #219:

Recursivity.  Call back if it happens again.
