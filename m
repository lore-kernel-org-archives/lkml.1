Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZD2JPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZD2JPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZD2JPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:15:40 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65163 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZD2JPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lXoA3yxzSWX+vRyq54iIVYA//xt0cyhxy+Y2Zi3rbHZNYj26rW43ocuztf2vdEgIFK
         HTFd9SCCViS53EKiWgqcY/h1F7VQzJoYFz0n6iJLBgmDiq0U/LewPFHc+o7Q0PkHRzsE
         I+P1mlFcw4PT5IwcubDAMyijNmSDLi0c+9lso=
From: Florian Fainelli <florian@openwrt.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the OpenCores SPI controller.
Date: Wed, 29 Apr 2009 11:15:34 +0200
User-Agent: KMail/1.9.9
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200904041227.54687.david-b@pacbell.net> <200904281354.12192.david-b@pacbell.net> <20090429063104.GB7784@avionic-design.de>
In-Reply-To: <20090429063104.GB7784@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904291115.34847.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 29 April 2009 08:31:04 Thierry Reding, vous avez écrit :
> * David Brownell wrote:
> > On Tuesday 28 April 2009, Florian Fainelli wrote:
> > > > > Is this the http://www.opencores.org/?do=project&who=spi core?
> > > >
> > > > Yes, it is.
> > > >
> > > > > Its summary says "Variable length of transfer word up to 32 bits";
> > > > > does that mean "configurable when core is synthesized" instead of
> > > > > truly "variable"?
> > >
> > > This is indeed configured at synthesis time.
> >
> > Now I'm confused again.  Thierry says (below) that the number of bits
> > can be set per-"transfer".
> >
> > Now, I can easily understand that a *maximum* would be configured
> > at synthesis time ... if there's a 32-bit CPU or DMA engine, it'd
> > make very limited sense to interact using 128-bit I/O words.

The maximum size of the FIFO is configured at synthesis time should have made 
this clear before, sorry for the confusion.

>
> I can't really comment on the synthesis because I'm not involved with that
> part. What I was saying that the core provides a field in the control
> register which defines the number of bits to transfer from/to the
> transmit/receive registers. The maximum number of bits that can be
> specified in this way is 128.

Yes, which matches the FIFO size configured in the IP at synthesis time.

>
> > Is there both a configurable maximum, *and* a word-size setting that
> > can be changed on the fly?  That's what I would expect; it's what
> > most other designs do.  The only time I've seen fixed "you must use
> > N-bit words" designs is on cost-eradicated 8-bit microcontrollers.
>
> Perhaps that maximum number of bits that can be set through the control
> register is what can be configured at synthesis time.

Provided that your FIFO is 128-bits, you can of course ask the core to do up 
to the FIFO-size transfers for instance provided that you do not exceed the 
size of the FIFO. The later can obviously not be changed on-the-fly since 
physical resources of the FPGA for this should be reserved at synthesis time. 
Of course, one could use partial reconfiguration to increase the size, but 
that's slightly off-topic ;)
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
