Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbXFGPR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbXFGPR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760655AbXFGPRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:17:20 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53456 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbXFGPRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:17:19 -0400
Date: Thu, 7 Jun 2007 11:17:17 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, akpm@linux-foundation.org,
       david@dgreaves.com, jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA commands
Message-ID: <20070607151717.GA6653@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org> <46665AB5.6040508@gmail.com> <20070606102122.GD29122@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606102122.GD29122@htj.dyndns.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 07:21:22PM +0900, Tejun Heo wrote:
> sata_promise uses two different command modes - packet and TF.  Packet
> mode is intelligent low-overhead mode while TF is the same old
> taskfile interface.  As with other advanced interface (ahci/sil24),
> ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands
> are issued using TF interface in polling mode, so pdc_interrupt()
> considers interrupts spurious if ATA_TFLAG_POLLING is set.
> 
> This is broken for polling NODATA commands because command is issued
> using packet mode but the interrupt handler ignores it due to
> ATA_TFLAG_POLLING.  Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA
> commands are issued using TF interface if ATA_TFLAG_POLLING is set.
> 
> This patch fixes detection failure introduced by polling SETXFERMODE.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> David, please verify this patch.  Mikael, does this look okay?  Please
> push this upstream after David and Mikael's ack.
> 
> (This repost is identical to the previous posting but it's now on the
>  correct thread.)

Acked-by: Jeff Garzik <jeff@garzik.org>

Tejun, would you mind pushing this upstream to Linus/Andrew?

I'm travelling this week, and my home firewall doesn't like me.
It is probably easier for you than me.

	Jeff



