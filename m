Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYHNPKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYHNPKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYHNPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:10:24 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:64092 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751946AbYHNPKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:10:24 -0400
Date: Thu, 14 Aug 2008 19:10:22 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linuxppc-dev@ozlabs.org, Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Message-ID: <20080814151022.GA9885@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808141604.22287.laurentp@cse-semaphore.com> <20080814141428.GA32296@oksana.dev.rtsoft.ru> <200808141645.56418.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200808141645.56418.laurentp@cse-semaphore.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 04:45:52PM +0200, Laurent Pinchart wrote:
> On Thursday 14 August 2008, Anton Vorontsov wrote:
> > On Thu, Aug 14, 2008 at 04:04:18PM +0200, Laurent Pinchart wrote:
> > > On Friday 08 August 2008, Anton Vorontsov wrote:
> > > > We'll need this function to write platform-specific hooks to deal
> > > > with pin's dedicated functions. Quite obviously this will work only
> > > > for the platforms with 1-to-1 GPIO to PIN mapping.
> > > > 
> > > > This is stopgap solution till we think out and implement a proper
> > > > api (pinlib?).
> > > 
> > > How do you support reverting the GPIO mode to non-dedicated ?
> > 
> > As we always do with the GPIO API: gpio_direction_*() calls.
> 
> So the proper sequence to configure a pin in dedicated mode is to set
> the direction first (which will unset the dedicated mode bit) and
> then set dedicated mode (which will not touch the direction bit) ?

Not exactly. But you can do this way, if you need to preserve
a direction. What I did is a bit different though.

qe_gpio_set_dedicated() actually just restores a mode that
firmware had set up, including direction (since direction could
be a part of dedicated configuration).

That is, upon GPIO controller registration, we save all registers,
then driver can set up a pin to a GPIO mode via standard API, and
then it can _revert_ a pin to a dedicated function via
qe_gpio_set_dedicated() call. Dedicated function is specified by
the firmware (or board file), we're just restoring it.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
