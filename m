Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbZKKAIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbZKKAIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbZKKAH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:07:59 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:46449 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbZKKAH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:07:58 -0500
Message-ID: <4AFA005C.7020607@us.ibm.com>
Date: Tue, 10 Nov 2009 18:07:56 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: agl@linux.vnet.ibm.com, qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
References: <1257782838.2835.5.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au>	<4AF9E0AA.8040100@us.ibm.com> <200911111032.14956.rusty@rustcorp.com.au>
In-Reply-To: <200911111032.14956.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 11 Nov 2009 08:22:42 am Anthony Liguori wrote:
>   
>> Rusty Russell wrote:
>>     
>>> On Tue, 10 Nov 2009 03:02:06 am Adam Litke wrote:
>>>   
>>>       
>>>> A simpler approach is to collect memory statistics in the virtio
>>>> balloon driver and communicate them to the host via the device config space.
>>>>     
>>>>         
>>> There are two issues I see with this.  First, there's an atomicity problem
>>> since you can't tell when the stats are consistent.  Second, polling is
>>> ugly.
>>>
>>> A stats vq might solve this more cleanly?
>>>   
>>>       
>> This turns out to not work so nicely.  You really need bidirectional 
>> communication.  You need to request that stats be collected and then you 
>> need to tell the hypervisor about the stats that were collected.  You 
>> don't need any real correlation between requests and stat reports either.
>>     
>
> You register an outbuf at initialization time.  The host hands it back when
> it wants you to refill it with stats.
>   

That's strangely backwards.  Guest send a stat buffer that's filled out, 
host acks it when it wants another.  That doesn't seem bizarre to you?

>> This really models how target/actual work and I think it suggests that 
>> we want to reuse that mechanism for the stats too.
>>     
>
> Sure, I want to.  You want to.  It's simple.
>
> But the universe is remarkably indifferent to what we want.  Is it actually
> sufficient or are we going to regret our laziness?
>   

It's not laziness, it's consistency.  How is actual different than free 
memory or any other stat?

> Cheers,
> Rusty.
>   


-- 
Regards,

Anthony Liguori

