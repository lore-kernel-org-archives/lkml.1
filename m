Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0BWRCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:02:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab0BWRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:02:05 -0500
Date: Tue, 23 Feb 2010 09:00:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
       Junichi Nomura <j-nomura@ce.jp.nec.com>, akpm@linux-foundation.org,
       stable@kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when requeueing io
In-Reply-To: <20100223153326.GA4275@kroah.com>
Message-ID: <alpine.LFD.2.00.1002230852070.4141@localhost.localdomain>
References: <20100219163257.186977438@kvm.kroah.org> <4B815A3D.9040402@canonical.com> <20100223153326.GA4275@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Feb 2010, Greg KH wrote:
> On Sun, Feb 21, 2010 at 05:07:25PM +0100, Stefan Bader wrote:
> > > 
> > > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > > Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> > >
> > >  		blk_start_request(rq);
> > >  		spin_unlock(q->queue_lock);
> > > -		map_request(ti, rq, md);
> > > +		if (map_request(ti, rq, md))
> > > +			goto requeued;
> > >  		spin_lock_irq(q->queue_lock);
> > >  	}
> > 
> > While looking over the code I also noticed that the spinlock is dropped with
> > spin_unlock and then reacquired with spin_lock_irq. Isn't the irq version too
> > much in that case? Or was the intention to have interrupts enabled when unlocking?
> 
> Ick, thanks for the review.  I'll drop this patch for now and fix it up
> in the next release if needed.

This part of the commentary seems to be relevant for mainline too. 

According to git logs, this spin_unlock/spin_lock_irq imbalance goes back 
to commit cec47e3d4a (last June). Maybe there's some reason for it, but it 
does look odd.

Ueda-san, Nomura-san, Alasdair? Comments?

			Linus
