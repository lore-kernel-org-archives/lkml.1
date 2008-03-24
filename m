Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYCXLN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYCXLN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 07:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758983AbYCXLNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 07:13:15 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:36195 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897AbYCXLNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 07:13:14 -0400
Date: Mon, 24 Mar 2008 13:13:11 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Carlos Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MMC: OMAP: Introduce new multislot structure and
 change driver to use it
Message-ID: <20080324131311.43c5d54c@mjolnir.drzeus.cx>
In-Reply-To: <47DAD3B1.4060502@indt.org.br>
References: <47DAD3B1.4060502@indt.org.br>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 15:36:17 -0400
Carlos Aguiar <carlos.aguiar@indt.org.br> wrote:

> From: Juha Yrjola <juha.yrjola@solidboot.com>
> 
> Introduce new MMC multislot structure and change driver to use it.
> 
> Note that MMC clocking is now enabled in mmc_omap_select_slot()
> and disabled in mmc_omap_release_slot().
> 
> Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
> Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---

*snip*

> +
> +	if (slot->pdata->name != NULL) {
> +		r = device_create_file(&mmc->class_dev,
> +					&dev_attr_slot_name);
> +		if (r < 0)
> +			goto err_remove_host;
> +	}
> +
> +	if (slot->pdata->get_ro != NULL) {
> +		r = device_create_file(&mmc->class_dev,
> +					&dev_attr_ro);
> +	}
> +

I guess these should have been removed as well?

> +static void mmc_omap_remove_slot(struct mmc_omap_slot *slot)
> +{
> +	struct mmc_host *mmc = slot->mmc;
> +
> +	if (slot->pdata->name != NULL)
> +		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
> +	if (slot->pdata->get_ro != NULL)
> +		device_remove_file(&mmc->class_dev, &dev_attr_ro);
> +

Same thing here.

Otherwise the patch looks fine.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
