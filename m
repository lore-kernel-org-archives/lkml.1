Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXC0QFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXC0QFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbXC0QFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:05:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38132 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932837AbXC0QFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:05:02 -0400
Date: Tue, 27 Mar 2007 12:04:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Rientjes <rientjes@google.com>, Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] usb: call bdev_read_only() only on CONFIG_BLOCK
In-Reply-To: <20070327093725.GA2481@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.44L0.0703271200430.2558-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, Sam Ravnborg wrote:

> On Tue, Mar 27, 2007 at 02:03:25AM -0700, David Rientjes wrote:
> > bdev_read_only() is only defined on CONFIG_BLOCK so we make sure not to
> > call it unless we have it.  A new static inline function,
> > is_inode_read_only(), is invoked to call bdev_read_only() on CONFIG_BLOCK
> > and return zero otherwise.
> > 
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  drivers/usb/gadget/file_storage.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> > --- a/drivers/usb/gadget/file_storage.c
> > +++ b/drivers/usb/gadget/file_storage.c
> > @@ -3493,6 +3493,14 @@ static int fsg_main_thread(void *fsg_)
> >  	complete_and_exit(&fsg->thread_notifier, 0);
> >  }
> >  
> > +#ifdef CONFIG_BLOCK
> > +static inline int is_inode_read_only(struct inode *inode)
> > +{
> > +	return bdev_read_only(inode->i_bdev);
> > +}
> > +#else
> > +#define is_inode_read_only(inode)	(0)
> > +#endif
> 
> This looks like the wrong place to fix this.
> Like we do with for exampel the pci_ functions we should provide a dummy
> implementation in the kernel if configured without CONFIG_BLOCK.
> 
> In this way the decision to provide dummy functions are centralized
> and benefits all users.

In any case this patch is unnecessary.  There is a patch in the USB 
development tree making USB_FILE_STORAGE dependent on CONFIG_BLOCK.

Alan Stern

