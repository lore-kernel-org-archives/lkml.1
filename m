Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYKRUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYKRUeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYKRUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:34:13 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:37532 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYKRUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:34:12 -0500
Message-ID: <492326B5.10203@nortel.com>
Date: Tue, 18 Nov 2008 14:33:57 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Chris Friesen" <cfriesen@nortel.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: BUG? timer_create() with SIGEV_THREAD not working (at least on
 ppc64)
References: <4922E9EC.3070606@nortel.com>
In-Reply-To: <4922E9EC.3070606@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2008 20:34:01.0422 (UTC) FILETIME=[FD9AA6E0:01C949BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> The code below sets up a simple timer with SIGEV_THREAD.  I compiled the 
> code as "g++ timertest.cc -o timertest -lrt -pthread".
> 
> Running it on my G5 with 2.6.27 (but with an older glibc), it prints:
> 
> Creating timer
> Setting timer 268509264 for 5-second expiration...
> 
> and then the timer never expires.  I have an old Fedora Core 4 x86 
> machine and there it works as expected.
> 
> Is there some hard requirement to upgrade glibc?  If not, then this 
> looks like a bug somewhere.

I'm getting suspicious of either glibc or my version of strace, as it 
shows the child thread calling rt_sigtimedwait() with an empty signal set.

clone(Process 2663 attached
child_stack=0xf7ffe6c0, 
flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|CLONE_DETACHED, 
parent_tidptr=0xf7ffeb68, tls=0xf8005f80, child_tidptr=0xf7ffeb68) = 2663
[pid  2662] futex(0xf5f11a4, FUTEX_WAKE, 2147483647) = 0
[pid  2662] timer_create(0, {0x10011050, 32, SIGEV_THREAD_ID, {2663}}, 
{(nil)}) = 0
[pid  2662] timer_settime(0, , {it_interval={1, 0}, it_value={1, 0}}, 
<unfinished ...>
[pid  2663] rt_sigprocmask(SIG_BLOCK, [RTMIN],  <unfinished ...>
[pid  2662] <... timer_settime resumed> NULL) = 0
[pid  2662] fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), 
...}) = 0
[pid  2663] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid  2662] mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid  2663] rt_sigtimedwait([],  <unfinished ...>
[pid  2662] <... mmap resumed> )        = 0xf7ffa000
[pid  2662] write(1, "set timer OK\n", 13set timer OK


Chris
