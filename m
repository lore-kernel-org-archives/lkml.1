Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbXFDVVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbXFDVVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXFDVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:21:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:60088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbXFDVVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:21:24 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: use iret directly where possible
Date: Mon, 4 Jun 2007 23:05:04 +0200
User-Agent: KMail/1.9.1
Cc: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46646662.9020707@goop.org> <200706042145.30339.ak@suse.de> <4664772A.20602@goop.org>
In-Reply-To: <4664772A.20602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706042305.05340.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 22:33, Jeremy Fitzhardinge wrote:

> Hm, yes, I guess so.  I'd assumed that softirq was in the WORK_NEEDED
> path of entry.S without checking; but anything which can set one of the
> WORK_NEEDED flags is an issue.

For interrupts it can be only signals or rescheduling.

> >>  - If the interrupt causes a signal to be delivered to the current
> >> process, the signal will be marked pending on the process, but it will
> >> not get delivered because we're past the point where pending signals are
> >> detected.  Again, it could be an unbounded amount of time before the
> >> signal gets delivered.
> >
> > It's still not clear to me why you can't do cli ; check again ;
> > iret-equivalent to handle this.
>
> Well, we use the real iret instruction to actually transition into
> userspace; obviously we can't do anything after that, and there's always
> going to be an open window before it because we can't do anything
> instruction-level atomic.

If you stay cli you don't need that. Why is it that it has to enable 
interrupts?

> In your sequence, the event may become pending after "check again", even
> though it won't be delivered. 

sti only takes affect one instruction after it. So if you can make 
it that small it would also work. But that might not help you.

-Andi
