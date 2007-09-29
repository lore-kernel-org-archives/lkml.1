Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXI2R1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXI2R1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXI2R1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:27:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:59218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXI2R1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:27:31 -0400
Date: Sat, 29 Sep 2007 10:17:22 -0700
From: Greg KH <gregkh@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module: return error when mod_sysfs_init() failed
Message-ID: <20070929171722.GA18041@suse.de>
References: <20070929100653.GA4121@APFDCB5C> <20070929145646.GB3075@suse.de> <961aa3350709290837m2d9d6668gd68b7cb8ac11e4d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350709290837m2d9d6668gd68b7cb8ac11e4d4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 12:37:10AM +0900, Akinobu Mita wrote:
> 2007/9/29, Greg KH <gregkh@suse.de>:
> > > Index: 2.6-git/kernel/module.c
> > > ===================================================================
> > > --- 2.6-git.orig/kernel/module.c
> > > +++ 2.6-git/kernel/module.c
> > > @@ -1782,7 +1782,8 @@ static struct module *load_module(void _
> > >       module_unload_init(mod);
> > >
> > >       /* Initialize kobject, so we can reference it. */
> > > -     if (mod_sysfs_init(mod) != 0)
> > > +     err = mod_sysfs_init(mod);
> > > +     if (err)
> > >               goto cleanup;
> >
> > I must be still asleep this morning, but I think this patch does the
> > exact same thing as the original code does, right?  Otherwise, this
> > code would always be failing.
> >
> > Or do I just need to go get my morning coffee to wake up and see the
> > problem here?
> 
> Hello,
> 
> In the original code, the "err" is zero before goto cleanup.
> This "err" will be the return value of load_module().

Ah, ok, that makes sense now, thanks.  It was the error not getting
returned, it was not the fact that we were incorrectly checking the
return value of mod_sysfs_init.

thanks for clearing this up.

greg k-h
