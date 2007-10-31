Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXJaTFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXJaTFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXJaTFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:05:43 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:47346 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752917AbXJaTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:05:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M3UL9WT627jVqjAkN//psGX3nLFWJlWfu+sV7qJQC+9KRTYznueYfGKXdDwVI7VJ6kPS1oEtDs4J78HfzzgyBDPb2mxCwF3CzhZwpss2rANjmTHfryBGZXxNeUW2n5hjaYj8xzYJ5YMYRIOvntwKeragXysMmum3t8dFQSSLPWs=  ;
X-YMail-OSG: DN.vvxkVM1lHv2Dsi3zKZIJKsbAoq1yBgo8Vg9lFScYsQDxuJ77dYpxjFE0n6QYAZBSVtHXi9w--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Date: Wed, 31 Oct 2007 12:01:28 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, bryan.wu@analog.com,
       Sonic Zhang <sonic.zhang@analog.com>, linux-kernel@vger.kernel.org
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <200710310011.33545.david-b@pacbell.net> <8bd0f97a0710310133m7b5cbbf3j545a489c401185df@mail.gmail.com>
In-Reply-To: <8bd0f97a0710310133m7b5cbbf3j545a489c401185df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311201.29643.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007, Mike Frysinger wrote:
> On 10/31/07, David Brownell <david-b@pacbell.net> wrote:
> > (ISTR the M25P16 in $SUBJECT has two read commands, one of
> > which is only usable at clock rates below 33 MHz or so, but
> > most other commands can work above that speed just fine.)
> 
> pretty much all SPI flashes have two read commands ("slow" and "fast"
> as they're typically called). 

Not DataFlash.  But many other modern flash chips do, like
most of the ones handled by the m25p80 driver.   As noted
there in the comment about how it should switch over to use
the fast read command ...


> i dont think any of the linux drivers though use the "slow"
> reads with any SPI flashes ... that'd be silly  :)

Considering the m25p80 driver started on a uClinux platform
that ISTR couldn't achieve the 33+ MHz clock rates for SPI,
it doesn't seem at all odd to me!

And in fact, lots of Linux systems for some reason don't
seem to be able to clock SPI that fast, even if a given
board were laid out to handle 50+ MHz signaling there.

- Dave
