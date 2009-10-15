Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbZJOO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbZJOO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762378AbZJOO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbZJOO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:59:24 -0400
Date: Thu, 15 Oct 2009 11:58:56 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
Message-ID: <20091015145855.GI8092@mothafucka.localdomain>
References: <1254849896-3947-1-git-send-email-glommer@redhat.com> <4AD2EE86.50807@redhat.com> <20091013122828.GZ8092@mothafucka.localdomain> <4AD4730C.9010305@redhat.com> <20091013124638.GC8092@mothafucka.localdomain> <4AD670FC.7010004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD670FC.7010004@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 09:46:52AM +0900, Avi Kivity wrote:
> On 10/13/2009 09:46 PM, Glauber Costa wrote:
>> On Tue, Oct 13, 2009 at 03:31:08PM +0300, Avi Kivity wrote:
>>    
>>> On 10/13/2009 03:28 PM, Glauber Costa wrote:
>>>      
>>>>        
>>>>> Do we want an absolute or relative adjustment?
>>>>>
>>>>>          
>>>> What exactly do you mean?
>>>>
>>>>        
>>> Absolute adjustment: clock = t
>>> Relative adjustment: clock += t
>>>      
>> The delta is absolute, but the adjustment in the clock is relative.
>>
>> So we pick the difference between what userspace is passing us and what
>> we currently have, then relatively adds up so we can make sure we won't
>> go back or suffer a too big skew.
>>    
>
> The motivation for relative adjustment is when you have a jitter  
> resistant place to gather timing information (like the kernel, which can  
> disable interrupts and preemption), then pass it on to kvm without  
> losing information due to scheduling.  For migration there is no such  
> place since it involves two hosts, but it makes sense to support  
> relative adjustments.
Since we added the padding you asked for, we could use that bit of information
to define whether it will be a relative or absolute adjustment, then. Right now,
I don't see the point of implementing a code path that will be completely untested.

I'd leave it this way until someone comes up with a need.
