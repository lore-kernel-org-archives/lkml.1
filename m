Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbYE0Xmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbYE0Xmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYE0Xmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:42:45 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48322 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755687AbYE0Xmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:42:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Hn3/u6uW0AWPsHHJCLNFrmv5ixh+eMNU4TUyvwrnq9CtnVwkWXhb9ZrcLx1O9yhUUh3EUfb1v39u2z62RBoSV/hiHMjop21SCIBEdIWi+DaD+N8gM5YCH8kwmtzaJ1W+sDKE9wqwSsCAjSN86w8pz/RwTFYQClh7ZbX4L9AwoAo=  ;
X-YMail-OSG: UUtKZO0VM1lxE5Jwo9lfSQiKPK71SUHxI4VbX0uZi1QQl7YD7kr0MpEYk1vTI5dM5R2x1uDZHA8Qsb4LfiUxIymm38TWzLEptQuRQHqfIUkAeW9ITE1M8eT1sBEyha0bJfsRdXCQrUgWiaxrnSRe77My
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: mgross@linux.intel.com
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Date: Tue, 27 May 2008 16:42:42 -0700
User-Agent: KMail/1.9.9
Cc: spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
References: <4832A211.4040206@gmail.com> <200805211753.39133.david-b@pacbell.net> <20080527155641.GB29868@linux.intel.com>
In-Reply-To: <20080527155641.GB29868@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805271642.42291.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, mark gross wrote:
> 
> > > Another problem area is around SPI itself.  There are variations of
> > > device implementations around chip select polarity, clock biasing
> > > (rising,falling, or midpoint) sampling from one SPI part to the next.
> > 
> > Midpoint?  That's not one I've come across before.  All four
> > standard SPI clock/sample/shift modes are already supported
> > in the SPI framework though.  Ditto active-high chipselects
> > (vs normal active-low) etc.
> 
> Yeah, its one of the sampling modes for the PIC18F4455 its one of the
> master mode sampling options  (see page 194 of
> http://ww1.microchip.com/downloads/en/DeviceDoc/39632D.pdf )

Actually figure 19-3 (p. 198) may be a bit more clear.

Curious.  That PIC18F controller has *three* bits ... equivalents
of CPOL and CPHA, plus a bit saying whether to wait a whole or
half clock after the leading clock edge before sampling it.

A quick survey of some other SPI chips suggests that the most
conventional interpretation is to sample on the trailing edge
of the clock, and not presume long hold times.

I would surely hope the SPI interface spec doesn't have to get
into the mess of timing variations which typify anyone trying to
make memory controllers do the Right thing ... *shudder* ...

- Dave


