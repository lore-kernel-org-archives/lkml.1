Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbXEPNQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbXEPNQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXEPNQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:16:01 -0400
Received: from gherkin.frus.com ([192.158.254.49]:55058 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXEPNQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:16:00 -0400
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <Pine.LNX.4.61.0705160903130.9570@yvahk01.tjqt.qr>
 "from Jan Engelhardt at May 16, 2007 09:03:43 am"
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Wed, 16 May 2007 08:15:58 -0500 (CDT)
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070516131558.E15BFDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> >On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:
> >
> >> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.
> 
> In short, boot with vga=6 (80x50), or even vga=ask, selecting something with
> lots of chars (132x60 for example)

That did it...

(...)
CPU: L1 I Cache: (...)
CPU: L2 Cache: (...)
Intel machine check architecture supported.
general protection fault: 0000 [#1]
PREEMPT
Modules linked in:
CPU:   0
EIP: 0060:[<c01079f4>]  Not tainted VLI
EFLAGS: 00010286   (2.6.22-rc1 #1)
EIP is at amd_mcheck_init+0x2b/0xc3
eax: 0000002f  ebx: 00000000  ecx: 00000179  edx: 00000001
esi: 000a0b00  edi: c03c1000  ebp: 00843007  esp: c03c7fb0
ds:007b  es:007b  fs:0000  gs:0000  ss:0068
Process swapper (pid:0, ti=c03c6000 task=c0399a20 task.ti=c03c6000)
Stack: c03569fc 00000000 00843007 c0189398 ffffffff 00000000 000a0600 c03cb34f
       00000002 c03a2b40 00000000 c03cb79c 00040000 00000000 00000000 c03c8842
       00000054 c03c8388 c03dfb40 00000000
Call Trace:
 [<c0189398>] proc_register+0x3b/0xb7
 [<c03cb34f>] identify_boot_cpu+0xd/0x1f
 [<c03cb79c>] check_bugs+0x8/0x4e
 [<c03c8842>] start_kernel+0x19a/0x1a3
 [<c03c8388>] unknown_bootoption+0x0/0x191
==========================================
Code: 56 53 83 ec 14 c7 05 08 f1 39 c0 3c 78 10 c0 8b 40 0c a8 80 0f 84 a0 00 00 00 c7 04 24 fc 69 35 c0 e8 79 f3 00 00 b9 79 01 00 00 <0f> 32 f6 c4 01 89 c3 74 0a b1 7b 83 c8 ff 83 ca ff 0f 30 0f b6
EIP:[<c01079f4>] amd_mcheck_init+0x2b/0xc3 SS:ESP 0068:c03c7fb0
Kernel panic - not syncing: Attempted to kill the idle task!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
