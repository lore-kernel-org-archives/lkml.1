Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXJKVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXJKVqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbXJKVqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:46:33 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:23639 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756728AbXJKVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:46:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rUK7BrswHyJN1sp3LLyTNDdtyBWlfWLscf3zRMwz4bzS2YY2LLYxWAy82yj/o8zaugh2P4ziW/zo06DirhxQpPjWeMGcQ0+PMDgAL0Z22izydZf1vj2gK6qs6ngrX3URAO3Yv7J7b8n1zf8thhrK6MJZBZ25qLq2OpQT71j3G1M=  ;
X-YMail-OSG: xqu_0icVM1lot.NEtvBCKC8Vnp.2qZOyY2N309lcsr5tumTHvidknXcRt.ILkpj89SxEqxosaw--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/9] Blackfin SPI driver: use new GPIO API and add error handling
Date: Thu, 11 Oct 2007 14:46:29 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1192097441-24962-1-git-send-email-bryan.wu@analog.com> <1192097441-24962-2-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1192097441-24962-2-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710111446.29725.david-b@pacbell.net>
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


This doesn't apply against 2.6.23 ... ?
