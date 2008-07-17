Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbYGQSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbYGQSf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbYGQSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:35:18 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:44522 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbYGQSfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BYKRyRjE+xMVYjtMRCV0icgkc61yM+z45/Fb0MpklpbZEIDFTXeaT524KGKyRJ8bBJ
         EHroAVicViXA2MZfJmUlD0T37zwAYBQLOMBOvdPDPOitcJWKnvnnSa3g/GUj+bwWY+M5
         67KTiH/3IZL+LyyXo+QEiLj2GM39xNEw+bAew=
Message-ID: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
Date: Thu, 17 Jul 2008 20:35:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net
Subject: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this on latest -git with an intentionally corrupted filesystem image:

BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
------------[ cut here ]------------
kernel BUG at fs/jfs/namei.c:512!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 4408, comm: rm Not tainted (2.6.26-03414-g33af79d #43)
EIP: 0060:[<c02df988>] EFLAGS: 00210286 CPU: 1
EIP is at jfs_unlink+0x418/0x430
EAX: 00000031 EBX: 00000000 ECX: f2d16000 EDX: 00000000
ESI: 0000004c EDI: f43b12dc EBP: f2d17f20 ESP: f2d17ed0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rm (pid: 4408, ti=f2d16000 task=f4b73fc0 task.ti=f2d16000)
Stack: c086269e c08626ce 00000200 c0862725 00000000 00000002 f43ba83c f43b10c8
       f43ba628 f43b108c f43b1008 f43ba568 f43ba83c f43b12dc 0000000a f6d33500
       0000005b 00000000 f43ba83c f4281c30 f2d17f3c c01ad04b c1fb0480 f2d17f3c
Call Trace:
 [<c01ad04b>] ? vfs_unlink+0xab/0x100
 [<c01af22b>] ? do_unlinkat+0x15b/0x170
 [<c01b185b>] ? vfs_readdir+0x6b/0xa0
 [<c01b1540>] ? filldir64+0x0/0xf0
 [<c044a0f8>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01af383>] ? sys_unlinkat+0x23/0x50
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: 5f 48 00 0f 0b eb fe c7 44 24 0c 25 27 86 c0 c7 44 24 08 00 02
00 00 c7 44 24 04 ce 26 86 c0 c7 04 24 9e 26 86 c0 e8 dc 5e 48 00 <0f>
0b eb fe ba 01 00 00 00 89 f0 e8 08 d5 01 00 e9 f2 fc ff ff
EIP: [<c02df988>] jfs_unlink+0x418/0x430 SS:ESP 0068:f2d17ed0
Kernel panic - not syncing: Fatal exception

Full log at http://folk.uio.no/vegardno/linux/log-1216318656.txt, but
I think the preceding messages are just left-overs from previous
mount/remount attempts. I can test patches.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
