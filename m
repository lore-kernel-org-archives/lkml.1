Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbXJWHRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbXJWHRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJWHRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:17:12 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:37052 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbXJWHRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:17:11 -0400
Date: Tue, 23 Oct 2007 09:16:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Christoph Schmitt <schmichr@de.ibm.com>,
       Swen Schillig <swen@vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 04/10] [SG] Update drivers to use sg helpers
Message-ID: <20071023071641.GE24546@osiris.boeblingen.de.ibm.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-5-git-send-email-jens.axboe@oracle.com> <20071023062857.GB24546@osiris.boeblingen.de.ibm.com> <20071023071407.GF25962@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023071407.GF25962@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 09:14:07AM +0200, Jens Axboe wrote:
> On Tue, Oct 23 2007, Heiko Carstens wrote:
> > On Mon, Oct 22, 2007 at 08:10:58PM +0200, Jens Axboe wrote:
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > ---
> > 
> > You forgot s390's zfcp driver. But unfortunately the trivial fix below
> > doesn't work. No more I/O possible. Swen and/or Christof could you
> > provide a correct fix for this please? Thanks!
> > 
> > ---
> >  drivers/s390/scsi/zfcp_def.h |    4 ++--
> >  drivers/s390/scsi/zfcp_erp.c |    4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6/drivers/s390/scsi/zfcp_def.h
> > ===================================================================
> > --- linux-2.6.orig/drivers/s390/scsi/zfcp_def.h
> > +++ linux-2.6/drivers/s390/scsi/zfcp_def.h
> > @@ -63,7 +63,7 @@
> >  static inline void *
> >  zfcp_sg_to_address(struct scatterlist *list)
> >  {
> > -	return (void *) (page_address(list->page) + list->offset);
> > +	return (void *) (page_address(sg_page(list) + list->offset));
> >  }
> 
> return sg_virt(list); would be better.
> 
> I'll fix up the driver, no worries.

ok, thanks!
