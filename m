Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZBXWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZBXWJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZBXWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:09:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:34195 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753852AbZBXWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:09:04 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+QjKRgC2WQKKzCYqlA9Eeyg3XCNU5/lMn4kVn2jV
	KpWan1tXKMgHwd
Date: Tue, 24 Feb 2009 23:09:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>, greg@kroah.com,
       s.hauer@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] mxc: move serial driver init()/exit() to
 platform_device
In-Reply-To: <20090224172606.GA22390@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0902242302300.9200@axis700.grange>
References: <20090224155737.28880.3945.stgit@Programuotojas>
 <20090224172606.GA22390@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Russell King - ARM Linux wrote:

> I really don't like this approach to controlling multiplex pins, which
> is to setup the SoC pin configuration when the driver is being bound and
> to remove it when the driver is unbound.

What do you think about the reasoning given by Sascha here: 
http://marc.info/?l=linux-arm-kernel&m=123453175927569&w=2 which is power 
saving?

> 
> Let's take the issue of a serial driver.
> 
> The outputs of a serial port have defined inactive levels - for TXD, RTS
> and DTR, that's logic one.  If a driver is not loaded and you have a
> peripheral connected to this port, you probably don't want them to see
> a break level on TXD, or active RTS or DTR signal.
> 
> However, by hooking the SoC pin configuration into the binding and
> unbinding of the driver, the state of the pins are indeterminent until
> the driver is initialised.
> 
> I can think of other cases in hardware I've dealt with which required
> careful handling of SSP signals to ensure that a flip-flop in a FPGA is
> correctly set to ensure that left/right channels aren't swapped.
> 
> Basically, my point is that for 99.9% of the time, SoC pin configuration
> is determined by the platform board layout, and the right place to set
> this configuration up is in the board support file, just like we do on
> PXA platforms.
> 
> For the 0.1% of cases where a board needs to manipulate the SoC pin
> configuration depending on which drivers are loaded, doing so at driver
> probe time _may_ make sense, but it feels all together cumbersome,
> especially as unloading drivers has historically had question marks
> over it.
> 
> Surely, for this 0.1% of cases, the right solution would be to have an
> interface which allows a platform device to be unregistered, the SoC pin
> mux settings changed by platform code, and the new device registered?
> 
> Finally, note that the approach of putting init/exit into struct
> platform_device doesn't cater for all cases - we're still going to need
> to have init/exit pointers in platform data for some platform devices,
> such as MMC drivers, which have to pass parameters to those hooks.

Thanks
Guennadi
---
Guennadi Liakhovetski
