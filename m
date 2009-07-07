Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZGGMxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZGGMxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZGGMxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:53:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbZGGMxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:53:42 -0400
Message-ID: <4A5345E9.6050502@redhat.com>
Date: Tue, 07 Jul 2009 15:56:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A533C4C.7020202@novell.com> <20090707124810.GD3647@redhat.com>
In-Reply-To: <20090707124810.GD3647@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 03:48 PM, Michael S. Tsirkin wrote:
>>>> +
>>>> +		__kvm_io_bus_unregister_dev(bus,&p->dev);
>>>> +		iosignalfd_release(p);
>>>>
>>>>          
>>> a single deassign removed multiple irqfds? Looks ugly.
>>>
>>>        
>> Avi requested this general concept.
>>      
>
> Really? Avi, could you explain? I would think each
> assign needs to be matched with 1 deassign. No?
>    

Doesn't it follow naturally?  How can a single deassign remove multiple 
fds (unless all were registered with exactly the same arguments)?

Maybe we should instead detect that the duplicate iosignaldfds are 
registered.

Note that we do need to allow the same fd to be multiple times, but not 
with exactly the same address/match etc.

-- 
error compiling committee.c: too many arguments to function

