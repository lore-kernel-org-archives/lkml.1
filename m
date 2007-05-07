Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbXEGReQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbXEGReQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXEGReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:34:13 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:1568 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbXEGReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:34:12 -0400
Date: Mon, 7 May 2007 13:34:01 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: [PATCH] libata: fallback to the other IDENTIFY on device error
Message-ID: <20070507173401.GA9229@electro-mechanical.com>
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463F56F2.3010106@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 06:42:26PM +0200, Tejun Heo wrote:
> It seems the world isn't as frank as we thought and some devices lie
> about who they are.  Fallback to the other IDENTIFY if IDENTIFY fails
> with device error.  As this is the strategy used by IDE for a long
> time, it shouldn't cause too much problem.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: William Thompson <wt@electro-mechanical.com>
> ---
> Willam, please verify this fixes your problem.  Jeff, after all, we
> seem to need this.  :-(

Seems that I have a different version than you do.  See below.

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ca67484..f543109 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1652,7 +1652,7 @@ int ata_dev_read_id(struct ata_device *d
>  	struct ata_taskfile tf;
>  	unsigned int err_mask = 0;
>  	const char *reason;
> -	int tried_spinup = 0;
> +	int may_fallback = 1, tried_spinup = 0;
>  	int rc;

My version doesn't have "int tried_spinup = 0;" in it at all.  I did find
where const char *reason; is (line 1455)

I'm using 2.6.20

I probably won't use 2.6.21 due to some of the problems I read about on the
kernel list.

I'll manually add this patch to mine and see how far I get.
