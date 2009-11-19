Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZKSUZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZKSUZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZKSUZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:25:14 -0500
Received: from www.tglx.de ([62.245.132.106]:55047 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZKSUZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:25:13 -0500
Date: Thu, 19 Nov 2009 21:24:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: commit b00bc0b237055b breaking perf subsystem
In-Reply-To: <20091119115020.7bd8896b@infradead.org>
Message-ID: <alpine.LFD.2.00.0911192053080.24119@localhost.localdomain>
References: <20091119115020.7bd8896b@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Arjan van de Ven wrote:
> commit b00bc0b237055b4c45816325ee14f0bd83e6f590
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Nov 2 13:01:56 2009 +0100
> 
>     uids: Prevent tear down race
> 
> has been bisected to break the perf system between -rc5 and -rc7;
> and reverting this patch in rc7 also fixes the issue.

Sigh, today seems to be the day of bisect madness.

I'm not buying direct related perf breakage from fixing that race.

Yes, I'm paranoid, but:
     Does your config have CONFIG_USER_SCHED=y ?

> now this patch is.... fun and seemingly unrelated to perf, so I
> am pretty sure something else is going on.

I fully agree, but ...
 
> the symptom of the breakage is that a userland client of perf
> (in my case, powertop) does not get to see new events if there
> is only, say, one or two of them. The data_head pointer just does
> not get updated.
> 
> Based on the patch, I have a suspicion that this pointer gets updated
> from synchronize RCU context, and this patch just makes that happen
> more.

... I have no idea how you associate that patch with the data_head
pointer and why this patch increases the sync RCU update frequency.

> If that is the case, what we really need is a new ioctl to perf that
> will cause all pending buffer state to be flushed to the ring buffer,
> that applications using perf can then just always call before looking
> at the ring. As a concept, that sounds like a good idea to me anyway...
> 
> comments/suggestions/saying-I'm-full-of-sh*t ?

I fear the latter unless you come up with some coherent explanation of
connecting that patch to rcu and the data_head pointer.

Thanks,

	tglx
