Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZHaV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZHaV5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZHaV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 17:57:00 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59077 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZHaV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 17:56:59 -0400
Message-ID: <4A9C4723.5080309@codemonkey.ws>
Date: Mon, 31 Aug 2009 16:56:51 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Xin, Xiaohui" <xiaohui.xin@intel.com>, "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "gregory.haskins@gmail.com" <gregory.haskins@gmail.com>
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <E88DD564E9DC5446A76B2B47C3BCCA150219600F9B@pdsmsx503.ccr.corp.intel.com> <C85CEDA13AB1CF4D9D597824A86D2B9006AEB944B8@PDSMSX501.ccr.corp.intel.com> <4A9C0DC2.6080704@redhat.com>
In-Reply-To: <4A9C0DC2.6080704@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 08/31/2009 02:42 PM, Xin, Xiaohui wrote:
>> Hi, Michael
>> That's a great job. We are now working on support VMDq on KVM, and 
>> since the VMDq hardware presents L2 sorting based on MAC addresses 
>> and VLAN tags, our target is to implement a zero copy solution using 
>> VMDq. We stared from the virtio-net architecture. What we want to 
>> proposal is to use AIO combined with direct I/O:
>> 1) Modify virtio-net Backend service in Qemu to submit aio requests 
>> composed from virtqueue.
>> 2) Modify TUN/TAP device to support aio operations and the user space 
>> buffer directly mapping into the host kernel.
>> 3) Let a TUN/TAP device binds to single rx/tx queue from the NIC.
>> 4) Modify the net_dev and skb structure to permit allocated skb to 
>> use user space directly mapped payload buffer address rather then 
>> kernel allocated.
>>
>> As zero copy is also your goal, we are interested in what's in your 
>> mind, and would like to collaborate with you if possible.
>>    
>
> One way to share the effort is to make vmdq queues available as normal 
> kernel interfaces.

It may be possible to make vmdq appear like an sr-iov capable device 
from userspace.  sr-iov provides the userspace interfaces to allocate 
interfaces and assign mac addresses.  To make it useful, you would have 
to handle tx multiplexing in the driver but that would be much easier to 
consume for kvm.

Regards,

Anthony Liguori
