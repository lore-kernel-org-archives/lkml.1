Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYJBJdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYJBJdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYJBJdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:33:33 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:36050 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYJBJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:33:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkDAO4x5Eh5LF82iGdsb2JhbACTTgEBARUiqESBag
X-IronPort-AV: E=Sophos;i="4.33,349,1220193000"; 
   d="scan'208";a="218972916"
Date: Thu, 2 Oct 2008 19:33:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002093326.GF30001@disturbed>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <87fxnfpjqj.fsf@basil.nowhere.org> <20081002075511.GX19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002075511.GX19428@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 09:55:11AM +0200, Jens Axboe wrote:
> On Thu, Oct 02 2008, Andi Kleen wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > 
> > > On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > >
> > >> Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
> > >
> > > You proposed this a while back and it didn't happen and I forget
> > > why and the changelog doesn't mention any of that?
> > 
> > XFS tried this some time ago too.
> > 
> > I think the issue was that real user supplied RT applications don't want to 
> > compete with a "pseudo RT" kjournald.
> > 
> > So it would really need a new priority class between RT and normal priority.
> 
> Good point. I think we should mark the IO as sync, and maintain the same
> priority level. Any IO that ends up being waited on is sync by
> definition, we just need to expand the coverage a bit.

That's what XFS has always done - mark the journal I/O as sync.
Still, once you load up the elevator, the sync I/O can still get
delayed for hundreds of milliseconds before dispatch, which was
why I started looking at boosting the priority of the log I/O.
It proved to be much more effective at getting the log I/O
dispatched than the existing "mark it sync" technique....

The RT folk were happy with the idea of journal I/O using the
highest non-RT priority for the journal, but I never got around
to testing that out as I had a bunnch of other stuff to fix at
the time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
