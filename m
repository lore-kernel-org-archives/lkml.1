Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbZENMUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbZENMUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZENMUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:20:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55684 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbZENMUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:20:39 -0400
Message-ID: <4A0C0C96.6050600@redhat.com>
Date: Thu, 14 May 2009 15:20:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net> <4A0BE8CA.7080801@redhat.com> <4A0C060D.2060107@novell.com>
In-Reply-To: <4A0C060D.2060107@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> Please fget() the new fd and compare the filps; fds aren't meaningful
>> in the kernel.  You can also drop _irqfd::fd.
>>     
>
> I like this as a second option...
>
>   
>> It may also be useful to compare the gsi, this allows a
>> "make-before-break" switchover:
>>     
>
> ...but I like this best.  Good idea.
>   

I thought of comparing both.

>> - guest reroutes irq to a different gsi
>> - associate irqfd with new gsi
>> - disassociate irqfd from old gsi
>>
>>     
>>> +
>>> +        irqfd_release(irqfd);
>>> +        mutex_unlock(&kvm->lock);
>>> +        return 0;
>>>   
>>>       
>> Don't return, userspace may have multiple associations?
>>     
>
> Parse error.  Can you elaborate?
>
>   

You break out of the look when you match your irqfd.  But there may be 
multiple matches.

Granted, it doesn't make much sense to hook the same fd to the same gsi 
multiple times (it may make sense to hook multiple fds to a single gsi, 
or maybe a single fd to multiple gsis), but it pays to have a consistent 
do-what-I-said-even-if-it-doesn't-make-sense interface.

-- 
error compiling committee.c: too many arguments to function

