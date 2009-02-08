Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZBHR1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZBHR1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 12:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZBHR1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 12:27:03 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:26127 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752202AbZBHR1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 12:27:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hEcs0SYhYQu5WIY9sB4JqGo/ADWYxZrnLmW84I5sNF42avmgCYXVz4Rb+iPB9Ubwd5xVcIqVT+XyVFH2lRTQ88xzj8PMuh3E/I+jAjKmyAS4tjn/K6H0vEVT2yxp2+Hts7snpbFY/1pWVdM2Y/U4nWgR7gqgDi2OVRHJMlkvjiM=  ;
X-YMail-OSG: OemSOQcVM1n0mGkkOAswyCwF5rH3lcTnBqdn8M8FlvVT1gsx6kGervedqrGfJFtxEzqfeBE54yh3CFlt9GgBK_ykK3n6MkZa2EEZmtGvCoRfjon6taS_oH2upa0oMPwNfoSlbWYle8zwMOeojTVaBR8qYpj5gUbwYfzfin7pm1t3uQJ3WnStyGY_h6mh7P1h_UZLJASLzL2OI1aLKc4h8yi7KEx6YOwm9f1tAQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] spi: limit reaches -1, tested 0
Date: Sun, 8 Feb 2009 09:26:54 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <498EE9C0.3010601@gmail.com> <200902080828.49036.david-b@pacbell.net> <498F0D64.4040909@gmail.com>
In-Reply-To: <498F0D64.4040909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902080926.56810.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Roel Kluin wrote:
> >>> -			while ((read(drv_data) == 0) && limit--);
> >>> +			while ((read(drv_data) == 0) && --limit);
> > 
> > ... although I wouldn't have resisted the urge to make the
> > loop body be "cpu_relax();" instead of an empty statement.
> 
> Ok,
> ---------------------------->8-------------------8<-----------------------------
> With a postfix decrement limit will reach -1 rather than 0, so the warning will
> not be issued.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Still:

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
> index 269a55e..15abe61 100644
> --- a/drivers/spi/spi_imx.c
> +++ b/drivers/spi/spi_imx.c
> @@ -779,7 +779,8 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
>  
>  			/* Read trailing bytes */
>  			limit = loops_per_jiffy << 1;
> -			while ((read(drv_data) == 0) && limit--);
> +			while ((read(drv_data) == 0) && limit--)
> +				cpu_relax();
>  
>  			if (limit == 0)
>  				dev_err(&drv_data->pdev->dev,
> 
> 


