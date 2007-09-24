Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbXIXXHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbXIXXHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbXIXXHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:07:25 -0400
Received: from tim.rpsys.net ([194.106.48.114]:42830 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708AbXIXXHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:07:24 -0400
Subject: Re: [Linux-fbdev-devel] [RFC] driving a LCD panel via I2C
From: Richard Purdie <rpurdie@rpsys.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, giometti@enneenne.com,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070924123408.596a3c69@dhcp-255-175.norway.atmel.com>
References: <41784.213.84.50.107.1190624288.squirrel@webmail.enneenne.com>
	 <20070924123408.596a3c69@dhcp-255-175.norway.atmel.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 00:03:04 +0100
Message-Id: <1190674984.19359.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 12:34 +0200, Haavard Skinnemoen wrote: 
> On Mon, 24 Sep 2007 10:58:08 +0200 (CEST)
> "Rodolfo Giometti" <giometti@enneenne.com> wrote:
> > I have an LCD panel on a custom PXA27x based board and it must be
> > turned on/off by some special commands via a GPIO throught a I2C chip.
> > 
> > I'd like some suggestion about I can easily manage this situation.
> 
> I have a similar panel in the sense that it needs a bunch of SPI
> commands to get started. I implemented a LCD driver
> (drivers/video/backlight) for it so that it is automatically turned
> on/off at bootup/shutdown, and can be manually turned on/off
> through /sys/class/lcd/ltv350qv/power. AFAIK the driver is currently
> sitting in the backlight tree scheduled for inclusion in 2.6.24.

It is, its queued as
http://git.o-hand.com/?p=linux-rpurdie-backlight;a=commitdiff;h=c962fe18c64ae9139028ee674ab3c380449ce052

Its also worth noting that corgi-bl.c has a variant (akita) that uses a
gpio over an I2C IO expander for the backlight control. The code paths
are a little convoluted since other gpios are used by other drivers. The
base driver is in arch/arm/mach-pxa/akita-ioexp.c, the set_intensity
function is in arch/arm/mach-pxa/corgi_lcd.c and the base backlight
device in arch/arm/mach-pxa/spitz.c. I will be moving the set_intensity
to spitz.c to make things a little clearer.

Also, I'm in the process of turning corgi-bl.c into a generic backlight
driver which might help you, see:

http://git.o-hand.com/?p=linux-rpurdie-backlight;a=commitdiff;h=c74f241bf53bf5251c7c10f65041c20979f6c694

Now, the GPIO framework could help too (it didn't exist when I wrote
akita-ioexp)...

Regards,

Richard

