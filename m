Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZFSJ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZFSJ1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZFSJ0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:26:55 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:22813 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755505AbZFSJ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:26:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=29yi/UYR4TAn1ZVHmW3rvNeFBZ/tsEkglyMSq+xJpSmvRDee3IEtfIv7bssltivAsoyjv7YI4+yL5bEEybwgJtrVvdRNDB0GB5kGAj0o0uw86nobfvoiHVLUxl8MeRiSz5dRcEKGa/pk0vqmuN9XElNeFzvqUQ6oXxb+y6ca9ys=  ;
X-YMail-OSG: g6UvlecVM1mdB0mqYGiElZH2SsHfPBI5Oj0iqTmYAKOuWUej2FbK2n4I2I4TxUJXHzkpVb25J2qbFqracqvhaFg07HdHrJnmtfD.jwFynL0kfkhA6PCYpYctbs65WhC_tb0nDd4POdBzL1WC2L5A569QP2A6MHckfpiZzeasiOnyTj9M4XFcFYTXoFkNIz0upnvg4jOmykSfgH4kgWx2ReQF2hZY5IglobfGaiKBcZi2jsTnOuRumFS0V32cFmMK2rqZIRyynQIQj7kspTMpBZdngyIf2UvkddFpF_AzZiD44FvNStAG
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
Date: Fri, 19 Jun 2009 02:26:56 -0700
User-Agent: KMail/1.9.10
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-usb@vger.kernel.org,
       avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       patrice.vilchez@atmel.com
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com> <200906190043.00428.david-b@pacbell.net> <20090619095148.67a74ed9@hskinnemoen-d830>
In-Reply-To: <20090619095148.67a74ed9@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906190226.56278.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 June 2009, Haavard Skinnemoen wrote:
> David Brownell wrote:
> > > --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> > > +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> 
> > > +	/* Enable VBus control for UHP ports */
> > > +	for (i = 0; i < data->ports; i++) {
> > > +		if (data->vbus_pin[i])
> > > +			at91_set_gpio_output(data->vbus_pin[i], 0);  
> > 
> > This should gpio_request() and gpio_direction_output().
> 
> Hmm...I thought the driver was supposed to call gpio_request(), not the
> platform code?

In some cases.  This isn't a good case for that.  Especially
if it's going to call gpio_direction_output() ... which needs
gpio_request() to have been done first.


> > Don't use AT91-specific GPIO calls except for things that
> > the generic calls don't support ... like enabling open-drain
> > outputs, the deglitching support, or input pullups.
> 
> This call does port configuration, which you convinced me a long time
> ago was a fundamentally different thing from GPIO.

Yes, pin/port config is certainly part of what the platform's
code to set up devices should handle.  That can include making
sure a given pin is configured as a GPIO ... and in the normal
case where it's dedicated to that task, it simplifies the driver
to have it pre-allocated and configured for I/O/both.

I'm pulling in some discussion from a different email thread
earlier, which proposed doing the right thing and finally
getting rid of the at91-specific GPIO calls except in the few
cases they could not be avoided.

It might be that AT91 needs to add some pin config calls which
resemble what you did for AT32AP7 chips.

- Dave


> If the pin really 
> requires one of those features, this would definitely be the place to
> set it up.
> 
> Haavard
> 
> 


