Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbZHZM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbZHZM2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbZHZM2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbZHZM2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:28:46 -0400
Message-ID: <4A952A5D.5040606@redhat.com>
Date: Wed, 26 Aug 2009 15:28:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@lst.de>, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
References: <20090820205616.GA5503@lst.de> <200908252341.38356.rusty@rustcorp.com.au> <20090825141608.GA32658@lst.de> <200908262136.46570.rusty@rustcorp.com.au>
In-Reply-To: <200908262136.46570.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 03:06 PM, Rusty Russell wrote:
> On Tue, 25 Aug 2009 11:46:08 pm Christoph Hellwig wrote:
>    
>> On Tue, Aug 25, 2009 at 11:41:37PM +0930, Rusty Russell wrote:
>>      
>>> On Fri, 21 Aug 2009 06:26:16 am Christoph Hellwig wrote:
>>>        
>>>> Currently virtio-blk doesn't set any QUEUE_ORDERED_ flag by default, which
>>>> means it does not allow filesystems to use barriers.  But the typical use
>>>> case for virtio-blk is to use a backed that uses synchronous I/O
>>>>          
>>> Really?  Does qemu open with O_SYNC?
>>>
>>> I'm definitely no block expert, but this seems strange...
>>> Rusty.
>>>        
>> Qemu can open it various ways, but the only one that is fully safe
>> is O_SYNC (cache=writethrough).
>>      
> (Rusty goes away and reads the qemu man page).
>
> 	By default, if no explicit caching is specified for a qcow2 disk image,
> 	cache=writeback will be used.
>    

It's now switched to writethrough.  In any case, cache=writeback means 
"lie to the guest, we don't care about integrity".

> Are you claiming qcow2 is unusual?  I can believe snapshot is less common,
> though I use it all the time.
>
> You'd normally have to add a feature for something like this.  I don't
> think this is different.
>    

Why do we need to add a feature for this?

-- 
error compiling committee.c: too many arguments to function

