Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYKETNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYKETNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYKETMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:12:52 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54301 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYKETMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:12:51 -0500
Date: Wed, 5 Nov 2008 20:11:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add round_jiffies_up and related routines
Message-ID: <20081105191126.GN21867@kernel.dk>
References: <491113FF.9070007@kernel.org> <Pine.LNX.4.44L0.0811051115370.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811051115370.2573-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2008, Alan Stern wrote:
> On Wed, 5 Nov 2008, Tejun Heo wrote:
> 
> > Alan Stern wrote:
> > > This patch (as1158) adds round_jiffies_up() and friends.  These
> > > routines work like the analogous round_jiffies() functions, except
> > > that they will never round down.
> > > 
> > > The new routines will be useful for timeouts where we don't care
> > > exactly when the timer expires, provided it doesn't expire too soon.
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Heh... I have exactly the same patches but mines were named
> > round_up_jiffies().
> 
> To an American, "round_up_jiffies" sounds like something a cowboy might 
> do.  :-)
> 
> I haven't bothered to look throughout the kernel to see where 
> round_jiffies_up() could be used.  Have you done this?

Heh, I do agree :-)

> > > +	unsigned long j0 = jiffies;
> > > +
> > > +	barrier();	/* Prevent the compiler from aliasing j0 and jiffies */
> > > +	return round_jiffies_common(j + j0, cpu, false) - j0;
> > 
> > jiffies is volatile.  No need for explicit barrier,
> 
> I didn't realize that.  Good, it makes things easier.
> 
> > but this part is
> > necessary for correct operation as if jiffies go up by two the
> > calculation will wrap and the returned value will be very large.  I
> > think this fix deserves a separate patch and proper explanation.
> 
> How about if I remove the barrier() call?  Should this new code still
> go in a separate patch?

I think it's fine as-is without the barrier. Can you resend it as such,
makes it easier to merge up (plus, it does need a new signed-off-by).

-- 
Jens Axboe

