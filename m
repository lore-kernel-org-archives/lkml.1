Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752118AbYLQUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbYLQUWg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYLQUW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:22:26 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:41674 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751169AbYLQUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:22:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VqKhj/+8RrrEe/vL22Fw+Dgx2/aY0LLfa0zdOVSDmWJkPlw8Fky9Z3act4fTmijhkuOFnVuJAfXbhLUhONMbgLyVDvU5K4xMBoZ6Lyx2l2NHoY59pdGMlM08avyzodQNQjjYS58B6Ra0Bs8rocV1ZrIm3Nz88lo1eEXOdJshD+U=  ;
X-YMail-OSG: rErEeEIVM1k23Hy7ZqEjPlKPeAivNRrjkC0d2KkkdlTBZC.lBFnmfuLiJWAl5hsuQW6Njmy8DJEmcPEpgIfSA4Wcfws3IJpmTUx6Jg8vhPMg7E2g42HmcGaMkBc6ts1Gty4UIACp7988C0jg3tPRTNGSr72gg.ba54ZUqTWQLnxRgWvszHEiN9331KrTXwJoTx74ZZpl4FDV0aLlK0mrubRtMWg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 10/11] drivers/spi: Move a dereference below a NULL test
Date: Wed, 17 Dec 2008 12:22:23 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812161615090.20444@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812161615090.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171222.23785.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... and I'm *still* glad to see tools shaking loose
goofage like this.  :)


> 
> ---
>  drivers/spi/pxa2xx_spi.c            |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
> index cf12f2d..fbad7e4 100644
> --- a/drivers/spi/pxa2xx_spi.c
> +++ b/drivers/spi/pxa2xx_spi.c
> @@ -1561,11 +1561,12 @@ out_error_master_alloc:
>  static int pxa2xx_spi_remove(struct platform_device *pdev)
>  {
>  	struct driver_data *drv_data = platform_get_drvdata(pdev);
> -	struct ssp_device *ssp = drv_data->ssp;
> +	struct ssp_device *ssp;
>  	int status = 0;
>  
>  	if (!drv_data)
>  		return 0;
> +	ssp = drv_data->ssp;
>  
>  	/* Remove the queue */
>  	status = destroy_queue(drv_data);
> 
> 


