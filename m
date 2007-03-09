Return-Path: <linux-kernel-owner+w=401wt.eu-S1767158AbXCIKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767158AbXCIKyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767165AbXCIKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:54:20 -0500
Received: from holomorphy.com ([66.93.40.71]:37302 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767158AbXCIKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:54:19 -0500
Date: Fri, 9 Mar 2007 02:54:11 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Ed Tomlinson <edt@aei.ca>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Message-ID: <20070309105411.GD2986@holomorphy.com>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com> <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca> <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org> <45F0DCB7.5020908@tmr.com> <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 10:31:48PM -0800, Linus Torvalds wrote:
> No. Really.
> I absolutely *detest* pluggable schedulers. They have a huge downside: 
> they allow people to think that it's ok to make special-case schedulers. 
> And I simply very fundamentally disagree.
> If you want to play with a scheduler of your own, go wild. It's easy 
> (well, you'll find out that getting good results isn't, but that's a 
> different thing). But actual pluggable schedulers just cause people to 
> think that "oh, the scheduler performs badly under circumstance X, so 
> let's tell people to use special scheduler Y for that case".
> And CPU scheduling really isn't that complicated. It's *way* simpler than 
> IO scheduling. There simply is *no*excuse* for not trying to do it well 
> enough for all cases, or for having special-case stuff.
> But even IO scheduling actually ends up being largely the same. Yes, we 
> have pluggable schedulers, and we even allow switching them, but in the 
> end, we don't want people to actually do it. It's much better to have a 
> scheduler that is "good enough" than it is to have five that are "perfect" 
> for five particular cases.

For the most part I was trying to assist development, but ran out of
patience and interest before getting much of anywhere. The basic idea
was to be able to fork over a kernel to a benchmark team and have them
run head-to-head comparisons, switching schedulers on the fly,
particularly on machines that took a very long time to boot. The
concept ideally involved making observations and loading fresh
schedulers based on them as kernel modules on the fly. I was more
interested in rapid incremental changes than total rewrites, though I
considered total rewrites to be tests of adequacy, since somewhere in
the back of my mind I had thoughts about experimenting with gang
scheduling policies on those machines taking very long times to boot.

What actually got written, the result of it being picked up by others,
and how it's getting used are all rather far from what I had in mind,
not that I'm offended in the least by any of it. I also had little or
no interest in mainline for it. The intention was more on the order of
an elaborate instrumentation patch for systems where the time required
to reboot is prohibitive and the duration of access strictly limited.
(In fact, downward-revised estimates of the likelihood of such access
also factored into the abandonment of the codebase.)

I consider policy issues to be hopeless political quagmires and
therefore stick to mechanism. So even though I may have started the
code in question, I have little or nothing to say about that sort of
use for it.

There's my longwinded excuse for having originated that tidbit of code.


-- wli
