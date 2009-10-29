Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZJ2OsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZJ2OsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZJ2OsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:48:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbZJ2OsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:48:18 -0400
Message-ID: <4AE9AB23.8010207@kernel.org>
Date: Thu, 29 Oct 2009 15:48:03 +0100
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
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1> <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de> <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> There already are two patches for this acked by Ingo/Tejun, which Tejun is
>> going to take through his tree tomorrow.
>>
>> 	http://lkml.org/lkml/2009/10/27/132
> 
> per cpu alloc from an atomic context without passing gfp flags through to
> the page allocator? That does not look right. Sure wish that the percpu
> allocator would be working from atomic contexts for other cases.

It's just for sched_init() which has irq off but is not really in
atomic context and does GFP_KERNEL allocations.  The following comment
has been added to the first patch to explain it.

+ * allocations are done using GFP_KERNEL with pcpu_lock released.  In
+ * general, percpu memory can't be allocated with irq off but
+ * irqsave/restore are still used in alloc path so that it can be used
+ * from early init path - sched_init() specifically.

Thanks.

-- 
tejun
