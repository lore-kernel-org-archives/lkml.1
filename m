Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYHZXXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYHZXXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYHZXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:23:41 -0400
Received: from quackingmoose.com ([63.73.180.143]:49180 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824AbYHZXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:23:40 -0400
Date: Tue, 26 Aug 2008 15:59:19 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: mpm@selenic.com, LKML <linux-kernel@vger.kernel.org>
Subject: drivers/char/random.c line 728 BUG
Message-ID: <20080826225918.GC5452@merfinllc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We saw this oops.  Kernel is vanilla 2.6.26.2.  Machine is Dell
PowerEdge 1750.

I saw one other instance mentioned on kerneloops but the link didn't
seem to go to the proper place.

Let me know if you need more information.

					Thanks,
					=a=

------------[ cut here ]------------
kernel BUG at drivers/char/random.c:728!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: nfs lockd autofs4 sunrpc firmware_class ohci_hcd usbcore tg3 [last unloaded: x_tables]

Pid: 31251, comm: python Not tainted (2.6.26.2-asb #18)
EIP: 0060:[<c0219cd7>] EFLAGS: 00010206 CPU: 1
EIP is at account+0x1f/0xca
EAX: 00000400 EBX: c03c2f98 ECX: 00000000 EDX: 00001000
ESI: c03c2f98 EDI: 00001000 EBP: 00000000 ESP: f6b8ff38
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process python (pid: 31251, ti=f6b8e000 task=f790c6c0 task.ti=f6b8e000)
Stack: 3e2efd76 00000000 1ff38c67 32a39c7a 00001000 c03c2f98 c021a215 b76a6000 
       c021a183 00000000 00000001 b76a6000 c014f8ed 00000000 f71e7a80 b76a6000 
       c021a215 00001000 c015d9e3 f6b8ffa0 f71e7a80 fffffff7 00000000 f6b8e000 
Call Trace:
 [<c021a215>] urandom_read+0x0/0xa
 [<c021a183>] extract_entropy_user+0x21/0xb3
 [<c014f8ed>] do_mmap_pgoff+0x1e7/0x232
 [<c021a215>] urandom_read+0x0/0xa
 [<c015d9e3>] vfs_read+0x81/0xf4
 [<c015dd96>] sys_read+0x3c/0x63
 [<c0102bf1>] sysenter_past_esp+0x6a/0x91
 [<c0300000>] native_cpu_up+0x2ee/0x63d
 =======================
Code: 5f 5d e9 b5 a3 0e 00 5b 5e 5f 5d c3 55 57 56 53 83 ec 10 89 c3 89 d7 89 4c 24 04 8b 6c 24 24 8b 00 8b 00 c1 e0 05 39 43 1c 7e 04 <0f> 0b eb fe 8d 43 14 89 44 24 08 e8 39 a1 0e 00 89 44 24 0c 8b 
EIP: [<c0219cd7>] account+0x1f/0xca SS:ESP 0068:f6b8ff38
---[ end trace 275ff84df4f1fc30 ]---

-- 
===================
Aaron Straus
aaron@merfinllc.com
