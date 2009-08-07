Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbZHGSnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbZHGSnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZHGSnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:43:19 -0400
Received: from ru.mvista.com ([213.79.90.228]:2030 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932615AbZHGSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:43:19 -0400
Date: Fri, 7 Aug 2009 22:43:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Kumar Gala <galak@kernel.crashing.org>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/4] sdhci-of: Fix high-speed cards recognition
Message-ID: <20090807184319.GA22652@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
 <20090807165015.GB524@oksana.dev.rtsoft.ru>
 <4A7C5FAB.2020304@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A7C5FAB.2020304@csr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 06:08:59PM +0100, David Vrabel wrote:
> Anton Vorontsov wrote:
> > eSDHC fails to recognize some SDHS cards, throwing timeout errors:
> > 
> >   mmc0: error -110 whilst initialising SD card
> > 
> > That's because we calculate timeout value in a wrong way: on eSDHC
> > hosts the timeout clock is derivied from the SD clock, which is set
> > dynamically.
> 
> I've seen an reference design for an SDHC controller do this also.

Thanks for the information!

> > +/* Controller has dynamic timeout clock management */
> > +#define SDHCI_QUIRK_DYNAMIC_TIMEOUT_CLOCK		(1<<24)
> 
> This comment and define would be better if it matched terms used in the
> spec.  Suggest:
> 
> /* Controller uses SDCLK instead of TMCLK for data timeouts. */
> #define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK  (1 << 24)

Yeah, if it's somewhat common scheme, then it makes sense to name the
quirk that way.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
