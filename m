Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYGUF3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYGUF3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYGUF3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:29:09 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50377 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbYGUF3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:29:08 -0400
Subject: Re: [PATCH 4/7] irda: Default to dongle type 9 on IBM hardware
From: Marcel Holtmann <marcel@holtmann.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
References: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 07:29:36 +0200
Message-Id: <1216618176.8411.124.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> CC: Samuel Ortiz <samuel@sortiz.org>
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Signed-off-by: Ben Collins <ben.collins@canonical.com>
> ---
>  drivers/net/irda/nsc-ircc.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
> index effc1ce..1ecb013 100644
> --- a/drivers/net/irda/nsc-ircc.c
> +++ b/drivers/net/irda/nsc-ircc.c
> @@ -151,8 +151,8 @@ static char *dongle_types[] = {
>  static chipio_t pnp_info;
>  static const struct pnp_device_id nsc_ircc_pnp_table[] = {
>  	{ .id = "NSC6001", .driver_data = 0 },
> -	{ .id = "IBM0071", .driver_data = 0 },
>  	{ .id = "HWPC224", .driver_data = 0 },
> +	{ .id = "IBM0071", .driver_data = 1 },
>  	{ }
>  };
>  
> @@ -934,6 +934,9 @@ static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *i
>  	 * On my box, cfg_base is in the PnP descriptor of the
>  	 * motherboard. Oh well... Jean II */
>  
> +	if (id->driver_data == 1)
> +		dongle_id = 0x9;
> +

this patch is in serious need of introducing some constants to be used
with driver_data and not plain numbers. Also using a bitmask would be a
good idea.

Regards

Marcel


