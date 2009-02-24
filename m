Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbZBXW1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbZBXW1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbZBXW0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:26:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50003 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZBXW0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:26:51 -0500
Date: Tue, 24 Feb 2009 22:26:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>, greg@kroah.com,
       s.hauer@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] mxc: move serial driver init()/exit() to platform_device
Message-ID: <20090224222622.GC22390@n2100.arm.linux.org.uk>
References: <20090224155737.28880.3945.stgit@Programuotojas> <20090224172606.GA22390@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0902242302300.9200@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902242302300.9200@axis700.grange>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 11:09:00PM +0100, Guennadi Liakhovetski wrote:
> On Tue, 24 Feb 2009, Russell King - ARM Linux wrote:
> 
> > I really don't like this approach to controlling multiplex pins, which
> > is to setup the SoC pin configuration when the driver is being bound and
> > to remove it when the driver is unbound.
> 
> What do you think about the reasoning given by Sascha here: 
> http://marc.info/?l=linux-arm-kernel&m=123453175927569&w=2 which is power 
> saving?

That kind of power saving methodology is far better being triggered from
the use of the driver, not whether it is loaded or not if and only if it
is appropriate and necessary for the hardware.

For example, if you do this with a serial port which is connected to the
external world, and you're monitoring it, you don't want your monitoring
to see a break condition every time the port is closed and re-opened.

If you talk about an I2S codec, you'd want to configure the SoCs outputs
to the codec to be logic 0 when powering it down because it isn't being
used.

That's all unrelated to whether the driver is loaded or not, or bound to
a device or not.
