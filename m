Return-Path: <linux-kernel-owner+w=401wt.eu-S1765973AbZFOTDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765973AbZFOTDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZFOTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:03:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZFOTDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:03:45 -0400
Message-ID: <4A369ADF.2050305@redhat.com>
Date: Mon, 15 Jun 2009 22:02:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <4A369573.1060504@zytor.com> <20090615184536.GH11248@elte.hu> <4A369914.4010903@zytor.com>
In-Reply-To: <4A369914.4010903@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2009 09:55 PM, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>    
>>> I wouldn't actually expect that, *as long as* there is
>>> serialization between the cr2 write and the cr2 read.
>>>        
>> Well, is there any OS that heavily relies on cr2 writes and which
>> uses them from NMI context, and which CPU makers care about?
>> (Meaning: Windows, pretty much.)
>>
>> If not then i agree that in theory it should work fine, but in
>> practice we only know that we dont know the unknown risk here ;-)
>>
>>      
>
> I think you can drop "uses them from NMI context" from that statement;
> writing to %cr2 is independent of the context.
>
> I can try to find out internally what Intel's position on writing %cr2
> is, but it'll take a while; however, KVM should be able to tell you if
> any random OS uses %cr2 writes (as should a static disassembly of their
> kernel.)
>    

Linux is one such OS.  When acting as a hypervisor it writes cr2 to 
present its guests with their expected environment (any hypervisor that 
uses virtualization extensions will of course need to do this).


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

