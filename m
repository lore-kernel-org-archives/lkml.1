Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYBEJxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYBEJxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 04:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYBEJxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 04:53:09 -0500
Received: from mail.hevs.ch ([153.109.23.15]:42122 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbYBEJxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 04:53:08 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] at91_mci:  use generic GPIO calls
Date: Tue, 5 Feb 2008 10:53:32 +0100
User-Agent: KMail/1.9.7
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>
References: <200802011901.27532.david-b@pacbell.net> <47A74790.50207@atmel.com>
In-Reply-To: <47A74790.50207@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051053.33105.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Monday 04 February 2008, Nicolas Ferre wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
...
>  /*
> @@ -946,9 +986,10 @@ static int __exit at91_mci_remove(struct
>  	host = mmc_priv(mmc);
>  
>  	if (host->board->det_pin) {
> +		if (device_can_wakeup(&pdev->dev))
> +			free_irq(gpio_to_irq(host->board->det_pin), host);
Seems strange to use device_can_wakeup(&pdev->dev) as
have_we_requested_this_irq(gpio_to_irq(host->board->det_pin))... but seems to
work.

Regards

Marc
