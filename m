Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbYBSV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbYBSV6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbYBSV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:58:10 -0500
Received: from mail1.ugh.no ([80.239.42.168]:50232 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304AbYBSV6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:58:08 -0500
Message-ID: <47BB50EB.6040107@tomt.net>
Date: Tue, 19 Feb 2008 22:58:03 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB OOPS 2.6.25-rc2-git1
References: <Pine.LNX.4.44L0.0802191429570.13562-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802191429570.13562-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 19 Feb 2008, Andre Tomt wrote:
> 
>> Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
>> not doing anything interesting at the time, but has its / and kernel on 
>> a usb-storage device (usb pen drive).
>>
>> Intel ICH8R chipset (and USB controller), running x86_64 kernel. I'll 
>> post .config and some additional info when I get home later if it isn't 
>> obvious what broke.
>>
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
>>> IP: [<ffffffff88063d11>] :ehci_hcd:end_unlink_async+0x17/0xfa
> 
> Can you provide some sort of disassembly listing of end_unlink_async, 
> to determine which C statement contained the NULL pointer dereference?

Here you go:
> atomt@pelle:~/work/pkg-linux/linux-2.6.25$ gdb /lib/modules/2.6.25-rc2-git1/kernel/drivers/usb/host/ehci-hcd.ko
> GNU gdb 6.7.1-debian
> Copyright (C) 2007 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu"...
> (no debugging symbols found)
> Using host libthread_db library "/lib/libthread_db.so.1".
> (gdb) disassemble end_unlink_async
> Dump of assembler code for function end_unlink_async:
> 0x0000000000000d1e <end_unlink_async+0>:        push   %r12
> 0x0000000000000d20 <end_unlink_async+2>:        push   %rbp
> 0x0000000000000d21 <end_unlink_async+3>:        mov    %rdi,%rbp
> 0x0000000000000d24 <end_unlink_async+6>:        push   %rbx
> 0x0000000000000d25 <end_unlink_async+7>:        mov    0x28(%rdi),%rbx
> 0x0000000000000d29 <end_unlink_async+11>:       lea    0x110(%rdi),%rdi
> 0x0000000000000d30 <end_unlink_async+18>:       callq  0xd35 <end_unlink_async+23>
> 0x0000000000000d35 <end_unlink_async+23>:       mov    0x80(%rbx),%eax
> 0x0000000000000d3b <end_unlink_async+29>:       movb   $0x3,0x88(%rbx)
> 0x0000000000000d42 <end_unlink_async+36>:       movq   $0x0,0x50(%rbx)
> 0x0000000000000d4a <end_unlink_async+44>:       dec    %eax
> 0x0000000000000d4c <end_unlink_async+46>:       test   %eax,%eax
> 0x0000000000000d4e <end_unlink_async+48>:       mov    %eax,0x80(%rbx)
> 0x0000000000000d54 <end_unlink_async+54>:       jne    0xd5e <end_unlink_async+64>
> 0x0000000000000d56 <end_unlink_async+56>:       mov    %rbx,%rdi
> 0x0000000000000d59 <end_unlink_async+59>:       callq  0x84d <qh_destroy>
> 0x0000000000000d5e <end_unlink_async+64>:       mov    0x70(%rbx),%r12
> 0x0000000000000d62 <end_unlink_async+68>:       mov    %rbx,%rsi
> 0x0000000000000d65 <end_unlink_async+71>:       mov    %rbp,%rdi
> 0x0000000000000d68 <end_unlink_async+74>:       mov    %r12,0x28(%rbp)
> 0x0000000000000d6c <end_unlink_async+78>:       movq   $0x0,0x70(%rbx)
> 0x0000000000000d74 <end_unlink_async+86>:       callq  0xf6a <qh_completions>
> 0x0000000000000d79 <end_unlink_async+91>:       lea    0x58(%rbx),%rax
> 0x0000000000000d7d <end_unlink_async+95>:       cmp    %rax,0x58(%rbx)
> 0x0000000000000d81 <end_unlink_async+99>:       je     0xd96 <end_unlink_async+120>
> 0x0000000000000d83 <end_unlink_async+101>:      testb  $0x1,-0x8(%rbp)
> 0x0000000000000d87 <end_unlink_async+105>:      je     0xd96 <end_unlink_async+120>
> 0x0000000000000d89 <end_unlink_async+107>:      mov    %rbx,%rsi
> 0x0000000000000d8c <end_unlink_async+110>:      mov    %rbp,%rdi
> 0x0000000000000d8f <end_unlink_async+113>:      callq  0x6b0 <qh_link_async>
> 0x0000000000000d94 <end_unlink_async+118>:      jmp    0xdfa <end_unlink_async+220>
> 0x0000000000000d96 <end_unlink_async+120>:      mov    0x80(%rbx),%eax
> 0x0000000000000d9c <end_unlink_async+126>:      dec    %eax
> 0x0000000000000d9e <end_unlink_async+128>:      test   %eax,%eax
> 0x0000000000000da0 <end_unlink_async+130>:      mov    %eax,0x80(%rbx)
> 0x0000000000000da6 <end_unlink_async+136>:      jne    0xdb0 <end_unlink_async+146>
> 0x0000000000000da8 <end_unlink_async+138>:      mov    %rbx,%rdi
> 0x0000000000000dab <end_unlink_async+141>:      callq  0x84d <qh_destroy>
> 0x0000000000000db0 <end_unlink_async+146>:      testb  $0x1,-0x8(%rbp)
> 0x0000000000000db4 <end_unlink_async+150>:      je     0xdfa <end_unlink_async+220>
> 0x0000000000000db6 <end_unlink_async+152>:      mov    0x20(%rbp),%rax
> 0x0000000000000dba <end_unlink_async+156>:      cmpq   $0x0,0x50(%rax)
> 0x0000000000000dbf <end_unlink_async+161>:      jne    0xdfa <end_unlink_async+220>
> 0x0000000000000dc1 <end_unlink_async+163>:      lock btsl $0x2,0x1b0(%rbp)
> 0x0000000000000dca <end_unlink_async+172>:      sbb    %eax,%eax
> 0x0000000000000dcc <end_unlink_async+174>:      test   %eax,%eax
> 0x0000000000000dce <end_unlink_async+176>:      jne    0xdfa <end_unlink_async+220>
> 0x0000000000000dd0 <end_unlink_async+178>:      mov    0x0(%rip),%rax        # 0xdd7 <end_unlink_async+185>
> 0x0000000000000dd7 <end_unlink_async+185>:      lea    0x5(%rax),%rsi
> 0x0000000000000ddb <end_unlink_async+189>:      cmp    %rsi,0x170(%rbp)
> 0x0000000000000de2 <end_unlink_async+196>:      js     0xdee <end_unlink_async+208>
> 0x0000000000000de4 <end_unlink_async+198>:      cmpq   $0x0,0x160(%rbp)
> 0x0000000000000dec <end_unlink_async+206>:      jne    0xdfa <end_unlink_async+220>
> 0x0000000000000dee <end_unlink_async+208>:      lea    0x160(%rbp),%rdi
> 0x0000000000000df5 <end_unlink_async+215>:      callq  0xdfa <end_unlink_async+220>
> 0x0000000000000dfa <end_unlink_async+220>:      test   %r12,%r12
> 0x0000000000000dfd <end_unlink_async+223>:      je     0xe13 <end_unlink_async+245>
> 0x0000000000000dff <end_unlink_async+225>:      movq   $0x0,0x28(%rbp)
> 0x0000000000000e07 <end_unlink_async+233>:      mov    %rbp,%rdi
> 0x0000000000000e0a <end_unlink_async+236>:      mov    %r12,%rsi
> 0x0000000000000e0d <end_unlink_async+239>:      pop    %rbx
> 0x0000000000000e0e <end_unlink_async+240>:      pop    %rbp
> 0x0000000000000e0f <end_unlink_async+241>:      pop    %r12
> 0x0000000000000e11 <end_unlink_async+243>:      jmp    0xe18 <start_unlink_async>
> 0x0000000000000e13 <end_unlink_async+245>:      pop    %rbx
> 0x0000000000000e14 <end_unlink_async+246>:      pop    %rbp
> 0x0000000000000e15 <end_unlink_async+247>:      pop    %r12
> 0x0000000000000e17 <end_unlink_async+249>:      retq
> End of assembler dump.

