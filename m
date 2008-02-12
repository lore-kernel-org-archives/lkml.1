Return-Path: <linux-kernel-owner+w=401wt.eu-S1764208AbYBLScN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764208AbYBLScN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762269AbYBLSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:31:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48660 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762006AbYBLSbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:31:53 -0500
Message-ID: <47B1E616.8040603@garzik.org>
Date: Tue, 12 Feb 2008 13:31:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: multiple drivers, single device (was Re: Announce: Linux-next
 (Or Andrew's dream  :-)))
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org> <20080212164232.GA326@kroah.com> <47B1DDD3.2000402@garzik.org> <20080212181037.GA2445@kroah.com>
In-Reply-To: <20080212181037.GA2445@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Except that the individual drivers are a lot of the time written by
> different people, live in different portions of the tree, and are
> combined into different combinations depending on the chipset.

Yes -- the worst case is that people have to work together, and it 
tweaks people who like to organize source files nicely into directories :)


> For i2c devices, I see the scx200_acb, i2c-elektor, i2c-sis5595, and
> i2c-sis630 drivers needing this.  The last one happens to share the pci
> device with a video driver, that doesn't always need to be / want to be
> loaded by users just so they can read the temperature of their
> processors.

Sure.  Reasonable request, and doable within today's APIs.


> Oh, the EDAC code also needs this, and I know that no one wants to merge
> that stuff into their individual drivers :)

So people have to work together...  darn :)  most drivers these days are 
organized nicely into nicely modular units anyway, making it easy to 
write a "shell" driver that simply registers each sub-driver, and helps 
arbitrate/provide resources to sub-units.

Consider, for example, a PCI driver that loads, and then fills in 
platform_data to provide a specific set of resources to a platform 
driver (a common idiom).  You would need to create parented struct 
devices (parent: pci_dev's device), but everything else should work within

I could even forsee a future where most drivers are written in a generic 
platform-driver style, and PCI|sbus|embedded-bus|blah are simply 
bus-specific shells that fill in platform data.

All of this should be nicely possible within the existing usage of 
struct device, platform drivers, generic DMA API, iomap, etc.

	Jeff



