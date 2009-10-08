Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZJHQ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZJHQ6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZJHQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:58:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33099 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751657AbZJHQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:58:44 -0400
Date: Thu, 8 Oct 2009 12:58:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <200910081727.11745.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0910081253420.2765-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Oliver Neukum wrote:

> Am Donnerstag, 8. Oktober 2009 16:58:39 schrieb Alan Stern:
> > On Thu, 8 Oct 2009, Oliver Neukum wrote:
> > > Am Mittwoch, 7. Oktober 2009 23:34:12 schrieb Alan Stern:
> 
> > > > Other schemes could work, but to me it seems simplest to rely on a flag
> > > > protected by a spinlock.  The flag would mean "URBs are supposed to be
> > > > queued unless we are suspended".  It would be set by open and
> > > > unthrottle, and cleared by close and throttle.
> > >
> > > 1. Why a spinlock?
> >
> > Because the amount of work involved seems too small for a mutex.  But
> > you could use a mutex if you wanted, since everything occurs in process
> > context.
> 
> We have to submit URBs under that lock.

Yes.  What's your point?

> > > 2. Can we get by with only one flag?
> >
> > If all you want to do is answer a single question ("Should URBs be
> > submitted") then a single flag should be all you need.  Why, do you
> > think more information will be necessary?  You can always add more.
> 
> We have at least three reasons URBs should not be submitted.
> - closure
> - throttling
> - suspension
> Resume() should not submit if either closure or throttling are active,
> neither should unthrottle() resubmit if closure or suspension are active.

True.  Nor should open() submit if throttling is active.  Feel free to 
use three separate flags.  :-)

Alan Stern

