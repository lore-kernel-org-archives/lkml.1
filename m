Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYKEQUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYKEQUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYKEQUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:20:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45655 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751480AbYKEQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:20:07 -0500
Date: Wed, 5 Nov 2008 11:20:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add round_jiffies_up and related routines
In-Reply-To: <491113FF.9070007@kernel.org>
Message-ID: <Pine.LNX.4.44L0.0811051115370.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Tejun Heo wrote:

> Alan Stern wrote:
> > This patch (as1158) adds round_jiffies_up() and friends.  These
> > routines work like the analogous round_jiffies() functions, except
> > that they will never round down.
> > 
> > The new routines will be useful for timeouts where we don't care
> > exactly when the timer expires, provided it doesn't expire too soon.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Heh... I have exactly the same patches but mines were named
> round_up_jiffies().

To an American, "round_up_jiffies" sounds like something a cowboy might 
do.  :-)

I haven't bothered to look throughout the kernel to see where 
round_jiffies_up() could be used.  Have you done this?

> > +	unsigned long j0 = jiffies;
> > +
> > +	barrier();	/* Prevent the compiler from aliasing j0 and jiffies */
> > +	return round_jiffies_common(j + j0, cpu, false) - j0;
> 
> jiffies is volatile.  No need for explicit barrier,

I didn't realize that.  Good, it makes things easier.

> but this part is
> necessary for correct operation as if jiffies go up by two the
> calculation will wrap and the returned value will be very large.  I
> think this fix deserves a separate patch and proper explanation.

How about if I remove the barrier() call?  Should this new code still
go in a separate patch?

Alan Stern

