Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbXBVJ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbXBVJ22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXBVJ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:28:27 -0500
Received: from tim.rpsys.net ([194.106.48.114]:39471 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXBVJ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:28:26 -0500
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
From: Richard Purdie <rpurdie@rpsys.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Paul Sokolovsky <pmiscml@gmail.com>
In-Reply-To: <20070222082848.GM4641@enneenne.com>
References: <20070221145353.GA23916@enneenne.com>
	 <1172105946.5790.78.camel@localhost.localdomain>
	 <20070222082848.GM4641@enneenne.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:27:09 +0000
Message-Id: <1172136430.5837.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 09:28 +0100, Rodolfo Giometti wrote:
> On Thu, Feb 22, 2007 at 12:59:06AM +0000, Richard Purdie wrote:
> > 
> > Reading through the patch its:
> > 
> > 1) Not against any mainline kernel

Sorry, I'd missed a patch entering mainline,

> > 2) Not against a recent kernel
> 
> I'm sorry, but the patch applay against the latest kernel. Please, try
> it.

but this still applies as there were a number of backlight changes
merged just before 2.6.21-rc1 and your driver will not work with
2.6.21-rc1.

> > As mentioned by others, there is no need to tie the backlight driver
> > into the framebuffer any more. Have a look at
> > drivers/video/backlight/corgi_bl.c for an example (its used by PXA
> > devices).
> z
> That driver uses the backlight class support as my patch does into
> pxafb.

Yes, my point is that you shouldn't need to touch pxafb if you use the
backlight class. I know pxafb has backlight hooks but they are probably
going to get removed at some point as they should no longer be needed.

> > I have said elsewhere I will take patches to make corgi_bl a more
> > generic driver (or maybe create a simple generic backlight driver) along
> > the lines of what Paul mentioned.
> 
> I see.
> 
> I suppose you are the backlight support mantainer, so what do you
> suggest to do to "make corgi_bl a more generic driver"?

What changes do you need to it to be able to use it as a generic driver?

The main issue is that the structure definition is in one of the
sharpsl.h files at the moment so most drivers can't get to it. Fix that
and it should make a good generic driver.

Ideally I'd prefer to leave the name alone since there is broken
userspace on the Zaurus that uses that name but I can see why people
want it renamed if its to be used as a generic driver...

Richard

