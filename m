Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYGJNn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYGJNn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYGJNnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:43:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:57911 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYGJNnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CFpn6uAQqaFKIola/bwzdrzeUztxnSk8UUI+vHM9AjISxvfLXOFl8xH/hRXu6R+DV4
         Yk9KTJFTqP7ZsIviOOQIsj140vSDtdGKmD8lz+4lkkJlEOQH3n5iGkqaFPTZVBNSQWSg
         R972AJC8nVF0oks1q6ZnuaLQ+YMU53DnN19mE=
Message-ID: <19f34abd0807100643t232372b4h9bbb6c5fb21845db@mail.gmail.com>
Date: Thu, 10 Jul 2008 15:43:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <19f34abd0807100633q632095b7k7635032d5fd21bc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <19f34abd0807100617m10338f97ic6fa7e74ddf2ac80@mail.gmail.com>
	 <19f34abd0807100633q632095b7k7635032d5fd21bc5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 3:33 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Pid: 19762, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
>> EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
>> EIP is at kmem_cache_alloc+0xc7/0xe0
>
> $ addr2line -e vmlinux -i c01991c7
> include/asm/string_32.h:183
> mm/slub.c:1646
>
> For reference, the disassembly:
> c01991c7:       f3 ab                   rep stos %eax,%es:(%edi)
>
> and registers in question:
>
> ESI: 00200282 EDI: f6c44000 EBP: e7c2befc ESP: e7c2bedc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

Got a similar one (same EIP), but this time with the "top" of the oops as well:

BUG: unable to handle kernel paging request at e82be000
IP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0
*pde = 35657163 *pte = 282be160
Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3879, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
EIP is at kmem_cache_alloc+0xc7/0xe0
EAX: 00000000 EBX: e82bdf00 ECX: 1adada9a EDX: 6b6b6b6b
ESI: 00200282 EDI: e82be000 EBP: da711e74 ESP: da711e54
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process grep (pid: 3879, ti=da710000 task=da7f6f90 task.ti=da710000)
Stack: c019fa36 f7a9cf20 c019fa36 000080d0 f7811c30 00000003 da711f04 ffffffe9
       da711e8c c019fa36 c092e478 000001f6 00000003 da711f04 da711eac c01a8e44
       00001000 e802a100 ffffff9c da711f04 00018801 00000004 da711ec4 c01a8f31
Call Trace:
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c01a8e44>] ? __path_lookup_intent_open+0x24/0x90
 [<c01a8f31>] ? path_lookup_open+0x21/0x30
 [<c01a8fd3>] ? do_filp_open+0x93/0x710
 [<c019cc48>] ? get_unused_fd_flags+0xc8/0xf0
 [<c05849b7>] ? _spin_unlock+0x27/0x50
 [<c019cc48>] ? get_unused_fd_flags+0xc8/0xf0
 [<c019ccb9>] ? do_sys_open+0x49/0xe0
 [<c019fbf9>] ? fput+0x19/0x20
 [<c019cdb9>] ? sys_open+0x29/0x40
 [<c0104ceb>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: b9 ff ff ff ff 8b 55 ec 89 7c 24 04 89 04 24 8b 45 f0 e8 4d f6 ff ff 89 c3
 eb a0 85 db 74 bc 8b 57 10 31 c0 89 df 89 d1 c1 e9 02 <f3> ab f6 c2 02 74 02 66
 ab f6 c2 01 74 01 aa eb 9f 90 8d b4 26
EIP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0 SS:ESP 0068:da711e54
---[ end trace f3a251e0ce11b6fd ]---

This seems to be grep both times, the command I used is:

    $ grep -r . /sys


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
