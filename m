Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZAOJtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZAOJtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZAOJtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:49:02 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:41698 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZAOJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kJ9+JqsmGRq13ALfYuc9ik78hdACtx+DeOi4J0xZFCrBJKkDr0EjzQOP4Ohfk6RJ3N
         eAi3HOwdHUK+6gciYhCCWK8Vn+EzYKabUx0g6J8xTKzpkEGeKQIQ4JlzyTqXyrzJk506
         RMCvlYj20mu8+og0z2aGQHGGY/4kXCseZa2wQ=
MIME-Version: 1.0
Date: Thu, 15 Jan 2009 09:48:55 +0000
Message-ID: <8b67d60901150148k1a7a5f63u2f01d9b0a0650aa1@mail.gmail.com>
Subject: pipe_read oops
From: Adrian McMenamin <lkmladrian@gmail.com>
To: linux-sh <linux-sh@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone else seen this? I haven't had time to investigate it - from a
pre 2.6.29-rc1 kernel (on my topic branch - but can see no signs of my
code being involved).

Unfortunately I was testing this to see if my code worked with out
memory allocation debugging on, so quite a lot of debugging stuff
switched off.

Will investigate further, later.


[   43.495753] Unable to handle kernel NULL pointer dereference at
virtual address 0000000c
[   43.509964] pc = 8c08938a
[   43.512441] *pde = 00000000
[   43.517075] Oops: 0000 [#1]
[   43.519187] Modules linked in:
[   43.522239]
[   43.523861] Pid : 816, Comm:                 rc
[   43.527281] CPU : 0                  Not tainted
(2.6.28-06145-g8874d26 #211)
[   43.527308]
[   43.535560] PC is at pipe_read+0xca/0x3e0
[   43.539685] PR is at pipe_read+0x54/0x3e0
[   43.543805] PC  : 8c08938a SP  : 8c849e60 SR  : 40008000 TEA : 004c8028
[   43.550632] R0  : 55555555 R1  : 00000000 R2  : 00000000 R3  : 8cf3222c
[   43.557460] R4  : 8cf32200 R5  : 8cf3222c R6  : 00000001 R7  : 55555555
[   43.564287] R8  : 8c5286c0 R9  : 8c849ebc R10 : 8c849efc R11 : fffffdee
[   43.571111] R12 : 8cf3222c R13 : 8c080000 R14 : 8cf32200
[   43.576503] MACH: 00000000 MACL: fffffff8 GBR : 296e4440 PR  : 8c089314
[   43.583319]
[   43.583332] Call trace:
[   43.587479] [<8c05eb52>] do_wp_page+0x4d2/0x800
[   43.592155] [<8c08035c>] do_sync_read+0x9c/0x100
[   43.596823] [<8c080000>] wait_on_retry_sync_kiocb+0x0/0xc0
[   43.602587] [<8c031800>] autoremove_wake_function+0x0/0x40
[   43.608141] [<8c2499e8>] preempt_schedule+0x28/0x60
[   43.613164] [<8c249360>] __sched_text_start+0x0/0x560
[   43.618380] [<8c080c1e>] vfs_read+0x7e/0x160
[   43.622862] [<8c08119a>] sys_read+0x3a/0x80
[   43.627182] [<8c008236>] syscall_call+0xc/0x10
[   43.631663] [<8c081160>] sys_read+0x0/0x80
[   43.635965]
[   43.637401] Process: rc (pid: 816, stack limit = 8c848001)
[   43.643148] Stack: (0x8c849e60 to 0x8c84a000)
[   43.647632] 9e60: 8cf3222c 8c52872c 8c849f40 55555555 8c8f0480
00000000 00000000 00000080
[   43.656075] 9e80: 55555555 00000000 8c05eb52 8c87d0a8 8c08035c
8c849f40 8c080000 8c8f0480
[   43.664698] 9ea0: fffffdee 8c849efc 8c849ebc 00000000 00000000
00000000 8c849f7c 8c84a004
[   43.673142] 9ec0: 8c8af3c0 00000000 00000001 ffffffff 8c8f0480
00000000 00000000 00000000
[   43.681764] 9ee0: 00000000 8cc1a080 00000000 00000000 8c8af380
8cc1a080 8c031800 8c849efc
[   43.690208] 9f00: 8c849efc 00000000 00000000 8cc1a250 8cc1a24c
8cc1a1d4 8cc1a0fc 00000080
[   43.698830] 9f20: 8c2499e8 8c849f40 00000638 00000000 00000000
00000000 8c249360 10000000
[   43.707274] 9f40: 7ba70cb4 00000080 8c080c1e 7ba70c84 00000638
fffffff7 8c849f7c 7ba70cb4
[   43.715897] 9f60: 00000080 8c8f0480 8c08119a 00000080 7ba70cb4
8c8f0480 8c849f48 00000000
[   43.724340] 9f80: 00000000 00000000 8c008236 00000000 00000000
00000071 0000007f 8c081160
[   43.732963] 9fa0: 00000000 00000440 7ba70d3c 00000003 00000003
7ba70cb4 00000080 00000118
[   43.741406] 9fc0: 00000000 00000080 7ba70cb4 00000003 00000000
00000638 7ba70c84 7ba70c84
[   43.750029] 9fe0: 29675174 00457bf2 00008001 296e4440 00000000
000003c0 0000004c 00000160
[   43.766583] ---[ end trace 42b96aa1b3d1820b ]---
