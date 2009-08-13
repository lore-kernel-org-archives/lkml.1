Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZHMVav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZHMVav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZHMVav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:30:51 -0400
Received: from kroah.org ([198.145.64.141]:47165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZHMVau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:30:50 -0400
Date: Thu, 13 Aug 2009 14:27:50 -0700
From: Greg KH <greg@kroah.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] Combine two one-character CR-LF writes into one
 two-character write for O_ONLCR
Message-ID: <20090813212750.GB24127@kroah.com>
References: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
 <20090813205018.4d781c74@lxorguk.ukuu.org.uk>
 <20090813195554.GA22751@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813195554.GA22751@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 12:55:54PM -0700, David VomLehn wrote:
> On Thu, Aug 13, 2009 at 08:50:18PM +0100, Alan Cox wrote:
> > > do_output_char() function uses the struct tty_operations function write_room()
> > > to determine whether it is possible to write two characters. It uses
> > > tty_put_char() for each character which, for the USB generic serial driver,
> > > translates into a write() for each character. For the USB generic serial
> > > driver the value returned by write_room() only applies to the next write().
> > 
> > The USB serial driver is broken, fix it instead. It's not even hard to
> > fix.
> > 
> > > +			tty->ops->write(tty, crlf, ARRAY_SIZE(crlf));
> > > +			return ARRAY_SIZE(crlf);
> > 
> > Emphatic NAK. Someone needs to actually fix the broken USB drivers for
> > once. This is just one example of where the device will go kersplat if its
> > broken, others include things like losing flow control.
> 
> Works for me; please consider the patch withdrawn. I'll take a crack at fixing
> the generic serial driver the right way; if other drivers are doing mix-and-match
> with per-device code and generic code, they could get broken. I have no way to
> test for this, so I'm hoping others will help out.

I have a whole box of different usb-serial devices, and can test just
about everything out.

thanks,

greg k-h
