Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYBLSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYBLSNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761901AbYBLSMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:12:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35914 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761634AbYBLSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:12:52 -0500
Date: Tue, 12 Feb 2008 10:10:37 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: multiple drivers, single device (was Re: Announce: Linux-next
	(Or Andrew's dream  :-)))
Message-ID: <20080212181037.GA2445@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org> <20080212164232.GA326@kroah.com> <47B1DDD3.2000402@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1DDD3.2000402@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:56:35PM -0500, Jeff Garzik wrote:
> Greg KH wrote:
>> The work I'm doing here is for stupid PCI firmware engineers, who have
>> created devices that are different things, all bound up under the same
>> PCI device.  I'm thinking of watchdog timers and random number
>> generator and i2c controller on the same PCI device, or even the more
>> basic, frame buffer and DRM access to the same PCI video device.
>
> Yes, that has a known solution:  have your driver register i2c, rng, 
> watchdog, etc. functions.
>
> Works just fine inside today's infrastructure, no changes needed.

Except that the individual drivers are a lot of the time written by
different people, live in different portions of the tree, and are
combined into different combinations depending on the chipset.

For i2c devices, I see the scx200_acb, i2c-elektor, i2c-sis5595, and
i2c-sis630 drivers needing this.  The last one happens to share the pci
device with a video driver, that doesn't always need to be / want to be
loaded by users just so they can read the temperature of their
processors.

Oh, the EDAC code also needs this, and I know that no one wants to merge
that stuff into their individual drivers :)

Same goes for framebuffer vs. DRM.  Yeah, I know DRM ended up "winning"
here, but for some hardware setups, both are still valid, and it really
would be good for both drivers to be notified when the system is about
to go into suspend/resume and other stuff like that.

If the driver core can provide this in a simple manner, I think it is
worth it, especially as there are lots of hardware that seems to need
it.

thanks,

greg k-h
