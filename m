Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbZGBUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbZGBUzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZGBUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:55:27 -0400
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:41276 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbZGBUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:55:26 -0400
Date: Thu, 2 Jul 2009 17:07:02 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
In-Reply-To: <20090629210206.GB13125@elte.hu>
Message-ID: <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
 <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu>
 <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
 <20090629210206.GB13125@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry for the delay in responding, was away

On Mon, 29 Jun 2009, Ingo Molnar wrote:
>
> * Vince Weaver <vince@deater.net> wrote:
>
>>> If the 5 thousand cycles measurement overhead _still_ matters to
>>> you under such circumstances then by all means please submit the
>>> patches to improve it. Despite your claims this is totally
>>> fixable with the current perfcounters design, Peter outlined the
>>> steps of how to solve it, you can utilize ptrace if you want to.
>>
>> Is it really "totally" fixible?  I don't just mean getting the
>> overhead from ~3000 down to ~100, I mean down to zero.
>
> The thing is, not even pfmon gets it down to zero:
>
>  pfmon -e INSTRUCTIONS_RETIRED --follow-fork --aggregate-results ~/million
>  1000001 INSTRUCTIONS_RETIRED
>
> So ... do you take the hardliner purist view and consider it crap
> due to that imprecision, or do you take the pragmatist view of also
> considering the relative relevance of any imperfection? ;-)

as I said in a previous post, on most x86 chips the instructions_retired
counter also includes any hardware interrupts that occur during the 
process runtime.  So any clock interrupts, etc, show up as an extra 
instruction.  So on the "million" benchmark, it's usually +/- 2 extra 
instructions.

It looks like support might be added to perfcounters to track these 
hardware interrupt stats per-process, which would be great, as it's been 
really hard to quantify that currently.

In any case, it looks like the changes to make perf have lower overhead 
have been merged, which makes me happy.  Thank you.

Vince

