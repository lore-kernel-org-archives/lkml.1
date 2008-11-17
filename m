Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYKQWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYKQWLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYKQWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:11:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYKQWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:11:08 -0500
Date: Mon, 17 Nov 2008 14:09:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: system_call() - Re: [Bug #11308] tbench regression on each kernel
 release from 2.6.22 -&gt; 2.6.28
In-Reply-To: <20081117215950.GA6398@elte.hu>
Message-ID: <alpine.LFD.2.00.0811171407080.18283@nehalem.linux-foundation.org>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com>
 <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117215950.GA6398@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Ingo Molnar wrote:
> 
> syscall entry instruction costs - unavoidable security checks, etc. - 
> hardware costs.

Yes. One thing to look out for on x86 is the system call _return_ path. It 
doesn't show up in kernel profiles (it shows up as user costs), and we had 
a bug where auditing essentially always caused us to use 'iret' instead of 
'sysret' because it took us the long way around.

And profiling doesn't show it, but things like lmbench did, iret being 
about five times slower than sysret.

But yes:

> -ENTRY(system_call_after_swapgs)
> +.globl system_call_after_swapgs
> +system_call_after_swapgs:

This definitely makes sense. We definitely do not want to align that 
special case.

		Linus
