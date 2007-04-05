Return-Path: <linux-kernel-owner+w=401wt.eu-S1767131AbXDEQMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767131AbXDEQMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767133AbXDEQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:12:12 -0400
Received: from mail37.syd.optusnet.com.au ([211.29.133.221]:57331 "EHLO
	mail37.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767131AbXDEQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:12:09 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [test] sched: SD-latest versus Mike's latest
Date: Fri, 6 Apr 2007 02:08:47 +1000
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <1175770950.6609.16.camel@Homer.simpson.net> <20070405115447.GA24138@elte.hu>
In-Reply-To: <20070405115447.GA24138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704060208.47327.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 21:54, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> > On Tue, 2007-04-03 at 08:01 +0200, Ingo Molnar wrote:
> > > looks interesting - could you send the patch?
> >
> > Ok, this is looking/feeling pretty good in testing.  Comments on
> > fugliness etc much appreciated.
> >
> > Below the numbers is a snapshot of my experimental tree.  It's a
> > mixture of my old throttling/anti-starvation tree and the task

Throttling to try to get to SD fairness? The mainline state machine becomes 
more complex than ever and fluctuates from interactive to fair by an as-yet 
unchosen magic number timeframe which ebbs and flows.

> > promotion patch, with the addition of a scheduling class for
> > interactive tasks to dish out some of that targeted unfairness I
> > mentioned.

Nice -10 on mainline ruins the latency of nice 0 tasks unlike SD. New 
scheduling class just for X? Sounds like a very complicated 
userspace-changing way to just do the equivalent of "nice -n -10" obfuscated. 

> here's some test results, comparing SD-latest to Mike's-latest:
>
> re-testing the weak points of the vanilla scheduler + Mike's:
>
>  - thud.c:    this workload has almost unnoticeable effect
>  - fiftyp.c:  noticeable, but alot better than previously!

Load of 1.5 makes mainline a doorstop without throttling.

> re-testing the weak points of SD:
>
>  - hackbench: still unusable under such type of high load - no improvement.

Load of 160. Is proportional slowdown bad?

>  - make -j:   still less interactive than Mike's - no improvement.

Depends on how big your job number vs cpu is. The better the throttling gets 
with mainline the better SD gets in this comparison. At equal fairness 
mainline does not have the low latency interactivity SD has.

Nice -10 X with SD is a far better solution than an ever increasing complexity 
state machine and a userspace-changing scheduling policy just for X. Half 
decent graphics cards get good interactivity with SD even without renicing.

> 	Ingo

-- 
-ck
