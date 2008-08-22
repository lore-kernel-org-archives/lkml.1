Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYHVTZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYHVTZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYHVTYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:24:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:8515 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYHVTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NPhgdonqNVjEsN+KrwCOipcq0zV0sj93jBW6/DxhQ4Sahtfg+64MhECZ7wSyIA0EMa
         MoKMHz6Mqtw4oZmpnEqyrzOk0JdAhmnhl+hFQaxqHVLmfYFu7LeCpZn3fvwxoaKc0mNM
         QCDapJ1+AsbmHU0eahVKptkUSn2Ek65Xi8MTQ=
Message-ID: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
Date: Fri, 22 Aug 2008 21:24:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was trying out

commit 9a2d43b7566caeeeb414aa628bc2759028897dbb
Date:   Tue Jul 15 21:21:43 2008 +0200

..as part of the debugging of a different issue, but I got this:

__alloc_bootmem_core(): zero-sized request
------------[ cut here ]------------
kernel BUG at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/mm/bootmem.c:247!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 0, comm: swapper Not tainted (2.6.26-00014-g9a2d43b #34)
EIP: 0060:[<c082be18>] EFLAGS: 00010286 CPU: 0
EIP is at __alloc_bootmem_core+0x28/0x300
EAX: 0000002e EBX: 00000080 ECX: c080e000 EDX: 00000002
ESI: 01000000 EDI: 01000000 EBP: c080ff44 ESP: c080ff00
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c080e000 task=c078d400 task.ti=c080e000)
Stack: c0716894 c080ff14 c0636753 0000230d 00000080 00000000 c08c2fa0 00000096
       ffffdcf3 34791ce0 00000217 c080ffac c0136894 c080ffac 00000080 00000000
       01000000 c080ff60 c082c28c 01000000 00000000 00000000 00000400 00000000
Call Trace:
 [<c0636753>] ? _spin_unlock_irqrestore+0x43/0x70
 [<c0136894>] ? vprintk+0x1c4/0x420
 [<c082c28c>] ? __alloc_bootmem_node+0x2c/0x50
 [<c082d370>] ? alloc_large_system_hash+0x1e0/0x2d0
 [<c03704f2>] ? dotest+0x382/0x400
 [<c082e40c>] ? vfs_caches_init_early+0x5c/0xb0
 [<c08159f0>] ? start_kernel+0x250/0x390
 [<c0815180>] ? unknown_bootoption+0x0/0x210
 [<c0815008>] ? __init_begin+0x8/0x10
 =======================
Code: 00 00 00 55 89 e5 57 56 53 83 ec 38 85 d2 8b 75 08 89 4d cc 8b
4d 0c 89 45 d4 89 55 d0 75 14 c7 04 24 94 68 71 c0 e8 d8 ac 90 ff <0f>
0b eb fe 8d 74 26 00 8b 7d cc 83 ef 01 85 7d cc 75 16 8b 55
EIP: [<c082be18>] __alloc_bootmem_core+0x28/0x300 SS:ESP 0068:c080ff00
---[ end trace 4eaa2a86a8e2da22 ]---

I saw some bootmem errata lately, can I cherry-pick anything to fix this?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
