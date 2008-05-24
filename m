Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbYEXVLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbYEXVLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYEXVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:11:32 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:25820 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751647AbYEXVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:11:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3rSl2K2Xoen70B4rkrgFM0vwgw3Fs3a0uyBptbJcPNhagenpCb2Sj4WZhTBjZqhVWVzCIFCb2X0tUl1ybVoRXKKekbDR3j97iP7aXX1L89H3awqM23qusafV7UCHwJl1Vp1spVmnK9+tpodJ5cWTzr5hl5qgnjdDoOAUaly38Ew=  ;
X-YMail-OSG: E9TLu5AVM1nEbTuQawHW31q6o8PKJw7klIbKxng2jWA4uejOKpKRPy.9BI.3ZxRjqWxrYm4zwyrFNQqxu4DAcCLY9mDjX3xohk21lZP9sWr_OcwRXkEqQKT_yoFMqOWx6Y4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [RFC] OpenFirmware bindings for the MMC-over-SPI driver
Date: Sat, 24 May 2008 12:56:32 -0700
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
In-Reply-To: <20080523182754.GA26891@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805241256.32639.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008, Anton Vorontsov wrote:
> 
> This is second attempt to write the OpenFirmware bindings for the
> MMC-over-SPI (and SPI bindings in general).

Summary:  an OF-specific wrapper around the mmc_spi platform code.

I think a wrapper to encapsulate all the OF-specific knowledge makes
much sense here.

The only thing that looks odd to me about this is that the wrapper
is a spi_device rather than an of_device.  To me it makes more sense
to just have an of_device setting up the right spi_device.  (Though
maybe I missed some discussion about why that can't work.)

Example:  drivers/usb/host/sl811_cs.c does that for PCMCIA card
that just wraps an sl811 chip that's more often used standalone.
The PCMCIA descriptors being analagous to OF device table entries.

- Dave


