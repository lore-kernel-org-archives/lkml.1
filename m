Return-Path: <linux-kernel-owner+w=401wt.eu-S1751313AbZL0Jad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbZL0Jad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 04:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZL0Jac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 04:30:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZL0Jaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 04:30:30 -0500
Message-ID: <4B372912.9050704@redhat.com>
Date: Sun, 27 Dec 2009 11:29:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <4B3248F9.5030504@gmail.com> <4B327F3A.9020101@redhat.com> <4B3334E1.9020401@gmail.com>
In-Reply-To: <4B3334E1.9020401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2009 11:31 AM, Gregory Haskins wrote:
> On 12/23/09 3:36 PM, Avi Kivity wrote:
>    
>> On 12/23/2009 06:44 PM, Gregory Haskins wrote:
>>      
>>>        
>>>>    - Are a pure software concept
>>>>
>>>>          
>>> By design.  In fact, I would describe it as "software to software
>>> optimized" as opposed to trying to shoehorn into something that was
>>> designed as a software-to-hardware interface (and therefore has
>>> assumptions about the constraints in that environment that are not
>>> applicable in software-only).
>>>
>>>
>>>        
>> And that's the biggest mistake you can make.
>>      
> Sorry, that is just wrong or you wouldn't have virtio either.
>    

Things are not black and white.  I prefer not to have paravirtualization 
at all.  When there is no alternative, I prefer to limit it to the 
device level and keep it off the bus level.

>>   Look at Xen, for
>> instance.  The paravirtualized the fork out of everything that moved in
>> order to get x86 virt going.  And where are they now? x86_64 syscalls
>> are slow since they have to trap to the hypervisor and (partially) flush
>> the tlb.  With npt or ept capable hosts performance is better for many
>> workloads on fullvirt.  And paravirt doesn't support Windows.  Their
>> unsung hero Jeremy is still trying to upstream dom0 Xen support.  And
>> they get to support it forever.
>>      
> We are only talking about PV-IO here, so not apples to apples to what
> Xen is going through.
>    

The same principles apply.

>> VMware stuck with the hardware defined interfaces.  Sure they had to
>> implement binary translation to get there, but as a result, they only
>> have to support one interface, all guests support it, and they can drop
>> it on newer hosts where it doesn't give them anything.
>>      
> Again, you are confusing PV-IO.  Not relevant here.   Afaict, vmware,
> kvm, xen, etc, all still do PV-IO and likely will for the foreseeable
> future.
>    

They're all doing it very differently:

- pure emulation (qemu e1000, etc.)
- pci device (vmware, virtio/pci)
- paravirt bus bridged through a pci device (Xen hvm, Hyper-V (I think), 
venet/vbus)
- paravirt bus (Xen pv, early vbus, virtio/lguest, virtio/s390)

The higher you are up this scale the easier things are, so once you get 
reasonable performance there is no need to descend further.

-- 
error compiling committee.c: too many arguments to function

