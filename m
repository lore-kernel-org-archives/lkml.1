Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbZJHUGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbZJHUGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933407AbZJHUGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:06:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45359 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933397AbZJHUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:06:47 -0400
Date: Thu, 8 Oct 2009 16:06:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <Pine.LNX.4.44L0.0910081253420.2765-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0910081601350.2765-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Alan Stern wrote:

> > > > 2. Can we get by with only one flag?
> > >
> > > If all you want to do is answer a single question ("Should URBs be
> > > submitted") then a single flag should be all you need.  Why, do you
> > > think more information will be necessary?  You can always add more.
> > 
> > We have at least three reasons URBs should not be submitted.
> > - closure
> > - throttling
> > - suspension
> > Resume() should not submit if either closure or throttling are active,
> > neither should unthrottle() resubmit if closure or suspension are active.
> 
> True.  Nor should open() submit if throttling is active.  Feel free to 
> use three separate flags.  :-)

On further thought, unthrottle should autoresume if the device is 
open and autosuspended (but it shouldn't do anything if the device is 
suspended).  After all, the reason for the autosuspend may have been 
the lack of activity caused by the throttling.

In practice this isn't likely to come up.  It would be surprising if 
throttling lasted long enough to cause an autosuspend or if the core 
decided to throttle while the device was autosuspended and hence idle.

Alan Stern

