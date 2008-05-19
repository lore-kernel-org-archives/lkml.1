Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYESK0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYESK0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 06:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYESK0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 06:26:31 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:31547
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYESK0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 06:26:31 -0400
Message-ID: <483155D4.2090700@qumranet.com>
Date: Mon, 19 May 2008 13:26:28 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <200805190016.10823.rusty@rustcorp.com.au> <48303CB9.7070406@qumranet.com> <200805191152.28409.rusty@rustcorp.com.au>
In-Reply-To: <200805191152.28409.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> We should have thought of this before, though, especially as Xen does
>>
>> this or something very similar:
>>     
>>> /* Shared ring page */                            \
>>> struct __name##_sring {                            \
>>>     RING_IDX req_prod, req_event;                    \
>>>     RING_IDX rsp_prod, rsp_event;                    \
>>>     uint8_t  pad[48];                            \
>>>     union __name##_sring_entry ring[1]; /* variable-length */        \
>>> };                                    \
>>>       
>> req_event and rsp_event allow the other side to indicate when it wants a
>> notification.
>>     
>
> Well, we do have such a thing, in the ring suppression flags.

Can you point me at this?

>   Note that DaveM 
> is talking about moving network tx queue into the net drivers themselves, 
> which will make them much more efficient (ie. drain entire queue before 
> kick), which may again change the balance of what the Right Thing is.
>   

That depends on whether Linux knows whether more packets are coming.

-- 
error compiling committee.c: too many arguments to function

