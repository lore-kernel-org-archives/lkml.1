Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZBQVad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZBQVad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZBQVaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:30:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbZBQVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:30:21 -0500
Date: Tue, 17 Feb 2009 13:29:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, andy@openmoko.com, drzeus-mmc@drzeus.cx
Subject: Re: [PATCH] mmc: In mmc_power_up, use previously selected ocr if
 available
Message-Id: <20090217132900.dc041bd5.akpm@linux-foundation.org>
In-Reply-To: <20090209132806.GD3278@fedora.yogi>
References: <20090209132806.GD3278@fedora.yogi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 18:58:08 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> When mmc_power_up is called during unsafe resume, host->ocr should be
> used instead of host->ocr_avail.
> 
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
> Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> ---
>  drivers/mmc/core/core.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index df6ce4a..3ad7f87 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -572,7 +572,13 @@ void mmc_set_timing(struct mmc_host *host, unsigned int timing)
>   */
>  static void mmc_power_up(struct mmc_host *host)
>  {
> -	int bit = fls(host->ocr_avail) - 1;
> +	int bit;
> +
> +	/* If ocr is set, we use it */
> +	if (host->ocr)
> +		bit = ffs(host->ocr) - 1;
> +	else
> +		bit = fls(host->ocr_avail) - 1;
>  
>  	host->ios.vdd = bit;
>  	if (mmc_host_is_spi(host)) {

What are the user-visible consequences of not having this patch in
their kernels?

In other words, what does this patch fix?

Please always include this information in changelogs.

See, this patch is applicable to 2.6.28, 2.6.27, 2.6.26, 2.6.25 and
probably earlier.  But I don't have a clue whether it should be applied
to those kernels, because you didn't tell me.



