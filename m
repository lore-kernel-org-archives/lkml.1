Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZJLJf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZJLJf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZJLJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbZJLJf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:35:27 -0400
Message-ID: <4AD2F83F.2020604@redhat.com>
Date: Mon, 12 Oct 2009 11:34:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] KVM: SVM: Notify nested hypervisor of lost event
 injections
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com> <1254996199-17667-2-git-send-email-joerg.roedel@amd.com> <4ACE0F6C.3060103@redhat.com> <20091008162222.GG14073@amd.com> <4ACE127A.6040304@redhat.com> <20091008163234.GJ14073@amd.com> <4ACE1598.6050200@redhat.com> <56DA32E3-04B4-4B4E-B364-1174AE4E3E50@suse.de>
In-Reply-To: <56DA32E3-04B4-4B4E-B364-1174AE4E3E50@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 06:46 PM, Alexander Graf wrote:
>
>
> Am 08.10.2009 um 18:38 schrieb Avi Kivity <avi@redhat.com>:
>
>> On 10/08/2009 06:32 PM, Joerg Roedel wrote:
>>> No. The L1 guest needs to execute VMRUN with an interrupt to inject to
>>> the L2 guest with event_inj. On that VMRUN instruction emulation an
>>> interrupt becomes pending which causes an immediate #vmexit from L2 to
>>> L2 again without even entering the L2 guest. The bug was that in this
>>> case the event which the L1 tried to inject in the L2 was lost because
>>> it was not copied to exit_int_info.
>>>
>>
>> (from L1 to L0?)
>>
>> Wow.  Alex, how did you find this?
>
> Hyper-V got stuck and I was trying to think of possible reasons 
> looking at the logs :-).
> Fortunately this patch also seemed to make things work better with KVM 
> in KVM.
>
> Doesn't really help with regression testing though...

We could write a dummy hypervisor that injects tons of interrupts and 
hope for a host interrupt in there.  I'm worried about such a mass of 
complex code that gets very little testing.

-- 
error compiling committee.c: too many arguments to function

