Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYGJPGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYGJPGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbYGJPGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:06:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:23085 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYGJPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WS2evi52rfGyT2OYSikKTzBtsUlbr1Ks4nUnE8ovq/PNtXvBgc5IUbv8smCJS5uS0l
         wsCVDpM/NyK+Gmv/ZvJSURIQVD7e2Qwtqiv90G7HD3s41RcBwyZL6aqXKDLU48Z4Cp9p
         UA1JNlYYtDovJsqciQ19t+QwosKwSe93s1JAY=
Message-ID: <19f34abd0807100806y3df8a231w78626ad18a910bad@mail.gmail.com>
Date: Thu, 10 Jul 2008 17:06:38 +0200
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
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 4:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Regarding new crashes. Do you get them
>>
>> (1) after a few cpu offline / onlines ?
>> (2) on a freshly booted system?
>> (3) (1) or (2) but only with Miao Xie's patch (should not be (2) then)
>> (4) something else?
>
> Without Miao Xie's patch, I regularly get a crash on the first cpu-up.
> So I am using it all the time. With this patch applied, the new
> crashes can happen from anywhere between 2 minutes to 20 while running
> a few different looping scripts simultaneously:
>
> 1. cpu up/down
> 2. grep -r . /sys
> 3. swapon/swapoff
> 4. cat /dev/cpu/*/msr

Inhibiting #1 kept the machine alive for at least 25 minutes. Then I
started it and it hung after 492 rounds of cpu up/down, with this new
report:

list_add corruption. next->prev should be prev (f782d090), but was
00000000. (next=f20b8438).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:27!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3860, comm: bash Not tainted (2.6.26-rc9-00059-gb190333 #5)
EIP: 0060:[<c0294b80>] EFLAGS: 00210086 CPU: 0
EIP is at __list_add+0x40/0x60
EAX: 00000061 EBX: f782d090 ECX: 00000002 EDX: 00000002
ESI: 00200282 EDI: c0a8de8c EBP: e7dd3e84 ESP: e7dd3e6c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3860, ti=e7dd2000 task=e7e0afd0 task.ti=e7dd2000)
Stack: c067fd30 f782d090 00000000 f20b8438 f20b81b0 00200282 e7dd3e8c c0294baa
       e7dd3e98 c019bf5e f782d070 e7dd3ec8 c019c4b1 c0a8deac 000000d0 e7de2a00
       c1da1ddc 00000005 00000000 f20b81b0 fff95000 fff98000 fff96000 e7dd3ed4
Call Trace:
 [<c0294baa>] ? list_add+0xa/0x10
 [<c019bf5e>] ? __mem_cgroup_add_list+0x3e/0x40
 [<c019c4b1>] ? mem_cgroup_charge_common+0x231/0x260
 [<c019c522>] ? mem_cgroup_charge+0x12/0x20
 [<c01843e7>] ? do_wp_page+0x117/0x550
 [<c01864c1>] ? handle_mm_fault+0x1b1/0x770
 [<c01866f1>] ? handle_mm_fault+0x3e1/0x770
 [<c014cc95>] ? down_read_trylock+0x55/0x60
 [<c0120d98>] ? do_page_fault+0x298/0x700
 [<c0584b26>] ? _spin_unlock_irq+0x36/0x60
 [<c01402db>] ? sigprocmask+0x7b/0xf0
 [<c0104df5>] ? restore_nocheck+0x12/0x15
 [<c0120b00>] ? do_page_fault+0x0/0x700
 [<c0584e6a>] ? error_code+0x72/0x78
 =======================
Code: 75 2d 89 08 89 41 04 89 02 89 50 04 83 c4 10 5b 5e 5d c3 89 4c
24 0c 89 54 24 08 89 5c 24 04 c7 04 24 30 fd 67 c0 e8 80 0c ea ff <0
f> 0b eb fe 89 5c 24 0c 89 74 24 08 89 4c 24 04 c7 04 24 80 fd
EIP: [<c0294b80>] __list_add+0x40/0x60 SS:ESP 0068:e7dd3e6c
---[ end trace 89a65901b268513f ]---

The list corruption now has a completely different backtrace, but they
both were 0 instead of some other (expected) value. This fits with the
theory that something is zeroed that shouldn't be.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
