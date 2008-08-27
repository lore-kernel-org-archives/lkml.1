Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYH0S6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYH0S6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYH0S6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:58:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32983 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752248AbYH0S6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:58:09 -0400
Date: Wed, 27 Aug 2008 14:58:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>
cc: USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
 2
In-Reply-To: <20080827183615.GA15692@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Greg KH wrote:

> On Wed, Aug 27, 2008 at 02:28:22PM -0400, Alan Stern wrote:
> > On Wed, 27 Aug 2008, Greg KH wrote:
> > 
> > > Here's an updated version of the usbtmc driver, with all of the
> > > different issues that have been raised, hopefully addressed.
> > 
> > This is an example of what I was discussing with Oliver.  In all 
> > likelihood you simply don't need usbtmc_mutex, and using it will cause 
> > a lockdep violation.
> > 
> > That's why so many of the other USB class drivers don't have an 
> > analogous static mutex.
> 
> Ok, then it's just safe to drop this static mutex entirely, right?

Yes, once you add the call to usb_deregister_dev.


On Wed, 27 Aug 2008, Oliver Neukum wrote:

> And this rule depends on sharing the USB major or not. This needs
> a big fat mention in Documentation.

You mean that the open/disconnect locking rule applies only to drivers 
that call usb_register_dev, i.e, drivers using the USB major.  Right?

I agree that it deserves to be mentioned in the documentation 
somewhere.  Where would be a good place?  None of the existing files in 
Documentation/usb seem appropriate.

Alan Stern

