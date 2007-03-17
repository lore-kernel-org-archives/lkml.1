Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXCQIJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXCQIJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965171AbXCQIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:09:20 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:55519 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965105AbXCQIJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:09:18 -0400
Date: Fri, 16 Mar 2007 23:44:17 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Ingo Molnar <mingo@elte.hu>
cc: Nicholas Miell <nmiell@comcast.net>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
In-Reply-To: <20070317074506.GA13685@elte.hu>
Message-ID: <Pine.LNX.4.63.0703162326020.6015@qynat.qvtvafvgr.pbz>
References: <200703042335.26785.a1426z@gawab.com>  <200703170040.48316.kernel@kolivas.org>
  <1174059299.7886.25.camel@Homer.simpson.net>  <200703170813.32594.kernel@kolivas.org>
  <1174084207.7009.9.camel@Homer.simpson.net>  <1174105443.3144.4.camel@entropy>
  <1174110965.7911.44.camel@Homer.simpson.net>  <1174112768.3144.8.camel@entropy>
 <20070317074506.GA13685@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007, Ingo Molnar wrote:

> * Nicholas Miell <nmiell@comcast.net> wrote:
>
>> The X people have plans for how to go about fixing this, [...]
>
> then we'll first have wait for those X changes to at least be done in a
> minimal manner so that they can be tested for real with RSDL. (is it
> _really_ due to that? Or will X regress forever once we switch to RSDL?)
> We cannot regress the scheduling of a workload as important as "X mixed
> with CPU-intense tasks". And "in theory this should be fixed if X is
> fixed" does not cut it. X is pretty much _the_ most important thing to
> optimize the interactive behavior of a Linux scheduler for. Also,
> paradoxically, it is precisely the improvement of _X_ workloads that
> RSDL argues with.
>
> this regression has to be fixed before RSDL can be merged, simply
> because it is a pretty negative effect that goes beyond any of the
> visible positive improvements that RSDL brings over the current
> scheduler. If it is better to fix X, then X has to be fixed _first_, at
> least in form of a prototype patch that can be _tested_, and then the
> result has to be validated against RSDL.

why isn't niceing X to -10 an acceptable option?

if you overload the box enough things slow down, what scheduler avoids that?

where RSDL 'regresses' is with multiple CPU hog running at once (more then the 
number of real CPU's you have available) at the same priority, with one of them 
being the X server process.

the initial report was that with X + 2 cpu hogs on 1.5 cpu's there's more of a 
slowdown (even with a nice difference of 5 between X and the other processes)

the latest report is that with X and 11 cpu hogs and a nice difference of 10 
things slow down (I don't remember the number of cpu's from this report)

how much of an overload should the scheduler adjust for? a load of 3xcpu's? 
10x cpu's? what would be deemed acceptable?

if the key factor in a scheduler is to be able to run multiple CPU hogs at the 
same time as the X process, why not just check the name of the process running, 
and if it's X give it a nice boost?

while that would be easy to abuse, it would at least be predictable.

if the nice levels don't have enough of an effect, how much of an effect should 
a given nice level have? (con has asked this several times, I haven't seen an 
answer from anyone)

David Lang
