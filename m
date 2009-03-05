Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZCEIri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZCEIri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZCEIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:47:17 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:61194 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756041AbZCEIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:47:16 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABcgr0lR9Sa6/2dsb2JhbADYAgeEAQY
Date: Thu, 5 Mar 2009 09:47:13 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: wim@iguana.be, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] watchdog: fsl_get_sys_freq() failure not noticed
Message-ID: <20090305084713.GB6026@infomag.iguana.be>
References: <49AD3A3D.4040303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD3A3D.4040303@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

> Maybe it is nicer to do a test like:
> 
> 	if (freq < MAX_FREQ)
> 
> but I don't know what MAX_FREQ should be.
> ------------------------------>8-------------8<---------------------------------
> fsl_get_sys_freq() may return -1 when 'soc' isn't found, but in gef_wdt_probe()
> 'freq' is unsigned, so the test doesn't catch that.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
> index f0c2b7a..734d980 100644
> --- a/drivers/watchdog/gef_wdt.c
> +++ b/drivers/watchdog/gef_wdt.c
> @@ -269,7 +269,7 @@ static int __devinit gef_wdt_probe(struct of_device *dev,
>  	bus_clk = 133; /* in MHz */
>  
>  	freq = fsl_get_sys_freq();
> -	if (freq > 0)
> +	if (freq != -1)
>  		bus_clk = freq;
>  
>  	/* Map devices registers into memory */

patch added into the linux-2.6-watchdog-next tree.
Will sent it to linus for inclusion into main kernel tree tonight together with some other fixes.

Kind regards,
Wim.

