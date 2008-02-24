Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYBXSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYBXSLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYBXSLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:11:18 -0500
Received: from lixom.net ([66.141.50.11]:38610 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYBXSLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:11:17 -0500
Date: Sun, 24 Feb 2008 12:15:10 -0600
From: Olof Johansson <olof@lixom.net>
To: Jochen Friedrich <jochen@scram.de>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCHv4 2.6.25] i2c: adds support for i2c bus on Freescale
	CPM1/CPM2 controllers
Message-ID: <20080224181509.GA6745@lixom.net>
References: <47A1C4E9.4000003@scram.de> <20080221130520.12b01553@hyperion.delvare> <47BEAF00.50106@scram.de> <20080223212823.GA22131@lixom.net> <47C18A4E.5080804@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C18A4E.5080804@scram.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 24, 2008 at 04:16:30PM +0100, Jochen Friedrich wrote:
> Hi Olof,
> 
> >> 2. record the I2c name in the dts tree, either as seperate tag (like linux,i2c-name="<i2c-name>")
> >>    or as additional compatible entry (like compatible="...", "linux,<i2c-name>").
> > 
> > I have to say no on this one. The device tree is not supposed to know
> > about how linux uses devices, there are firmwares out there that don't
> > use DTS for thier device trees, etc.
> 
> I still believe this this could be done for embedded devices which are usually booted
> via wrapper or U-Boot as those devices will most probably use the most exotic I2c devices
> out there (e.g. home-grown devices used by stbs). However, I'm not an device tree expert.

Sorry, but you're wrong in your assumptions. Not all embedded devices
use U-boot, and not all use the wrapper. It's just a bad idea to encode
linux-specific things in the device tree, period.

And even if you DO decide to go that route, guess what? You need a
translation table just as with (3) anyway!

> >> 3. use a glue layer with a translation map.
> > 
> > In my opinion this is an OK solution since the same information has to
> > be added somewhere already anyway -- eiither to the drivers or to this
> > translation table. It should of course be an abstacted shared table,
> > preferrably contained under the i2c source directories since several
> > platforms and architectures might share them.
> 
> I could think of a mixture between 2. and 3.:
> 
> Using the compatible attribute with the manufacturer stripped off as I2c name by default
> and using an exception table. For now, the struct i2c_driver_device would currently only
> need one entry ("dallas,ds1374", "rtc-ds1374").

You still need the translation table, you're just flattening the
namespace to one string instead of two, the same information still has
to be encoded. I can't see what the benefit of this approach compared to
the other one is. "dallas,ds1374" already only has one translation entry
in the table?


-Olof

