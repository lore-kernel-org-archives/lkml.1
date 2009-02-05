Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZBEWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZBEWN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZBEWNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:13:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbZBEWNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:13:00 -0500
Date: Thu, 5 Feb 2009 14:12:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com, cooloney@kernel.org
Subject: Re: [PATCH 3/5] Blackfin SPI Driver: fix NULL pointer crash
Message-Id: <20090205141250.cf66e663.akpm@linux-foundation.org>
In-Reply-To: <1233828453-13311-4-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	<1233828453-13311-4-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Feb 2009 18:07:31 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> fix NULL pointer crash when cleaning up from invalid platform resources
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/spi/spi_bfin5xx.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index ce24d5e..b6098b5 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -1240,6 +1240,9 @@ static void bfin_spi_cleanup(struct spi_device *spi)
>  {
>  	struct chip_data *chip = spi_get_ctldata(spi);
>  
> +	if (!chip)
> +		return;
> +
>  	if ((chip->chip_select_num > 0)
>  		&& (chip->chip_select_num <= spi->master->num_chipselect))
>  		peripheral_free(ssel[spi->master->bus_num]

This one looks like 2.6.29 material to me.

If you believe that it should be backported to earlier kernels then
please let me know.  indicating whcih kernel versions would help things
a bit, too.


