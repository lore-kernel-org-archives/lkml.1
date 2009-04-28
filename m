Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZD1Nlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZD1Nlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZD1Nl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:41:26 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:62635 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZD1NlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HEqi948h8S3DR3VJ3f4sWMbWAMMtjkSjQlM3lCLTmjp2JIkmfPcBuEq/52La0wYtLl
         HZgXsfceQbaI3UdipKmvQCmeXDmEqWnJNdJGCfA7h7wZlTm/7EHATIxXJE3p/wmxwvYw
         hgc+/cqAt5Y0CzPNIT56IyX9G6TLMhRnL8PTo=
From: Florian Fainelli <florian@openwrt.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the OpenCores SPI controller.
Date: Tue, 28 Apr 2009 15:41:20 +0200
User-Agent: KMail/1.9.9
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200904041227.54687.david-b@pacbell.net> <200904280458.23018.david-b@pacbell.net> <20090428122011.GB6325@avionic-design.de>
In-Reply-To: <20090428122011.GB6325@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904281541.21238.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 28 April 2009 14:20:11 Thierry Reding, vous avez écrit :
> * David Brownell wrote:
> > On Tuesday 28 April 2009, Thierry Reding wrote:
> > > This second version is pretty much a rewrite.
> >
> > That happens sometimes...
> >
> > > Some notes about the most
> > > important changes:
> > >
> > >   * uses per-chip states to allow more slaves to use the controller
> > >     concurrently
> > >   * rejects invalid device configurations during setup
> > >   * rejects invalid per-message and per-transfer options
> > >   * queues messages so that they can be processed one after another
> > >       - this also provides for a way to handle power-management
> > >   * omits the spioc.h (and with it the platform data structure):
> > >       - uses the platform_device.id for the bus number
> > >       - always uses 8 chipselects because that's the maximum that the
> > > core supports
> >
> > All that sounds good.
> >
> > > I couldn't really find a way to implement per-transfer overrides for
> > > the word size because the controller simply has no concept of word
> > > sizes. Is it in such cases still necessary to hardwire the word size to
> > > 8 bits?
> >
> > Is this the http://www.opencores.org/?do=project&who=spi core?
>
> Yes, it is.
>
> > Its summary says "Variable length of transfer word up to 32 bits";
> > does that mean "configurable when core is synthesized" instead of
> > truly "variable"?

This is indeed configured at synthesis time.

>
> That summary seems out-dated. The variable length of transfer word is
> actually the maximum length of a single transfer and is 128 bits in the
> latest version. So you get 4 registers, each 32 bits wide into which you
> program the data you want to transfer. Then you set the number of bits of
> that transfer so the core knows which registers and what bits of those
> registers to shift out serially.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
