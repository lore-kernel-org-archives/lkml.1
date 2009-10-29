Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZJ2PKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZJ2PKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZJ2PKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:10:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:40217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbZJ2PKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:10:54 -0400
Message-ID: <4AE9B090.9090107@kernel.org>
Date: Thu, 29 Oct 2009 16:11:12 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1> <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de> <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1> <4AE9AB23.8010207@kernel.org> <alpine.DEB.1.10.0910291455400.19555@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0910291455400.19555@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 29 Oct 2009, Tejun Heo wrote:
> 
>> It's just for sched_init() which has irq off but is not really in
>> atomic context and does GFP_KERNEL allocations.  The following comment
>> has been added to the first patch to explain it.
> 
> Uhmm.. Is the page allocator available at that point? If you are
> constricted to the reserved per cpu area then IA64 can still run out of
> space if its booted with 4096 actual cpus.

sched_init() is after mm_init() so it should work.

>> + * allocations are done using GFP_KERNEL with pcpu_lock released.  In
>> + * general, percpu memory can't be allocated with irq off but
>> + * irqsave/restore are still used in alloc path so that it can be used
>> + * from early init path - sched_init() specifically.
> 
> Maybe make the patch a bit more general so that it can operate in an
> atomic context and handles gfp flags nicely?

That would be nice but currently, we have no user which needs anything
other than GFP_KERNEL although lack of users could have been caused by
the lack of the functionality and the non-atomic irq disabled state is
an exception case which is handled differently by might_sleep() too.
So, I'm not sure whether adding GFP_* parameter would worth the
effort.  Also, adding that is a bit too late for 2.6.32 at this point.

Thanks.

-- 
tejun
