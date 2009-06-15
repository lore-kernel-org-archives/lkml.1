Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbZFOS7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbZFOS7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZFOS7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:59:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFOS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:59:21 -0400
Message-ID: <4A369914.4010903@zytor.com>
Date: Mon, 15 Jun 2009 11:55:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <4A369573.1060504@zytor.com> <20090615184536.GH11248@elte.hu>
In-Reply-To: <20090615184536.GH11248@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>> I wouldn't actually expect that, *as long as* there is 
>> serialization between the cr2 write and the cr2 read.
> 
> Well, is there any OS that heavily relies on cr2 writes and which 
> uses them from NMI context, and which CPU makers care about? 
> (Meaning: Windows, pretty much.)
> 
> If not then i agree that in theory it should work fine, but in 
> practice we only know that we dont know the unknown risk here ;-)
> 

I think you can drop "uses them from NMI context" from that statement;
writing to %cr2 is independent of the context.

I can try to find out internally what Intel's position on writing %cr2
is, but it'll take a while; however, KVM should be able to tell you if
any random OS uses %cr2 writes (as should a static disassembly of their
kernel.)

	-hpa

