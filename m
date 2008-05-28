Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYE1F3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYE1F3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYE1F24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:28:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59128 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbYE1F2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:28:55 -0400
Date: Tue, 27 May 2008 22:26:03 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH -next] block: genhd errors when CONFIG_PROC_FS=n
Message-ID: <20080528052603.GB8736@kroah.com>
References: <20080523094411.06f173e0.randy.dunlap@oracle.com> <20080527222036.1141e43a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527222036.1141e43a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:20:36PM -0700, Andrew Morton wrote:
> On Fri, 23 May 2008 09:44:11 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > block/genhd.c has build errors when CONFIG_PROC_FS=n, so omit some of
> > its functions in that case.
> > 
> > /local/linsrc/linux-next-20080523/block/genhd.c: In function 'diskstats_start':
> > /local/linsrc/linux-next-20080523/block/genhd.c:555: error: 'find_start' undeclared (first use in this function)
> > /local/linsrc/linux-next-20080523/block/genhd.c:555: error: (Each undeclared identifier is reported only once
> > /local/linsrc/linux-next-20080523/block/genhd.c:555: error: for each function it appears in.)
> > make[2]: *** [block/genhd.o] Error 1
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  block/genhd.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- linux-next-20080523.orig/block/genhd.c
> > +++ linux-next-20080523/block/genhd.c
> > @@ -539,6 +539,7 @@ static struct device_type disk_type = {
> >  	.release	= disk_release,
> >  };
> >  
> > +#ifdef CONFIG_PROC_FS
> >  /*
> >   * aggregate disk stat collector.  Uses the same stats that the sysfs
> >   * entries do, above, but makes them available through one seq_file.
> > @@ -644,6 +645,7 @@ const struct seq_operations diskstats_op
> >  	.stop	= diskstats_stop,
> >  	.show	= diskstats_show
> >  };
> > +#endif /* CONFIG_PROC_FS */
> >  
> >  static void media_change_notify_thread(struct work_struct *work)
> >  {
> 
> This is a fix against
> 
> commit ce8568d9535b4756ea304a97ea803314ce895d3c
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Thu May 22 17:21:08 2008 -0400
> 
>     block: make proc files seq_start use the class_find_device()
>     
>     Use the proper class iterator function instead of mucking around in the
>     internals of the class structures.
>     
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Yeah, sorry, missed that first time around, just added it to my tree
about an hour ago and sent out a response to Randy about it :)

thanks,

greg k-h
