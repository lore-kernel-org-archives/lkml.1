Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJFKyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJFKyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYJFKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:54:47 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47386 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYJFKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:54:47 -0400
Subject: Re: [PATCH] btsdio: fix tx error path
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1223283914-18238-1-git-send-email-tomas.winkler@intel.com>
References: <1223283914-18238-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 12:54:50 +0200
Message-Id: <1223290490.11272.149.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> This patch fixes accumulating of the header
> in case packet was requeued in the error path.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> ---
>  drivers/bluetooth/btsdio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
> index 58630cc..e4724b8 100644
> --- a/drivers/bluetooth/btsdio.c
> +++ b/drivers/bluetooth/btsdio.c
> @@ -91,6 +91,7 @@ static int btsdio_tx_packet(struct btsdio_data *data, struct sk_buff *skb)
>  
>  	err = sdio_writesb(data->func, REG_TDAT, skb->data, skb->len);
>  	if (err < 0) {
> +		skb_pop(skb, 4);
>  		sdio_writeb(data->func, 0x01, REG_PC_WRT, NULL);
>  		return err;
>  	}

please do at least a compile test. It is skb_pull() and not skb_pop().

Regards

Marcel


