Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbYJWB1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbYJWB1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYJWB1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:27:14 -0400
Received: from dew2.atmos.washington.edu ([128.95.89.42]:60043 "EHLO
	dew2.atmos.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbYJWB1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:27:14 -0400
Message-ID: <48FFD2E4.6080000@atmos.washington.edu>
Date: Wed, 22 Oct 2008 18:27:00 -0700
From: Harry Edmon <harry@atmos.washington.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: SUNRPC problem with 2.6.26 and beyond - try again with response
 in correct place.
References: <48FF482F.5060002@atmos.washington.edu>	 <1224715874.7525.18.camel@localhost>	 <48FFAF6F.3040406@atmos.washington.edu> <1224718666.7525.30.camel@localhost>
In-Reply-To: <1224718666.7525.30.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.813 () BAYES_00,RDNS_DYNAMIC,SPF_NEUTRAL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Wed, 2008-10-22 at 15:55 -0700, Harry Edmon wrote:
>   
>> Trond Myklebust wrote:
>>     
>>> On Wed, 2008-10-22 at 08:35 -0700, Harry Edmon wrote:
>>>   
>>>       
>>>> I have a dual quad-core Xeon system running software 
>>>> (http://www.unidata.ucar.edu/software/ldm) that relays and processes 
>>>> weather data through RPC calls, keeping a queue of data in a memory 
>>>> mapped file.  Up until 2.6.26 the system has run just fine (for example 
>>>> 2.6.25.17).  But starting with 2.6.26 through 2.6.27.2 the system runs 
>>>> into a problem after approximately 24 hours.  The symptom is that the 
>>>> processing slows down to a crawl.  Using "top" I can see that the System 
>>>> time is up over 90%, with almost no User and Wait time.  If I stop and 
>>>> restart the software, most of the time it gets better - but sometimes it 
>>>> takes a reboot to fix the problem.  I have an identical system that does 
>>>> just processing and ingesting data from remote systems, and it does not 
>>>> have this problem.  I have tried a number of different kernel 
>>>> configurations, but they all show the same problem.
>>>>
>>>> I suspect a problem with SUNRPC.  I notice that there were a large 
>>>> number of SUNRPC patches in 2.6.26.  I am looking for suggestions on how 
>>>> to pin down which patches are causing the problem.  Are there ways to 
>>>> figure where in the  kernel the time is being spent?  I am will to work 
>>>> on isolating the problem, but I need some suggestions on the best way to 
>>>> do it given the large number of SUNRPC patches in 2.6.26 and the fact 
>>>> that each experiment takes a day.
>>>>     
>>>>         
>>> The kernel sunrpc interface is not exported to user land: the glibc code
>>> uses its own, entirely separate implementation of sunrpc.
>>>
>>> I cannot therefore see, how your application's RPC calls can be affected
>>> by kernel sunrpc changes.
>>>
>>> Cheers
>>>   Trond
>>>
>>>   
>>>       
>> Then how do you explain the the large system time used with 2.6.26 and 
>> beyond?  Is it some other patch I should be looking at?
>>     
>
> I'm not explaining it. I'm saying that nothing outside the kernel NFS
> and NLM code uses the kernel sunrpc implementation. Your userland RPC
> calls are using glibc's implementation of sunrpc. Those are unaffected
> by patches to the kernel sunrpc layer.
>
> If you are seeing a hang, then I suggest you start by using the strace
> utility to figure out which system call is actually involved.
>
> Cheers
>   Trond
>
>   
The problem is that it is not hanging.  The processes are running 
through a lot of systems calls.  It is just that the system time jumps 
up to over 95% on all 8 processors with 2.6.26 and beyond.  I never see 
that with 2.6.25.17.  I will try looking again and see if there are 
certain calls that are taking a lot of time.
