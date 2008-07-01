Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbYGABvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbYGABvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYGABuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:50:52 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37224 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbYGABuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:50:51 -0400
Subject: Re: [PATCH 5/5] MMC: cleanup endianity conversions
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214869984-20115-5-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-4-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-5-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 03:51:04 +0200
Message-Id: <1214877064.11537.94.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index e6703e5..3ad340c 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -271,17 +271,17 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>  int mmc_send_csd(struct mmc_card *card, u32 *csd)
>  {
>  	int ret, i;
> -
> +	__be32 csd_buf[4];
>  	if (!mmc_host_is_spi(card->host))
>  		return mmc_send_cxd_native(card->host, card->rca << 16,
>  				csd, MMC_SEND_CSD);

what is up with this empty line removal. I would keep the empty line
after the variable declaration.

>  	for (i = 0;i < 4;i++)
> -		csd[i] = be32_to_cpu(csd[i]);
> +		csd[i] = be32_to_cpu(csd_buf[i]);

While you are at it. Add the missing whitespace in the for statement :)

Otherwise, looks good to me.

Regards

Marcel


