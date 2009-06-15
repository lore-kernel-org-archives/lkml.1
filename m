Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbZFOSmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbZFOSmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZFOSmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:42:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZFOSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:42:31 -0400
Message-ID: <4A369508.2090707@zytor.com>
Date: Mon, 15 Jun 2009 11:38:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       mathieu.desnoyers@polymtl.ca, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 15 Jun 2009, Ingo Molnar wrote:
>> A simple cr2 corruption would explain all those cc1 SIGSEGVs and 
>> other user-space crashes i saw, with sufficiently intense sampling - 
>> easily.
> 
> Note that we could work around the %cr2 issue, since any corruption is 
> always nicely "nested" (ie there are never any SMP issues with async 
> writes to the register).
> 
> So what we _could_ do is to have a magic value for %cr2, along with a "NMI 
> sequence count", and if we see that value, we just return (without doing 
> anything) from the page fault handler.
> 

Wouldn't it be simpler to just require the NMI handler to save and
restore %cr2 around any potentially faulting references?

	-hpa
