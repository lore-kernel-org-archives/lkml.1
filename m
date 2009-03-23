Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZCWQ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZCWQ4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZCWQ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:56:10 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61693 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbZCWQ4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:56:09 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19mDh8oMzDhA28f+qOwD9R0
Date: Mon, 23 Mar 2009 09:56:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH 1/2] arm: twl4030 - leak fix
Message-ID: <20090323165611.GE29546@atomide.com>
References: <20090323103834.32524.65397.stgit@localhost.localdomain> <20090323104347.32524.76448.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090323104347.32524.76448.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk> [090323 03:45]:
> Trivial error path leak fix. Problem found by Daniel Marjamäki using
> cppcheck
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
> 
>  arch/arm/mach-omap2/mmc-twl4030.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
> index 437f520..e1dadf7 100644
> --- a/arch/arm/mach-omap2/mmc-twl4030.c
> +++ b/arch/arm/mach-omap2/mmc-twl4030.c
> @@ -397,6 +397,7 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
>  			break;
>  		default:
>  			pr_err("MMC%d configuration not supported!\n", c->mmc);
> +			kfree(mmc);
>  			continue;
>  		}
>  		hsmmc_data[c->mmc - 1] = mmc;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
