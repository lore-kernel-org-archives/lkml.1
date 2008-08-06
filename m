Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbYHFTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbYHFTL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbYHFTLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:11:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36289 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756686AbYHFTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:11:12 -0400
Date: Wed, 6 Aug 2008 15:11:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <4899F035.9040003@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808061508430.12900-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Simon Arlott wrote:

> On 31/07/08 20:16, Alan Stern wrote:
> >> > It's not entirely clear why usblp is blocking at all.  Probably because
> >> > it is waiting on the device semaphores for devices that are currently
> >> > being probed -- the driver core won't allow two threads to probe the
> >> > same device concurrently.
> >> 
> >> Ok - so there could be some big improvements to be had by making the hcd 
> >> init happen as early as possible and the device initcalls later?
> > 
> > Maybe.  Perhaps a better approach would be to make the device driver 
> > initcalls before there are any devices for their probe routines to 
> > block on.
> 
> What about this?
> 
> The Makefiles become a bit messy, but by moving things around I get the 
> desired effect without splitting their initcalls.

Wouldn't it be much simpler, and less objectionable, to do what I
suggested earlier?  That is, add a 5-second delay at the start of
hub_thread() in drivers/usb/core/hub.c.  No messing with Makefiles, no
changes to the initcall scheduling.

Alan Stern

