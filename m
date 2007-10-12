Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbXJLG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbXJLG0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXJLG0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:26:37 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23858 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753423AbXJLG0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:26:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JOkozIT0HcFLJOi/bVg72Pvz17VIsLr2C/aFTkveP+0URSe3SBuNuL0jW7oOmlrl4wpHuxjasrkYh137UptSp4A/AhXzDB3vVIPYnfDvOLy+QTZ12NY4evSM16YsYckmnUfS9TN0SkeKaKU0QpiLJOPo+sm6haVzF0rGJGbVBUM=  ;
X-YMail-OSG: MNuoofQVM1l1xW.YPtqFvPdT_BzKor_.P2gk22LREqr2XzZic17jLidiyo18LMLWljFxbjMlvA--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 02/10] Blackfin SPI driver: use new GPIO API and add error handling
Date: Thu, 11 Oct 2007 23:26:34 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com> <1192158304-8277-3-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1192158304-8277-3-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710112326.34500.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007, Bryan Wu wrote:
> @@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>         }
>  
> -       if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
> -                peripheral_request(P_SPI0_MISO, DRV_NAME) ||
> -                peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
> -
> +       if (setup_pin_mux(1)) {
>                 dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
> -               goto out_error_queue_alloc;
> +               goto out_error;
>         }
>  
>         drv_data = spi_master_get_devdata(master);
> 

Still doesn't apply ... what tree are you generating this series against??
