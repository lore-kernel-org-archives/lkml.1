Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbXGWNhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbXGWNhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbXGWNgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:36:51 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6774 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790AbXGWNgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:36:50 -0400
Date: Mon, 23 Jul 2007 15:37:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Kyle Moffett <mrlinuxman@mac.com>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723133704.GN11657@kernel.dk>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723133202.GB23495@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723133202.GB23495@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23 2007, Lars Ellenberg wrote:
> > +/* THINK maybe we actually want to use the default "event/%s" worker threads
> > + * or similar in linux 2.6, which uses per cpu data and threads.
> > + *
> > + * To be general, this might need a spin_lock member.
> > + * For now, please use the mdev->req_lock to protect list_head,
> > + * see drbd_queue_work below.
> > + */
> > +struct drbd_work_queue {
> > +       struct list_head q;
> > +       struct semaphore s; /* producers up it, worker down()s it */
> > +       spinlock_t q_lock;  /* to protect the list. */
> > +};
> > 
> > Umm, how about fixing this to actually use proper workqueues or something
> > instead of this open-coded mess?
> 
> unlikely to happen "right now".
> but it is on our todo list...

But stuff like that is definitely a merge show stopper, jfyi.

-- 
Jens Axboe

