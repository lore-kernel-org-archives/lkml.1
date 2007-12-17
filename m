Return-Path: <linux-kernel-owner+w=401wt.eu-S937507AbXLQXW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937507AbXLQXW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937155AbXLQXVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:21:23 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:41199 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936666AbXLQXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:21:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: mvtodevnull@gmail.com
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Tue, 18 Dec 2007 00:18:56 +0100
User-Agent: KMail/1.9.6
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "Simon Holm =?iso-8859-1?q?Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <200712172345.20710.mb@bu3sch.de> <520b60a90712171512vcab7fb6of7732466ccb85996@mail.gmail.com>
In-Reply-To: <520b60a90712171512vcab7fb6of7732466ccb85996@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712180018.57272.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 00:12:30 mvtodevnull@gmail.com wrote:
> On Dec 17, 2007 5:45 PM, Michael Buesch <mb@bu3sch.de> wrote:
> >
> > Ehm, excuse me.
> > What are you doing exactly? In this thread you told me you have
> > a device which requires b43:
> >
> 
> Well, I'm not sure what you mean by "requires" b43, but I did say that
> the device uses the b43 driver.

Requires means requires.

> Sorry, I should have been more specific. I figured since the device
> could use bcm43xx, it could also use b43legacy, so I copied the
> entries in b43_ssb_tbl[] to b43legacy_ssb_tbl[] and rebuilt the
> b43legacy driver. I removed the b43 and ssb modules, and inserted the
> b43legacy module. Afterwards, I noticed b43 had still been autoloaded,
> so I removed it (I checked dmesg and only b43legacy had initialized
> anyway) , and proceeded to use the b43legacy driver with the version 3
> firmware. And like I said, it works exactly like the b43 driver with
> the version 4 firmware.

I'm not sure what you are trying to show with this hack.
It's been said several times in this thread that the firmware has
nothing to do with the device radio.
So it won't affect the transmit rate or something like that.

Note that the difference between b43 and b43legacy is NOT that the
driver is "legacy". It is called legacy because it does _only_ support
legacy _devices_. So if you hack it to drive a new card it will only
work by luck (luck as in there might be some code left over which
is able to initialize the device somehow.). My point being, we removed
code for new devices from b43legacy and are probably going to remove
even more stuff in the future. So there is simply no point in testing
any new device with b43legacy.

-- 
Greetings Michael.
