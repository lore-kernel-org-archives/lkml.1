Return-Path: <linux-kernel-owner+w=401wt.eu-S1161149AbXDSG4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149AbXDSG4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161151AbXDSG4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:56:53 -0400
Received: from mx10.go2.pl ([193.17.41.74]:59529 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161149AbXDSG4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:56:52 -0400
Date: Thu, 19 Apr 2007 09:02:28 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] workqueue: debug possible lockups in flush_workqueue
Message-ID: <20070419070228.GC1782@ff.dom.local>
References: <20070419055247.GA1782@ff.dom.local> <20070419061416.GB18894@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419061416.GB18894@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 08:14:16AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > Here is my patch proposal for detecting possible lockups, when 
> > flush_workqueue caller holds a lock (e.g. rtnl_lock) also used in work 
> > functions.
> 
> looks good in principle - did you test it and it caught a bug that wasnt 
> caught before?

Yes, but it was only my own testing bug... (I'm not a good tester, sorry).

> 
> > +#ifdef CONFIG_PROVE_LOCKING
> > +/* Detect possible flush_workqueue() lockup with circular dependency check. */
> > +static struct lockdep_map flush_dep_map = { .name = "flush_dep_map" };
> > +#endif
> 
> > +#ifdef CONFIG_PROVE_LOCKING
> > +		/* lockdep dependency: flush_dep_map (read) before any lock: */
> > +		lock_acquire(&flush_dep_map, 0, 0, 1, 2, _THIS_IP_);
> > +#endif
> 
> i think the #ifdef should only be needed for the .name initialization - 
> both lock_acquire() and lock_release() maps to NOP if PROVE_LOCKING is 
> off.

There is also DEBUG_LOCK_ALLOC without PROVE_LOCKING possibility,
which isn't usable here.

Jarek P.
