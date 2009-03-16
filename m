Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbZCPSk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbZCPSk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZCPSkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:40:14 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:31103 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753727AbZCPSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:40:13 -0400
X-Yahoo-Newman-Id: 846135.23067.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i7gZuQfztFjiW6PBM9iYGLZzpwQHaLV+Tgx23Dg4bGgV2EOhNDijb8ANas3KgsxW8R0XK98YD9Ai2mDkWgRRLUAHNbUaYnY9YFbrvINrnk4+SjSWeA8s6JWVvVZHgarzrnV2JSKOtBAsQ97OC78fmJshC66l2fyzApHxTuXa6lA=  ;
X-YMail-OSG: nLuKPXAVM1n.RqqKvWKNOu_iC5sgJ.zJfH5Besu5JZgIBDQytqqTXIS6YG5YG4FZoiChUBQ.8vACIhUIaSxyYwYdIEdeZuxuzaJbjH7fmlZAcIfFfAqGGcmo_QgU5JYXg9dzhWUxhhGbEPu_o26cTH1ltmF7cyE9Hv0bRhugv3hf7KKFKO3RCQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Purushotam Kumar <purushotam@ti.com>
Subject: Re: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for DaVinci/DM6446.
Date: Mon, 16 Mar 2009 11:40:00 -0700
User-Agent: KMail/1.9.10
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
In-Reply-To: <1237214559-31345-1-git-send-email-purushotam@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903161140.01121.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Purushotam Kumar wrote:
> From: Purshotam Kumar <purushotam@ti.com>
> 
> This patch adds support for DaVinci (DM6446) MMC/SD controller driver. This

The dm6446 is the only chip with current mainline support;
but dm355 can use it too, "support on the way" to mainline.
(Only for 2.6.30 if Kevin still has time...)

And there are other DaVinci chips that support MMC too ...
some are compatible with those two chips, some not, all
should use a version of this driver.  (And OMAP-L137 too,
same tech family but with a different marketing label.)

So I'd remove the implication that DaVinci == DM6446, or
that this driver is specific to that SoC.


> @@ -171,6 +171,14 @@ config MMC_TIFM_SD
>            To compile this driver as a module, choose M here: the
>  	  module will be called tifm_sd.
>  
> +config MMC_DAVINCI
> +        tristate "TI DAVINCI Multimedia Card Interface support"
> +        depends on MMC

Everything in that menu depends on MMC.  This should
depend on ARCH_DAVINCI instead.  :)


> +       host->clk = clk_get(&pdev->dev, NULL);

The NULL won't work with the clock code currently
included in mainline ... "MMCSDCLK" will though.

It's probably simplest to list the updated DaVinci
clock framework code as a runtime dependency, much
like EDMA support is a build-time one, for this patch.


> +       if (pdata->max_freq)
> +               mmc->f_max = pdata->max_freq;
> +       if (pdata->caps)
> +               mmc->caps |= pdata->caps;

A build-time issue is that "struct davinci_mmc_config"
is missing.  You could update this patch to include
"arch/arm/mach-davinci/include/mach/mmc.h" too.

- Dave

