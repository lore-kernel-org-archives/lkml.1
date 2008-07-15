Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbYGOBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbYGOBqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYGOBqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:46:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47872 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYGOBqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:46:05 -0400
Message-ID: <487C0147.5070808@garzik.org>
Date: Mon, 14 Jul 2008 21:45:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>
In-Reply-To: <1216077806.27455.85.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Linus, please pull from the for-2.6.27 branch of:
> 	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27
> 
> This does the following (not quite in this order):
> 
>  - Provides a method for firmware files to be built into the kernel, so
>    that drivers can be updated to use request_firmware() without forcing
>    people to use an initrd.
> 
>  - In doing that, mark fw->data as 'const', and fix a few drivers to cope.
> 
>  - Update a bunch of drivers to use request_firmware(), and move their
>    existing firmware, previously hardcoded in all kinds of interesting
>    ways, into the firmware/ directory of the kernel tree.
> 
>  - Add a FIRMWARE_IN_KERNEL config option which allows the firmware for
>    the above (and below) drivers to continue to be built into the kernel.
> 
>  - Add a simple method for representing Intel HEX records in binary form,
>    since a bunch of drivers need that kind of thing. And a tool to
>    convert HEX files into that binary form, for the kernel to load.
> 
>  - Drop special cases from a few drivers which could either use
>    request_firmware() or build their firmware in; they don't need to
>    do that for themselves any more.
> 
>  - Implement 'make firmware_install' target, which installs all firmware
>    shipped with the kernel.
> 
>  - Modify 'make modules_install' to install any firmware required by the
>    modules it installs (where that firmware is shipped in the kernel tree).
> 
> There are more drivers to be converted to request_firmware() -- notably
> drivers/net and drivers/scsi, but it's probably best to ensure that the
> infrastructure is all in place and working correctly before we update
> those. (Although since modern drivers have been using request_firmware()
> for some time, I don't think there's likely to be a problem there; we'll
> probably clean up the stragglers in time for 2.6.28.)
> 
> David Howells (5):
>       Fix a const pointer usage warning in the Digigram VX soundcard driver
>       Fix a const assignment in moxa_load_fw()
>       Fix a const pointer error in the Conexant cx23418 MPEG encoder driver
>       Fix a const pointer usage warning in the Digigram pcxhr soundcard driver
>       Fix a const pointer usage warning in the Digigram miXart soundcard driver
> 
> Full shortlog and diffstat below, although the really interesting part
> is probably between commits fd4f80de..59890f74 -- seen at 
> http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=shortlog;h=59890f74


After the long threads, you would think you would have at least 
mentioned controversy attached to these changes?

Or perhaps mention that you are specifically excluding the ability to 
build firmware into modules -- the most reliable method available for 
those who use modules, MORE reliable than a system where firmware and 
kernel module are separated.

Or some of the objections raised, that were not met?

Or even _acknowledge_ that these changes have a high probability of 
creating a non-working driver, and therefore advising distros with Big 
Fat Warnings and Be Carefuls sprinkled liberally?

Or perhaps describe the outside-the-kernel migration path for distros?

Isn't it silly to create firmware/ top-level dir, when the firmware more 
naturally lives in the same dir as the driver to which it is intimately 
tied?  We'll just have to start creating firmware/net firmware/char 
firmware/media etc. after a while.

What about keeping binary objects as binary objects?  Surely git can 
handle binary file.  And you are already converting each firmware's data 
from format A to format B.  Might as well convert it to unpacked, 
un-ASCII'd format that will be loaded directly, as that can be easier in 
some cases.

I think it's just downright shady to push this crap without mentioning 
any of the swirl of issues surrounding this, that are quite relevant to 
its inclusion.

It should be obvious that building firmware into a kernel module (or the 
kernel itself, if you don't use modules) is _the_ most reliable method 
of ensuring your driver will work [if it requires firmware].

	Jeff



