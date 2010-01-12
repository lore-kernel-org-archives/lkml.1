Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0ALXhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0ALXhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887Ab0ALXhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:37:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab0ALXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:37:04 -0500
Date: Tue, 12 Jan 2010 15:36:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       khilman@deeprootsystems.com
Subject: Re: [PATCH v3 1/2] davinci: MMC: Add a function to control reset
 state of the controller
Message-Id: <20100112153657.f3474ab8.akpm@linux-foundation.org>
In-Reply-To: <1262950729-12502-1-git-send-email-chaithrika@ti.com>
References: <1262950729-12502-1-git-send-email-chaithrika@ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Jan 2010 17:08:49 +0530
Chaithrika U S <chaithrika@ti.com> wrote:

> -static void
> -davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
> +static inline void mmc_davinci_reset_ctrl(struct mmc_davinci_host *host,
> +								int val)
>  {
>  	u32 temp;
>  
> -	/* reset command and data state machines */
>  	temp = readl(host->base + DAVINCI_MMCCTL);
> -	writel(temp | MMCCTL_CMDRST | MMCCTL_DATRST,
> -		host->base + DAVINCI_MMCCTL);
> +	if (val)	/* reset */
> +		temp |= MMCCTL_CMDRST | MMCCTL_DATRST;
> +	else		/* enable */
> +		temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
>  
> -	temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
> -	udelay(10);
>  	writel(temp, host->base + DAVINCI_MMCCTL);
> +	udelay(10);
> +}

nit: it's hard for a reader of the code to work out why a udelay() such
as the above was included.  Perhaps the data sheet for the hardware
would tell him, if he has access to it.

But generally speaking, the code is better code if it explains the
reasoning to the reader.
