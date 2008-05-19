Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbYESRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbYESRwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbYESRwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:52:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59512 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYESRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:52:08 -0400
Date: Mon, 19 May 2008 10:51:21 -0700
From: Greg KH <greg@kroah.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH 01/20] tty: Introduce a tty_port common structure
Message-ID: <20080519175121.GA25150@kroah.com>
References: <20080519144557.19326.74313.stgit@core> <20080519145013.19326.38344.stgit@core> <20080519174738.GA20961@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519174738.GA20961@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 07:47:39PM +0200, Sam Ravnborg wrote:
> Hi Alan.
> 
> On Mon, May 19, 2008 at 03:50:13PM +0100, Alan Cox wrote:
> > From: Alan Cox <alan@redhat.com>
> > 
> > Every tty driver has its own concept of a port structure and because they all
> > differ we cannot extract commonality. Begin fixing this by creating a structure
> > drivers can elect to use so that over time we can push fields into this and
> > create commonality and then introduce common methods.
> > ---
> > 
> >  drivers/char/tty_io.c |   37 +++++++++++++++++++++++++++++++++++++
> >  include/linux/tty.h   |   29 +++++++++++++++++++++++++++++
> >  2 files changed, 66 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> > index 49c1a22..fb17b18 100644
> > --- a/drivers/char/tty_io.c
> > +++ b/drivers/char/tty_io.c
> > @@ -2004,6 +2004,43 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
> >  	return tty_write(file, buf, count, ppos);
> >  }
> >  
> > +void tty_port_init(struct tty_port *port)
> > +{
> > +	memset(port, 0, sizeof(*port));
> > +	init_waitqueue_head(&port->open_wait);
> > +	init_waitqueue_head(&port->close_wait);
> > +	mutex_init(&port->mutex);
> > +}
> > +
> > +EXPORT_SYMBOL(tty_port_init);
> A small nitpick...
> The typical style is to let the EXPORT_SYMBOL follow the closing
> brace with no extra empty line.

I'll run them through checkpatch.pl and fix up any minor things like
this before sending them off, that's part of my normal patch-queue
process :)

thanks,

greg k-h
