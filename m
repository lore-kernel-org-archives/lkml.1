Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbXCMAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbXCMAHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXCMAHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:07:00 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:65442 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752641AbXCMAG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:06:59 -0400
Date: Mon, 12 Mar 2007 15:43:36 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Mike Galbraith <efault@gmx.de>
cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-Reply-To: <1173732344.6431.54.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.63.0703121523220.1245@qynat.qvtvafvgr.pbz>
References: <200703111457.17624.kernel@kolivas.org>  <200703130549.47058.kernel@kolivas.org>
  <1173730314.6431.30.camel@Homer.simpson.net>  <200703130738.19034.kernel@kolivas.org>
 <1173732344.6431.54.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Mike Galbraith wrote:

> On Tue, 2007-03-13 at 07:38 +1100, Con Kolivas wrote:
>> On Tuesday 13 March 2007 07:11, Mike Galbraith wrote:
>>>
>>> Killing the known corner case starvation scenarios is wonderful, but
>>> let's not just pretend that interactive tasks don't have any special
>>> requirements.
>>
>> Now you're really making a stretch of things. Where on earth did I say that
>> interactive tasks don't have special requirements? It's a fundamental feature
>> of this scheduler that I go to great pains to get them as low latency as
>> possible and their fair share of cpu despite having a completely fair cpu
>> distribution.
>
> As soon as your cpu is fully utilized, fairness looses or interactivity
> loses.  Pick one.

correct.

the problem is that it's hard (if not impossible) to properly identify what is 
needed to make a system have good interactivity. in some cases it's a matter of 
low latency (wake up a process as quickly as you can when whatever it was 
waiting on is available), but in others it's a matter of allocating the _right_ 
process enough CPU (X needs enough CPU to do things)

where it's a matter of needing low-latency, it's possible to design a scheduler 
that will do things in a predictable enough way that you know the max latency 
you have to deal with (and the RSDL seems to do this)

the problem comes when this isn't enough. if you have several CPU hogs on a 
system, and they are all around the same priority level, how can the scheduler 
know which one needs the CPU the most for good interactivity?

in some cases you may be able to directly detect that your high-priority process 
is waiting for another one (tracing pipes and local sockets for example), but 
what if you are waiting for several of them? (think a multimedia desktop waiting 
for the sound card, CDRom, hard drive, and video all at once) which one needs 
the extra CPU the most?

Fairness is much easier to enforce (and much easier to understand)

the RSDL is concentrating on enforcing fairness, with bounded (and predictable) 
latencies.

if you are willing to tell the system what you consider more important (and how 
much more important you consider it), then it's much easier to figure out who to 
give the CPU to. Con is just asking you to do this (and you already do, by doing 
a nice -5. but it sounds like you want that to mean more then it currently does)

David Lang


