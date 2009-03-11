Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZCKVEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZCKVEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZCKVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:03:58 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:27688 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750886AbZCKVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:03:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rLZxZJqkMnFBocZ4gZN4gUPs4GznVcSI4WjwyXNp0MPFLzwLi61RkaQQBFreH2RHNxeXgdpp4/I9/7iANcfrM4Ltc3kVOB/NlwXfTgjjW4O6rv3qRmtFNdm1DORTEf15HiGC5Q6zP8ekybdt3xfjDikD2LgWXWU9DyiEm3cl9Y8=  ;
X-YMail-OSG: 9qzMrgQVM1kvaGAkuLhNoidVMcgoDjXAwjHaRS_7GHBy2B.NRu25EhIzcG0I_58bgZ9_aM6qkY4uW_1W36R3b_vxPRPflykUzwmRDb5mC0QRTMR01zRRKoJ1N0eNfzjPSvzi0NsaHKp1KEiG6XIz7eUrWeaGmmRyaIJgpC_tpd_DEAjhhpguTk4yShMN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 7/7] mmc_spi: support for non-byte-aligned cards
Date: Wed, 11 Mar 2009 13:03:53 -0800
User-Agent: KMail/1.9.10
Cc: "Will Newton" <will.newton@gmail.com>, "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <87a5b0800903110656x7000e0c8q23ceae7e87483bf7@mail.gmail.com> <200903111534.34340.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111534.34340.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111403.54407.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> The SD protocoll ist NOT byte-aligned. Messages are starting with a 
> leading "0" bit. I think some chip vendors have adapted the SPI mode
> from SD mode and forgotten to do propper byte alignment. 

Please capture that information in comments somewhere, so the
next folk updating the driver won't have to be guessing as much
about the low-level protocol bugs that are being coped with.

Comments listing concrete examples of such cards (or even
just a compatibility list posted to an archived mailing
list so a websearch can find it) would be nice too.  Who
knows, maybe the vendors would even fix the next rev of
their silicon (or firmware, whatever).  ;)


> Am Mittwoch, 11. März 2009 schrieb Will Newton:
> > I have not seen these problems or seen them reported by others.
>
> Yes, it is hard to believe that such a design error is present in today SD
> cards. But spi mode is used only by some devices which do not have a SD
> host controller on board.

I think that's it exactly.  Some of the newer MMC-derived
specifications even desupported SPI mode, as I recall.

In practice, I can't see it going away for a very long time,
but mid- and high-end systems tend to have real MMC/SD/SDIO
controllers they use for media cards as well as eMMC and
other "managed NAND" solutions (iNAND etc); and presumably
CE-ATA isn't entirely a paper tiger.

- Dave


