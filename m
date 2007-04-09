Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbXDIRvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbXDIRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXDIRvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:51:46 -0400
Received: from holomorphy.com ([66.93.40.71]:36921 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbXDIRvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:51:45 -0400
Date: Mon, 9 Apr 2007 10:51:43 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070409175143.GV2986@holomorphy.com>
References: <200703290237.38777.kernel@kolivas.org> <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org> <200704071212.57401.gene.heskett@gmail.com> <20070407180818.GB23861@elte.hu> <1175973261.6288.2.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175973261.6288.2.camel@Homer.simpson.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 20:08 +0200, Ingo Molnar wrote:
>> not many - and i dont think Mike tested any of these - Mike tested 
>> pretty low make -j values (Mike, can you confirm?).

On Sat, Apr 07, 2007 at 09:14:21PM +0200, Mike Galbraith wrote:
> Yes.  I don't test anything more than make -j5 when looking at
> interactivity, and make -j nr_cpus+1 is my must have yardstick.

I strongly suggest assembling a battery of cleanly and properly written,
configurable testcases, and scripting a series of regression tests as
opposed to just randomly running kernel compiles and relying on Braille.
For instance, a program that spawns a set of tasks with some spectrum
of interactive vs. noninteractive behaviors and maybe priorities too
according to command-line flags and then measures and reports the
distribution of CPU bandwidth between them, with some notion of success
or failure and performance within the realm of success reported would
be something to include in such a battery of testcases. Different sorts
of cooperating processes attempting to defeat whatever sorts of
guarantees the scheduler is intended to provide would also be good
testcases, particularly if they're arranged so as to automatically
report success or failure in their attempts to defeat the scheduler
(which even irman2.c, while quite good otherwise, fails to do).

IMHO the failure of these threads to converge to some clear conclusion
is in part due to the lack of an agreed-upon set of standards for what
the scheduler should achieve and overreliance on subjective criteria.
The testcase code going around is also somewhat embarrassing.

>From the point of view of someone wondering what these schedulers solve,
how any of this is to be demonstrated, and what the status of various
pathological cases are, these threads are a nightmare of subjective
squishiness and a tug-of-war between testcases only ever considered one
at a time needing Lindent to read that furthermore have all their
parameters hardcoded. Scripting edits and recompiles is awkward. Just
finding the testcases is also awkward; con has a collection of a few,
but they've got the aforementioned flaws and others also go around
that can only be dredged up from mailing list archive searches, plus
there's nothing like LTP where they can be run in a script with
pass/fail reports and/or performance metrics for each. One patch goes
through for one testcase and regressions against the others are open
questions.

Scheduling does have a strong subjective component, but this is too
disorganized to be allowed to pass without comment. Some minimum bar
must be set for schedulers to pass before they're considered correct.
Some method of regression testing must be arranged. And the code to
do such testing should not be complete crap with hardcoded parameters.


-- wli
