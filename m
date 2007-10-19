Return-Path: <linux-kernel-owner+w=401wt.eu-S967206AbXJSVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967206AbXJSVZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966717AbXJSVYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:24:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:4512 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966754AbXJSVYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=lSFshJS+B7c1Z9Zf4ziOS7RMTDA2kJhINlIBiJX872HR+21S9gyYEJLwNZy6ZHzbulXgqVM9R8QQdGWwOMBFZ28rR5jwglJQG6ZYx7zRJUV4mcY2gYnwqGsl3Af0lbJOx0pPtBILw4bK75axaOh4xx4trHvIdd8TzS5tuPjciNA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] ide/pci/sis5513.c: add missing "else"
Date: Fri, 19 Oct 2007 23:00:57 +0200
User-Agent: KMail/1.9.7
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20071019140419.GC3778@stusta.de>
In-Reply-To: <20071019140419.GC3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192300.58051.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007, Adrian Bunk wrote:
> This patch adds a missing "else" that was missing in
> commit c77a89cd98d99819f23a4a08e5e17ee1f13f6e4d.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied, thanks!

> ---
> 2e4b8d4f58ea45e55c87ba5563b0d0e135cac2b4 
> diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
> index c1d280b..1680926 100644
> --- a/drivers/ide/pci/sis5513.c
> +++ b/drivers/ide/pci/sis5513.c
> @@ -264,7 +264,7 @@ static void sis_ata133_program_timings(ide_drive_t *drive, const u8 mode)
>  	if (mode >= XFER_MW_DMA_0) {
>  		t1 &= ~0x04;	/* disable UDMA */
>  		idx = mode - XFER_MW_DMA_0 + 5;
> -	}
> +	} else
>  		idx = mode - XFER_PIO_0;
>  	t1 |= ini_time_value[clk][idx] << 12;
>  	t1 |= act_time_value[clk][idx] << 16;
