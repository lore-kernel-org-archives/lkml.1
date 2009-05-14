Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbZENMXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbZENMXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZENMWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:22:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZENMWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:22:49 -0400
Message-ID: <4A0C0D17.2060401@redhat.com>
Date: Thu, 14 May 2009 15:22:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 3/3] kvm: add iofd support
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182701.26131.66801.stgit@dev.haskins.net> <4A0BFC56.9090601@redhat.com> <4A0C084F.3040706@novell.com>
In-Reply-To: <4A0C084F.3040706@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>> +#define KVM_IOFD_FLAG_PIO       (1 << 1)
>>> +
>>> +struct kvm_iofd {
>>> +    __u64 addr;
>>> +    __u32 len;
>>> +    __u32 fd;
>>> +    __u32 flags;
>>> +    __u8  pad[12];
>>> +};
>>> +
>>>   
>>>       
>> Please add a data match capability.  virtio uses a write with the data
>> containing the queue ID, and we want a separate event for each queue.
>>     
>
> How about "u64 cookie" ?
>   

Sure, and a bit in flags to enable it.

>>>   * kvm trace categories
>>> @@ -508,6 +519,7 @@ struct kvm_irqfd {
>>>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct
>>> kvm_assigned_irq)
>>>  #define KVM_ASSIGN_IRQFD           _IOW(KVMIO, 0x76, struct kvm_irqfd)
>>>  #define KVM_DEASSIGN_IRQFD         _IOW(KVMIO, 0x77, __u32)
>>> +#define KVM_IOFD                   _IOW(KVMIO, 0x78, struct kvm_iofd)
>>>   
>>>       
>> Too general a name.  It's not doing IO, just sending out notifications.
>>     
>
> Hmm...good point.  I was trying to reflect "[MM/P]IO-FD".  How about
> "IOSIGNALFD"
>   

Okay.

>> Why have assign/deassign for irqfd and a single ioctl for iofd?
>>     
> Heh..  irqfd "liked" two because the deassign only needed a u32.  iofd
> needed more or less the same structure for both so I guess I thought I
> would be "slick" and condense the vectors.  Will fix so they are
> symmetrical.
>   

Yeah.  You could have both use just one, or both use two.  Not sure 
which is better.

-- 
error compiling committee.c: too many arguments to function

