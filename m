Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbZJHO7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbZJHO7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZJHO7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:59:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54261 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757109AbZJHO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:59:16 -0400
Date: Thu, 8 Oct 2009 10:58:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <200910081543.01933.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0910081054300.2986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Oliver Neukum wrote:

> Am Mittwoch, 7. Oktober 2009 23:34:12 schrieb Alan Stern:
> > I'm losing track of the original point of this thread.  IIRC, the
> > problem is how the resume method should know whether or not to submit
> > the receive URB(s).  It can't afford to acquire the port mutex because
> > it might be called by open or close, at which time the mutex is already
> > held.
> >
> > Other schemes could work, but to me it seems simplest to rely on a flag
> > protected by a spinlock.  The flag would mean "URBs are supposed to be
> > queued unless we are suspended".  It would be set by open and
> > unthrottle, and cleared by close and throttle.
> 
> 1. Why a spinlock?

Because the amount of work involved seems too small for a mutex.  But 
you could use a mutex if you wanted, since everything occurs in process 
context.

> 2. Can we get by with only one flag?

If all you want to do is answer a single question ("Should URBs be 
submitted") then a single flag should be all you need.  Why, do you 
think more information will be necessary?  You can always add more.

Alan Stern

