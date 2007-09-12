Return-Path: <linux-kernel-owner+w=401wt.eu-S965273AbXILKBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273AbXILKBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbXILKBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:01:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43447 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXILKBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:01:31 -0400
Date: Wed, 12 Sep 2007 03:01:23 -0700
From: Greg KH <greg@kroah.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Heiko Schocher <hs@denx.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Detlev Zundel <dzu@denx.de>
Subject: Re: SYSFS: need a noncaching read
Message-ID: <20070912100123.GA23182@kroah.com>
References: <1189503798.6674.46.camel@Zeus.EmbLux> <20070912053207.GH23573@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912053207.GH23573@pengutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 07:32:07AM +0200, Robert Schwebel wrote:
> On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> > I have developed a device driver and use the sysFS to export some
> > registers to userspace.
> 
> Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
> not to play around with registers from userspace.
> 
> > I opened the sysFS File for one register and did some reads from this
> > File, but I alwas becoming the same value from the register, whats not
> > OK, because they are changing. So I found out that the sysFS caches
> > the reads ... :-(
> 
> Yes, it does. What you can do is close()ing the file handle between
> accesses, which makes it work but is slow.

Do an lseek back to 0 and then re-read, you will get called in your
driver again.

Not that this is a good thing to do for this kind of thing, as others
have already said.

thanks,

greg k-h
