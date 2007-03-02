Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbXCBSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbXCBSpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932995AbXCBSpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:45:40 -0500
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:48243 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933357AbXCBSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:45:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=pocqYeUN5e4gOG18xNRTPx3hwqozJXfjdwUMUsxWQ1HBjnrqgxM+VJ/pWS0eQN17APoECwiVT8S8xOW9Jtp5aR/49lWW/jCHlyZj1NmTRt1J2PfEC2mCFgvNBq5fDGctt7yN+FfBbVUnNqjlkZa/xc5kjXe9iuKeA8Lt2J9tgJo=  ;
X-YMail-OSG: KWdwI0UVM1kJ4H6uQpTRC.Mm5VrGHkCPBVTC7C0n5gk7vrHvh99e64e5TyKUDhl_sDmpQrrRBb4s1pGyE90Ak7u81crfTFqwNcfDdPPCBUXc0rEqL5Wn6hhrkfOgYx5EQ9.jNUXqZH98fWo-
From: David Brownell <david-b@pacbell.net>
To: Andrew Victor <andrew@sanpeople.com>
Subject: Re: [patch 2.6.20-rc2] gpio_direction_output() needs an initial value
Date: Fri, 2 Mar 2007 10:45:21 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Milan Svoboda <msvoboda@ra.rockwell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200703011825.10370.david-b@pacbell.net> <1172814491.26751.4.camel@fuzzie.sanpeople.com>
In-Reply-To: <1172814491.26751.4.camel@fuzzie.sanpeople.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703021045.22461.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 9:48 pm, Andrew Victor wrote:
> hi David,
> 
> > It's been pointed out that output GPIOs should have an initial value, to
> > avoid signal glitching ... among other things, it can be some time before
> > a driver is ready.  This patch corrects that oversight, fixing
> 
> For the AT91 changes:
>   Acked-by: Andrew Victor <andrew@sanpeople.com>
> 
> 
> > --- g26.orig/drivers/spi/atmel_spi.c	2007-02-28 12:47:43.000000000 -0800
> > +++ g26/drivers/spi/atmel_spi.c	2007-03-01 15:29:30.000000000 -0800
> 
> > -		gpio_direction_output(npcs_pin);
> > +		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
> >  	}
> 
> As mentioned previously (by Walter Tuppa), wouldn't it be better to just
> change this to:
>      cs_deactivate(spi);

That *does* deactivate the chipselect, as the initial value.
Given this function signature change, some initial value must
be specified, and that expression uses the inactive value...
