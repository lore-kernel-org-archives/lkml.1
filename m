Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZGYSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZGYSkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZGYSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 14:40:55 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:52858 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZGYSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 14:40:54 -0400
Date: Sat, 25 Jul 2009 19:40:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/32] mmc: add host capabilities for SD only and MMC
	only
Message-ID: <20090725184030.GB12665@console-pimps.org>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower> <20090710124054.1262.18902.sendpatchset@ahunter-tower> <20090725155336.GA12665@console-pimps.org> <4A6B300A.10706@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6B300A.10706@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 07:17:14PM +0300, Adrian Hunter wrote:
> Matt Fleming wrote:
>>
>> And by saying what capabilities a host supports, when we add new
>> capabilities we don't have to modify existing code to say that it
>> doesn't support the new capability.
>
> If the capabilities are the other way around, then all existing drivers
> must be changed.  On the other hand, the if statement can easily be
> improved:
>
> #define mmc_cap_mmc(host) (!((host)->caps & MMC_CAP_NOT_MMC))
> #define mmc_cap_sd(host) (!((host)->caps & MMC_CAP_NOT_SD))
> #define mmc_cap_sdio(host) (!((host)->caps & MMC_CAP_NOT_SDIO))
>
> -	mmc_send_if_cond(host, host->ocr_avail);
> +	if (mmc_cap_sdio(host) || mmc_cap_sd(host))
> +		mmc_send_if_cond(host, host->ocr_avail);
> +

OK, that's a fair point, all drivers would need to be changed. However,
I'm not adverse to making a one-time change to all drivers in the name
of sanity. Enumerating what cards a controller doesn't support just
doesn't sound correct to me.

It wouldn't be a complicated change either, I'd even be happy to write
the patch ;-)
