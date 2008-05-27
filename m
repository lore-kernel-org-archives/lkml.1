Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYE0Ps4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYE0Ps4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYE0Psr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:48:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:48559 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755876AbYE0Psq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:48:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="332830772"
Date: Tue, 27 May 2008 08:56:41 -0700
From: mark gross <mgross@linux.intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080527155641.GB29868@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <4832A211.4040206@gmail.com> <20080520175041.GA30909@linux.intel.com> <200805211753.39133.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805211753.39133.david-b@pacbell.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 27 May 2008 15:48:45.0431 (UTC) FILETIME=[25637070:01C8C011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:53:38PM -0700, David Brownell wrote:
> On Tuesday 20 May 2008, mark gross wrote:
> > > ST Micro LIS3L02DQ 3D accelerometer.  ...
> > 
> > FWIW: I have this device talking to a PIC-18 and pushing the results
> > over the serial port.
> 
> Jonathan neglected to mention that he's already sent a driver
> for this to the SPI list.  ;)
> 
> Which is part of the reason for asking this question.  Right
> now that driver sits in drivers/spi/lis3l02dq.c but that is
> probably not its best long-term domicile.
> 
> 
> > WRT linux support, I can't think of a generalized way to create a driver
> > that would be able to be used with this device in Linux.  You need to
> > know witch IRQ line the DR line is connected too, and if you are
> > bit-banging the SPI data off the thing, then you need to know which
> > GPIO's of the host CPU you'll be using.  If you have SPI hardware then
> > you need to know where to pull the data from.  The problem doesn't seem to
> > generalize well.
> 
> I guess I don't follow.  The SPI framework handles all that
> stuff already, even if you're bitbanging.  Though to be
> sure, if you're bitbanging SPI you want your platform to
> be able to inline those GPIO calls so those inner loops
> only take a few instructions per bit ... also solved!  :)
>

I'll take a look sometime soon.
 
> 
> > Also, If you are playing with accelerometer data, you likely need some
> > real time support or at lest a reliable time stamping of the data to do
> > anything interesting.
> 
> True.  I imagine a few other such issues will appear once
> more folk than Jonathan are using these sorts of sensors
> on Linux.  I'd expect the sample stream to have internal
> timestamps for truly critical systems, unless variability
> in when the host makes timestamps is not really an issue.
>  

Its on my list of things to do..

> 
> > Another problem area is around SPI itself.  There are variations of
> > device implementations around chip select polarity, clock biasing
> > (rising,falling, or midpoint) sampling from one SPI part to the next.
> 
> Midpoint?  That's not one I've come across before.  All four
> standard SPI clock/sample/shift modes are already supported
> in the SPI framework though.  Ditto active-high chipselects
> (vs normal active-low) etc.

Yeah, its one of the sampling modes for the PIC18F4455 its one of the
master mode sampling options  (see page 194 of
http://ww1.microchip.com/downloads/en/DeviceDoc/39632D.pdf )

--mgross

