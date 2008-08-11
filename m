Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYHKUqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYHKUqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYHKUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:46:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37310 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYHKUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:46:06 -0400
Date: Mon, 11 Aug 2008 22:45:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC, 2.6.26.3-rc1]  i2c: Fix NULL pointer dereference in
 i2c_new_probed_device
Message-ID: <20080811224558.57d052a1@hyperion.delvare>
In-Reply-To: <200808112207.53563.oliver.pntr@gmail.com>
References: <200808112207.53563.oliver.pntr@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 22:07:53 +0200, Oliver Pinter wrote:
> 
> From b25b791b13aaa336b56c4f9bd417ff126363f80b Mon Sep 17 00:00:00 2001

I doubt it...

> It is an RFC for sending this patch for stable, when this patch needed, then send ACK and CC stable,
>  if not then send NAK.

And what exactly is stable going to do with a patch they can't even
apply due to the quotation marks my e-mail client will have added?

Doesn't make sense to me. I can send my patches to stable myself, thank
you. And without spamming LKML at that.

> 
> ---
> 
> From: Hans Verkuil <hverkuil@xs4all.nl>
> Date: Sun, 10 Aug 2008 22:56:15 +0200
> Subject: [PATCH] i2c: Fix NULL pointer dereference in i2c_new_probed_device
> 
> Fix a NULL pointer dereference that happened when calling
> i2c_new_probed_device on one of the addresses for which we use byte
> reads instead of quick write for detection purpose (that is: 0x30-0x37
> and 0x50-0x5f).
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> CC: Oliver Pinter <oliver.pntr@gmail.com>
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 7bf38c4..c16dcad 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1451,9 +1451,11 @@ i2c_new_probed_device(struct i2c_adapter *adap,
>  		if ((addr_list[i] & ~0x07) == 0x30
>  		 || (addr_list[i] & ~0x0f) == 0x50
>  		 || !i2c_check_functionality(adap, I2C_FUNC_SMBUS_QUICK)) {
> +			union i2c_smbus_data data;
> +
>  			if (i2c_smbus_xfer(adap, addr_list[i], 0,
>  					   I2C_SMBUS_READ, 0,
> -					   I2C_SMBUS_BYTE, NULL) >= 0)
> +					   I2C_SMBUS_BYTE, &data) >= 0)
>  				break;
>  		} else {
>  			if (i2c_smbus_xfer(adap, addr_list[i], 0,
> 


-- 
Jean Delvare
