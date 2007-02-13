Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXBMWa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXBMWa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXBMWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:30:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:40335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXBMWa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:30:58 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Greg KH <greg@kroah.com>
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Date: Tue, 13 Feb 2007 14:30:46 -0800
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, neilb@suse.de, viro@zeniv.linux.org.uk,
       hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070213195116.GA5181@kroah.com> <200702131158.02809.agruen@suse.de> <20070213213737.GA14383@kroah.com>
In-Reply-To: <20070213213737.GA14383@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131430.47053.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 13:37, Greg KH wrote:
> On Tue, Feb 13, 2007 at 11:58:02AM -0800, Andreas Gruenbacher wrote:
> > > I'm running pretty new GNOME and dbus here:
> > > 	dbus 1.0.2
> > > 	gnome 2.16.2
> > > 	hal 0.5.7.1
> > > 	nautilus 2.16.3
> > >
> > > Any ideas of things I can test?
> >
> > Sorry for the breakage. Printk of the __d_path result may tell:
> >
> > Index: b/fs/dcache.c
> > ===================================================================
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1803,6 +1803,8 @@ char *__d_path(struct dentry *dentry, st
> >
> >  out:
> >         spin_unlock(&dcache_lock);
> > +	printk(KERN_DEBUG "%s(%d): %s\n", current->comm, current->pid,
> > +	       IS_ERR(buffer) ? "failed" : buffer);
> > 	return buffer;
>
> This causes the following to just loop over and over, incrementing the
> pid:
>
> gnome-vfs-daemo(8914):

That's the weird case, and it should only trigger if there's no path to be 
recovered from what gnome-vfs-deamon calls d_path on, like a lazily unmounted 
filesystem. (A bind mount wouldn't do.)

> I'm running gnome-vfs version 2.6.13 if that matters.
>
> Anything else I can try?

I guess I'll just have to check what gnome-vfs-deamon does, thanks.

Andreas
