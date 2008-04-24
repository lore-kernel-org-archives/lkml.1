Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYDXGPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYDXGPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYDXGPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:15:32 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:15635 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752800AbYDXGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:15:32 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1209017730!10245763!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 24 Apr 2008 08:11:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Roel Kluin <12o3l@tiscali.nl>
CC: <rmk@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: am79c961a: platform_get_irq() may return signed unnoticed
Message-ID: <20080424061110.GC17978@digi.com>
References: <480FADA3.7030708@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <480FADA3.7030708@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 24 Apr 2008 06:11:10.0529 (UTC) FILETIME=[FDD34B10:01C8A5D1]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15866.007
X-TM-AS-Result: No--11.329000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Roel Kluin wrote:
> dev->irq is unsigned, platform_get_irq() may return signed unnoticed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
> index ba6bd03..a637910 100644
> --- a/drivers/net/arm/am79c961a.c
> +++ b/drivers/net/arm/am79c961a.c
> @@ -693,11 +693,15 @@ static int __init am79c961_probe(struct platform_device *pdev)
>  	 * done by the ether bootp loader.
>  	 */
>  	dev->base_addr = res->start;
> -	dev->irq = platform_get_irq(pdev, 0);
> +	ret = platform_get_irq(pdev, 0);
>  
> -	ret = -ENODEV;
> -	if (dev->irq < 0)
> +	if (ret < 0) {
> +		ret = -ENODEV;
>  		goto nodev;
> +	}
> +	dev->irq = ret;
> +
> +	ret = -ENODEV;
>  	if (!request_region(dev->base_addr, 0x18, dev->name))
>  		goto nodev;
For me the change looks fine.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
