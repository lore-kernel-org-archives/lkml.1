Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbXKAQ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbXKAQ7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXKAQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:59:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:65459 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbXKAQ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,359,1188802800"; 
   d="scan'208";a="309685725"
Date: Thu, 1 Nov 2007 09:58:24 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-Id: <20071101095824.2f53e6d9.kristen.c.accardi@intel.com>
In-Reply-To: <4729B670.7090403@garzik.org>
References: <20071031201308.GK11514@kernel.dk>
	<20071101084145.GA5037@kernel.dk>
	<20071101092155.GB5037@kernel.dk>
	<4729B670.7090403@garzik.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 07:20:16 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Jens Axboe wrote:
> > Reverting just the default AHCI flags makes it work again. IOW, with the
> > below patch I can suspend properly with current -git.
> > 
> > diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> > index ed9b407..77f7631 100644
> > --- a/drivers/ata/ahci.c
> > +++ b/drivers/ata/ahci.c
> > @@ -190,8 +190,7 @@ enum {
> >  
> >  	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
> >  					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
> > -					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
> > -					  ATA_FLAG_IPM,
> > +					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
> >  	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
> 
> 
> sounds like the easy thing to do, in light of this breakage, might be to 
> default it to off, add a module parameter turning it on by setting that 
> flag.
> 

Can you give me a day to fix it first?  I had a similar problem earlier
on in the development, and the fix was not that bad.  The issue was 
related to not bringing the link back up to active before doing suspend/resume,
and the fix was really straight forward.  I'll take a look at this today,
and if I can't come up with a pretty fast fix I'll let you know.

Kristen
