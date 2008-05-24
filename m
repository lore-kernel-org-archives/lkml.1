Return-Path: <linux-kernel-owner+w=401wt.eu-S1760376AbYEXRnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376AbYEXRnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbYEXRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:43:46 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:32874 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756207AbYEXRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:43:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6ol689mdy0g7H8lV+14X7SgpUGHnxxOSjF9QKfVYlo3yzwc5+s2vIThk8wUzxbovNheMcuE0uG95lsazThqTIqodiueDhSiFLGumzO0nGzJitILWd/bjE5n14JoXtWOmFlA5gC/TZ8NgrssqLOu6y8lg99S15mdG/nbUX8Cf5Jk=  ;
X-YMail-OSG: ouxbXSAVM1l3s1HXkBL3xgfvdhfXcdDb1Q9JDSaginitpQYrGi0RfoQl9yq8iS92JXNzzToj0fzwgNbzsIFlgV8A4iJbX8qTugILHJg4jtoboCgf05Sp8R7sqq996wd5kUk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Sat, 24 May 2008 10:43:43 -0700
User-Agent: KMail/1.9.9
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       fabrizio.garetto@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <fa686aa40805232326w35f455d1s274899160d47eccb@mail.gmail.com> <fa686aa40805240950ocd16b97y308a54c68efa28ef@mail.gmail.com>
In-Reply-To: <fa686aa40805240950ocd16b97y308a54c68efa28ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805241043.43711.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 May 2008, Grant Likely wrote:
> >>> > +++ b/drivers/spi/spi_of.c
> >>>
> >>> I think better placement for this is drivers/of, no?
> >>
> >> Yes please.
> >
> > Okay, I wasn't sure.  Will do.
> 
> I'm having second thoughts about this.  I think this code is more SPI
> centric than it is OF centric.  ie. it is usable by all spi masters in
> an OF enabled system, but it is not usable by all OF devices in an SPI
> enabled system. 

It's not usable by *any* SPI master on a non-OF system though.
So in that sense it's far more about OF setup than it is about SPI.


> Or, in other words; it adds OF support to SPI, not 
> the other way around.  I think drivers/spi is the right place for this
> to live.

I'd still rather see such translations in the OF-specific part of
the source tree.  Like drivers/acpi/pci_*.c code, this has more to
do with the firmware interface than with bus (SPI) interface.

Arguments could be made both ways here, but for the moment it makes
more sense to me to keep this type of platform glue (be it OF, ACPI,
arch-specific setup code, or whatever) together in the source tree
and apart from the bus-specific code.

Where do the proposed patches gluing OF to I2C live, or has that
been settled yet?

- Dave


