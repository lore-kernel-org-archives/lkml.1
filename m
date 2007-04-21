Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXDUQXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXDUQXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXDUQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:23:04 -0400
Received: from holomorphy.com ([66.93.40.71]:49019 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXDUQXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:23:03 -0400
Date: Sat, 21 Apr 2007 09:23:07 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070421162307.GO31925@holomorphy.com>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au> <20070421050734.GL31925@holomorphy.com> <4629A349.8060207@bigpond.net.au> <4629BE29.6010306@bigpond.net.au> <20070421075401.GA23410@elte.hu> <20070421083317.GN31925@holomorphy.com> <20070421085729.GD29800@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421085729.GD29800@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Suppose a table of nice weights like the following is tuned via 
>> /proc/:
>> -20	21			 0	1
>>  -1	2			19	0.0476
> > Essentially 1/(n+1) when n >= 0 and 1-n when n < 0.

On Sat, Apr 21, 2007 at 10:57:29AM +0200, Ingo Molnar wrote:
> ok, thanks for thinking about it. I have changed the nice weight in 
> CVSv5-to-be so that it defaults to something pretty close to your 
> suggestion: the ratio between a nice 0 loop and a nice 19 loop is now 
> set to about 2%. (This something that users requested for some time, the 
> default ~5% is a tad high when running reniced SETI jobs, etc.)

Okay. Maybe what I suggested is too weak vs. too strong. I didn't
actually have it in mind as a proposal for general use, but maybe it is
good for such. I had more in mind tunability in general, but it's all
good. I'd think some curve gentler in intermediate nice levels and
stronger at the tails might be better.


On Sat, Apr 21, 2007 at 10:57:29AM +0200, Ingo Molnar wrote:
> the actual percentage scales almost directly with the nice offset 
> granularity value, but if this should be exposed to users at all, i 
> agree that it would be better to directly expose this as some sort of 
> 'ratio between nice 0 and nice 19 tasks', right? Or some other, more 
> finegrained metric. Percentile is too coarse i think, and using 0.1% 
> units isnt intuitive enough i think. The sysctl handler would then 
> transform that 'human readable' sysctl value into the appropriate 
> internal nice-offset-granularity value (or whatever mechanism the 
> implementation ends up using).

I vaguely liked specifying the full table, but maybe it's too much
for a real user interface.

4-digit or 5-digit fixed point decimal sounds reasonable.


On Sat, Apr 21, 2007 at 10:57:29AM +0200, Ingo Molnar wrote:
> I'd not do this as a per-nice-level thing but as a single value that 
> rescales the whole nice level range at once. That's alot less easy to 
> misconfigure and we've got enough nice levels for users to pick from 
> almost arbitrarily, as long as they have the ability to influence the 
> max.
> does this sound mostly OK to you?

For the most part, yes. I've been mostly looking at how effectively
the prioritization algorithms work. I'll be wrapping up writing a
testcase to measure all this soon. The basic idea is to take the
weights as inputs somehow and then check to see that they're honored.

What's appropriate for end-users is a very different thing from what
might be appropriate for me. I won't have trouble fiddling with the
code, so please do design around what the best interface for end-users
might be.


-- wli
