Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYBMVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYBMVGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYBMVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:06:44 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58583 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752287AbYBMVGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:06:43 -0500
Date: Wed, 13 Feb 2008 22:06:46 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080213220646.081583d6@siona>
In-Reply-To: <e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 12:11:58 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> > +               desc = chan->device->device_prep_slave(chan,
> > +                               sg_dma_address(sg), direction,
> > +                               DMA_SLAVE_WIDTH_32BIT,
> > +                               sg_dma_len(sg), dma_flags);
> > +               desc->txd.callback = NULL;
> > +               list_add_tail(&desc->client_node,
> > +                               &host->dma.data_descs);
> > +       }  
> 
> Need to handle device_prep_slave returning NULL?

You're right, we definitely need to handle that. Which probably means
we need to prepare an interrupt descriptor first that we can throw in
when we're unable to obtain more descriptors, and submit the rest from
the callback.

Except we're not allowed to submit anything from the callback. Ouch.

How can we solve that? Set up a work queue and submit it from there?
Trigger a different tasklet?

In any case, I guess I need to implement support for interrupt
descriptors in the dw_dmac driver.

Haavard
