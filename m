Return-Path: <linux-kernel-owner+w=401wt.eu-S1031562AbXEDWNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031562AbXEDWNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 18:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031705AbXEDWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 18:13:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14319 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031562AbXEDWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 18:13:48 -0400
X-IronPort-AV: i="4.14,494,1170651600"; 
   d="scan'208"; a="37476097:sNHT23559739"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: Correct location for ADC/DAC drivers
Date: Fri, 4 May 2007 18:16:01 -0400
User-Agent: KMail/1.9.5
Cc: "Stefan Roese" <ml@stefan-roese.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <200705011435.45046.ml@stefan-roese.de> <200705041421.50830.rgetz@blackfin.uclinux.org> <20070504205213.GQ22585@pengutronix.de>
In-Reply-To: <20070504205213.GQ22585@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041816.01572.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 May 2007 22:13:46.0974 (UTC) FILETIME=[7C4A67E0:01C78E99]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 4 May 2007 16:52, Robert Schwebel pondered:
> Robin,
>
> On Fri, May 04, 2007 at 02:21:50PM -0400, Robin Getz wrote:
> > We also have DAC and ADC drivers (up to 16 bits @ 64MS/s, via DMA),
> > that would be nice to put in the "right" place  - I don't think that
> > drivers/char is the right place, nor drivers/misc - I also don't think
> > that /adc is a descriptive place for DAC or mixed signal front ends
> > (MxFE).
>
> What userspace interface do your drivers have?

Right now, it is a little rudimentary char interface, it needs a little care 
to be a bit more general purpose, but it suited needs of what the people who 
were using it.

http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/?view=markup&path=/trunk/drivers/char/ad9960.c

> I don't think that there 
> is anything generic available at the moment, other than COMEDI (which is
> rather outdated as far as I know).

I would be interested in having a detailed discussion/random thoughts on 
this - what is the best way to expose these types of devices?

I never actually used COMEDI, to understand the pro/cons of what it did.

> > What about /drivers/char/daq or just drivers/daq - drivers for
> > non-PCI/USB/ISA/PCMCIA Data Acquisition Hardware, D/A and A/D
> > converters, Analog Front ends, etc.
>
> I'd like drivers/daq better, because it doesn't have anything to do with
> the bus it is connected to; a chipselect bus connectable ADC may be
> connected to a SoC CS-bus or to a PCI bridge and you want to use the
> same driver for it.

That makes sense - I have seen more and more parts with selectable interfaces 
(I2C or SPI), and you should be able to use the same base driver, independent 
of the bus - so drivers/daq would suite me fine. 

-Robin
