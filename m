Return-Path: <linux-kernel-owner+w=401wt.eu-S933515AbYBMRQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515AbYBMRQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbYBMRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:15:57 -0500
Received: from r00tworld.com ([212.85.137.21]:46394 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758714AbYBMRP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:15:56 -0500
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Feb 2008 18:15:13 +0200
MIME-Version: 1.0
Subject: Re: vmsplice exploits, stack protector and Makefiles
Reply-to: pageexec@freemail.hu
CC: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-ID: <47B333B1.28931.A31602E@pageexec.freemail.hu>
In-reply-to: <20080213164853.GA25476@elte.hu>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>, <20080213152900.GA28959@elte.hu>, <20080213164853.GA25476@elte.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 13 Feb 2008 18:13:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Feb 2008 at 17:48, Ingo Molnar wrote:

> hm, had to pull it again because it crashed in testing:

i've only tested .24, not .25 so maybe something changed. did you
make sure that

  write_pda(stack_canary, next_p->stack_canary);

was removed from arch/x86/kernel/process_64.c:__switch_to? that's
the only reason i can think of that would trigger this trace.

> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
> Brought up 2 CPUs
> stack corrupted in: thread_return+0xd0/0xe2
> Pid: 0, comm: swapper Not tainted 2.6.25-rc1 #3
> 
> Call Trace:
>  [<ffffffff80242018>] __stack_chk_fail+0x2a/0x68
>  [<ffffffff807a0478>] thread_return+0xd0/0xe2
>  [<ffffffff8025f5c3>] getnstimeofday+0x3f/0xab
>  [<ffffffff8025cfc7>] ktime_get_ts+0x27/0x6f
>  [<ffffffff8025d02b>] ktime_get+0x1c/0x66
>  [<ffffffff802639af>] tick_nohz_stop_idle+0x39/0x76
>  [<ffffffff8020b204>] cpu_idle+0xb6/0xca
> 
> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
> 
> config attached.
> 
> 	Ingo
> 



