Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYF1NeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYF1NeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYF1NeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:34:08 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52699 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754916AbYF1NeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:34:05 -0400
Date: Sat, 28 Jun 2008 15:34:03 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628153403.0870e96c@mjolnir.drzeus.cx>
In-Reply-To: <1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 13:09:48 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> Export all the fields in struct mmc_ios under /sys/kernel/debug/<host>/ios
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/mmc/core/host.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mmc/host.h |   13 +++++++++++
>  2 files changed, 68 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 93da502..2977f26 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -25,6 +25,54 @@
>  #ifdef CONFIG_MMC_DEBUG_FS
>  #include <linux/debugfs.h>
>  
> +static void mmc_remove_ios_debugfs(struct mmc_ios *ios)
> +{
> +	if (ios->dbg_root) {

You can save a bit of indentation if you do:

	if (!ios->dbg_root)
		return;

> +static int mmc_add_ios_debugfs(struct mmc_ios *ios, struct dentry *parent)
> +{
> +	struct dentry *dir;
> +
> +	dir = debugfs_create_dir("ios", parent);
> +	if (!dir)
> +		return -EBUSY;	/* or whatever */

Is it undefined what a NULL return means here? I would have expected an
ERRPTR or ENOMEM.

> +#ifdef CONFIG_MMC_DEBUG_FS
> +	struct dentry		*dbg_root;
> +	struct dentry		*dbg_clock;
> +	struct dentry		*dbg_vdd;
> +	struct dentry		*dbg_bus_mode;
> +	struct dentry		*dbg_chip_select;
> +	struct dentry		*dbg_power_mode;
> +	struct dentry		*dbg_bus_width;
> +	struct dentry		*dbg_timing;
> +#endif

Can't we use debugfs' own bookkeeping to keep track of them? Saves us a
lot of noise in these structures.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
