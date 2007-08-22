Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXHVIhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXHVIhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXHVIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:37:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:49166 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbXHVIhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:37:36 -0400
Message-ID: <46CBF5DD.6040300@qumranet.com>
Date: Wed, 22 Aug 2007 11:37:49 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <46CBCC58.3010700@vmware.com>
In-Reply-To: <46CBCC58.3010700@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Avi Kivity wrote:
>> Zachary Amsden wrote:
>>  
>>> In general, I/O in a virtual guest is subject to performance
>>> problems.  The I/O can not be completed physically, but must be
>>> virtualized.  This means trapping and decoding port I/O instructions
>>> from the guest OS.  Not only is the trap for a #GP heavyweight, both
>>> in the processor and the hypervisor (which usually has a complex #GP
>>> path), but this forces the hypervisor to decode the individual
>>> instruction which has faulted.  Worse, even with hardware assist such
>>> as VT, the exit reason alone is not sufficient to determine the true
>>> nature of the faulting instruction, requiring a complex and costly
>>> instruction decode and simulation.
>>>
>>> This patch provides hypercalls for the i386 port I/O instructions,
>>> which vastly helps guests which use native-style drivers.  For certain
>>> VMI workloads, this provides a performance boost of up to 30%.  We
>>> expect KVM and lguest to be able to achieve similar gains on I/O
>>> intensive workloads.
>>>
>>>     
>>
>>
>> Won't these workloads be better off using paravirtualized drivers? 
>> i.e., do the native drivers with paravirt I/O instructions get anywhere
>> near the performance of paravirt drivers?
>>   
>
> Yes, in general, this is true (better off with paravirt drivers).  
> However, we have "paravirt" drivers which run in both 
> fully-paravirtualized and fully traditionally virtualized 
> environments.  As a result, they use native port I/O operations to 
> interact with virtual hardware.

Suffering from terminology overdose here: "fully traditionally 
virtualized, fully-paravirtuallized, para-fullyvirtualized".

Since this is only for newer kernels, won't updating the driver to use a 
hypercall be more efficient?  Or is this for existing out-of-tree drivers?

>
> Since not all hypervisors have paravirtualized driver infrastructures 
> and guest O/S support yet, these hypercalls can be advantages to a 
> wide range of scenarios.  Using I/O hypercalls as such gives exactly 
> the same performance as paravirt drivers for us, by eliminating the 
> costly decode path, and the simplicity of using the same driver code 
> makes this a huge win in code complexity.

Ah, seems the answer to the last question is yes.


-- 
error compiling committee.c: too many arguments to function

