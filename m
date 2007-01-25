Return-Path: <linux-kernel-owner+w=401wt.eu-S1030267AbXAYQOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030267AbXAYQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030270AbXAYQOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:14:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52242 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267AbXAYQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:14:37 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@pobox.com, torvalds@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070125150905.652f9ce2@localhost.localdomain>
References: <20070125150905.652f9ce2@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 00:14:18 +0800
Message-Id: <1169741658.3593.98.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 15:09 +0000, Alan wrote:
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c
> --- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c       2007-01-22 16:26:50.000000000 +0000
> +++ linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c       2007-01-24 17:31:40.000000000 +0000
> @@ -827,7 +827,8 @@
>   */
>  void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
>  {
> -       ata_bmdma_stop(qc);
> +       if (qc->ap->ioaddr.bmdma_addr)
> +               ata_bmdma_stop(qc);
>  }

But what if the bmdma_addr _is_ zero? Please, let's not allow the "zero
is not a valid number" braindamage to spread any further than the IRQ
setup it's already broken.

All the world is not a PeeCee.

-- 
dwmw2

