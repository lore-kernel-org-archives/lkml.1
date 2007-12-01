Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbXLAA7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbXLAA7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXLAA7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:59:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbXLAA7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:59:37 -0500
Date: Fri, 30 Nov 2007 16:58:35 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
	functions
Message-ID: <20071201005835.GA4745@kroah.com>
References: <20071130222629.GA7653@kroah.com> <Pine.LNX.4.44L0.0711301816290.2747-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711301816290.2747-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 06:22:37PM -0500, Alan Stern wrote:
> On Fri, 30 Nov 2007, Greg KH wrote:
> >  And you
> > can't know that, so you have to call kobject_put() in order to be safe
> > and clean up everything.
> > 
> > Now why did we not do the final kobject_put() in kobject_del() as well?
> > Doing two calls, always in order, seems a bit strange, anyone know why
> > it's this way?
> 
> To be symmetrical with kobject_init() and kobject_add().  Besides, 
> isn't there kobject_unregister()?  Presumably it will go away along 
> with kobject_register(), though.

Yes, it will go away too, once everyone gets converted.

> > > You could put that a little less strongly.  After kobject_init() you
> > > SHOULD call kobject_put() to clean up properly, and after kobject_add()
> > > you MUST call kobject_del() and kobject_put().
> >
> > No, in looking at the code, you only need to call kobject_del() to clean
> > everything up properly, if kobject_add() succeeds.  No need to call
> > kobject_put() yet again.
> 
> Sorry, yes, that's what I meant.  After a successful call to 
> kobject_add() you must call kobject_del() to undo the _add, and then
> kobject_put() for the final cleanup.

No, kobject_del() does the put for you[1].  All that is needed is a call
to kobject_del().

I'll post the updated patches in a minute, they look and seem to work
much better.

thanks,

greg k-h
