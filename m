Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZJBODa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZJBODa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZJBODa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:03:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:55302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZJBOD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:03:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,494,1249282800"; 
   d="scan'208";a="556041624"
Date: Fri, 2 Oct 2009 16:05:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, tglx@linutronix.de,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction
 LCDBacklight and Keypad Input Device Driver
Message-ID: <20091002140517.GA1520@sortiz.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org>
 <1253682664-27040-1-git-send-email-vapier@gentoo.org>
 <20091001140948.GD10199@sortiz.org>
 <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com>
 <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, Oct 02, 2009 at 02:48:27PM +0100, Hennerich, Michael wrote:
> >From: uclinux-dist-devel-bounces@blackfin.uclinux.org
> [mailto:uclinux-dist-devel-
> >bounces@blackfin.uclinux.org] On Behalf Of Hennerich, Michael
> >Device Driver
> >
> >Hi Samuel,
> >
> >>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> >>Hi Mike,
> >>
> >>Some comments on this patch:
> >>
> >>On Wed, Sep 23, 2009 at 01:11:04AM -0400, Mike Frysinger wrote:
> >>> +static irqreturn_t adp5520_irq_handler(int irq, void *data)
> >>> +{
> >>> +	struct adp5520_chip *chip = data;
> >>> +
> >>> +	disable_irq_nosync(irq);
> >>> +	schedule_work(&chip->irq_work);
> >>Have you considered using a threaded irq handler here ?
> >
> >The Linux version I developed this driver on didn't feature threaded
> irq
> >handlers.
> >But thanks I'm going to take a look here.
> 
> Hi Samuel,
> 
> Well the threaded irq handlers are no option here, since we use a Level
> Sensitive Interrupt. 
> The work queue here is to schedule the main irq handler outside hardirq
> context.
> I2C can't we invoked form none sleepy context, so we can't clear the
> interrupt. 
> This will cause that we execute the hardirq over and over again,
> preventing the irq thread to be run.
> 
> The threaded irqs with its current implementation also doesn't allow me
> to disable the irq in the hardirq handler.
Ok, that's the piece I missed. Thanks for the clarification.


> There have been some discussions about this on lkml recently.
> Until there is a way to workaround this issue (handle_level_oneshot_irq,
> etc.),
> I like to stick with: 
Fine with me, yes.

Cheers,
Samuel.


> >>> +	disable_irq_nosync(irq);
> >>> +	schedule_work(&chip->irq_work);
> 
> Best regards,
> Michael
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
