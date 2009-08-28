Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZH1Gdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZH1Gdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZH1Gdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZH1Gdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:33:41 -0400
Message-ID: <4A977A41.1070101@redhat.com>
Date: Fri, 28 Aug 2009 09:33:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@lst.de>, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
References: <20090820205616.GA5503@lst.de> <200908272013.50839.rusty@rustcorp.com.au> <4A966833.2090404@redhat.com> <200908281045.27333.rusty@rustcorp.com.au>
In-Reply-To: <200908281045.27333.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 04:15 AM, Rusty Russell wrote:
> On Thu, 27 Aug 2009 08:34:19 pm Avi Kivity wrote:
>    
>> There are two possible semantics to cache=writeback:
>>
>> - simulate a drive with a huge write cache; use fsync() to implement
>> barriers
>> - tell the host that we aren't interested in data integrity, lie to the
>> guest to get best performance
>>      
> Why lie to the guest?  Just say we're not ordered, and don't support barriers.
> Gets even *better* performance since it won't drain the queues.
>    

In that case, honesty is preferable.  It means testing with 
cache=writeback exercises different guest code paths, but that's acceptable.

> Maybe you're thinking of full virtualization where we guest ignorance is
> bliss.  But lying always gets us in trouble later on when other cases come
> up.
>
>    
>> The second semantic is not useful for production, but is very useful for
>> testing out things where you aren't worries about host crashes and
>> you're usually rebooting the guest very often (you can't rely on guest
>> caches, so you want the host to cache).
>>      
> This is not the ideal world; people will do things for performance "in
> production".
>
>    

We found that cache=none is faster than cache=writeback when you're 
really interested in performance (no qcow2).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

