Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYLEQDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYLEQDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLEQDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:03:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35021 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980AbYLEQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:03:42 -0500
Date: Fri, 5 Dec 2008 11:03:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Marc Haber <mh+linux-kernel@zugschlus.de>
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: pl2303 - pl2303_open - failed submitting interrupt urb, error
 -28
In-Reply-To: <20081205121023.GA21963@torres.zugschlus.de>
Message-ID: <Pine.LNX.4.44L0.0812051100560.2588-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Marc Haber wrote:

> On Wed, Dec 03, 2008 at 07:47:25AM -0800, Greg KH wrote:
> > I would suggest using a USB 1.1 hub instead if you have to use this kind
> > of hardware set up.
> 
> It is nearly impossible to buy that kind of hardware at the current
> time.
> 
> >   I think the core is just not able to schedule so many interrupt urbs
> >   with such a setup, running USB 1.1 devices behind a USB 2.0 hub like
> >   this is a very difficult thing to do.
> > 
> > Sorry I don't have a better solution.
> 
> Is it possible to disable USB 2.0 for selected links?

Yes it is.  You can force port P of the EHCI controller on bus B to run 
at low/full speed by doing:

	echo P >/sys/class/usb_host/usb_hostB/companion

To allow port P to run at high speed again, use the same command but 
write -P instead of P.

Alan Stern

