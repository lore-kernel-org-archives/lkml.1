Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbXKBMgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbXKBMgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXKBMgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:36:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:37681 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753552AbXKBMgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:36:07 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19BnGdGI4RBLB5qdtZ0Me+zszGJNiVfvdHy6B3XhW
	Dy4JsftgyWwppe
Date: Fri, 2 Nov 2007 13:36:03 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: oops in enqueue_entity with 2.6.24-rc1-g54866f03
Message-ID: <20071102123603.GA4988@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.24-rc1 (x86_64)
X-Uptime: 13:19:42 up  2:30,  6 users,  load average: 0.23, 0.20, 0.56
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I get the following crash with 2.6.24-rc1-g54866f03, the last version I
tested which booted fine was 2.6.24-rc1-gb1d08ac0

Netconsole was active, so i took a picture:
http://www.cccmz.de/~snakebyte/pdrm2410.jpg

Here is the message typed:

BUG: unable to handle kernel paging request at virtual address f00ef97
printing eip: c0118042 *pde = 0000000
Oops: 0000 [#1] PREEMPT
Modules linked in:

Pid: 0, comm: Not tainted (2.6.24-rc1-g54866f03 #4)
EIP: 0060:[<c0118042>] EFLAGS: 00010086 CPU: 0
EIP is at update_curr+0x12/0x100
EAX: f000ef6f EBC: 00000000 ECX: 00000000 EDX: c1431580
ESI: f000ef6f EDI: c1431580 EBP: c0814ec8 ESP: c0814ea0
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process (pid: 0, ti=c0814000, task=c07d03a0 task,ti=c0814000)
Stack: f000ef6f c080fa00 00000000 00000001 00000000 42549096 00000007
00000000
...
Call Trace: 
 [<c01049fa>] show_trace_log_lvl+0x1a/0x30
 [<c0104ab9>] show_stack_log_lvl+0xa9/0xd0
 [<c0104baa>] show_registers+0xca/0x250
 [<c0104e31>] die+0x101/0x220
 [<c011631b>] do_page_fault+0x27b/0x610
 [<c065d752>] error_code+0x6a/0x70
 [<c011833c>] enqueue_entity+0x1c/0x60
 [<c011839a>] enqueue_task_fair+0x1a/0x30
 [<c0117865>] enqueue_task+0x27/0x30
 [<c01178d7>] activate_task+0x27/0x40
 [<c011b6ec>] wake_up_new_task+0x4c/0x80
 [<c011dcd7>] do_fork+0x147/0x250
 [<c0102596>] kernel_thread+0x86/0xa0
 [<c065a714>] rest_inix+0x14/0x60
 [<c0815b75>] start_kernel+0x235/0x2c0
 [<00000000>] 0x0
 ================
Code: 00 80 00 00 8d 14 16 83 d2 00 0f ac d0 10 c1 ea 10 eb 96 8d
b6 00 00 00 00 55 89 e5 83 ec 28 89 5d f4 89 75 f8 89 7d ...


System is a Pentium 3, gcc is version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)

Greetings, Eric
