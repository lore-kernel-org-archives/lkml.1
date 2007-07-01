Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbXGAXI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbXGAXI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 19:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXGAXIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 19:08:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47059 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbXGAXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 19:08:17 -0400
Date: Mon, 2 Jul 2007 01:08:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kumar Gala <galak@freescale.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] ppc: remove APUS support
Message-ID: <20070701230843.GD10869@stusta.de>
References: <20070701202206.GO10869@stusta.de> <Pine.LNX.4.64.0707020053530.30442@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707020053530.30442@anakin>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 12:55:36AM +0200, Geert Uytterhoeven wrote:
> On Sun, 1 Jul 2007, Adrian Bunk wrote:
> > Current status of APUS:
> > - arch/powerpc/: a patch to remove it is in powerpc.git
> > - arch/ppc/: marked BROKEN since 2 years
> > 
> > This patch therefore removes the remaining parts of APUS support.
> 
> > --- linux-2.6.22-rc6-mm1/include/asm-m68k/pgtable.h.old	2007-06-30 01:23:33.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/include/asm-m68k/pgtable.h	2007-06-30 01:23:43.000000000 +0200
> > @@ -107,8 +107,6 @@ extern void *empty_zero_page;
> >  /* 64-bit machines, beware!  SRB. */
> >  #define SIZEOF_PTR_LOG2			       2
> >  
> > -#define mm_end_of_chunk(addr, len)	0
> > -
> >  extern void kernel_set_cachemode(void *addr, unsigned long size, int cmode);
> >  
> >  /*
> > --- linux-2.6.22-rc6-mm1/drivers/scsi/a2091.c.old	2007-06-30 01:23:53.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/drivers/scsi/a2091.c	2007-06-30 01:24:08.000000000 +0200
> > @@ -46,8 +46,7 @@ static int dma_setup(struct scsi_cmnd *c
> >      struct Scsi_Host *instance = cmd->device->host;
> >  
> >      /* don't allow DMA if the physical address is bad */
> > -    if (addr & A2091_XFER_MASK ||
> > -	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
> > +    if (addr & A2091_XFER_MASK)
> >      {
> >  	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
> >  	    & ~0x1ff;
> > --- linux-2.6.22-rc6-mm1/drivers/scsi/a3000.c.old	2007-06-30 01:24:17.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/drivers/scsi/a3000.c	2007-06-30 01:24:26.000000000 +0200
> > @@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
> >       * end of a physical memory chunk, then allocate a bounce
> >       * buffer
> >       */
> > -    if (addr & A3000_XFER_MASK ||
> > -	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
> > +    if (addr & A3000_XFER_MASK)
> >      {
> >  	HDATA(a3000_host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
> >  	    & ~0x1ff;
> > --- linux-2.6.22-rc6-mm1/drivers/scsi/gvp11.c.old	2007-06-30 01:24:35.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/drivers/scsi/gvp11.c	2007-06-30 01:24:46.000000000 +0200
> > @@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
> >      static int scsi_alloc_out_of_range = 0;
> >  
> >      /* use bounce buffer if the physical address is bad */
> > -    if (addr & HDATA(cmd->device->host)->dma_xfer_mask ||
> > -	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
> > +    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
> >      {
> >  	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
> >  	    & ~0x1ff;
> 
> These seem to be completely unrelated to removing APUS support?

For APUS mm_end_of_chunk() was an actual function, otherwise it was 
always 0.

> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

