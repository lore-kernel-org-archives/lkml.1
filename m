Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZFWJvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZFWJvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZFWJv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:51:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38923 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZFWJv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:51:26 -0400
Message-ID: <4A40A5D5.4080208@redhat.com>
Date: Tue, 23 Jun 2009 12:52:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com>
In-Reply-To: <20090622160833.GA15228@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 07:08 PM, Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 11:45:00AM -0400, Gregory Haskins wrote:
>    
>> Michael S. Tsirkin wrote:
>>      
>>> It seems that a lot of complexity and trickiness with iosignalfd is
>>> handling the group/item relationship, which comes about because kvm does
>>> not currently let a device on the bus claim a write transaction based on the
>>> value written.  This could be greatly simplified if the value written
>>> was passed to the in_range check for write operation.  We could then
>>> simply make each kvm_iosignalfd a device on the bus.
>>>
>>> What does everyone think of the following lightly tested patch?
>>>
>>>        
>> Hi Michael,
>>    Its interesting, but I am not convinced its necessary.  We created the
>> group/item layout because iosignalfds are unique in that they are
>> probably the only IO device that wants to do some kind of address
>> aliasing.
>>      
>
> We actually already have aliasing: is_write flag is used for this
> purpose. Actually, it's possible to remove is_write by passing
> a null pointer in write_val for reads. I like this a bit less as
> the code generated is less compact ... Avi, what do you think?
>    

Greg, won't Michael's patch eliminate a big chunk from your iosignalfd 
patches?  Seems like a win to me.

> One is enough :)
> Seriously, do you see that this saves you all of RCU, linked lists and
> counters? You don't need to keep track of iofds, you don't need to
> implement your own lookup logic - you just use the kvm device
> and that's it.
>
>    

Yup.

-- 
error compiling committee.c: too many arguments to function

