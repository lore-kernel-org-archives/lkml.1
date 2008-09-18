Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYIRO3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYIRO3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYIRO3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:29:38 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36760 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbYIRO3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:29:38 -0400
Date: Thu, 18 Sep 2008 16:28:26 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Timur Tabi" <timur@freescale.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
References: <48D02589.8070601@freescale.com>
	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Sep 2008 14:28:17.0265 (UTC) FILETIME=[CAAB4610:01C9199A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Timur Tabi" <timur@freescale.com> wrote:
> On Wed, Sep 17, 2008 at 5:36 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > I believe the problem is that dmatest is telling the core to take
> > multiple references on a channel.  Take a look at
> > net/core/dev.c:netdev_dma_event and
> > crypto:asynx_tx/async_tx.c:dma_channel_add_remove both of those check
> > to see if they already have a refence to the channel.  
> 
> Ok, I see what these functions are doing, and dmatest_add_channel() is
> not doing it.  dmatest_add_channel() should not assume that it will
> only receive one and only one DMA_RESOURCE_AVAILABLE for each channel.

Wouldn't it be better if the dmaengine layer made sure it didn't pass
the same channel several times to a client?

I mean, you seem concerned that the memcpy() API should be transparent
and easy to use, but the whole registration interface is just
ridiculously complicated...

> I'll post a patch, if Haavard doesn't do it first.  Thanks for looking
> into this and getting back to me.  I've spent the entire week
> debugging this.

I'm sorry I didn't respond earlier, but I'm having difficulties
figuring out what's going on during registration/unregistration
myself...

Haavard
