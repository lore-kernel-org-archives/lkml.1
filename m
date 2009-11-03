Return-Path: <linux-kernel-owner+w=401wt.eu-S1750862AbZKCFMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862AbZKCFMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZKCFMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:12:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZKCFMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:12:35 -0500
Message-ID: <4AEFBBA2.4040907@redhat.com>
Date: Tue, 03 Nov 2009 07:12:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <78f9bb94-fb5d-4fe7-b20f-774bb14e360f@default>
In-Reply-To: <78f9bb94-fb5d-4fe7-b20f-774bb14e360f@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 05:46 PM, Dan Magenheimer wrote:
>>> I don't have any public data available for this DB usage,
>>>        
>> Sorry, that doesn't explain anything.
>>      
> Well for now just consider the DB usage as another use
> of profiling.  But one can easily draw scenarios where
> a monotonic timestamp is also used to guarantee transaction
> ordering.
>    

In this case we should provide a facility for this.  Providing a global 
monotonic counter may be easier than providing a monotonic clock.  Hence 
my question.

>>> Search for "flight recorder".  This feature is intended to
>>> be enabled all the time, but with non-vsyscall gettimeofday
>>> the performance impact is unacceptably high, so they are using
>>>        
>> For profiling work fast timestamping is of course great, but surely
>> there is no monotonicity requirement?
>>      
> Yes and no.  Monotonicity is a poor substitute for a more
> generic mechanism that might provide an indication that a
> discontinuity has occurred (forward or backward); if an app
> could get both the timestamp AND some kind of "continuity
> generation counter" (basically a much more sophisticated
> form of TSC_AUX that changes whenever the timestamp is
> coming from a different source), perhaps all problems could be solved.
>    

I doubt it.  A discontinuity has occured, but what do we know about it?  
nothing.

>> I don't think we'll be able to provide monotonicity with vsyscall on
>> tsc-broken hosts, so we'll be limited to correcting the tsc frequency
>> after migration for good-tsc hosts.
>>      
> True, though clock_gettime(CLOCK_MONOTONIC) can provide
> the monotonicity where it is required.
>    

We have that already.  The question is how to implement it in a vsyscall.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

