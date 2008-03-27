Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbYC0W3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbYC0W3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbYC0W3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:29:09 -0400
Received: from mail.tmr.com ([64.65.253.246]:51377 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbYC0W3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:29:08 -0400
Message-ID: <47EC1FC0.7040405@tmr.com>
Date: Thu, 27 Mar 2008 18:29:20 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Manfred Spraul <manfred@colorfullife.com>, paulmck@linux.vnet.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>	 <47E3B924.3000304@colorfullife.com>	 <20080321141339.GB9618@linux.vnet.ibm.com>	 <47E3DD8C.4000904@colorfullife.com> <1206164608.3659.11.camel@marge.simson.net>
In-Reply-To: <1206164608.3659.11.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Fri, 2008-03-21 at 17:08 +0100, Manfred Spraul wrote: 
>> Paul E. McKenney wrote:
>>> I could give it a spin -- though I would need to be pointed to the
>>> patch and the test.
>>>
>>>   
>> I'd just compare a recent kernel with something older, pre Fri Oct 19 
>> 11:53:44 2007
>>
>> Then download ctxbench, run one instance on each core, bound with taskset.
>> http://www.tmr.com/%7Epublic/source/
>> (I don't juse ctxbench myself, if it doesn't work then I could post my 
>> own app. It would be i386 only with RDTSCs inside)
> 
> (test gizmos are always welcome)
> 
> Results for Q6600 box don't look particularly wonderful.
> 
> taskset -c 3 ./ctx -s 
> 
> 2.6.24.3
> 3766962 itterations in 9.999845 seconds = 376734/sec
> 
> 2.6.22.18-cfs-v24.1
> 4375920 itterations in 10.006199 seconds = 437330/sec
> 
> for i in 0 1 2 3; do taskset -c $i ./ctx -s& done
> 
> 2.6.22.18-cfs-v24.1
> 4355784 itterations in 10.005670 seconds = 435361/sec
> 4396033 itterations in 10.005686 seconds = 439384/sec
> 4390027 itterations in 10.006511 seconds = 438739/sec
> 4383906 itterations in 10.006834 seconds = 438128/sec
> 
> 2.6.24.3
> 1269937 itterations in 9.999757 seconds = 127006/sec
> 1266723 itterations in 9.999663 seconds = 126685/sec
> 1267293 itterations in 9.999348 seconds = 126742/sec
> 1265793 itterations in 9.999766 seconds = 126592/sec
> 
Glad to see that ctxbench is still useful, I think there's a more recent 
version I haven't put up, which uses threads rather than processes, but 
there were similar values generated, so I somewhat lost interest. There 
was a "round robin" feature to pass the token through more processes, 
again I didn't find more use for the data.

I never tried binding the process to a CPU, in general the affinity code 
puts one process per CPU under light load, and limits the context switch 
overhead. It looks as if you are testing only the single CPU (or core) case.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
