Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXF0Sl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXF0Sl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbXF0SlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:41:19 -0400
Received: from gw.goop.org ([64.81.55.164]:49463 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbXF0SlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:41:18 -0400
Message-ID: <4682AF15.5040906@goop.org>
Date: Wed, 27 Jun 2007 14:40:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Tony Luck <tony.luck@intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: dma_mapping_ops for i386
References: <46817016.7090400@goop.org> <200706270021.11434.ak@suse.de> <468270F5.7040408@goop.org> <200706271726.51013.ak@suse.de>
In-Reply-To: <200706271726.51013.ak@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 27 June 2007 16:15:17 Jeremy Fitzhardinge wrote:
>   
>> Andi Kleen wrote:
>>     
>>> Ok, if you can do it without ifdefs. 
>>>   
>>>       
>> That should be OK.  All the existing i386 mapping operations would just 
>> have their own ops structure, right?
>>     
>
> I just mention it because many people's ideas of merging files
> seem to add lots of ifdefs which is imho the totally wrong thing
> to do.
>
>   
>>> And no swiotlb on i386; that is something that is completely broken
>>> in upstream Xen and needs to be fixed properly anyways.
>>>   
>>>       
>> Hm, OK.  I'm not really familiar with the issues here.  What are they?  
>> Looks like Jan has made a number of Xen-ish changes to lib/swiotlb.c; 
>> are more changes be needed?
>>     
>
> See the recent "quiet down swiotlb warnings" thread which uncovered
> quite some corpses in Xen's current IO setup.
>
> Xen apparently bounces for multi page IOs which get merged from block
> lists because the block layer doesn't know they are not really 
> continuous in machine memory.
>
> Proper fix is to tell the block layer to not merge in the first
> place instead.
>
> And probably some similar mechanism for network drivers that limits
> MTUs.
>   

Well, I think there are two issues here.  One is that two 
pseudo-physical pages won't necessarily be contigious in bus space, 
because of the pseudo-phys to machine mapping.

The second problem is that devices which can't address all machine 
physical memory (ie, 32-bit PCI devices on machines with >4G memory) 
will need to have bouncebuffers established for them.  Device drivers 
won't necessarily be able to do it because they're not really aware of 
machine addresses.

> Maybe we'll still need a simple bouncing mechanism for other obscure
> devices with large IOs then, but I would very much prefer if it wasn't 
> swiotlb and could be solved some other way.
>   

I think 32-bit-only devices are a bigger concern, no?

    J
