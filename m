Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZH1T0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZH1T0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZH1T0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:26:46 -0400
Received: from www.tglx.de ([62.245.132.106]:48230 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZH1T0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:26:44 -0400
Date: Fri, 28 Aug 2009 21:23:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux-foundation.org>
cc: Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.DEB.1.10.0908281446520.7317@gentwo.org>
Message-ID: <alpine.LFD.2.00.0908282100040.19335@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
 <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain> <alpine.DEB.1.10.0908281446520.7317@gentwo.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Christoph Lameter wrote:

> On Fri, 28 Aug 2009, Thomas Gleixner wrote:
> 
> > That makes sense and should not be rocket science to implement.
> 
> I like it and such a thing would do a lot for reducing noise.
> 
> However, look at a typical task (from the HPC world) that would be
> running on an isolated processors. It would
> 
> 1. Spin on some memory location waiting for an event.
> 
> 2. Process data passed to it, prepare output data and then go back to 1.
> 
> The enticing thing about doing 1 with shared memory and/or infiniband is
> that it can be done in a few hundred nanoseconds instead of 10-20
> microseconds. This allows a much faster IPC communication if we bypass
> the OS.
> 
> For many uses deterministic responses are desired. If the handler that
> runs is never disturbed by extraneous processing (IPI, faults, irqs etc)
> then we can say that we run at the maximum speed that the machine can run
> at. That is what many sites expect.

Right, and I think we can get there. The timer can be eliminated with
some work. Faults shouldn't happen on that CPU and all other
interrupts can be kept away with proper affinity settings. Softirqs
should not happen on such a CPU either as there is neither a hardirq
nor a user space task triggering them. Same applies for timers. So
there are some remaining issues like IPIs, but I'm pretty sure that
they can be tamed to zero as well.

Thanks,

	tglx

 
