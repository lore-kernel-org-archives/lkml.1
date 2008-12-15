Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYLOVhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYLOVhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbYLOVhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:37:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:56295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYLOVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:37:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KipJknCr93JDUb9ZCn4FYJybyR700pJp47pG4YhLlWxLPp/G0Utv/W3DZt5dYQVvAz
         6AV/Xe2J3rp/CPPzWh6bQhjdiukxV1nB8NHKfenktfTtLt/AE4uXHxQHt1MkE3TKMJTw
         YcTwE1Rs6cK/gHMGKCLDpS4M7XnMA3Wv3WXiI=
Message-ID: <84144f020812151337r79268169xf77f2e6f547a51e5@mail.gmail.com>
Date: Mon, 15 Dec 2008 23:37:38 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ottavio Campana" <ottavio.campana@dei.unipd.it>
Subject: Re: Oops when trying to create more than 16000 timers
Cc: linux-kernel@vger.kernel.org, error27@gmail.com,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <4946CEF1.6060405@dei.unipd.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49468024.1020700@dei.unipd.it>
	 <84144f020812150845g10a1ce26ke2844ab495d2591b@mail.gmail.com>
	 <4946CEF1.6060405@dei.unipd.it>
X-Google-Sender-Auth: abec0600ae4e8432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ottavio,

On Mon, Dec 15, 2008 at 11:41 PM, Ottavio Campana
<ottavio.campana@dei.unipd.it> wrote:
>>> I am currently developing a software that needs approx 60k timers. I
>>> currently use timer_create and all the relative functions to manage timers.
>>>
>>> I've noticed that after having created 16039 timers I always get an oops
>>> from the kernel, which are always of the same kind:
>>>
>>> Dec 15 15:20:00 evolution kernel: [601680.417064] BUG: unable to handle
>>> kernel NULL pointer dereference at 0000000000000040 .
>>
>> This would be a kernel bug so can you please post the full oops. See
>> REPORTING-BUGS and Documentation/oops-tracing.txt for details.
>
> I hope the report is correct, please tell me if you want me to do
> something else.
>
> RIP: 0010:[<ffffffff80245291>]  [<ffffffff80245291>]
> sys_timer_create+0x79/0x360
> RSP: 0018:ffff81007a5ddef8  EFLAGS: 00010286
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000086
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000286
> RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
> R10: 00007f927adb3a50 R11: 0000000000000000 R12: 00000000016ed768
> R13: 00000000016ed6d0 R14: 00007fff833dead0 R15: 00000000016ed754
> FS:  00007f927b3cd6e0(0000) GS:ffff81007d37a9c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000040 CR3: 000000007b00c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process timer_tester (pid: 2743, threadinfo ffff81007a5dc000, task
> ffff81007a7936b0)
> Stack:  ffff81007646f9f8 0000000000000000 0000000000000000 ffffffff8029b4ed
>  0000000000000000 ffff81007b024c80 0000000000000017 fffffffffffffff7
>  00007f927b3da000 ffffffff8029ba36 0000000000000292 0000000000000000
> Call Trace:
>  [<ffffffff8029b4ed>] vfs_write+0x121/0x156
>  [<ffffffff8029ba36>] sys_write+0x60/0x6e
>  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
>
>
> Code: c6 0e 05 00 48 85 c0 74 3b 48 89 c5 e8 d0 a0 ff ff 48 85 c0 48 89
> 45 40 75 11 48 8b 3d e1 22 3e 00 48 89 ee 31 ed e8 fe 10 05 00 <48> 8b
> 7d 40 31 f6 ba 80 00 00 00 48 83 c7 18 e8 6b ae 0d 00 48
> RIP  [<ffffffff80245291>] sys_timer_create+0x79/0x360
>  RSP <ffff81007a5ddef8>
> CR2: 0000000000000040
>  ---[ end trace 2e93d77cdbbd83c6 ]---
>
> Using decodecode
>
> Code: c6 0e 05 00 48 85 c0 74 3b 48 89 c5 e8 d0 a0 ff ff 48 85 c0 48 89
> 45 40 75 11 48 8b 3d e1 22 3e 00 48 89 ee 31 ed e8 fe 10 05 00 <48> 8b
> 7d 40 31 f6 ba 80 00 00 00 48 83 c7 18 e8 6b ae 0d 00 48
>
> /tmp/tmp.CcCjFxHOMN.o:     file format elf64-x86-64
>
> Disassembly of section .text:
>
> 0000000000000000 <.text>:
>   0:   c6                      (bad)
>   1:   0e                      (bad)
>   2:   05 00 48 85 c0          add    $0xc0854800,%eax
>   7:   74 3b                   je     0x44
>   9:   48 89 c5                mov    %rax,%rbp
>   c:   e8 d0 a0 ff ff          callq  0xffffffffffffa0e1
>  11:   48 85 c0                test   %rax,%rax
>  14:   48 89 45 40             mov    %rax,0x40(%rbp)
>  18:   75 11                   jne    0x2b
>  1a:   48 8b 3d e1 22 3e 00    mov    0x3e22e1(%rip),%rdi        # 0x3e2302
>  21:   48 89 ee                mov    %rbp,%rsi
>  24:   31 ed                   xor    %ebp,%ebp
>  26:   e8 fe 10 05 00          callq  0x51129
>
> /tmp/tmp.CcCjFxHOMN.o:     file format elf64-x86-64
>
> Disassembly of section .text:
>
> 0000000000000000 <.text>:
>   0:   48 8b 7d 40             mov    0x40(%rbp),%rdi
>   4:   31 f6                   xor    %esi,%esi
>   6:   ba 80 00 00 00          mov    $0x80,%edx
>   b:   48 83 c7 18             add    $0x18,%rdi
>   f:   e8 6b ae 0d 00          callq  0xdae7f
>  14:   48                      rex.W

I think you're simply hitting RLIMIT_SIGPENDING and then tripping over
a bug in alloc_posix_timer() that's fixed by commit
aa94fbd5ccd840c8ab26d02439ec799b03a72547 ("fix error-path NULL deref
in alloc_posix_timer()") in 2.6.28-rc8.

Dan, can you please send your patch to the -stable queue as well?

                        Pekka
