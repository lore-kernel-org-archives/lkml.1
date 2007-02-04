Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbXBDG03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbXBDG03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 01:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXBDG03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 01:26:29 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52951 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbXBDG03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 01:26:29 -0500
Message-ID: <45C57C93.2020808@lwfinger.net>
Date: Sun, 04 Feb 2007 00:26:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: Free Linux Driver Development!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 09:45:45PM EST, Lennart Sorensen wrote:
>On Thu, Feb 01, 2007 at 02:59:03PM +0100, Erik Mouw wrote:
>> I can't remember that kind of corruption ever being reported to the
>> bcm43xx-dev mailing list.

I came into this discussion late as I only read LKML in summary form, but I feel I need to address
several misconceptions here.

>Well I assumed it messed up the eeprom settings, since we had to go into
>the advanced driver settings and change it from 802.11b only back to
>auto mode and I would think those settings are stored in the eeprom if
>booting a 2.6.18 kernel and loading the bcm43xx driver can cause it to
>stop working, then it has to be an eeprom setting.

As Michael Buesch has explained, bcm43xx only changes the eeprom under very controlled circumstances
that never happen accidentally. It is much more likely that your Windows driver uses V4 firmware,
whereas bcm43xx uses V3. Without a power-off step to erase the firmware the results are likely to be
indeterminate.

>Actually I suppose the other posibility is that you simply have to power
>cycle before booting windows after linux to avoid any left over settings
>in the chip from being a problem. That may be what I did. Given I
>couldn't get the card to connect using the bcm43xx driver anyhow, I
>didn't spend too much time trying (I am fairly sure I set the AP to
>802.11g only though which may have been a problem).

It is _NOT_ true that bcm43xx only works with 802.11b. My AP is set in 802.11g-only mode and I have
been using bcm43xx with it for nearly a year. What is true is that none of the OFDM rates work
because of some unknown bug, probably in initialization. As a result, we are limited to a maximum
data rate of 11Mbs, but it is still running in 802.11g mode!

>> You could use a CardBus or USB card.
>
>I just don't like things sticking out that are breakable.
>
>> So are the bcm43xx maintainers.
>
>Excellent. Is the bcm43xx planning to get 802.11g mode working at some
>point? Is broadcom ever going to help out with any specs for their
>hardware or do they still mistakenly believe that end users are not
>their customers? Given the behaviour of broadcom over the years I know
>I don't intend to buy anything with a broadcom chip in it again, which
>means broadcom's behaviour directly means they will get less sales to the
>laptop makers, since some people will actively avoid anything with
>broadcom's hardware in it. :)

I certainly would hope for a even a little cooperation from Broadcom; however, it is not easy to
avoid getting their hardware, particularly with laptops. When I recently upgraded, my primary aims
were (1) a 14 inch screen  as the native resolution of a larger one makes things too small for my
eyes and reduced resolution looks crappy on an LCD, and (2) an AMD 64 X2 processor to run an x86_64
OS. The kind of wireless card contained within was not an issue, although the BCM4311 that I got
turned out to be a benefit as I became the first developer with the hardware needed to find and fix
two major outstanding bugs.

While I'm on my soapbox, I want to thank the group that reverse-engineered the Broadcom chips and
the group that did the early coding on the driver. Although the current driver still has its faults,
the fact that there is a working driver that doesn't hang or crash an SMP version of Linux and
offers usable wireless service for such a complicated piece of totally undocumented hardware is a
real tribute to those two groups. Thanks guys.

Larry Finger
bcm43xx Maintainer
