Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbXDLHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbXDLHC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXDLHC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:02:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32942 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbXDLHC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:02:56 -0400
Date: Wed, 11 Apr 2007 23:27:17 -0700
From: Greg KH <greg@kroah.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Oliver Neukum <oneukum@suse.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: CPU ordering with respect to krefs
Message-ID: <20070412062717.GA13047@kroah.com>
References: <200704021447.59476.oneukum@suse.de> <20070402163354.ef741262.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402163354.ef741262.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 04:33:54PM +0200, Eric Dumazet wrote:
> On Mon, 2 Apr 2007 14:47:59 +0200
> Oliver Neukum <oneukum@suse.de> wrote:
> 
> > Hi,
> > 
> > some atomic operations are only atomic, not ordered. Thus a CPU is allowed
> > to reorder memory references to an object to before the reference is
> > obtained. This fixes it.
> > 
> > 	Regards
> > 		Oliver
> > Signed-off-by: Oliver Neukum <oneukum@suse.de>
> > ------
> > 
> > --- a/lib/kref.c	2007-04-02 14:40:40.000000000 +0200
> > +++ b/lib/kref.c	2007-04-02 14:40:50.000000000 +0200
> > @@ -21,6 +21,7 @@
> >  void kref_init(struct kref *kref)
> >  {
> >  	atomic_set(&kref->refcount,1);
> > +	smp_mb();
> >  }
> 
> I dont understand why smp_mb() is needed here, and not in
> spinlock_init() for example.

I think, after reading the Documentation/memory-barriers.txt and
Documentation/atomic_ops.txt documentation, that spin_lock_init() also
needs this kind of memory barrier.

>From what I can tell (Oliver, please correct me if I'm wrong, you know
this much better than I do), the issue is that atomic init has no memory
barrier, and you need to handle that.

thanks,

greg k-h
