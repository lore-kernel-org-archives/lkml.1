Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbZDBMnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbZDBMnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZDBMm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:42:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbZDBMmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:42:55 -0400
Message-ID: <49D4B2C0.5060906@redhat.com>
Date: Thu, 02 Apr 2009 15:42:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <49D3D7EE.4080202@novell.com> <49D46089.5040204@redhat.com> <49D497A1.4090900@novell.com> <49D4A4EB.8020105@redhat.com> <49D4AE0C.3000604@novell.com>
In-Reply-To: <49D4AE0C.3000604@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Avi Kivity wrote:
>   
>> Gregory Haskins wrote:
>>
>>  
>>
>>     
>>>> virtio is already non-kvm-specific (lguest uses it) and
>>>> non-pci-specific (s390 uses it).
>>>>     
>>>>         
>>> Ok, then to be more specific, I need it to be more generic than it
>>> already is.  For instance, I need it to be able to integrate with
>>> shm_signals.  
>>>       
>> Why?
>>     
> Well, shm_signals is what I designed to be the event mechanism for vbus
> devices.  One of the design criteria of shm_signal is that it should
> support a variety of environments, such as kvm, but also something like
> userspace apps.  So I cannot make assumptions about things like "pci
> interrupts", etc.
>   

virtio doesn't make these assumptions either.  The only difference I see 
is that you separate notification from the ring structure.

> By your own words, the exit to userspace is "prohibitively expensive",
> so that is either true or its not.  If its 2 microseconds, show me.

In user/test/x86/vmexit.c, change 'cpuid' to 'out %al, $0'; drop the 
printf() in kvmctl.c's test_outb().

I get something closer to 4 microseconds, but that's on a two year old 
machine;  It will be around two on Nehalems.

My 'prohibitively expensive' is true only if you exit every packet.



-- 
error compiling committee.c: too many arguments to function

