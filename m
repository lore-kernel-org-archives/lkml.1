Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbXGKKtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbXGKKtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762493AbXGKKsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:48:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:50114 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762498AbXGKKsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:48:53 -0400
Date: Tue, 10 Jul 2007 15:02:28 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Message-ID: <20070710150228.15008b53@localhost.localdomain>
In-Reply-To: <20070707211306.2ef074cf@the-village.bc.nu>
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
	<20070707211306.2ef074cf@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007 21:13:06 +0100
Alan Cox wrote:

> On Sat, 07 Jul 2007 13:48:52 +0400
> Vitaly Bordug <vitb@kernel.crashing.org> wrote:
> 
> > 
> > This adds support for MMIO IDE device like CompactFlash 
> > in TrueIDE mode.
> 
> Really we should be working towards libata support for all new
> devices. This looks like a candidate for the existing (or a little
> enhanced) pata_platform driver.
> 

Yes I am aware of it, yet, the code was created for IDE subsystem due to internal reasons,
and I thought to better make it available for others at least. We'll prolly pick it up to move
to libata/pata_platform but not instantly afaict now.

> > +config BLK_DEV_MMIOIDE
> > +	tristate "Memory Mapped IDE support"
> 
> Please pick a better description. This isn't a generic option for
> enabling MMIO based IDE as you make it sound.
> 
> 
> Also we have an accepted match name for ATA platform devices - and
> adding another one messes it up irrespective of whether you want
> libata or legacy IDE support. If you use the same matches then your
> platform code, and everyone elses platform code can work with both
> drivers, except for hotpluggability.
> 
> Other bugs
> 
> - Your remove code releases the resources before the hwif which means
> it races another user trying to claim the resource
> - Be careful with ide_unregister. It exists and you can call it but
> its actually not very safe and there are lots of unfixed races in the
> IDE layer if you do
> 

OK, makes sense.
> 
> The "should we have a legacy ide driver that matches the libata
> pata_platform" question I don't really care about. Its a waste of
> effort in many ways but if you've written the code the work is done
> so why not use it.
> 
> However it needs to be *compatible* so that platform devices can be
> claimed by either so the kernel build can pick legacy IDE v libata and
> not have to #ifdef all the platform code.
> 

Sounds good. I'll look forward to address the issues, thanks.

> Alan


-- 
Sincerely, Vitaly
