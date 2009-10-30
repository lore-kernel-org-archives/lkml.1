Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZJ3ANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZJ3ANt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZJ3ANs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:13:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33358 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZJ3ANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:13:48 -0400
Message-ID: <4AEA2FB9.6060305@linux.vnet.ibm.com>
Date: Thu, 29 Oct 2009 17:13:45 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, paulus@au1.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_events: zero time running and enabled, but non-zero count
References: <4AE20102.8010002@linux.vnet.ibm.com> <20091023193246.GA3139@elte.hu> <4AE21655.6040403@linux.vnet.ibm.com> <20091023205711.GB8356@elte.hu> <4AE50B55.4070706@linux.vnet.ibm.com>
In-Reply-To: <4AE50B55.4070706@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone had a chance to look at this test case yet?

Regards,

- Corey

Corey Ashford wrote:
> On 10/23/2009 01:57 PM, Ingo Molnar wrote:
>>
>> * Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
>>
>>>> Btw., you might want to consider putting such testcases into a new
>>>> 'perf test' kind of utility (under tools/perf/builtin-test.c) that
>>>> does various tests such as reading a count and validating the
>>>> time-running/time-enabled values - so that we can see any bugs
>>>> directly.
>>>
>>> I'll see if I can put the test case in some sort of acceptable format
>>> like that.  Maybe we can use this one test case as the starting point
>>> for builtin-test.c.
>>
>> Yeah. Feel free to add just something minimal that solves your problem.
>> Others will add their testcases too i'm sure, once the basic command is
>> there.
>>
>>     Ingo
> 
> Hi Ingo and Paul,
> 
> I followed the directions Ingo provided for getting the -tip tree and 
> then attempted to build the perf tool that's in it and it doesn't build. 
>  I'm getting this error on a Power5 box:
> 
> ../../lib/find_next_bit.c: In function ‘ext2_swabp’:
> ../../lib/find_next_bit.c:168: warning: passing argument 1 of 
> ‘__swab64p’ from incompatible pointer type
> make: *** [util/find_next_bit.o] Error 1
> 
> I looked at the code and it looks ok to me.  There's a cast from an 
> "unsigned long *" to a "unsigned long long *", but those types should be 
> of the same size (in -m64 mode), so I don't know why this is failing.
> 
> Some good news is that I have created a simple test case which 
> demonstrates the bug, but I haven't formulated it in the builtin-test.c 
> format yet, since I have been able to build perf.
> 
> If you toss the attached file into the perf source directory and compile 
> it as follows:
> 
> gcc -m64 -o petb perf_events_time_bug.c -lrt
> 
> it will show the error:
> % ./petb
> [0] = 1
> [1] = 0 <- time enabled
> [2] = 0 <- time running
> [3] = 4559d1f8
> [4] = 1
> test failed!
> 
> perf_events_time_bug.c -lrt
> 
> If you compile it with:
> 
> gcc -DDO_DISABLE -m66 -o petb perf_events_time_bug.c -lrt
> 
> This will disable the event before reading it and then you will get the 
> correct times.
> 
> % ./petb
> [0] = 1
> [1] = 2a50c1c8 <- time enabled
> [2] = 2a50c1c8 <- time running
> [3] = 460dea97
> [4] = 2
> test passed!
> 

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

