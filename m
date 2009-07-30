Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbZG3M4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbZG3M4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZG3M4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:56:04 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:54196 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZG3M4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:56:03 -0400
Message-ID: <4A719811.4060904@csr.com>
Date: Thu, 30 Jul 2009 13:54:41 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@bencohen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>,
       Matt Fleming <matt@console-pimps.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Subject: Re: [PATCH] sdio: add CD disable support
References: <1248954848.5396.6.camel@localhost>
In-Reply-To: <1248954848.5396.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 12:54:42.0010 (UTC) FILETIME=[E7D69BA0:01CA1114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen wrote:
> From: Ohad Ben-Cohen <ohad@wizery.com>
> 
> To save power, the pull-up resistor on CD/DAT[3] (pin 1)
> of the card can be disconnected. This is desired, e.g.,
> with embedded SDIO devices which do not rely on this pin
> for card detection.

Platforms may rely on the card's pull-up and not fit/configure an
external one.  There may need to be a way for host controller drivers to
 say this and prevent the disabling of the card's DAT3 pull-up.

> Signed-off-by: Ohad Ben-Cohen  <ohad@wizery.com>
> ---
>  drivers/mmc/core/sdio.c  |   32 ++++++++++++++++++++++++++++++++
>  include/linux/mmc/card.h |    3 ++-
>  2 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index fb99ccf..4c4c9a9 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -165,6 +165,31 @@ static int sdio_enable_wide(struct mmc_card *card)
>  }
>  
>  /*
> + * Disconnect the pull-up resistor on CD/DAT[3] if requested by the card.
> + * If card detection is not needed, this can save some power.
> + */

The first sentence of this comment doesn't make sense.  The decision to
disable the pull-up is for the controller driver to make, not that card.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
