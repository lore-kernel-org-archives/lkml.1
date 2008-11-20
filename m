Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYKTUw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYKTUw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYKTUvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:38 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22317 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756015AbYKTUvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rUkvy672zP9QozbRMBXzIAMaIYH/m5EoIjkLz+N22Mc+XCrA3KeohTVCY0kdopAWbJ4d+0fzATcPqpZ10nLHl0rhwiQJilfJIXitbG19a39qt16O0HXIe7JVX94NEWNPbm3LyKr2gSeA+N4tfBZH65fL8IXCV0lzQfiuZOOYFOo=  ;
X-YMail-OSG: 2fKQ9CMVM1mPxFhjRCh9GpGPAoZYrqVXr.O_9A8F0YjRO3jqyAiMfMUlID2m_EYVLf2pMWuNcO0.GLAx4Mnx4xYiFj5K81jxpEy57vCYSw5Kp33mmWLDj2JUd7TOzlrteNDKhpoJVTxfLdc4m3FZllRV
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 02/16] Blackfin SPI Driver: Fix erroneous SPI Clock divisor calculation
Date: Thu, 20 Nov 2008 12:25:59 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-3-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201226.00286.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Fix erroneous SPI Clock divisor calculation. Make sure SPI_BAUD is
> always >= 2. Writing a value of 0 or 1 to the SPI_BAUD register disables
> the serial clock.
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  arch/blackfin/include/asm/bfin5xx_spi.h |    2 ++
>  drivers/spi/spi_bfin5xx.c               |    3 +++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/blackfin/include/asm/bfin5xx_spi.h b/arch/blackfin/include/asm/bfin5xx_spi.h
> index 9fa1915..b16c3cd 100644
> --- a/arch/blackfin/include/asm/bfin5xx_spi.h
> +++ b/arch/blackfin/include/asm/bfin5xx_spi.h
> @@ -21,6 +21,8 @@
>  #ifndef _SPI_CHANNEL_H_
>  #define _SPI_CHANNEL_H_
>  
> +#define MIN_SPI_BAUD_VAL	2
> +
>  #define SPI_READ              0
>  #define SPI_WRITE             1
>  
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index e9b7366..a38106a 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -158,6 +158,9 @@ static u16 hz_to_spi_baud(u32 speed_hz)
>  	if ((sclk % (2 * speed_hz)) > 0)
>  		spi_baud++;
>  
> +	if (spi_baud < MIN_SPI_BAUD_VAL)
> +		spi_baud = MIN_SPI_BAUD_VAL;
> +
>  	return spi_baud;
>  }
>  
> -- 
> 1.5.6.3
> 
> 


