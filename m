Return-Path: <linux-kernel-owner+w=401wt.eu-S965299AbXAYNOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299AbXAYNOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965308AbXAYNNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:13:48 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32585 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965299AbXAYNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:13:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=NBr6nGwAJxASNiJvhBsELz2XZTAy8UxNCV5aluKY11nhzCydCsU3hQKGxLRa6MxsgBYAMnuYLlSSw0qcSXzOamUJ1fPADGb0MzlTnD//dab+SeksXjYvReaUBktPWKrGTN6tLiC8iuyGinRA8hKS7zmihBy6h1+TcyT8aCjdQNk=  ;
X-YMail-OSG: F_WkV3kVM1lUJDbUBHIzANeyCUUQjXbtoQOHuxzi.c49SVx6Hm4wDFIT263VlLmwe50wGsaJDgz7tcHH.p24dI.t0vrkklK2UK7ILd.fBi0Te6pa3mlSTy_lgMbKLho-
From: David Brownell <david-b@pacbell.net>
To: "Hans-Peter Nilsson" <hans-peter.nilsson@axis.com>
Subject: Re: [PATCH] 3/5: Updates to SPI and mmc_spi: tx_default, kernel 2.6.19
Date: Thu, 25 Jan 2007 05:02:56 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701250452.l0P4q76u017140@ignucius.se.axis.com>
In-Reply-To: <200701250452.l0P4q76u017140@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701250502.56467.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 8:52 pm, Hans-Peter Nilsson wrote:
> (Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)
> 
> The SD/MMC SPI-based protocol isn't really duplex.  In the
> normal case there's either information transmitted or received,
> not both simultaneously.  The unused data is always 0xff; ones.
> Unfortunately, the SPI framework leaves outgoing data for a
> left-out tx_buf just as "undefined"

In current kernels that's actually changed.  The value to be shifted
out is now specified ... as all-zeroes, which is what various chips
need to receive, and various (half-duplex/Microwire) controllers seem
to be doing in any case.

If that's an issue -- and MMC-over-SPI needs to specify some other
value -- then please re-issue this patch against 2.6.20, including
the update to the bitbang driver ("reference implementation").

I think a better way to package this would be to define a new
flag for spi->mode, since controller drivers are already supposed
to be checking that to make sure they handle all the options which
have been specified.  That flag could work in conjunction with
a byte provided in the spi_device, that would be used instead of
zero.  (Some folk have noted that when debugging, it's easier if
the pattern there is neither all-ones nor all-zeroes ... something
that a digital scope will show is easier to work with.)

- Dave



