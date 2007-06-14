Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXFNUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXFNUhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXFNUg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:36:59 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:4827 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbXFNUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:36:58 -0400
X-Greylist: delayed 2047 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 16:36:58 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Christoph Hellwig <hch@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: libertas (private) ioctls vs. nl80211
Date: Thu, 14 Jun 2007 22:03:13 +0200
User-Agent: KMail/1.9.7
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org>
In-Reply-To: <20070614170901.GA13384@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142203.13779.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Independent of any nl80211 status the private libertas ioctls have to
> go.  Not only don't we want private ioctls for mesh networking but
> rather have it as driver-independent interface, but the actual
> libertas interface is the worst possible choice.

I have been told that the Libertas mesh functionality is not 802.11s, 
Marvell brew their own beer (because it predates 802.11s, I guess). 
However, for the kernel I'd see more an interface that supports 
802.11s --- or is flexible to support both this and the libertas one.


I also have two related observations:

If I'm correctt, the only non-mesh ioctl in ioctl.c is the led_gpio 
ioctl. Theoretically one can abstract this, many WLAN chips have GPIOs. 
But mostly there is no documentation available about how those GPIOs 
are used, where they are soldered to etc. To blindly allow changing 
arbitrary GPIOs migth even be harmful to the hardware.

That said: with the USB 8388 dongle that I have, the LED GPIO iwpriv 
call didn't do anything. Not sure if it works on OLPC ... but I doubt 
that one can see the LEDs there ...


Another thing: I'm working on a CF 8385 based driver. Here I have a 
firmware that does not (as far as I know this undocumented pile of 
bytes) have any mesh functionality at all. So I need a way from if_cs.c 
to disable all those iwpriv ioctls. Haven't thought about this issue 
yet, other things are more pressing right now. However, I already don't 
create the mshX interface.

