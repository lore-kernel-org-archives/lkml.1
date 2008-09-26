Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYIZJm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYIZJm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYIZJmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:42:51 -0400
Received: from www.tglx.de ([62.245.132.106]:53092 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbYIZJmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:42:51 -0400
Date: Fri, 26 Sep 2008 11:42:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: udelay and timers
In-Reply-To: <87skrnz6o0.fsf@denkblock.local>
Message-ID: <alpine.LFD.1.10.0809261141350.27026@apollo.tec.linutronix.de>
References: <87skrnz6o0.fsf@denkblock.local>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Elias Oltmanns wrote:

> Hi all,
> 
> finally, I have managed to identify the cause of some odd symptoms on my
> system, but I need your help to understand what is really going on and
> what should be done to fix things. My problem is this: I have written a
> small test module which, in due course, does the following:
> 
> ...
>         mod_timer(&timera, jiffies + msecs_to_jiffies(10000));
>         mod_timer(&timerb, jiffies + HZ/50);
> ...
> 
> The callbacks for those timers are defined as follows:
> 
> void timera.function(unsigned long data)
> {
>         udelay(120);
>         mod_timer(&timera, jiffies + msecs_to_jiffies(10000));
> }
> 
> void timerb.function(unsigned long data)
> {
> ...
>         mod_timer(&timerb, jiffies + HZ/50);
> }
> 
> Now, I can observe that because of the call to udelay() in the callback
> of timera, timerb rather frequently fires *much* too early, i.e. after
> less than 1 msec rather than 20 msecs. This means that an udelay in a
> timer callback heavily affects the precision of other timers running at
> the time. The effect if particularly grave on a tickless system, but
> even when NO_HZ was not set, I have observed this behaviour.
> 
> As I understand, udelay() is meant to be usable in softirq context. What
> can I do to find out what exactly causes the problem?

I have no idea what's going wrong. Can you please provide the full
source of your test module ?

Thanks,

	tglx
