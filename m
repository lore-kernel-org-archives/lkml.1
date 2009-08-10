Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZHJQiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZHJQiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:38:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZHJQiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:38:01 -0400
Received: from kroah.org ([198.145.64.141]:44665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZHJQiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:38:00 -0400
Date: Mon, 10 Aug 2009 09:36:52 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090810163652.GB28091@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090809120902.GC1338@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090809120902.GC1338@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 02:09:02PM +0200, Pavel Machek wrote:
> Hi!
> 
> > --- /dev/null
> > +++ b/drivers/base/devtmpfs.c
> > @@ -0,0 +1,367 @@
> > +/*
> > + * devtmpfs - kernel-maintained tmpfs-based /dev
> > + *
> > + * Copyright (C) 2009, Kay Sievers <kay.sievers@vrfy.org>
> > + *
> 
> I'd expect GPL notice here...

But it's not needed, the overall license of the kernel covers it.

> > +#if defined CONFIG_DEVTMPFS_MOUNT
> > +static int dev_mount = 1;
> > +#else
> > +static int dev_mount;
> > +#endif
> 
> 
> A bit too many config options?

It's only 1 option, is that 1 too many for you?

> > +#ifdef CONFIG_BLOCK
> > +static inline int is_blockdev(struct device *dev)
> > +{
> > +	return dev->class == &block_class;
> > +}
> > +#else
> > +static inline int is_blockdev(struct device *dev) { return 0; }
> 
> Should this go to header somewhere?

It could go in device.h, but do others need it?

thanks,

greg k-h
