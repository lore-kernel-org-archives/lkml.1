Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbZEFVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbZEFVxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbZEFVx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:53:29 -0400
Received: from kroah.org ([198.145.64.141]:56809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123AbZEFVx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:53:28 -0400
Date: Wed, 6 May 2009 14:32:09 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to
	forcewrites
Message-ID: <20090506213209.GA18511@kroah.com>
References: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org> <200905062201.42965.oliver@neukum.org> <4A01F201.3020406@windriver.com> <20090506202821.GA12449@kroah.com> <4A01F842.9080300@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01F842.9080300@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 03:51:14PM -0500, Jason Wessel wrote:
> Greg KH wrote:
> >> Doing enough printk's such as in register_console() will cause loss
> >> because you run out of URBs unless you can force them to complete.
> >>     
> >
> > Why not just make the upper bound of urbs very large?  We used to have
> > an unlimited number of in-flight urbs for some drivers until it was
> > pointed out that a simple:
> > 	cat /dev/null > /dev/ttyUSB0
> > would cause a DoS :)
> >
> > What happens if your upper bound is 400?  4000?  Will that work
> > properly?
> >   
> Sure, if you have enough of a urb available, ultimately you get all the
> printk's.

Good, then you just solved your issue with no nasty host driver hack.

> If I want to printk from the nmi_watchdog out to this device, am I going
> to get anything if the write is not synchronous, because in theory the
> hcd device is never going to get accessed again?

No you are not, sorry, USB doesn't work without interrupts in this kind
of mode at all.

> Ideally I want to make sure that somehow I get my debug output out to
> the console, even if it means we do some polling after the oops state is
> set.

That's going to be "interesting" to try to accomplish :)

good luck,

greg k-h
