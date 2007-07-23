Return-Path: <linux-kernel-owner+w=401wt.eu-S935476AbXGWVN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935476AbXGWVN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761522AbXGWVNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:13:49 -0400
Received: from aug.linbit.com ([212.69.162.22]:48057 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760559AbXGWVNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:13:48 -0400
Date: Mon, 23 Jul 2007 23:13:44 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kyle Moffett <mrlinuxman@mac.com>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723211344.GC6477@mail.linbit.com>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723133202.GB23495@mail.linbit.com> <20070723133704.GN11657@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723133704.GN11657@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 03:37:04PM +0200, Jens Axboe wrote:
> On Mon, Jul 23 2007, Lars Ellenberg wrote:
> > > +/* THINK maybe we actually want to use the default "event/%s" worker threads
> > > + * or similar in linux 2.6, which uses per cpu data and threads.
> > > + *
> > > + * To be general, this might need a spin_lock member.
> > > + * For now, please use the mdev->req_lock to protect list_head,
> > > + * see drbd_queue_work below.
> > > + */
> > > +struct drbd_work_queue {
> > > +       struct list_head q;
> > > +       struct semaphore s; /* producers up it, worker down()s it */
> > > +       spinlock_t q_lock;  /* to protect the list. */
> > > +};
> > > 
> > > Umm, how about fixing this to actually use proper workqueues or something
> > > instead of this open-coded mess?
> > 
> > unlikely to happen "right now".
> > but it is on our todo list...
> 
> But stuff like that is definitely a merge show stopper, jfyi.

I see.
but it is not that easy to do away with kernel threads
(the open-coded mess) in favor of "proper workqueues or something".

	Lars
