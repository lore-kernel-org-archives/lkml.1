Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZF0LKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZF0LKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZF0LKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:10:25 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:36276
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbZF0LKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:10:24 -0400
Message-Id: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com>
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: BUG: scheduling while atomic
Date: Sat, 27 Jun 2009 13:10:23 +0200
Cc: alan@linux.intel.com
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list, Alan,

I got the same error  with pptpgw as Sergey after switching form  
2.6.30 to recent git (rc1).

[  102.335486] BUG: scheduling while atomic: pptpgw/392/0x00000500
[  102.341528] Modules linked in: emlog nf_nat_irc nf_conntrack_irc  
nf_nat_rtsp nf_conntrack_rtsp
[  102.350242] NIP: c00258d0 LR: c00258c8 CTR: c001cae8
[  102.355240] REGS: c7a75d20 TRAP: 0501   Tainted: G        W    
(2.6.31-rc1)
[  102.362148] MSR: 00009032 <EE,ME,IR,DR>  CR: 24222482  XER: 20000000
[  102.368609] TASK = c7966880[392] 'pptpgw' THREAD: c7a74000
[  102.373949] GPR00: c01c101c c7a75dd0 c7966880 00000001 00190834  
00000000 0014ff97 00000019
[  102.382396] GPR08: 0834548b 00000004 00000004 c7a74000 00190834
[  102.388671] NIP [c00258d0] __tasklet_schedule+0x80/0x90
[  102.393935] LR [c00258c8] __tasklet_schedule+0x78/0x90
[  102.399101] Call Trace:
[  102.401576] [c7a75dd0] [c00258c8] __tasklet_schedule+0x78/0x90  
(unreliable)
[  102.408620] [c7a75de0] [c01c101c] ppp_asynctty_wakeup+0x90/0xbc
[  102.414594] [c7a75e00] [c017037c] tty_wakeup+0x70/0xa0
[  102.419773] [c7a75e10] [c0178cd4] pty_unthrottle+0x24/0x50
[  102.425305] [c7a75e20] [c0175340] tty_unthrottle+0x5c/0x78
[  102.430831] [c7a75e30] [c0172e7c] check_unthrottle+0x1c/0x2c
[  102.436530] [c7a75e40] [c0174a14] n_tty_read+0x3f8/0x65c
[  102.441881] [c7a75ec0] [c0171bf8] tty_read+0xa8/0xe4
[  102.446891] [c7a75ef0] [c0084004] vfs_read+0xb4/0x1c0
[  102.451990] [c7a75f10] [c008438c] sys_read+0x4c/0x90
[  102.457008] [c7a75f40] [c00118a8] ret_from_syscall+0x0/0x38
[  102.462620] --- Exception: c01 at 0xff2d510
[  102.462629]     LR = 0x100032e0
[  102.470004] Instruction dump:
[  102.473004] 60000020 90090040 4182001c 7fe00124 80010014 83e1000c  
38210010 7c0803a6
[  102.480840] 4e800020 4bfff6d5 7fe00124 80010014 <83e1000c> 38210010  
7c0803a6 4e800020

this happens if I put some load on my ADSL line. I already have  
ppp_async.c build with commit

commit a6540f731d506d9e82444cf0020e716613d4c46c
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Jun 22 18:42:29 2009 +0100

     ppp: Fix throttling bugs

So I do not understand why this is still happening here. My call trace  
looks different than the one from Sergey so I do not know if I am  
hitting the same problem.
2.6.30 is rock solid.

Kind regards,
Michael Guntsche
