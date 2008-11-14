Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYKNWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYKNWAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYKNWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:00:30 -0500
Received: from server.drzeus.cx ([85.8.24.28]:56192 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670AbYKNWAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:00:30 -0500
Date: Fri, 14 Nov 2008 23:00:26 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 6/7] SDHCI: Check DMA for overruns at end of transfer
Message-ID: <20081114230026.18513b8a@mjolnir.drzeus.cx>
In-Reply-To: <20081103201010.820070757@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.820070757@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 20:09:50 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> At the end of a transfer, check that the DMA engine in the
> SDHCI controller actually did what it was meant to and didn't
> overrun the end of the buffer.
> 
> This seems to be triggered by a timeout during an CMD25 (multiple block         
> write) to a card. The mmc_block module then issues a command to find out        
> how much data was moved and this seems to end up triggering this DMA            
> check. The result is the card's queue generates an OOPS as the stack has        
> been trampled on due to the extra data transfered.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

I'm sorry, but I don't see how this is anywhere near acceptable. This
should be a panic at the very least, and until this can be sorted out
and avoided the driver should avoid using DMA on these chips.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
