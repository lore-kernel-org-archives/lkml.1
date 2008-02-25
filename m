Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYBYLFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYBYLFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYBYLFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:05:36 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:58696 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYBYLFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:05:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: dma engine drivers for 2.6.25?
Date: Mon, 25 Feb 2008 18:25:08 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEC9304A@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20802231806u15bbf0dbm7ee68b6620a4b418@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: dma engine drivers for 2.6.25?
Thread-Index: Ach2idRtJij6zV6ZQBi9FA8dH+oB2AA8OdzA
References: <BEF96263-F31B-472E-B31F-0751F5ABFBDA@kernel.crashing.org> <e9c3a7c20802141014k6018f6dfvc1a97bf81acb872e@mail.gmail.com> <DC488215-D313-41E0-A98A-1C90D02A465D@kernel.crashing.org> <e9c3a7c20802142129m51acf21amc48eaea5db45840b@mail.gmail.com> <e9c3a7c20802231806u15bbf0dbm7ee68b6620a4b418@mail.gmail.com>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>,
       "Kumar Gala" <galak@kernel.crashing.org>
Cc: "LKML Kernel" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for missing lots of emails in my long vacation. :)

> -----Original Message-----
> From: dan.j.williams@gmail.com 
> [mailto:dan.j.williams@gmail.com] On Behalf Of Dan Williams
> Sent: Sunday, February 24, 2008 10:06 AM
> To: Kumar Gala
> Cc: LKML Kernel; Zhang Wei
> Subject: Re: dma engine drivers for 2.6.25?
> 
> On Thu, Feb 14, 2008 at 10:29 PM, Dan Williams 
> <dan.j.williams@intel.com> wrote:
> > On Thu, Feb 14, 2008 at 8:44 PM, Kumar Gala 
> <galak@kernel.crashing.org> wrote:
> >  >
> >  >  On Feb 14, 2008, at 12:14 PM, Dan Williams wrote:
> >  >
> >  >  > On Wed, Feb 13, 2008 at 8:52 PM, Kumar Gala
> >  >  > <galak@kernel.crashing.org> wrote:
> >  >  >> Dan,
> >  >  >>
> >  >  >> What's going on with the dma engine drivers for 
> 2.6.25?  We had a
> >  >  >> Freescale dma driver from Zhang Wei queued up but 
> seems to have been
> >  >  >> lost.
> >  >  >
> >  >  > I pulled it into my tree and am holding it until Zhang has an
> >  >  > opportunity to address the pending review comments 
> [1].  I also did
> >  >  > not feel comfortable pushing it to Linus without a 
> PPC maintainer's
> >  >  > Acked-by/Reviewed-by.
> >  >  >
> >  >  > I have attached the version I am carrying.
> >  >
> >  >  What issues are still open.  I was under the belief 
> that Zhang had
> >  >  resolved all the issues.
> >  >
> >
> >  The high priority review item is that the driver performs operation
> >  completion callbacks in hardirq context.  Clients of the API assume
> >  that callbacks will happen in softirq context.  Of lesser 
> concern is
> >  the use of GFP_ATOMIC in fsl_dma_alloc_descriptor.  Other drivers
> >  preallocate a small pool of descriptors.
> >
> 
> Have not received a response, so let's try this the other way.  I took
> a closer look and found that my concern should be addressed by the
> following one-liner:
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 902e852..cc9a681 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -685,7 +685,6 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int
> irq, void *data)
>                                 "nlndar 0x%016llx\n", 
> (u64)get_cdar(fsl_chan),
>                                 (u64)get_ndar(fsl_chan));
>                 stat &= ~FSL_DMA_SR_EOSI;
> -               fsl_chan_ld_cleanup(fsl_chan);
>         }
> 
>         /* If it current transfer is the end-of-transfer,
> 
> With your ack I'll push the driver plus this fixlet for the 
> current kernel.

I agree with you to remove the fsl_chan_ld_cleanup() function calling in
Interrupt action, which is already called in tasklet. I forgot to remove it.
Thanks!

Cheers!
Wei.

