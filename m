Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXDQHWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXDQHWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDQHWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:22:17 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:42883 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXDQHWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:22:16 -0400
Message-ID: <4624759A.7090301@bigpond.net.au>
Date: Tue, 17 Apr 2007 17:22:02 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Davide Libenzi <davidel@xmailserver.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com>
In-Reply-To: <20070417070949.GR8915@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 07:22:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Mon, Apr 16, 2007 at 11:50:03PM -0700, Davide Libenzi wrote:
>> I had a quick look at Ingo's code yesterday. Ingo is always smart to 
>> prepare a main dish (feature) with a nice sider (code cleanup) to Linus ;)
>> And even this code does that pretty nicely. The deadline designs looks 
>> good, although I think the final "key" calculation code will end up quite 
>> different from what it looks now.
> 
> The additive nice_offset breaks nice levels. A multiplicative priority
> weighting of a different, nonnegative metric of cpu utilization from
> what's now used is required for nice levels to work. I've been trying
> to point this out politely by strongly suggesting testing whether nice
> levels work.
> 
> 
> On Mon, Apr 16, 2007 at 11:50:03PM -0700, Davide Libenzi wrote:
>> I would suggest to thoroughly test all your alternatives before deciding. 
>> Some code and design may look very good and small at the beginning, but 
>> when you start patching it to cover all the dark spots, you effectively 
>> end up with another thing (in both design and code footprint).
>> About O(1), I never thought it was a must (besides a good marketing 
>> material), and O(log(N)) *may* be just fine (to be verified, of course).
> 
> The trouble with thorough testing right now is that no one agrees on
> what the tests should be and a number of the testcases are not in great
> shape. An agreed-upon set of testcases for basic correctness should be
> devised and the implementations of those testcases need to be
> maintainable code and the tests set up for automated testing and
> changing their parameters without recompiling via command-line options.
> 
> Once there's a standard regression test suite for correctness, one
> needs to be devised for performance, including interactive performance.
> The primary difficulty I see along these lines is finding a way to
> automate tests of graphics and input device response performance. Others,
> like how deterministically priorities are respected over progressively
> smaller time intervals and noninteractive workload performance are
> nowhere near as difficult to arrange and in many cases already exist.
> Just reuse SDET, AIM7/AIM9, OAST, contest, interbench, et al.

At this point, I'd like direct everyone's attention to the simloads package:

<http://downloads.sourceforge.net/cpuse/simloads-0.1.1.tar.gz>

which contains a set of programs designed to be used in the construction 
of CPU scheduler tests.  Of particular use is the aspin program which 
can be used to launch tasks with specified sleep/wake characteristics.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
