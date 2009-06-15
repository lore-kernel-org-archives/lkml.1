Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbZFOWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbZFOWkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZFOWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:40:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbZFOWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:40:43 -0400
Date: Mon, 15 Jun 2009 15:39:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <4A36B238.5020203@zytor.com>
Message-ID: <alpine.LFD.2.01.0906151539350.6276@localhost.localdomain>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal>
 <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <4A36ABB5.1040109@goop.org> <alpine.LFD.2.01.0906151326170.6276@localhost.localdomain>
 <4A36B238.5020203@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, H. Peter Anvin wrote:
> 
> cs/ss you could potentially restore with sysret/sysexit, at least for
> the common case.  Of course, this means more cases...

Yes. But it gets pretty complicated. You now have to make user space 
restore some of the registers, so you end up having to write to the user 
space stack etc.

It might be worth it (iret really is very slow, _especially_ to user 
space, but it's definitely nontrivial.

			Linus
