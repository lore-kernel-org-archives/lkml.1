Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXIRTpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXIRTpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXIRTpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:45:12 -0400
Received: from mout.perfora.net ([74.208.4.194]:58230 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbXIRTpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:45:10 -0400
Message-ID: <46F02AC0.7090607@rlworkman.net>
Date: Tue, 18 Sep 2007 14:45:04 -0500
From: Robby Workman <rw@rlworkman.net>
Organization: http://rlworkman.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] CPU too old panic on Centrino proc - 2.6.22.6
References: <46EFF173.4010104@rlworkman.net> <p73sl5bx2an.fsf@bingen.suse.de>
In-Reply-To: <p73sl5bx2an.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19piATe7wOOC4Z0RGXGFmYv65ap0Q2t1PKavT6
 xKY3WqGGKhnZN0v0/LJafg94eaxxERwqvvRsypQpfzK68TAoFQ
 ACKjJ92RincuQH3kLF91w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Robby Workman <rw@rlworkman.net> writes:
> 
>> On booting a 2.6.22.6 kernel with SMP support, I get a panic
>> immediately:
>>   PANIC: CPU too old for this kernel
>> This panic does not occur on a non-SMP kernel having almost
>> identical configuration.
>>
>> This is on a Thinkpad T41:
>>   /proc/cpuinfo --> http://rlworkman.net/cpuinfo
>>   dmesg --> http://rlworkman.net/dmesg
>>   kernel config --> http://rlworkman.net/config-2.6.22.6
>>
>> The 2.6.21.5 SMP kernels from Slackware 12.0 all boot properly, and
>> the config for this 2.6.22.6 SMP kernel is based on the one from 12.0.
>>
>> I'm basically reaching for clues at this point -- is this a PEBKAC on
>> my part?  What other information would be useful?
> 
> Most likely you enabled CONFIG_HIGHMEM64G. Banias didn't support 
> PAE.


Thanks, Andi - that was indeed the problem.  Of course, things like
this are never solved until asked about on a mailing list :)

HIGHMEM4G rather than HIGHMEM64G (not sure why I had that marked),
no PAE, and I was using the 64-bit memory/IO (EXPERIMENTAL).  Now it's
off.  A side effect was CONFIG_X86_CMPXCHG64 disappearing from the
.config, which I thought might have also been part of the problem
based on that other thread.

Either way, thanks for the response!

-RW

