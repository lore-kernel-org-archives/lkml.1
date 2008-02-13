Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYBMSby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYBMSby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYBMSbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:31:46 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:56972 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbYBMSbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:31:45 -0500
Date: Wed, 13 Feb 2008 19:30:51 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080213193051.1a7e3b29@poseidon.drzeus.cx>
In-Reply-To: <1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 19:10:13 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> +
> +/* Those printks take an awful lot of time... */
> +#ifndef DEBUG
> +static unsigned int fmax = 15000000U;
> +#else
> +static unsigned int fmax = 1000000U;
> +#endif
> +module_param(fmax, uint, 0444);
> +MODULE_PARM_DESC(fmax, "Max frequency in Hz of the MMC bus clock");
> +

I think this was meant to go away.

> +
> +static int req_dbg_open(struct inode *inode, struct file *file)
> +{

And this should go into the core.

> +
> +static int __exit atmci_remove(struct platform_device *pdev)
> +{
> +	struct atmel_mci *host = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	if (host) {
> +		atmci_cleanup_debugfs(host);
> +
> +		if (host->detect_pin >= 0) {
> +			free_irq(gpio_to_irq(host->detect_pin),host->mmc);
> +			cancel_delayed_work(&host->mmc->detect);

I also pointed this out. mmc_remove_host() will synchronize this for
you.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
