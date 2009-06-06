Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZFFBZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZFFBZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 21:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZFFBZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 21:25:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:13504 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbZFFBY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 21:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GE0Hws72rDlKC08MjdoeGKAaAZuNc5ctuAdcVNclPppfZyqlk+ks78ydXbaO8hqSuT
         PfsEWUidlhyfwR91JD9FMM1CkPdPv2qEj/RUfl/noW0eDhe/zjcgRLHNtswV/uj7Da4t
         vjV85Gk1BXhqO/55nD/iPayCf8VPSynrg265s=
Message-ID: <4A29C56A.8020306@gmail.com>
Date: Fri, 05 Jun 2009 19:24:58 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: david@lang.hm
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: only a single core (out of 8) initialized
References: <alpine.DEB.1.10.0906041949030.7953@asgard> <20090604202933.d7c24c3d.akpm@linux-foundation.org> <alpine.DEB.1.10.0906042049230.11064@asgard>
In-Reply-To: <alpine.DEB.1.10.0906042049230.11064@asgard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 4 Jun 2009, Andrew Morton wrote:
> 
>> Subject: Re: only a single core (out of 8) initialized
>>
>> On Thu, 4 Jun 2009 19:52:36 -0700 (PDT) david@lang.hm wrote:
>>
>>> this is 2.6.30-rc7
>>
>> Were any earlier kernels OK?
>>
>>>  with a patch added to debug a nv sata driver
>>> incompatibility with the Intel SSDs on a tyan motherboard
>>>
>>> on one system it sees all 8 cores, on the other system it only 
>>> initializes
>>> one core.
>>>
>>> can anyone help me spot what's going wrong in the one that's only 
>>> seeing a
>>> single core? If I'm reading things correctly it's seeing both sockets 
>>> for
>>> the NUMA setup, but then only initializing one core on the first socket.
>>
>> good:
>>     SMP: Allowing 8 CPUs, 4 hotplug CPUs
>>
>> bad:
>>     SMP: Allowing 1 CPUs, 0 hotplug CPUs
>>
>> perhaps due to
>>     ACPI: No APIC-table, disabling MPS
>>
>> You could have a poke around in arch/x86/kernel/smpboot.c() and find
>> out what happened here.  I'd be suspecting this code triggered:
>>
>>        /* no processor from mptable or madt */
>>        if (!num_processors)
>>                num_processors = 1;
>>
>> because ACPI doesn't like that board.
>>
>> Did you look into updating the BIOS?
> 
> this is actually the newer of the two systems. I've already escalated up 
> to Tyan about the fact that this board won't see the Intel SSD drives 
> (unless you hotplug the drive). I've forwarded this to them as well. 
> their website does show a newer bios than what was shipped to me.

Yeah, it seems like a BIOS problem on that system. It's missing a bunch 
of the ACPI tables that the other system has.
