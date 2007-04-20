Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbXDTJQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbXDTJQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXDTJQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:16:24 -0400
Received: from mx2.go2.pl ([193.17.41.42]:58613 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752892AbXDTJQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:16:23 -0400
Date: Fri, 20 Apr 2007 11:22:01 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420092201.GC1695@ff.dom.local>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419102122.GA93@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 02:21:22PM +0400, Oleg Nesterov wrote:
> On 04/19, Andrew Morton wrote:
> > 
> > Begin forwarded message:
> > 
> > Date: Thu, 19 Apr 2007 08:54:04 +0200
> > From: Jarek Poplawski <jarkao2@o2.pl>
> > To: linux-kernel@vger.kernel.org
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Subject: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work

At first I didn't spotted your thread is "independent" and
from your second message it seems you didn't receive all, you
expected. I wonder, if there is a need and possibility to add
somewhere (I would prefer Linus' tree git's http frontend)
addresses of developers (but not maintainers), who are
interested in CC-ing about some files' patches?. 

...
> Yes. It would be better to use cancel_work_sync() instead of flush_workqueue()
> to make this less possible (because cancel_work_sync() doesn't need to wait for
> the whole ->worklist), but we can't.
> 
> > Maybe this patch could check, if I'm not dreaming...
> 
> Also: cancel_rearming_delayed_work() will hang if it (or cancel_delayed_work())
> was already called.
> 
> I had some ideas how to make this interface reliable, but I can't see how to do
> this without uglification of the current code.

For some time I thought about using a flag (isn't there
one available after NOAUTOREL?), e.g. WORK_STRUCT_CANCEL,
as a sign:

- for a workqueue code: that the work shouldn't be queued,
nor executed, if possiblei, at first possible check.

- for a work function: to stop execution as soon as possible,
even without completing the usual job, at first possible check.

There would be a question, whether the flag should be changed
under a lock for exact synchronisation.

Cheers,
Jarek P.

PS: I hope there is no reason against going with this to lkml
