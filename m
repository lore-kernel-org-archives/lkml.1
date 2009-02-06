Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZBFNXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZBFNXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZBFNXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:23:01 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:49784 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZBFNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:23:00 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: Paul Walmsley <paul@pwsan.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Date: Fri, 6 Feb 2009 14:22:32 +0100
User-Agent: KMail/1.9.9
Cc: tony@atomide.com, ext-adrian.hunter@nokia.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       jarkko.lavinen@nokia.com, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
References: <20081207213617.10456.43951.stgit@localhost> <20090205121045.4022c319.akpm@linux-foundation.org> <alpine.DEB.2.00.0902051323090.8131@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.0902051323090.8131@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061422.32689.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 21:32:03 Paul Walmsley wrote:
> On Thu, 5 Feb 2009, Andrew Morton wrote:
> > On Tue, 3 Feb 2009 15:05:58 +0100
> >
> > Jean Pihet <jpihet@mvista.com> wrote:
> > > +	while (OMAP_HSMMC_READ(host->base,
> > > + 			SYSCTL) & SRD)
> > > + 		;
> >
> > Is a __raw_readl() sufficient to prevent the cpu from burning up here,
> > or should we add cpu_relax()?
>
> The __raw_readl() should be sufficient.  The MMC controller is located on
> the L4 CORE interconnect, so the round trip latency for the read from MMC
> is at least 90 ns, while the CPU cycle time is only about 1 to 2 ns.
Ok.
>
> > An infinite loop which assumes the hardware is perfect is always a
> > worry.  But I see the driver already does that, so we're no worse off..
Do you want a finite loop with udelay in it? I located 4 places were this 
could be used. If so I can generate a new patch for that.

>
> - Paul

Regards,
Jean
