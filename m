Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZJ2O6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZJ2O6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZJ2O6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:58:21 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:55061 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516AbZJ2O6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:58:20 -0400
Date: Thu, 29 Oct 2009 14:57:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <4AE9AB23.8010207@kernel.org>
Message-ID: <alpine.DEB.1.10.0910291455400.19555@V090114053VZO-1>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1> <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de> <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1>
 <4AE9AB23.8010207@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Tejun Heo wrote:

> It's just for sched_init() which has irq off but is not really in
> atomic context and does GFP_KERNEL allocations.  The following comment
> has been added to the first patch to explain it.

Uhmm.. Is the page allocator available at that point? If you are
constricted to the reserved per cpu area then IA64 can still run out of
space if its booted with 4096 actual cpus.

> + * allocations are done using GFP_KERNEL with pcpu_lock released.  In
> + * general, percpu memory can't be allocated with irq off but
> + * irqsave/restore are still used in alloc path so that it can be used
> + * from early init path - sched_init() specifically.
>
> Thanks.

Maybe make the patch a bit more general so that it can operate in an
atomic context and handles gfp flags nicely?

