Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZCHWRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZCHWRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZCHWR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:17:29 -0400
Received: from h155.mvista.com ([63.81.120.155]:5994 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbZCHWR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:17:28 -0400
Message-ID: <49B443F1.7050102@ru.mvista.com>
Date: Mon, 09 Mar 2009 01:17:21 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] ide: add ->dma_clear method and remove ->dma_timeout
 one
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171147.25429.26218.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171147.25429.26218.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> All custom ->dma_timeout implementations call the generic one thus it is
> possible to have only an optional method for resetting DMA engine instead:
>
> * Add ->dma_clear method and convert hpt366, pdc202xx_old and sl82c105
>   host drivers to use it.
>
> * Always use ide_dma_timeout() in ide_dma_timeout_retry() and remove
>  ->dma_timeout method.
>
> * Make ide_dma_timeout() static.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -715,8 +715,9 @@ struct ide_dma_ops {
>  	int	(*dma_end)(struct ide_drive_s *);
>  	int	(*dma_test_irq)(struct ide_drive_s *);
>  	void	(*dma_lost_irq)(struct ide_drive_s *);
> +	/* below ones are optional */
>  	int	(*dma_timer_expiry)(struct ide_drive_s *);
> -	void	(*dma_timeout)(struct ide_drive_s *);
> +	void	(*dma_clear)(struct ide_drive_s *);
>  	/*
>  	 * The following method is optional and only required to be
>   

   Perhaps worth removing the words about method being optional now...

>  	 * implemented for the SFF-8038i compatible controllers.
>   

MBR, Sergei

