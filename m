Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYGQMv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYGQMv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYGQMvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:51:20 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:9864 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYGQMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MPdLPpNe3aLFPZvoh2W+8XndStkoWEBoISXzm1UfWuX11GngTNEDudlDkgwOlTyECP
         uBVpZhAFwvZr4lGeKjCoWp8JgAx6KmQ2zmNgP+8b+o0QFJOqpfPraUbQdMyRW54vabvW
         O3wPZB9pgHYKbxgyz8Q8eyXCWwZu9Zs/Ncl8c=
Message-ID: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
Date: Thu, 17 Jul 2008 14:51:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: linux-ext4@vger.kernel.org
Subject: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this with both clean v2.6.26 and latest -git
(33af79d12e0fa25545d49e86afc67ea8ad5f2f40):

BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c01fd1e0>] journal_dirty_metadata+0xa0/0x160
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 4935, comm: rm Not tainted (2.6.26-03414-g33af79d #39)
EIP: 0060:[<c01fd1e0>] EFLAGS: 00210246 CPU: 1
EIP is at journal_dirty_metadata+0xa0/0x160
EAX: 00000000 EBX: cca59160 ECX: 00000001 EDX: f5114000
ESI: 00000000 EDI: f3d27750 EBP: f5115d58 ESP: f5115d40
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rm (pid: 4935, ti=f5114000 task=f6a04fb0 task.ti=f5114000)
Stack: 00000001 f77d0050 cca00c90 f3d27750 f77d0050 f3d27750 f5115d78 c01f9eff
       00000001 00000001 c05c2a53 f3d27750 00000000 f60da560 f5115da8 c01ef9ef
       00000001 00000001 f60da560 f60da800 f3d27750 f3cc5944 f77d0050 f3d27750
Call Trace:
 [<c01f9eff>] ? __ext3_journal_dirty_metadata+0x1f/0x50
 [<c01ef9ef>] ? ext3_free_data+0x9f/0x100
 [<c01efc8b>] ? ext3_free_branches+0x23b/0x250
 [<c01c8cc0>] ? sync_buffer+0x0/0x40
 [<c01efafe>] ? ext3_free_branches+0xae/0x250
 [<c01efafe>] ? ext3_free_branches+0xae/0x250
 [<c01f0268>] ? ext3_truncate+0x5c8/0x940
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01ff1d0>] ? journal_start+0xb0/0x110
 [<c01ff1f3>] ? journal_start+0xd3/0x110
 [<c01ff1d0>] ? journal_start+0xb0/0x110
 [<c01f7cb9>] ? ext3_journal_start_sb+0x29/0x50
 [<c01f06b7>] ? ext3_delete_inode+0xd7/0xe0
 [<c01f05e0>] ? ext3_delete_inode+0x0/0xe0
 [<c01b97c2>] ? generic_delete_inode+0x62/0xe0
 [<c01b995d>] ? generic_drop_inode+0x11d/0x170
 [<c01b8877>] ? iput+0x47/0x50
 [<c01aee4c>] ? do_unlinkat+0xec/0x170
 [<c0293dd8>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0120140>] ? do_page_fault+0x0/0x880
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01af013>] ? sys_unlinkat+0x23/0x50
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: b8 01 00 00 00 e8 f1 57 f3 ff 89 e0 25 00 e0 ff ff f6 40 08 08
74 05 e8 2f e6 3a 00 83 c4 0c 31 c0 5b 5e 5f 5d c3 90 8d 74 26 00 <8b>
46 0c 85 c0 0f 84 8c 00 00 00 39 5e 18 74 68 8d 47 02 89 45
EIP: [<c01fd1e0>] journal_dirty_metadata+0xa0/0x160 SS:ESP 0068:f5115d40
---[ end trace ad9c7bca1cad9e55 ]---

This corresponds to "jh" being NULL in journal_dirty_metadata():

        if (jh->b_modified == 0) {

I also tried with this patch, but without success:

    http://folk.uio.no/vegardno/linux/jbd-transaction.patch

so the problem seems quite reproducible by intentionally corrupting a
disk image.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
