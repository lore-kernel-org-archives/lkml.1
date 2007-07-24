Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbXGXGuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbXGXGuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXGXGus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:50:48 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9128 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXGXGur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:50:47 -0400
Date: Tue, 24 Jul 2007 08:51:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sebastian Siewior <sebastian@breakpoint.cc>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat_ioctl requires CONFIG_BLOCK
Message-ID: <20070724065107.GE3287@kernel.dk>
References: <20070720225817.050195257@ayoka.breakpoint.cc> <200707210108.58478.arnd@arndb.de> <20070723172337.de0bce58.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723172337.de0bce58.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23 2007, Andrew Morton wrote:
> On Sat, 21 Jul 2007 01:08:57 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Saturday 21 July 2007, Sebastian Siewior wrote:
> > > 
> > > Got with randconfig
> > > include/linux/loop.h:66: error: expected specifier-qualifier-list before
> > > 'request_queue_t'
> > > make[1]: *** [fs/compat_ioctl.o] Error 1
> > > 
> > > parts of compat ioctl require CONFIG_BLOCK to be set.
> > > 
> > > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> > > Index: b/fs/compat_ioctl.c
> > > ===================================================================
> > > --- a/fs/compat_ioctl.c
> > > +++ b/fs/compat_ioctl.c
> > > @@ -63,7 +63,9 @@
> > > __#include <linux/wireless.h>
> > > __#include <linux/atalk.h>
> > > __#include <linux/blktrace_api.h>
> > > +#ifdef CONFIG_BLOCK
> > > __#include <linux/loop.h>
> > > +#endif
> > 
> > Adding #ifdef around an #include is considered bad style. Better just
> > make loop.h compile without any conditionals. Does the below
> > patch work for you?
> 
> This is the classic why-typedefs-are-bad.  AFAIK there is no way of fixing
> this build error apart from adding otherwise-unneeded nested inclusions
> (very bad), or:
> 
> > 	Arnd <><
> > 
> > --- a/include/linux/loop.h
> > +++ b/include/linux/loop.h
> > @@ -63,7 +63,7 @@ struct loop_device {
> >  	struct task_struct	*lo_thread;
> >  	wait_queue_head_t	lo_event;
> >  
> > -	request_queue_t		*lo_queue;
> > +	struct request_queue	*lo_queue;
> >  	struct gendisk		*lo_disk;
> >  	struct list_head	lo_list;
> >  };
> 
> Good start.  Now can we do the rest of the kernel?  ;)

Yep indeed, it's been my plan to kill that ugly typedef for some time...

-- 
Jens Axboe

