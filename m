Return-Path: <linux-kernel-owner+w=401wt.eu-S1161366AbXEDST7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161366AbXEDST7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161373AbXEDST6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:19:58 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14345 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161386AbXEDSTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:19:43 -0400
X-IronPort-AV: i="4.14,493,1170651600"; 
   d="scan'208"; a="37457156:sNHT29672083"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Stefan Roese" <ml@stefan-roese.de>
Subject: Re: Correct location for ADC/DAC drivers
Date: Fri, 4 May 2007 14:21:50 -0400
User-Agent: KMail/1.9.5
Cc: "Robert Schwebel" <r.schwebel@pengutronix.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <200705011435.45046.ml@stefan-roese.de> <20070504082434.GA22585@pengutronix.de> <200705041054.05650.ml@stefan-roese.de>
In-Reply-To: <200705041054.05650.ml@stefan-roese.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041421.50830.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 May 2007 18:19:36.0083 (UTC) FILETIME=[C54E9630:01C78E78]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 4 May 2007 04:54, Stefan Roese pondered:
> On Friday 04 May 2007 10:24, Robert Schwebel wrote:
> > On Tue, May 01, 2007 at 02:35:44PM +0200, Stefan Roese wrote:
> > > I'm in the stage of integrating some ADC and DAC drivers for the AMCC
> > > 405EZ PPC and looking for the correct location to place these drivers
> > > in the Linux source tree. The drivers are basically character-drivers,
> > > so my first thought is to put them in "drivers/char/adc/foo.c" or
> > > "drivers/char/adc_foo.c". Is this a good solution?
> > >
> > > Any suggestions welcome (could be that I missed an already existing
> > > example).
> > >
> > > BTW: I am aware of the hwmon subsystem, but I don't think it fits my
> > > needs in this case.
> >
> > Could you elaborate the requirements a bit more? ADC is not ADC, because
> > slow i2c ADCs which measure a temperature every five minutes have other
> > requirements than multi-megabyte-per-second-dma-driven ADCs.
>
> The hardware (PPC405EZ) actually implements an high speed, dma capable, ADC
> controller with 10-bit resolution and up to 4MHz sample rate. The current
> driver doesn't support all these features though (dma is not supported
> right now for example). Could be that this will be added in future
> releases. It would be good though, to have the driver located at the
> "correct" place in the kernel tree right away.

We also have DAC and ADC drivers (up to 16 bits @ 64MS/s, via DMA), that would 
be nice to put in the "right" place  - I don't think that drivers/char is the 
right place, nor drivers/misc - I also don't think that /adc is a descriptive 
place for DAC or mixed signal front ends (MxFE).

What about /drivers/char/daq or just drivers/daq - drivers for 
non-PCI/USB/ISA/PCMCIA Data Acquisition Hardware, D/A and A/D converters, 
Analog Front ends, etc.

I think that is the common TLA - at least according to 
http://en.wikipedia.org/wiki/Data_acquisition

?

-Robin
