Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYESP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYESP5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYESP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:57:24 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:58687 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYESP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:57:23 -0400
Message-ID: <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
Date: Mon, 19 May 2008 09:57:21 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com, jonsmirl@gmail.com
In-Reply-To: <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
X-Google-Sender-Auth: 7e73346d0ff4218d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 7:17 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 16 May 2008, Grant Likely wrote:
>
>> +    However, the binding does not attempt to define the specific method for
>> +    assigning chip select numbers.  Since SPI chip select configuration is
>> +    flexible and non-standardized, it is left out of this binding with the
>> +    assumption that board specific platform code will be used to manage
>> +    chip selects.  Individual drivers can define additional properties to
>> +    support describing the chip select layout.
>
> Yes, this looks like a problem to me. This means, SPI devices will need
> two bindings - OF and platform?... Maybe define an spi_chipselect
> OF-binding?

Actually, spi devices have *neither*.  :-)  They bind to the SPI bus.
Not the platform bus or of_platform bus.  But that is Linux internal
details; this discussion is about device tree bindings.

Note that I did say that drivers can define additional properties for
supporting chip select changes as needed.  I'm just not attempting to
encode them into the formal binding.  There is simply just too many
different ways to manipulate chip select signals and so I don't feel
confident trying to define a *common* binding at this moment in time.
At some point in the future when we have a number of examples to
choose from then we can extend this binding with chip select related
properties.

As for the Linux internals, the 5200 SPI bus driver that I posted
exports a function that allows another driver to call in and
manipulated the CS lines before the transfer.  It isn't the prettiest
solution, but I'm not locked into the approach and that gives some
time to consider cleaner interfaces.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
