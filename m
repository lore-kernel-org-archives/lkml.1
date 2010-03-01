Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab0CAPX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:23:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40052 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751033Ab0CAPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:23:28 -0500
Date: Mon, 1 Mar 2010 10:23:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <20100301063508.GA1455@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1003011021440.1645-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, Pavel Machek wrote:

> Hi!
> 
> > > > This is a matter for Jens.  Is the bdi writeback task freezable?  If it
> > > > is, should it be made unfreezable?
> > > 
> > > I'm not a big expect on what tasks should be freezable or not. As it
> > > stands, the writeback tasks will attempt to freeze and thaw with the
> > > system. I guess that screws the sync from resume call, since it's not
> > > running and the sync will wait for it to retrieve and finish that work
> > > item.
> > > 
> > > To the suspend experts - can we safely mark the writeback tasks as
> > > non-freezable?
> > 
> > The reason for freezing those tasks is to avoid writebacks at random
> > times during a system sleep transition, when the underlying device may
> > already be suspended, right?
> 
> It is also there to avoid inconsistency between in-filesystem data and
> snapshot in hibernation image.

A good point, although in this case I think it won't matter.  Writing
out a dirty page twice (once right after taking the snapshot and then
again after resuming from hibernation) will leave the disk in a correct
state.

Alan Stern

