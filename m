Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZETJSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZETJSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZETJR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:17:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbZETJR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:17:57 -0400
Message-ID: <4A13CABB.9010000@redhat.com>
Date: Wed, 20 May 2009 12:17:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com>	 <200905071000.14038.mark.langsdorf@amd.com>	 <200905081203.55484.mark.langsdorf@amd.com>	 <200905191356.37071.mark.langsdorf@amd.com>	 <1242806386.26820.549.camel@twins>  <4A13C199.5020400@redhat.com>	 <1242808954.26820.556.camel@twins>  <4A13C40B.8080608@redhat.com>	 <1242809657.26820.559.camel@twins>  <4A13C7B0.10507@redhat.com> <1242810616.26820.562.camel@twins>
In-Reply-To: <1242810616.26820.562.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>>> It's a fully virtualized guest.  There's no way to get this without 
>>>> patching the guest kernel.
>>>>     
>>>>         
>>> Yes there is.. virtualized monitor-wait stuff coupled with a
>>> monitor-wait based spinlock implementation.
>>>   
>>>       
>> That only works if the guest uses monitor/mwait.  Not all of the guests 
>> are under our control.  I don't know whether Windows uses 
>> monitor/mwait.  Further, we don't have timed exits on mwait like we do 
>> with pause.
>>     
>
> Ugh, you really care about crap like windows?
>   

Yes, it is used by my users.  Either we convince them not to use 
Windows, or we find a way to support it well.

>> I've also heard that monitor/mwait are very slow and only usable on idle 
>> loop stuff.
>>     
>
> Yeah, current implementations suck, doesn't mean it has to stay that
> way.
>   

Well, I'm not speculating on future cpu changes.  I'd like to support 
current and near-future software and hardware, not how it should have 
been done software running on how it should have been done hardware.

>>> Once we go change silicon, you might as well do it right.
>>>   
>>>       
>> None of the major x86 vendors are under my control.
>>     
>
> I thought this patch came from AMD, who changed their silicon so 'solve'
> one of these virt problems.
>   

They changed the silicon to support existing guests.  For both Linux and 
Windows, the pause instruction is the only indication the guest is spinning.

> /me goes hide again, and pretend all of virt doesn't exist :-) Think
> happy thoughts.
>   

You'll end up running permanently in a guest, with no way out.

-- 
error compiling committee.c: too many arguments to function

