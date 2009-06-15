Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbZFOTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbZFOTP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZFOTPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:15:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZFOTPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:15:16 -0400
Message-ID: <4A369CD8.3090505@zytor.com>
Date: Mon, 15 Jun 2009 12:11:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>	 <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>	 <20090615171845.GA7664@elte.hu>	 <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>	 <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal>	 <1245091917.6741.185.camel@laptop>  <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop>
In-Reply-To: <1245092561.6741.205.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-06-15 at 14:59 -0400, Mathieu Desnoyers wrote:
>> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
>>> On Mon, 2009-06-15 at 14:48 -0400, Mathieu Desnoyers wrote:
>>>> we should not care that much about the performance hit of
>>>> saving/restoring the cr2 register at each nmi entry/exit.
>>> But we do, perf counters very much cares about nmi performance.
>>>
>> To a point where it cannot afford a simple register save/restore ?
>>
>> There is "caring" and "_caring_". I am tempted to ask what NMI handler
>> execution frequency you have in mind here to figure out if we are not
>> trying to optimize sub-nanoseconds per minutes. ;)
> 
> Ah, well, I have no idea who expensive cr2 is, if its like a regular
> register then it should be fine. If however its tons more expensive then
> we should really avoid it.
> 
> As to the freq, 100kHz would be nice ;-)
> 

Writing control registers is serializing, so it's a lot more expensive
than writing a normal register; my *guess* is that it will be on the
order of 100-200 cycles.

That is not based on any actual information.

	-hpa

