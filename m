Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYF1Nhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYF1Nhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYF1Nhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:37:48 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52221 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbYF1Nhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:37:47 -0400
Date: Sat, 28 Jun 2008 15:37:45 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628153745.027b0817@mjolnir.drzeus.cx>
In-Reply-To: <1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 13:09:49 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> For each card successfully added to the bus, create a subdirectory under
> the host's debugfs root with information about the card.
> 
> At the moment, only a single file is added to the card directory:
> "status". Reading this file will ask the card about its current status
> and return it. This can be useful if the card just refuses to respond to
> any commands, which might indicate that the card state is not what the
> MMC core thinks it is (due to a missing stop command, for example.)
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---

The status command doesn't work on SDIO cards, so this seems like the
wrong place for it.

> +#else
> +static inline void mmc_add_card_debugfs(struct mmc_card *card)
> +{
> +
> +}
> +
> +static inline void mmc_remove_card_debugfs(struct mmc_card *card)
> +{
> +
> +}
> +#endif
> +

ifdef the calls here as well.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
