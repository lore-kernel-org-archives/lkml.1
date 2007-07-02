Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXGBTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXGBTN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXGBTNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:13:51 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3861 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXGBTNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:13:51 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [PATCH] mmc: at91_mci: fix hanging and rework to match flowcharts
Date: Mon, 2 Jul 2007 21:13:45 +0200
User-Agent: KMail/1.9.5
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Andreas Beier <mughat@gmail.com>,
       Hamish Guthrie <hamish@prodigi.ch>, Marc Pignat <marc.pignat@hevs.ch>,
       wux@landicorp.com, Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
References: <4688EC94.1090901@rfo.atmel.com>
In-Reply-To: <4688EC94.1090901@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707022113.46858.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> @@ -250,28 +246,27 @@ static void at91_mci_pre_dma_read(struct
>  /*
>   * Handle after a dma read
>   */
> -static void at91_mci_post_dma_read(struct at91mci_host *host)
> +static int at91_mci_post_dma_read(struct at91mci_host *host)
>  {
>         struct mmc_command *cmd;
>         struct mmc_data *data;
> +       int completed = 0;

You added 'completed' but you use it only once - as a return value.

>         pr_debug("post dma read done\n");
> +       return completed;
> }

What's the point?

	Mariusz
