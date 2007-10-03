Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXJCGSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXJCGSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXJCGSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:18:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36144 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXJCGSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:18:16 -0400
Date: Wed, 3 Oct 2007 15:18:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linuxsh-dev@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix SH DMAC code to handle PVR2 cascade
Message-ID: <20071003061805.GA8851@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linuxsh-dev@lists.sourceforge.net>,
	LKML <linux-kernel@vger.kernel.org>
References: <1191359367.17654.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191359367.17654.24.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 10:09:27PM +0100, Adrian McMenamin wrote:
> Fix SH DMAC code to correctly handle PVR2 cascade DMA.
> 
> This updates http://lkml.org/lkml/2007/10/2/276
> 
> (I decided it was better to have the true size of the transfer put in
> via the API and refactor this here. And calc_xmit_shift(chan) should
> return 5 but only returns 3 so I've not used it here)
> 
It would be helpful to know why calc_xmit_shift() is broken here rather
than just coding around it, as this will have implications for the other
DMA channels on SH7091/SH7750.

Now that you've completely bypassed the rest of the SH-DMAC ->xfer_dma()
op, it's clear that the existing infrastructure needs a bit of rework for
dealing with the cascaded DMACs (especially for single-address mode only,
unidirectionally). It would be nice to get the mach-specific kludges for
cascade out of dma-sh entirely.

This can certainly be fixed for 2.6.24, though a larger overhaul is
2.6.25 material at this point.
