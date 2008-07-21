Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYGUUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYGUUts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYGUUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:49:40 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:47226 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750881AbYGUUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:49:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VAEBFNBUurWSE9ljAeJThEIa0aO3T0cswlJp1H0CA5awBWXv88HglFxxNrDMcCxGr8hfYeHe/iVZyOA3xRlsJSKrcsjrUZeI5J6JUMGYB8odWiCCeKb/AvMrb9HrOGu+K4BzaiUqBNnszabz6F/DjUJ5UEfORtzFcq8Sc6h1FlY=  ;
X-YMail-OSG: thpFeoUVM1nFAabQ1fXL8.fTWWbgVDHFOTR8wDuoap1cJQtIhhrUZaKO7lyZKhEJ5a3Q8BOOpgB9axfe2Zx.f.4TVI7V_tuZu27DczhPxlCMuKpp05TKllcrI6aNMa0Jero-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
Date: Mon, 21 Jul 2008 13:49:36 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807142109.19360.mb@bu3sch.de> <1216098409.4265.144.camel@moss.renham>
In-Reply-To: <1216098409.4265.144.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211349.37227.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008, Ben Nizette wrote:
> 
> On Mon, 2008-07-14 at 21:09 +0200, Michael Buesch wrote:
> > This driver provides a sysfs interface to dynamically create
> > and destroy GPIO-based MMC/SD card interfaces.
> > So an MMC or SD card can be connected to generic GPIO pins
> > and be configured dynamically from userspace.
> 
> Can you use mmc-spi attached to spi-gpio and be done with it? 

Yes, that's how some of the early mmc-spi work was done.  ;)


> Sure you 
> won't have the dynamic alloc capability but you won't be reinventing the
> wheel either.  You don't have dynamic creation for any other platform
> device and if you need it then, IMO, it'd be better solved in a more
> generic way.
> 
> btw, what's this spi-gpio thing?  I can't see it in mainline except in a
> s3c24xx specific way.  My domestic blindness??

ISTR a patch for that, sitting somewhere in my mailbox waiting
for review cycles.  I've sent examples of such stuff around
before too.

I've held back submitting a spi-gpio driver until I could come
up with a way to configure it which would let the GPIO calls
get inlined ... because otherwise, there's a nasty speed penalty.

It's the difference between a function call per GPIO operation
and an instruction per GPIO operation.  Consider that each SPI
clock cycle requires four such operations, and GPIO function
calls often take 30 instructions ... there's a big penalty to
the non-inlined bitbangers, which is only partly addressed by
having those function calls sitting in I-cache.

- Dave
