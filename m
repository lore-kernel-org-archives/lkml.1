Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXGaOUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXGaOUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbXGaOUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:20:15 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:59083 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXGaOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:20:14 -0400
Message-ID: <46AF44C5.50102@gentoo.org>
Date: Tue, 31 Jul 2007 10:18:45 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: jack@hawkeye.stone.uk.eu.org
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [Patch 14/16] Remove needless kmalloc casts in the zd1211rw drivers.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125446.578465000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125446.578465000@hawkeye.stone.uk.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jack@hawkeye.stone.uk.eu.org wrote:
> Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
> 
> CC: Daniel Drake <dsd@gentoo.org>

NAK: this patch adds a sparse warning
zd_chip.c:116:15: warning: implicit cast to nocast type

> ---
>  drivers/net/wireless/zd1211rw/zd_chip.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/zd1211rw/zd_chip.c
> ===================================================================
> --- a/drivers/net/wireless/zd1211rw/zd_chip.c
> +++ b/drivers/net/wireless/zd1211rw/zd_chip.c
> @@ -115,7 +115,7 @@ int zd_ioread32v_locked(struct zd_chip *
>  
>  	/* Allocate a single memory block for values and addresses. */
>  	count16 = 2*count;
> -	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> +	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
>  		                   GFP_KERNEL);
>  	if (!a16) {
>  		dev_dbg_f(zd_chip_dev(chip),
> 

