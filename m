Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYKVXaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYKVXaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYKVX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:29:56 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:60960 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYKVX34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:29:56 -0500
Date: Sun, 23 Nov 2008 00:29:45 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: David Brownell <david-b@pacbell.net>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       spi-devel-general@lists.sourceforge.net, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Message-ID: <20081122232945.GB24437@datenfreihafen.org>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <f17812d70811220601p1d7af668mf3265224179753ab@mail.gmail.com> <1227369262.19591.41.camel@brutus> <200811221108.54331.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811221108.54331.david-b@pacbell.net>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sat, 2008-11-22 at 11:08, David Brownell wrote:
> On Saturday 22 November 2008, Daniel Ribeiro wrote:
> > Em Sáb, 2008-11-22 às 22:01 +0800, Eric Miao escreveu:
> > > On Sat, Nov 22, 2008 at 1:25 PM, David Brownell <david-b@pacbell.net> wrote:
> > > > On Friday 21 November 2008, stefan@datenfreihafen.org wrote:
> > > >> Since the last submission we are also using the spi subsystem and
> > > >> pxa2xx-spi instead of ssp.c directly as before.
> > > >
> > > > I took a quick glance at this and it seemed like it should be
> > > > able to build without depending on PXA ... should certainly
> > > > not include <mach/ssp.h> or <mach/regs-ssp.h>, and it doesn't
> > > > look like it needs PXA-specific stuff like <mach/mfp-pxa27x.h>
> > > > either.
> > > >
> > > > It's also worth removing the reverse dependencies ("select X")
> > > > from Kconfig; they don't work very well for the things which
> > > > those dependencies rely on.
> > > >
> > > I'm wondering if it call fall into the regulator framework, along with
> > > a hwmon driver with its attributes being exported by sysfs.
> 
> Make it work like other MFD drivers, with child devices
> to encapsulate such functionality ... and drivers specific
> to those functionalities.
> 
> Such as a regulator framework driver, an RTC, and so on.

We do this already. pcap-rtc, pcap_ts and pcap_leds are later in this set.

As Daniel already pointed out. At the moment MMC is the only user of the voltage
regulator. We plan to add a regulator child device once more users come up.
(Pretty sure they will. :))

> > The ADC is also used by the touchscreen driver, and later will be used
> > for accessory detection (usb otg, charger, EMU (audio and uart on usb
> > port)).
> 
> ADC integration may be an interesting little puzzle.

It will. :/ 

At the moment we are working to have more of the basics done though.

The PXA dep is also almost gone. It's our aim to provide a generic driver here.

regards
Stefan Schmidt
