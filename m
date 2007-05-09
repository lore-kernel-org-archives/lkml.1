Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXEIQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXEIQxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbXEIQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:53:21 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55063
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXEIQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:53:20 -0400
Date: Wed, 9 May 2007 09:50:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509164207.GA28633@kroah.com>
Message-ID: <Pine.LNX.4.64.0705090947010.4467@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <20070509095302.GA13053@kroah.com>
 <20070509153813.52a7c397@gondolin.boeblingen.de.ibm.com> <20070509164207.GA28633@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Greg KH wrote:

>>>> doesn't take long, having all devices probed one after the other may
>>>> take a lot of time. Putting the actual probe on a thread makes it
>>>> possible to run several probes in parallel, thereby cutting probing
>>>> time.
>>>
>>> Again, not for PCI, right?
>>
>> It seems that everyone agrees now that moving PCI over to a new probing
>> model without individual driver support was a bad idea. So generic
>> multithreaded probing is dead.
>
> Why is it dead?  Since when is PCI the only bus in the system?

correct, while this discussion started over the PCI_MULTITHREAD_PROBE it's 
focusing on the generic problem that would apply to any bus

>>> If you want to implement this for your bus type, fine, I have no
>>> objection to that at all, but not for PCI, it's just not worth it.
>>
>> Infrastructure for async probing might not be such a bad idea, though.
>> (Aren't there some huge PCI-based machines?) However, I don't really
>> care whether PCI or SCSI or $HUGE_BUS use it, but serial synchronous
>> probing on a bus looks like a killer on most large systems.
>
> PCI probing is just reading stuff from memory.  The slowness happens
> when storage devices need to spin up and/or discover attached drives.
>
> So, the async stuff can be done in those buses if wanted/needed, PCI is
> not the problem here.

I don't think anyone is saying that PCI is the problem here. We're trying 
to identify what needs to be done for any arbatrary bus, if a particular 
bus doesn't need to split it's initialization up becouse there are no 
delays (and therefor no gains for multithreading) then drivers for that 
bus don't bother to implement any async portion.

David Lang
