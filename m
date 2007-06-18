Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbXFRV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbXFRV12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762553AbXFRV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:27:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762667AbXFRV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:27:21 -0400
Date: Mon, 18 Jun 2007 14:27:13 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] debugfs: create file error handling
Message-ID: <20070618142713.4d030a42@localhost.localdomain>
In-Reply-To: <20070618205727.GA14857@kroah.com>
References: <20070618134132.463a6699@localhost.localdomain>
	<20070618205727.GA14857@kroah.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 13:57:27 -0700
Greg KH <greg@kroah.com> wrote:

> On Mon, Jun 18, 2007 at 01:41:32PM -0700, Stephen Hemminger wrote:
> > Shouldn't Debugfs file routines should either return NULL or use ERR_PTR()
> > not mixed? The following patch changes the create routines to
> > propagate return values.
> > 
> > --- a/fs/debugfs/file.c	2007-05-30 10:32:32.000000000 -0700
> > +++ b/fs/debugfs/file.c	2007-06-18 13:38:01.000000000 -0700
> > @@ -83,12 +83,11 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs
> >   * This function will return a pointer to a dentry if it succeeds.  This
> >   * pointer must be passed to the debugfs_remove() function when the file is
> >   * to be removed (no automatic cleanup happens if your module is unloaded,
> > - * you are responsible here.)  If an error occurs, %NULL will be returned.
> > + * you are responsible here.)
> >   *
> > - * If debugfs is not enabled in the kernel, the value -%ENODEV will be
> > - * returned.  It is not wise to check for this value, but rather, check for
> > - * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
> > - * code.
> > + * If an error occurs, an invalid pointer will be returned, use
> > + * the function IS_ERR() to check. The error code can be extracted
> > + * with PTR_ERR().
> 
> No, you are forgetting the issue when debugfs is not enabled in the
> kernel.
> 
> The goal is not to return -ENODEV when it's not configured in, to make
> it "simpler" to handle that case.

But it makes sense to pass error values back not just: create failed
sorry!

> 
> Check the lkml archives for previous times this has come up and example
> code to use to handle the error cases properly.
> 
> I agree it isn't the "simplest" way, and if you can suggest something
> that is easier, and allow for the code to "easily" determine the option
> isn't built in that would be great.

Checking for ENODEV works fine in either case.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
