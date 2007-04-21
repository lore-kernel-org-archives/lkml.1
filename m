Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXDUHdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXDUHdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964865AbXDUHdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:33:10 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:22699 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796AbXDUHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:33:09 -0400
Message-ID: <4629BE29.6010306@bigpond.net.au>
Date: Sat, 21 Apr 2007 17:32:57 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au> <20070421050734.GL31925@holomorphy.com> <4629A349.8060207@bigpond.net.au>
In-Reply-To: <4629A349.8060207@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Sat, 21 Apr 2007 07:33:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> William Lee Irwin III wrote:
>> William Lee Irwin III wrote:
>> On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
>>> If some form of precise timer was used (instead) to trigger 
>>> pre-emption then, where there is more than one task with the same 
>>> expected "on CPU" time, only the last would get any CPU (and that's 
>>> only the case if some infinite loop doesn't get created).
>>
>> I think you can check for this and adjust their on-cpu times in various
>> ways and choose what order to run them in. I think it'd end up something
>> of a missed deadline policy.
> 
> Arguably the latest one should go first as its estimate is more likely 
> to be correct being based on more recent info i.e. the other's estimates 
> would be based on less runnable tasks and be optimistic. This would 
> involve pushing them down the queue and pushing items already on the 
> queue downwards is likely to be expensive.  Which is why I prefer the 
> less elegant solution of the periodical interrupt.
> 
> Of course, one solution might be to just add the adjustment to the key 
> time on all tasks on the queue?

I retract this suggestion as it's a very bad idea.  It introduces the 
possibility of starvation via the poor sods at the bottom of the queue 
having their "on CPU" forever postponed and we all know that even the 
smallest possibility of starvation will eventually cause problems.

I think there should be a rule: Once a task is on the queue its "on CPU" 
time is immutable.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
