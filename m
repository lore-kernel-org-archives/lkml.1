Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZA2NR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZA2NR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZA2NRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:17:51 -0500
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:45429
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZA2NRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:17:49 -0500
Date: Thu, 29 Jan 2009 14:17:45 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.29-rc3: bad PC value
Message-ID: <20090129131745.GJ9390@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	rostedt@goodmis.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run a 2.6.29-rc3 kernel on an ep9301 (ARM) platform. After
activating the option CONFIG_FUNCTION_TRACER, the kernel generates the
following Oops:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c5790000
[00000000] *pgd=0576f031, *pte=00000000, *ppte=00000000
Internal error: Oops: 0 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.29-rc3 #3)
PC is at 0x0
LR is at 0x4000d018
pc : [<00000000>]    lr : [<4000d018>]    psr: 60000013
sp : c5415be8  ip : 4000d008  fp : c5415c04
r10: 00000204  r9 : 00000000  r8 : c5780518
r7 : 00000000  r6 : c02eabdc  r5 : 04492000  r4 : c4454000
r3 : 4000d024  r2 : 00000000  r1 : c4494000  r0 : c4456000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0000717f  Table: 05790000  DAC: 00000015
Process init (pid: 1, stack limit = 0xc5414268)
Stack: (0xc5415be8 to 0xc5416000)
5be0:                   00000000 c5790000 00000001 c037fa80 c5415c54 c5415c08
5c00: c008f04c c002e98c 0007a000 c578dde0 00000001 c578dde0 00000001 0000006a
5c20: 0007a000 c0380240 c5415c54 c576f800 c576f9e8 c5412bc0 00000000 c5780518
5c40: 00000000 0007a000 c5415cb4 c5415c58 c0090388 c008ef34 0000006a 00000001
5c60: 00000000 c5415c70 c007f9f8 0000007a c5790000 00000800 c578dde0 000001e8
5c80: c5790000 c5415c90 c012fd98 00000000 0007a000 c5412bc0 c5780518 c578de14
5ca0: c578dde0 c5415dd0 c5415cfc c5415cb8 c021fb5c c0090100 0000006a 00000000
5cc0: c02bf5c4 00000800 00000805 0007aa99 c578056c c02a7f10 c5415e04 c02a7f60
5ce0: 00000805 c5415dd0 80000013 0007aa99 c5415d1c c5415d00 c021fcbc c021fa10
5d00: c02a7f10 c5415e04 c02a7f60 00000805 c5415dcc c5415d20 c0025268 c021fcb4
5d20: c5780584 08101877 c5780518 c578dde0 08101877 c56f8da0 00000001 c0093f38
5d40: c5415dac c5415d50 c0096778 c57804c4 c578dde4 c5780530 c0096778 c57804c4
5d60: 00000000 c5780530 c0096778 c009456c c57804c4 00000000 c5415db4 c5415d88
5d80: c0095004 c009456c c57805d8 c5415d98 c00a0f08 c57804c4 c57805d8 c578dde0
5da0: 0007b000 00100077 ffffffff c5415e04 0007aa99 0007a448 00000000 0007bd84
5dc0: c5415e2c c5415dd0 c021dc00 c002523c 0007aa99 00000567 00000000 00000000
5de0: 0007aa99 0007bd84 0007aa99 0007a448 00000000 c5777580 0007bd84 c5415e2c
5e00: 00000001 c5415e18 c00dc2cc c0128624 80000013 ffffffff 00000567 c00dc2cc
5e20: c5415edc c5415e30 c00dce2c c00dc294 00001812 00000000 c5414000 c5415f58
5e40: 00000003 c56f8920 00008000 00000000 00000001 c4034840 c5777480 00000000
5e60: 00000000 00008000 00072448 0007a448 0007aa99 c4017e60 00000003 c5415eb4
5e80: 00000000 00000007 00000001 c5414000 c5415ed4 c5415ea0 c00a9314 c0090a78
5ea0: 00000001 c037f0a0 c026f049 00000000 00000069 00000000 c02b0f80 c5777580
5ec0: c5414000 00000000 c00dc6b0 00000000 c5415f1c c5415ee0 c00a9840 c00dc6c0
5ee0: c4405000 c5415f58 c5777582 fffffffe c5415f58 00000000 c5414000 c5777580
5f00: 00000002 c02a78f8 c5415f58 c02a786c c5415f54 c5415f20 c00aaaa4 c00a9744
5f20: 00003fc0 00000000 00000020 c026f03e c02a78f8 c02a786c c5415f58 00000000
5f40: 00000000 00000000 c5415fbc c5415f58 c0028f70 c00aa8c8 00000000 00000000
5f60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5f80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fa0: c02a78f8 c00203fc 00000000 00000000 c5415fd4 c5415fc0 c002555c c0028f3c
5fc0: c02c0098 c02c0098 c5415ff4 c5415fd8 c000843c c0025474 00000000 00000001
5fe0: 00000000 00000000 00000000 c5415ff8 c00478ec c0008384 e5851004 e585b000
Backtrace:
[<c002e97c>] (v4wb_copy_user_highpage+0x0/0xa4) from [<c008f04c>] (__do_fault+0x128/0x3a4)
 r6:c037fa80 r5:00000001 r4:c5790000
[<c008ef24>] (__do_fault+0x0/0x3a4) from [<c0090388>] (handle_mm_fault+0x298/0x6cc)
[<c00900f0>] (handle_mm_fault+0x0/0x6cc) from [<c021fb5c>] (do_page_fault+0x15c/0x2a4)
[<c021fa00>] (do_page_fault+0x0/0x2a4) from [<c021fcbc>] (do_translation_fault+0x18/0x80)
[<c021f544>] (do_translation_fault+0x0/0x80) from [<c0025268>] (do_DataAbort+0x3c/0x9c)
 r7:00000805 r6:c02a7f60 r5:c5415e04 r4:c02a7f10
[<c002522c>] (do_DataAbort+0x0/0x9c) from [<c021d4a0>] (__dabt_svc+0x40/0x60)
Exception stack(0xc5415dd0 to 0xc5415e18)
5dc0:                                     0007aa99 00000567 00000000 00000000
5de0: 0007aa99 0007bd84 0007aa99 0007a448 00000000 c55d0580 0007bd84 c5415e2c
5e00: 00000001 c5415e18 c00dbb68 c0127ec0 80000013 ffffffff
[<c00dbb20>] (padzero+0x0/0x60) from [<c00dc6c8>] (load_elf_binary+0x77c/0x11c0)
[<c00dbf4c>] (load_elf_binary+0x0/0x11c0) from [<c00a90dc>] (search_binary_handler+0x10c/0x2ec)
[<c00a8fd0>] (search_binary_handler+0x0/0x2ec) from [<c00aa340>] (do_execve+0x1ec/0x2a8)
[<c00aa154>] (do_execve+0x0/0x2a8) from [<c0028f70>] (kernel_execve+0x44/0x8c)
[<c0028f2c>] (kernel_execve+0x0/0x8c) from [<c002555c>] (init_post+0xf8/0x180)
 r7:00000000 r6:00000000 r5:c0020368 r4:c02a78f8
[<c0025464>] (init_post+0x0/0x180) from [<c000843c>] (kernel_init+0xc8/0xf0)
 r4:c02c0058
[<c0008374>] (kernel_init+0x0/0xf0) from [<c00478ec>] (do_exit+0x0/0x764)
 r5:00000000 r4:00000000
Code: bad PC value.
---[ end trace e9ae1364e3c1e622 ]---
note: init[1] exited with preempt_count 2
Kernel panic - not syncing: Attempted to kill init!

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
