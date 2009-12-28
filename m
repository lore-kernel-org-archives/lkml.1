Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZL1QvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZL1QvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZL1QvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:51:19 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:50790 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZL1QvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:51:18 -0500
Date: Mon, 28 Dec 2009 17:51:15 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       kernel-janitors@vger.kernel.org, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: RE: [PATCH 1/5] arch/arm: Correct NULL test
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F461@mi8nycmail19.Mi8.com>
Message-ID: <Pine.LNX.4.64.0912281747570.6928@ask.diku.dk>
References: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk><20091227215106.GA18317@pengutronix.de>
 <Pine.LNX.4.64.0912272307310.20548@ask.diku.dk>
 <BD79186B4FD85F4B8E60E381CAEE19090200F461@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009, H Hartley Sweeten wrote:

> On Sunday, December 27, 2009 3:08 PM, Julia Lawall wrote:
> >>>  	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
> >>>  			     GFP_KERNEL);
> >>> -	if (!dbgfs_state)
> >>> +	if (!dbgfs_chan)
> >>>  		goto err_alloc;
> >> Shouldn't the malloc line read:
> >> 
> >> 	... = kmalloc(sizeof(*dbgfs_chan) * ...)
> >> 	                      ^^^^^^^^^^
> >> 
> >> ?
> >
> > Good point, thanks.  I will send a revised patch.
> 
> Wouldn't this be clearer?
> 
> 	... = kmalloc(sizeof(struct dentry) * ...)

Documentation/CodingStyle thinks otherwise:

"The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);

The alternative form where struct name is spelled out hurts readability 
and introduces an opportunity for a bug when the pointer variable type is 
changed but the corresponding sizeof that is passed to a memory allocator 
is not."

And actually, in this case, sizeof(struct dentry) would be wrong, because 
the type of dbgfs_chan is struct dentry **, not struct dentry *.  What is 
wanted is an array of pointers.

julia
