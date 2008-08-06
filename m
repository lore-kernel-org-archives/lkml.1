Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbYHFTcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbYHFTcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbYHFTby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:31:54 -0400
Received: from mail.suse.de ([195.135.220.2]:40726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbYHFTbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:31:53 -0400
Date: Wed, 6 Aug 2008 12:29:13 -0700
From: Greg KH <gregkh@suse.de>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
Message-ID: <20080806192913.GA29239@suse.de>
References: <Pine.LNX.4.44L0.0808061508430.12900-100000@iolanthe.rowland.org> <4899F96D.9060809@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4899F96D.9060809@simon.arlott.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 08:20:13PM +0100, Simon Arlott wrote:
> On 06/08/08 20:11, Alan Stern wrote:
>> On Wed, 6 Aug 2008, Simon Arlott wrote:
>>> On 31/07/08 20:16, Alan Stern wrote:
>>> >> > It's not entirely clear why usblp is blocking at all.  Probably 
>>> because
>>> >> > it is waiting on the device semaphores for devices that are 
>>> currently
>>> >> > being probed -- the driver core won't allow two threads to probe the
>>> >> > same device concurrently.
>>> >> >> Ok - so there could be some big improvements to be had by making 
>>> the hcd >> init happen as early as possible and the device initcalls 
>>> later?
>>> > > Maybe.  Perhaps a better approach would be to make the device driver 
>>> > initcalls before there are any devices for their probe routines to > 
>>> block on.
>>> What about this?
>>> The Makefiles become a bit messy, but by moving things around I get the 
>>> desired effect without splitting their initcalls.
>> Wouldn't it be much simpler, and less objectionable, to do what I
>> suggested earlier?  That is, add a 5-second delay at the start of
>> hub_thread() in drivers/usb/core/hub.c.  No messing with Makefiles, no
>> changes to the initcall scheduling.
>
> Aside from 5 seconds being too long, and anything less being a race between 
> hub_thread() and driver initcalls, it doesn't improve anything because 
> it'll still have to wait for the devices to finish initialising in 
> userspace instead.

And what is your boot time if the usb drivers are modules?

I'd much prefer that requirement to get a faster boot than to go around
mucking with the link-time ordering...

thanks,

greg k-h
