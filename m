Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZFWLXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZFWLXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZFWLXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:23:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZFWLXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:23:41 -0400
Message-ID: <4A40BB73.600@redhat.com>
Date: Tue, 23 Jun 2009 14:24:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090623085633.GA16294@redhat.com> <4A40A721.3020901@redhat.com> <20090623104812.GB17635@redhat.com>
In-Reply-To: <20090623104812.GB17635@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 01:48 PM, Michael S. Tsirkin wrote:
> On Tue, Jun 23, 2009 at 12:57:53PM +0300, Avi Kivity wrote:
>    
>> On 06/23/2009 11:56 AM, Michael S. Tsirkin wrote:
>>      
>>> On Thu, Jun 18, 2009 at 08:30:46PM -0400, Gregory Haskins wrote:
>>>
>>>        
>>>> +static int
>>>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
>>>> +			  int is_write)
>>>> +{
>>>> +	struct _iosignalfd_group *p = to_group(this);
>>>> +
>>>> +	return ((addr>= p->addr&&   (addr<   p->addr + p->length)));
>>>> +}
>>>>
>>>>          
>>> I think I see a problem here. For virtio, we do not necessarily want all
>>> virtqueues for a device to live in kernel: there might be control
>>> virtqueues that we want to leave in userspace. Since this claims all
>>> writes to a specific address, the signal never makes it to userspace.
>>>
>>>        
>> Userspace could create an eventfd for this control queue and wait for it
>> to fire.
>>      
>
> What if guest writes an unexpected value there?
> The value it simply lost ... that's not very elegant.
>    

True, it's better to have a lossless interface.

-- 
error compiling committee.c: too many arguments to function

