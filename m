Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZCDUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZCDUx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbZCDUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:53:18 -0500
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.207.48]:37305 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754356AbZCDUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:53:17 -0500
X-Yahoo-Newman-Id: 696940.61563.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uBy5d2UyOnhsF2eUP0iHrVqiACwkX0lDiuDXHB45xHPvVvNBS27TOakFHhPVWBBYMsIEzfq7/X7KAW5E4e+cVx7TKQwIfBiErIzrLLb+09B3qGj0E7U2NjeP1qVORCIkYzZE3P8iJgx7ShE1Y83KOllMILTSfud/5d0rqdCLJJM=  ;
X-YMail-OSG: M01V.3UVM1nAqsZkypFOT2lSx4H2_Hn1gYAeg.dYonv9xIf3UGkVY0nSjBPWvb4lM9yHs9WAQDziM3YVD7bh80KuKr2QYxuGo4yYN3jBQPT0OSpfCoO.iXOuw6f0CQUTFM5Msym5_JsPaoNerAP_uKSHydaioSBKDFmNmxlgf_Qo95zYwjboTOd9abgvwxQpew--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Will Newton <will.newton@gmail.com>
Subject: Re: [PATCH] mtd_dataflash: Fix probing of AT45DB321C chips.
Date: Wed, 4 Mar 2009 12:53:12 -0800
User-Agent: KMail/1.9.10
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>
References: <87a5b0800903040241k51f65a65p82a2da8f6de1c832@mail.gmail.com>
In-Reply-To: <87a5b0800903040241k51f65a65p82a2da8f6de1c832@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041253.13414.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Will Newton wrote:
> Commit 771999b65f79264acde4b855e5d35696eca5e80c broke support for probing
> AT45DB321C flash chips. These chips do not support the "page size" status
> bit, so if we match the JEDEC id return early.
> 
> Signed-off-by: Will Newton <will.newton@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

.... these are the *only* such chips with that issue, first
version of the more capable generations of chips.

Out of curiousity, was this observed with a C-rev chip, or
inferred by noticing it was the only chip that could ever
need such an "else" branch?

> ---
>  drivers/mtd/devices/mtd_dataflash.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/devices/mtd_dataflash.c
> b/drivers/mtd/devices/mtd_dataflash.c
> index d44f741..cd4781f 100644
> --- a/drivers/mtd/devices/mtd_dataflash.c
> +++ b/drivers/mtd/devices/mtd_dataflash.c
> @@ -822,6 +822,8 @@ static struct flash_info *__devinit
> jedec_probe(struct spi_device *spi)
>  						return info;
>  				}
>  			}
> +			else
> +				return info;
>  		}
>  	}
> 
> -- 
> 1.5.5.2
> 



