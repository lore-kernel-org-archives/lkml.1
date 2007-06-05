Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbXFEVxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbXFEVxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbXFEVw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:52:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45004 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765558AbXFEVw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:52:58 -0400
Date: Tue, 5 Jun 2007 17:52:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: akpm@linux-foundation.org, david@dgreaves.com, htejun@gmail.com,
       jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc4 - sata_promise regression since -rc3
Message-ID: <20070605215256.GT31565@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706052131.l55LVkYN000191@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:31:46PM +0200, Mikael Pettersson wrote:
> I can easily reproduce the problem in 2.6.22-rc4. There are no
> sata_promise changes between rc3 and rc4, but Tejun's libata
> polling SETXFER change was included in rc4. Reverting it makes
> sata_promise work again for me.

Ugh.


> I suspect that sata_promise.c:pdc_interrupt() should detect
> a qc w/ ATA_TFLAG_POLLING, treat the interrupt as spurious,
> and just call ata_chk_status(qc), similar to how sata_inic162x.c,
> sata_nv.c, sata_sil.c, and sata_vsc.c do things.

Yes, highly likely.

SFF-like controllers (and in this case, Promise is included in that
list) with their own interrupt handlers need their own polling handling
code.

	Jeff



