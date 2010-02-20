Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0BTHWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:22:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0BTHWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:22:30 -0500
Date: Sat, 20 Feb 2010 00:21:48 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100220002148.6676a8f6@redhat.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03215B07FF@dbde02.ent.ti.com>
References: <20100208065519.GE1290@ucw.cz>
	<1265622676.4020.19.camel@pc1117.cambridge.arm.com>
	<20100208105209.GA31671@atrey.karlin.mff.cuni.cz>
	<1265628483.4020.63.camel@pc1117.cambridge.arm.com>
	<EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
	<20100216084442.GA3212@n2100.arm.linux.org.uk>
	<5A47E75E594F054BAF48C5E4FC4B92AB03215B07FF@dbde02.ent.ti.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 14:21:48 +0530
"Gadiyar, Anand" <gadiyar@ti.com> wrote:

> >         hcd->self.uses_dma = (dev->dma_mask != NULL);
> > 
> > Is it easier to make sure that PIO devices don't have dev->dma_mask set?
> 
> Not really. For instance, in the case of the DMA engine in the MUSB
> controller in OMAP3, we can only use DMA with endpoints other than
> EP0, and EP0 is what is used for control transfers.
> 
> It's not PIO for all the endpoints or DMA for all of them.

The HC driver does not have to be 100% truthful here. If the system
is not HIGHMEM, HCD can easily set uses_dma to false yet use DMA
by mapping buffers itself, without relying on the quoted code.

On a HIGHMEM system, block layer will bounce-buffer data in such case.
Hopefuly not a problem for ARM?

All network stack drivers work that way, BTW.

-- Pete
