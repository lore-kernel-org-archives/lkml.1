Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXIQObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXIQObR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXIQObB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:31:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22781 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbXIQObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:31:00 -0400
Message-ID: <46EE8F63.3070108@oracle.com>
Date: Mon, 17 Sep 2007 07:29:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: crashme fault
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org> <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com> <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org> <46EC6F2A.5090008@oracle.com> <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org> <20070916094001.d87ed0f0.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709161055070.16478@woody.linux-foundation.org> <20070916220643.bea3e44f.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709162224580.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709162224580.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 16 Sep 2007, Randy Dunlap wrote:
>> I'll test this overnight on 2.6.23-rc6-git2 since that was failing.
>>
>> I haven't been able to reproduce the fault on 2.6.21 after several
>> hours of testing.
>>
>> I'll also test a microcode update to see if it helps.
> 
> Before you do the microcode update, try to see if you can bisect the place 
> between 2.6.21->22 that seems to start it. Even if you don't get all the 
> way, if you are confident enough about the "no error" case to be able to 
> bisect it down by doing a few reboots, it will at least cut down the set 
> of possible commits by roughly a factor of 2^<nr-of-bisect> events, so 
> even "just" a series of 4-5 bisect things might give us more of a clue.

OK, I haven't done the microcode update yet.  I ran crashme overnight
with your newer patch and it crashed:

[14254.327676] Unable to handle kernel paging request at 00000000ff021eaf RIP: 
[14254.332299]  [<0000000000504225>]
[14254.338084] PGD d8542067 PUD 0 
[14254.341271] Oops: 0000 [1] SMP 
[14254.344449] CPU 3 
[14254.346484] Modules linked in: loop
[14254.350001] Pid: 28565, comm: crashme Not tainted 2.6.23-rc6-git2 #2
[14254.356349] RIP: 0033:[<0000000000504225>]  [<0000000000504225>]
[14254.362376] RSP: 002b:00007fff5afccbf8  EFLAGS: 00010656
[14254.367685] RAX: 000000005afccbf8 RBX: 00002abd4fbf5c00 RCX: 00002abd4fc88b37
[14254.374812] RDX: 0000000000504220 RSI: 0000000000000000 RDI: 000000000000000a
[14254.381939] RBP: 00007fff5afccc00 R08: 00007fff5afccb50 R09: 0000000000000000
[14254.389068] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
[14254.396195] R13: 00007fff5afccdf0 R14: 0000000000000000 R15: 0000000000000000
[14254.403324] FS:  00002abd4fe276d0(0000) GS:ffff81011fc751c0(0000) knlGS:0000000000000000
[14254.411403] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[14254.417144] CR2: 00000000ff021eaf CR3: 00000000d85f6000 CR4: 00000000000006e0
[14254.424273] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[14254.431400] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[14254.438528] Process crashme (pid: 28565, threadinfo ffff8100d8970000, task ffff8100d8628820)
[14254.446953] 
[14254.448443] RIP  [<0000000000504225>]
[14254.452124]  RSP <00007fff5afccbf8>
[14254.455614] CR2: 00000000ff021eaf
[14254.459244] Kernel panic - not syncing: Fatal exception


> Of course, if it's somewhat random and timing-dependent, bisection can be 
> hard (the "2^n" thing is very efficient, but it also means that a *single* 
> wrong answer will totally invalidate the result, so if something isn't 
> entirely reproducible, bisection often fails!)

