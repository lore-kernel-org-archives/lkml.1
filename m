Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbZJOArW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbZJOArW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761730AbZJOArV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762208AbZJOArV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:47:21 -0400
Message-ID: <4AD670FC.7010004@redhat.com>
Date: Thu, 15 Oct 2009 09:46:52 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
References: <1254849896-3947-1-git-send-email-glommer@redhat.com> <4AD2EE86.50807@redhat.com> <20091013122828.GZ8092@mothafucka.localdomain> <4AD4730C.9010305@redhat.com> <20091013124638.GC8092@mothafucka.localdomain>
In-Reply-To: <20091013124638.GC8092@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 09:46 PM, Glauber Costa wrote:
> On Tue, Oct 13, 2009 at 03:31:08PM +0300, Avi Kivity wrote:
>    
>> On 10/13/2009 03:28 PM, Glauber Costa wrote:
>>      
>>>        
>>>> Do we want an absolute or relative adjustment?
>>>>
>>>>          
>>> What exactly do you mean?
>>>
>>>        
>> Absolute adjustment: clock = t
>> Relative adjustment: clock += t
>>      
> The delta is absolute, but the adjustment in the clock is relative.
>
> So we pick the difference between what userspace is passing us and what
> we currently have, then relatively adds up so we can make sure we won't
> go back or suffer a too big skew.
>    

The motivation for relative adjustment is when you have a jitter 
resistant place to gather timing information (like the kernel, which can 
disable interrupts and preemption), then pass it on to kvm without 
losing information due to scheduling.  For migration there is no such 
place since it involves two hosts, but it makes sense to support 
relative adjustments.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

