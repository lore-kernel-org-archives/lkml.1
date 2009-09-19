Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZISMaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZISMaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 08:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZISM37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 08:29:59 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:60957 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZISM37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 08:29:59 -0400
Message-ID: <4AB4CEC8.4060101@telenet.be>
Date: Sat, 19 Sep 2009 14:30:00 +0200
From: Ian Schram <ischram@telenet.be>
User-Agent: Thunderbird 2.0.0.23 (X11/20090913)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xiaoguangrong@cn.fujitsu.com, Paul Mackerras <paulus@samba.org>
Subject: Re: perf_copy_attr pointer arithmetic weirdness
References: <4AB3DEE2.3030600@telenet.be> <1253303868.10538.60.camel@laptop> <20090919080609.GA10748@elte.hu>
In-Reply-To: <20090919080609.GA10748@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Fri, 2009-09-18 at 21:26 +0200, Ian Schram wrote:
>>> There is some -to me at least- weird code in per_copy_attr. Which supposedly
>>> checks that all bytes trailing a struct are zero.
>>>
>>> It doesn't seem to get pointer arithmetic right. Since it increments
>>> an iterating pointer by sizeof(unsigned long) rather than 1.
>>>
>>> I believe this has an impact on the exploitability of the recent buffer overflow
>>> in the perf_copy_attr function. I'm pretty sure I'm not the only one who noticed
>>> this, but i couldn't find it being mentioned. For some reason people prefer
>>> mmaping something at zero these days?
>>>
>>> I have appended a patch locating the issue. The PTR_ALIGN stuff right above it
>>> doesn't seem to take any boundary conditions into account which is probably not
>>> a good thing either.
>> sizeof(struct perf_counter_attr) should always be a multiple of u64, and
I don't think this matters since the starting address is not 'forced' to be
aligned. In which case some bytes in the middle would be unchecked. All in
all seems like an undesirable situation. I'll verify this and try my hand
at fixing it properly. Unless somebody who actually understands the purpose
of these checks wants to have a go..

>> we can indeed read beyond the tail boundary, but that should be ok,
>> worst that can happen is that we fail the read..
>>
>> Ugh on the ptr arith, one wonders how many stupid bugs one can make in
>> such a piece of code... :/
>>
>>> signed-of-by Ian Schram <ischram@telenet.be>
>> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Ian, you meant Signed-off-by, not signed-of-by, right?
> 

exactly right, *shame*, apologies for the extra work for this one line
drive-by patch.

> 	Ingo
> 
> 
