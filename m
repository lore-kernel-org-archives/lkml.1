Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXDUNlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXDUNlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031030AbXDUNlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:41:24 -0400
Received: from mail.tmr.com ([64.65.253.246]:44242 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030619AbXDUNlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:41:24 -0400
Message-ID: <462A144B.9000400@tmr.com>
Date: Sat, 21 Apr 2007 09:40:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
   Scheduler [CFS]
References: <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 18 Apr 2007, Matt Mackall wrote:
>> Why is X special? Because it does work on behalf of other processes?
>> Lots of things do this. Perhaps a scheduler should focus entirely on
>> the implicit and directed wakeup matrix and optimizing that
>> instead[1].
> 
> I 100% agree - the perfect scheduler would indeed take into account where 
> the wakeups come from, and try to "weigh" processes that help other 
> processes make progress more. That would naturally give server processes 
> more CPU power, because they help others
> 
> I don't believe for a second that "fairness" means "give everybody the 
> same amount of CPU". That's a totally illogical measure of fairness. All 
> processes are _not_ created equal.
> 
> That said, even trying to do "fairness by effective user ID" would 
> probably already do a lot. In a desktop environment, X would get as much 
> CPU time as the user processes, simply because it's in a different 
> protection domain (and that's really what "effective user ID" means: it's 
> not about "users", it's really about "protection domains").
> 
> And "fairness by euid" is probably a hell of a lot easier to do than 
> trying to figure out the wakeup matrix.
> 
You probably want to consider the controlling terminal as well...  do 
you want to have people starting 'at' jobs competing on equal footing 
with people typing at a terminal? I'm not offering an answer, just 
raising the question.

And for some database applications, everyone in a group may connect with 
the same login-id, then do sub authorization to the database 
application. euid may be an issue there as well.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
