Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZFPIhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZFPIhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZFPIgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:36:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58412 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZFPIgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:36:54 -0400
Date: Tue, 16 Jun 2009 10:36:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090616083635.GE16229@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <4A369573.1060504@zytor.com> <20090615184536.GH11248@elte.hu> <4A369914.4010903@zytor.com> <4A369ADF.2050305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A369ADF.2050305@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 06/15/2009 09:55 PM, H. Peter Anvin wrote:
>> Ingo Molnar wrote:
>>    
>>>> I wouldn't actually expect that, *as long as* there is
>>>> serialization between the cr2 write and the cr2 read.
>>>>        
>>> Well, is there any OS that heavily relies on cr2 writes and which
>>> uses them from NMI context, and which CPU makers care about?
>>> (Meaning: Windows, pretty much.)
>>>
>>> If not then i agree that in theory it should work fine, but in
>>> practice we only know that we dont know the unknown risk here ;-)
>>>
>>>      
>>
>> I think you can drop "uses them from NMI context" from that statement;
>> writing to %cr2 is independent of the context.
>>
>> I can try to find out internally what Intel's position on writing 
>> %cr2 is, but it'll take a while; however, KVM should be able to 
>> tell you if any random OS uses %cr2 writes (as should a static 
>> disassembly of their kernel.)
>
> Linux is one such OS.  When acting as a hypervisor it writes cr2 
> to present its guests with their expected environment (any 
> hypervisor that uses virtualization extensions will of course need 
> to do this).

Ah, it does save/restore it in svm_vcpu_run. VMX can do this via its 
context structure (without explicit CR manipulations in host space), 
right?

	Ingo
