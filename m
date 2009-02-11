Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZBKIJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZBKIJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBKIJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:09:37 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51307 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBKIJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IgyJ7T/C3f/WVDb6judRv2YCQiznts+ji2Pl5pfvEzxNb12OcWKlM0uv/lImPV0GFK
         jk/G+WCm0zjzp5WvpD6c2wJek94EGJ9G+P2vwVexQQLWtMxC5k7BmlJGTWT9CDa6wYYH
         gg2pB0k/kWatu4QBrLJ0rcmYune/kCpmHIntw=
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 09:09:34 +0100
Message-ID: <19f34abd0902110009g4cdb1754na1cbf0acb6a93cce@mail.gmail.com>
Subject: 2.6.29-rc3: BUG: scheduling while atomic: udevd/917/0x10000100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just got this:

[  774.115554] BUG: scheduling while atomic: udevd/917/0x10000100
[  774.117293] Modules linked in:
[  774.117293] CPU 1:
[  774.117293] Modules linked in:
[  774.117293] Pid: 917, comm: udevd Not tainted 2.6.29-rc3 #223
[  774.117293] RIP: 0010:[<ffffffff811b0eff>]  [<ffffffff811b0eff>]
find_next_bit+0x17/0xa1
[  774.117293] RSP: 0018:ffff88003e40bcd8  EFLAGS: 00000246
[  774.117293] RAX: 0000000000000000 RBX: ffff88003e40bcd8 RCX: 00000000ffffffff
[  774.117293] RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffffffff8181cd80
[  774.117293] RBP: ffffffff8100cf6e R08: 0000000000000040 R09: 0000000000000000
[  774.117293] R10: ffff88003b090000 R11: 000000000000000a R12: ffff88003e5165a0
[  774.117293] R13: 000000000003b08f R14: 0000000100000001 R15: 0000000000000000
[  774.117293] FS:  0000000000000000(0000) GS:ffff88003f156f80(0063)
knlGS:00000000f7f6d700
[  774.117293] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  774.117293] CR2: 0000000008ff28bc CR3: 000000003e407000 CR4: 00000000000006a0
[  774.117293] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  774.117293] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  774.117293] Call Trace:
[  774.117293]  [<ffffffff81108a90>] ? show_stat+0x43e/0x4d6
[  774.117293]  [<ffffffff810d6122>] ? seq_read+0x130/0x31a
[  774.117293]  [<ffffffff81101f40>] ? proc_reg_read+0x80/0x9a
[  774.117293]  [<ffffffff810bf40b>] ? vfs_read+0xad/0x107
[  774.117293]  [<ffffffff810bf533>] ? sys_read+0x4c/0x73
[  774.117293]  [<ffffffff8102d398>] ? sysenter_dispatch+0x7/0x27
[  774.291296] ------------[ cut here ]------------

$ addr2line -e vmlinux -i ffffffff811b0eff ffffffff81108a90
lib/find_next_bit.c:26
fs/proc/stat.c:95


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
