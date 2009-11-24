Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbZKXOge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbZKXOge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933022AbZKXOga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:36:30 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63616 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbZKXOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:36:29 -0500
Message-ID: <4B0BEF70.5070104@codemonkey.ws>
Date: Tue, 24 Nov 2009 08:36:32 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Shirley Ma <mashirle@us.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers and
 big packets in virtio_net
References: <1258697745.7416.20.camel@localhost.localdomain> <200911231138.30755.rusty@rustcorp.com.au> <1258992421.5022.19.camel@localhost.localdomain> <200911240854.24054.rusty@rustcorp.com.au> <20091124113754.GB2405@redhat.com>
In-Reply-To: <20091124113754.GB2405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> On Tue, Nov 24, 2009 at 08:54:23AM +1030, Rusty Russell wrote:
>   
>> On Tue, 24 Nov 2009 02:37:01 am Shirley Ma wrote:
>>     
>>>>> +             skb = (struct sk_buff *)buf;
>>>>>           
>>>> This cast is unnecessary, but a comment would be nice:
>>>>         
>>> Without this cast there is a compile warning. 
>>>       
>> Hi Shirley,
>>
>>    Looks like buf is a void *, so no cast should be necessary.  But I could
>> be reading the patch wrong.
>>
>>     
>>>> However, I question whether making it 16 byte is the right thing: the
>>>> ethernet header is 14 bytes long, so don't we want 8 bytes of padding?
>>>>         
>>> Because in QEMU it requires 10 bytes header in a separately, so one page
>>> is used to share between virtio_net_hdr header which is 10 bytes head
>>> and rest of data. So I put 6 bytes offset here between two buffers. I
>>> didn't look at the reason why a seperate buf is used for virtio_net_hdr
>>> in QEMU.
>>>       
>> It's a qemu bug.  It insists the header be an element in the scatterlist by
>> itself.  Unfortunately we have to accommodate it.
>>     
>
> We do?  Let's just fix this?
>   

So does lguest.  It's been that way since the beginning.  Fixing this 
would result in breaking older guests.

We really need to introduce a feature bit if we want to change this.

Regards,

Anthony Liguori
