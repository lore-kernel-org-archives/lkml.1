Return-Path: <linux-kernel-owner+w=401wt.eu-S1751619AbZH0LEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbZH0LEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZH0LEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZH0LEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:04:30 -0400
Message-ID: <4A966833.2090404@redhat.com>
Date: Thu, 27 Aug 2009 14:04:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@lst.de>, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
References: <20090820205616.GA5503@lst.de> <200908262136.46570.rusty@rustcorp.com.au> <4A952A5D.5040606@redhat.com> <200908272013.50839.rusty@rustcorp.com.au>
In-Reply-To: <200908272013.50839.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 01:43 PM, Rusty Russell wrote:
>
>>> Are you claiming qcow2 is unusual?  I can believe snapshot is less common,
>>> though I use it all the time.
>>>
>>> You'd normally have to add a feature for something like this.  I don't
>>> think this is different.
>>>        
>> Why do we need to add a feature for this?
>>      
> Because cache=writeback should *not* lie to the guest?
>
>    

No, it should.

There are two possible semantics to cache=writeback:

- simulate a drive with a huge write cache; use fsync() to implement 
barriers
- tell the host that we aren't interested in data integrity, lie to the 
guest to get best performance

The first semantic is not very useful; guests don't expect huge write 
caches so you can't be sure of your integrity guarantees, and it's 
slower than cache=none due to double caching and extra copies.  The 
second semantic is not useful for production, but is very useful for 
testing out things where you aren't worries about host crashes and 
you're usually rebooting the guest very often (you can't rely on guest 
caches, so you want the host to cache).

-- 
error compiling committee.c: too many arguments to function

