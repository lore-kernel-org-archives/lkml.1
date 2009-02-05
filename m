Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZBEWOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZBEWOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZBEWNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:13:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170AbZBEWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:13:22 -0500
Date: Thu, 5 Feb 2009 14:13:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, wolfgang.mues@auerswald.de,
       yi.li@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 5/5] Blackfin SPI Driver: Make mmc_spi driver work on
 Blackfin
Message-Id: <20090205141302.be8b3217.akpm@linux-foundation.org>
In-Reply-To: <1233828453-13311-6-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	<1233828453-13311-6-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Feb 2009 18:07:33 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> 1. Rewrite of the non-dma data transfer functions to use only ONE
> mode of TIMOD (TIMOD=0x1). With TIMOD=0, it was not possible to set
> the TX bit pattern. So the TDBR = 0xFFFF inside the read calls won't
> work.
> 
> 2. Clear SPI_RDBR before reading and before duplex transfer. Otherwise
> the garbage data in RDBR will get read. Since mmc_spi uses a lot of
> duplex transfers, this is the main cause of mmc_spi failure.
> 
> 3. Poll RXS for transfer completion. Polling SPIF or TXS cannot
> guarantee transfer completion. This may interrupt a transfer before
> it is finished. Also this may leave garbage data in buffer and
> affect next transfer.
> 
> [Yi Li <yi.li@analog.com>: add a field "u16 idle_tx_val" in "struct
> bfin5xx_spi_chip" to specify the value to transmit if no TX value
> is supplied.]


again, driver-core has destroyed your patch.

There was no _need_ to take the unusual and undesirable step of
modifying SPI via an unrelated tree.
