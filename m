Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbYIITgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbYIITgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYIITgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:36:16 -0400
Received: from www.tglx.de ([62.245.132.106]:34386 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYIITgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:36:15 -0400
Date: Tue, 9 Sep 2008 21:36:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [regression] __tick_program_event of hpet is stuck
In-Reply-To: <200809092120.45295.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809092131160.13819@apollo.tec.linutronix.de>
References: <200809080114.36106.elendil@planet.nl> <200809091438.57158.elendil@planet.nl> <alpine.LFD.1.10.0809091503460.3271@apollo.tec.linutronix.de> <200809092120.45295.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008, Frans Pop wrote:

> On Tuesday 09 September 2008, Thomas Gleixner wrote:
> > It's nothing to worry about. I out the WARN_ON() there to get some
> > information about the validation of min_delta_ns and to see in which
> > range this happens.
> 
> Ah, OK. A WARN_ON is perhaps a bit heavy for that, unless you actually
> want to be flooded with reports :-)

Yes, I wanted that. Some new debug outputs are usually
ignored. WARN_ONs are not.

> In my case it prevented me from running the kernel on other boxes than the
> laptop because I feared some possibly important issue.

That was not my intention.
 
> Also, a single line can easily be filtered out from logcheck reports while
> doing the same for WARN_ONs is much harder and even not advisable.
> 
> > I'm going to remove the WARN_ON() and just keep the information that
> > we need to increase the min_delta_ns value for safe operation.
> 
> Sounds like a plan; have already done so locally.
> 
> Here are some results I've got so far. You can see reboots and supend
> to RAMs. Maximum observed value on the HP 2510p is now 80000 with the
> system mostly idle or in light use.

Ok. That's still a reasonable range.

> I also tried getting these on my desktop by switching the clocksource from
> tsc to hpet, but that did not result in any output (identical x86_64 kernel).

I have not a single machine where this shows up, but I really wanted
to get some data. It worked :)

Thanks,

	tglx


