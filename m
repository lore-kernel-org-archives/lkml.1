Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYF1N3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYF1N3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYF1N3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:29:00 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37821 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752777AbYF1N27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:28:59 -0400
Date: Sat, 28 Jun 2008 15:28:56 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 1/3] mmc: Export internal host state through debugfs
Message-ID: <20080628152856.3ba1c2ff@mjolnir.drzeus.cx>
In-Reply-To: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 13:09:47 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> This adds a new config option, MMC_DEBUG_FS which will, when enabled,
> create a few files under /sys/kernel/debug containing information
> about an mmc host's internal state.
> 
> Host drivers can add additional files and directories under the host's
> root directory by passing the debugfs_root field in struct mmc_host as
> the 'parent' parameter to debugfs_create_*.
> 
> Unfinished: No files are actually created yet.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---

Is there any point to having a separate option for this? Can't we just
include it if DEBUG_FS is defined?

Otherwise the system looks ok to me, assuming that everyone is of the
opinion that debugfs is _not_ a stable API.

> +
> +#else
> +static inline void mmc_add_host_debugfs(struct mmc_host *host)
> +{
> +
> +}
> +
> +static inline void mmc_remove_host_debugfs(struct mmc_host *host)
> +{
> +
> +}
> +#endif
> +

In the other places we have conditional function, it is done by
ifdef:ing the calls instead. There are just two of them, so it should
be less mess.


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
