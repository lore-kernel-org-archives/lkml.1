Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZJMM26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZJMM26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZJMM26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:28:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZJMM25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:28:57 -0400
Date: Tue, 13 Oct 2009 09:28:28 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
Message-ID: <20091013122828.GZ8092@mothafucka.localdomain>
References: <1254849896-3947-1-git-send-email-glommer@redhat.com> <4AD2EE86.50807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD2EE86.50807@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:53:26AM +0200, Avi Kivity wrote:
> On 10/06/2009 07:24 PM, Glauber Costa wrote:
>> When we migrate a kvm guest that uses pvclock between two hosts, we may
>> suffer a large skew. This is because there can be significant differences
>> between the monotonic clock of the hosts involved. When a new host with
>> a much larger monotonic time starts running the guest, the view of time
>> will be significantly impacted.
>>
>> Situation is much worse when we do the opposite, and migrate to a host with
>> a smaller monotonic clock.
>>
>> This new proposed ioctl will allow userspace to inform us what is the monotonic
>> clock value in the source host, so we can keep the time skew short, and more
>> importantly, never goes backwards.
>>
>>    
>
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index f8f8900..0cd5ad8 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -546,6 +546,7 @@ struct kvm_irqfd {
>>   #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
>>   #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
>>   #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
>> +#define KVM_ADJUST_CLOCK	  _IOW(KVMIO, 0x7a, __u64)
>>    
>
> Please change to a struct with some reserved space.
Ok, can do it.
 
>
> Do we want an absolute or relative adjustment?
What exactly do you mean?
