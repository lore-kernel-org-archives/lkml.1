Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZDANoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZDANoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761308AbZDANoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbZDANoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:07 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-mtd@lists.infradead.org
Date: Wed, 1 Apr 2009 15:43:43 +0200
User-Agent: KMail/1.9.9
Cc: Kay Sievers <kay.sievers@vrfy.org>, David Brownell <david-b@pacbell.net>,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>
References: <200903260042.42091.david-b@pacbell.net> <200903311418.53772.david-b@pacbell.net> <ac3eb2510903311651i4c5f6805tc74fe04ee765be9c@mail.gmail.com>
In-Reply-To: <ac3eb2510903311651i4c5f6805tc74fe04ee765be9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904011543.44124.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Kay,

On Mittwoch, 1. April 2009, Kay Sievers wrote:
> On Tue, Mar 31, 2009 at 23:18, David Brownell <david-b@pacbell.net> wrote:
> > On Thursday 26 March 2009, David Brownell wrote:
> >> From: David Brownell <dbrownell@users.sourceforge.net>
> >>
> >> Update driver model support in the MTD framework, so it fits
> >> better into the current udev-based hotplug framework:
> >
> > Hmm, no comments?  I had understood there was interest over on
> > the MTD side of things in exposing more information through
> > sysfs, to help avoid the need to add Even More Ioctls as part
> > of support for things like NAND chips with 4KB pages, or which
> > handle more than 4GBytes ...
>
> Please have a look at this. We got asked repeatedly to provide better
> hotplug/udev integration, and the patches, and having the parent
> device properly assigned, would solve some of the problems people run
> into currently.

Without patch:
--------------

$ udevadm info -a -p /sys/block/mtdblock0
[...]
  looking at device '/devices/virtual/block/mtdblock0':
    KERNEL=="mtdblock0"
    SUBSYSTEM=="block"
    DRIVER==""
    ATTR{range}=="1"
    ATTR{removable}=="0"
    ATTR{size}=="256"
    ATTR{capability}=="10"
    ATTR{stat}=="       0        0        0        0        0        0        0        0        0        0        0"

And nearly the same data for the other flash device. No chance to detect if
this one is the NOR or the NAND type...

With the patch:
---------------

$ udevadm info -a -p /sys/block/mtdblock0
[...]
  looking at parent device '/devices/platform/physmap-flash.0':
    KERNELS=="physmap-flash.0"
    SUBSYSTEMS=="platform"
    DRIVERS=="physmap-flash"
    ATTRS{modalias}=="platform:physmap-flash"

The second flash device is of NAND type and 'udevadm' shows:

$ udevadm info -a -p /sys/block/mtdblock4
[...]
  looking at parent device '/devices/platform/mxc_nand.0':
    KERNELS=="mxc_nand.0"
    SUBSYSTEMS=="platform"
    DRIVERS=="mxc_nand"
    ATTRS{modalias}=="platform:mxc_nand"

\o/

I will try now to define some udev rules to match for my different flash
memories.

Thank you,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
