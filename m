Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXLQX2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXLQX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937603AbXLQX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:27:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:47149 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbXLQX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L7eulVYOn4zNYFu/jbvD9d5yhb+/OA16VYRe6lkuYqrPjUlUC47YaPS03opZobBQhE6BiEft5p2VpKD1a/vzum/lvAgQcxNJdPoRbLItrzzCM0Tc+Di7NfLrS0eq4pu5AShNNPj5SAGLm77fAXDV0UBGhM2tdCwdgyaSIxNpJUA=
Message-ID: <520b60a90712171527h4563542ane34796b32e99635d@mail.gmail.com>
Date: Mon, 17 Dec 2007 18:27:44 -0500
From: mvtodevnull@gmail.com
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712180018.57272.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712172345.20710.mb@bu3sch.de>
	 <520b60a90712171512vcab7fb6of7732466ccb85996@mail.gmail.com>
	 <200712180018.57272.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 6:18 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 18 December 2007 00:12:30 mvtodevnull@gmail.com wrote:
> >
> > Well, I'm not sure what you mean by "requires" b43, but I did say that
> > the device uses the b43 driver.
>
> Requires means requires.
>

Ok, noted.

> > Sorry, I should have been more specific. I figured since the device
> > could use bcm43xx, it could also use b43legacy, so I copied the
> > entries in b43_ssb_tbl[] to b43legacy_ssb_tbl[] and rebuilt the
> > b43legacy driver. I removed the b43 and ssb modules, and inserted the
> > b43legacy module. Afterwards, I noticed b43 had still been autoloaded,
> > so I removed it (I checked dmesg and only b43legacy had initialized
> > anyway) , and proceeded to use the b43legacy driver with the version 3
> > firmware. And like I said, it works exactly like the b43 driver with
> > the version 4 firmware.
>
> I'm not sure what you are trying to show with this hack.
> It's been said several times in this thread that the firmware has
> nothing to do with the device radio.
> So it won't affect the transmit rate or something like that.
>
> Note that the difference between b43 and b43legacy is NOT that the
> driver is "legacy". It is called legacy because it does _only_ support
> legacy _devices_. So if you hack it to drive a new card it will only
> work by luck (luck as in there might be some code left over which
> is able to initialize the device somehow.). My point being, we removed
> code for new devices from b43legacy and are probably going to remove
> even more stuff in the future. So there is simply no point in testing
> any new device with b43legacy.
>

At the start of my discussion with Larry, I asked if the firmware
could cause such a difference. Larry said no, and I believed him, but
I'm very lost as to what could be causing such a difference between
bcm43xx and b43. I figured it was at least worth testing, I mean, it
wasn't like I was recommending others do the same.

I'm actually still using the b43legacy driver right now, and it really
does work exactly the same as b43. If you're interested, here's the
relevant section of dmesg from when I loaded the b43legacy driver:

ssb: SPROM revision 2 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:05:00.0
b43legacy-phy1: Broadcom 4311 WLAN found
b43legacy-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
b43legacy-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
b43legacy-phy1 debug: Radio initialized
phy1: Selected rate control algorithm 'simple'
b43legacy-phy1 debug: Loading firmware version 0x127, patch level 14
(2005-04-18 02:36:27)
Registered led device: b43legacy-phy1:tx
Registered led device: b43legacy-phy1:rx
b43legacy-phy1 debug: Chip initialized
b43legacy-phy1 debug: 32-bit DMA initialized
b43legacy-phy1 debug: Wireless interface started
b43legacy-phy1 debug: Adding Interface type 2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:09:5b:70:2d:68
wlan0: RX authentication from 00:09:5b:70:2d:68 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:09:5b:70:2d:68
wlan0: RX AssocResp from 00:09:5b:70:2d:68 (capab=0x5 status=0 aid=86)
wlan0: associated
b43legacy-phy1 debug: Removing Interface type 2
b43legacy-phy1 debug: Wireless interface stopped
b43legacy-phy1 debug: DMA-32 0x0200 (RX) max used slots: 1/64
b43legacy-phy1 debug: DMA-32 0x02A0 (TX) max used slots: 0/128
b43legacy-phy1 debug: DMA-32 0x0280 (TX) max used slots: 0/128
b43legacy-phy1 debug: DMA-32 0x0260 (TX) max used slots: 0/128
b43legacy-phy1 debug: DMA-32 0x0240 (TX) max used slots: 0/128
b43legacy-phy1 debug: DMA-32 0x0220 (TX) max used slots: 2/128
b43legacy-phy1 debug: DMA-32 0x0200 (TX) max used slots: 0/128
b43legacy-phy1 debug: Radio initialized
b43legacy-phy1 debug: Radio initialized
b43legacy-phy1 debug: Loading firmware version 0x127, patch level 14
(2005-04-18 02:36:27)
Registered led device: b43legacy-phy1:tx
Registered led device: b43legacy-phy1:rx
b43legacy-phy1 debug: Chip initialized
b43legacy-phy1 debug: 32-bit DMA initialized
b43legacy-phy1 debug: Wireless interface started
b43legacy-phy1 debug: Adding Interface type 2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:09:5b:70:2d:68
wlan0: RX authentication from 00:09:5b:70:2d:68 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:09:5b:70:2d:68
wlan0: RX AssocResp from 00:09:5b:70:2d:68 (capab=0x5 status=0 aid=86)
wlan0: associated
wlan0: disassociate(reason=3)
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:09:5b:70:2d:68
wlan0: RX authentication from 00:09:5b:70:2d:68 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:09:5b:70:2d:68
wlan0: RX ReassocResp from 00:09:5b:70:2d:68 (capab=0x5 status=0 aid=87)
wlan0: associated
