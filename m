Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbYC0ToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbYC0ToT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbYC0ToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:44:07 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:32935 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757720AbYC0ToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:44:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bt8DyuofwiZTLRnxDIe2gC/+fZJBQ6GEjftlPOFAErg7t+vGSfTSAnGHisrfH8Ao05X4RbrF6JMZBWHtSmTfdGQO8iXgPEcDJ5wuae2MXwmpFjbXM5x7VzZ+RxqQ5yGgQw2DXgnDem5bSyquz3VnEFl0+fM/NiQi6RWVemMxuBQ=  ;
X-YMail-OSG: zZ_Mb8gVM1kZnFpz2F90obFeMKizuVVXGrXt_fBUBzcQf26Cl7V_hLv6w8As.0SJ9rIexOrnCcJcclsA8mjJ603tk70loi9_CHciTkBOGgHOwNdctTDMhDcmrmtK
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] test for NULL return from platform_get_resource() in ohci_hcd_sm501_drv_remove()
Date: Thu, 27 Mar 2008 12:27:46 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb@vger.kernel.org, Roman Weissgaerber <weissg@vienna.at>,
       Lennert Buytenhek <kernel@wantstofly.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <alpine.LNX.1.00.0803212250210.9597@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0803212250210.9597@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271227.46818.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 March 2008, Jesper Juhl wrote:
> 
> platform_get_resource() may return null, so although it seems it will never
> do so here unless there's a bug elsewhere, it does no harm to be defensive 
> and test.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

(and cc the author of that code:  Magnus Damm <magnus.damm@gmail.com>)

> ---
> 
>  ohci-sm501.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
> index a970701..1ffc272 100644
> --- a/drivers/usb/host/ohci-sm501.c
> +++ b/drivers/usb/host/ohci-sm501.c
> @@ -199,7 +199,8 @@ static int ohci_hcd_sm501_drv_remove(struct platform_device *pdev)
>  	usb_put_hcd(hcd);
>  	dma_release_declared_memory(&pdev->dev);
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	release_mem_region(mem->start, mem->end - mem->start + 1);
> +	if (mem)
> +		release_mem_region(mem->start, mem->end - mem->start + 1);
>  
>  	/* mask interrupts and disable power */
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


