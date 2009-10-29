Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZJ2OpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZJ2OpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZJ2OpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:45:14 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:42472 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754808AbZJ2OpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:45:12 -0400
Date: Thu, 29 Oct 2009 14:39:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jiri Kosina <jkosina@suse.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1> <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Jiri Kosina wrote:

> On Tue, 27 Oct 2009, Christoph Lameter wrote:
>
> > The NR_CPUS array in the percpu section needs to be removed.
> >
> > A simple fix would be to allocate the rq_weight per cpu array
> > dynamically.
>
> There already are two patches for this acked by Ingo/Tejun, which Tejun is
> going to take through his tree tomorrow.
>
> 	http://lkml.org/lkml/2009/10/27/132

per cpu alloc from an atomic context without passing gfp flags through to
the page allocator? That does not look right. Sure wish that the percpu
allocator would be working from atomic contexts for other cases.

> 	http://lkml.org/lkml/2009/10/27/215

There is still heavy percpu use because of the patch for machines with
large numbers of processors. Another solution would be better that does
not require a N^2 sized array.

