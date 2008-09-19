Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYISL0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYISL0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYISL0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:26:16 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57834 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYISL0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:26:15 -0400
Date: Fri, 19 Sep 2008 13:25:44 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Timur Tabi" <timur@freescale.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
References: <48D02589.8070601@freescale.com>
	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
	<48D2664D.7040204@freescale.com>
	<20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
	<e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 11:25:34.0988 (UTC) FILETIME=[6F0E4CC0:01C91A4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Williams" <dan.j.williams@intel.com> wrote:
> On Thu, Sep 18, 2008 at 7:45 AM, Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com> wrote:
> > Timur Tabi <timur@freescale.com> wrote:  
> >> Haavard Skinnemoen wrote:
> >>  
> >> > Wouldn't it be better if the dmaengine layer made sure it didn't pass
> >> > the same channel several times to a client?  
> >>
> >> Wouldn't that require it to keep track of which clients have already seen which
> >> channels?  It might make more sense, but it's probably easier the current way.  
> >
> > I guess so. What would be even more simple is to simply prevent other
> > clients from taking a channel once someone has acked it, which would be
> > perfect for my purposes, but perhaps not everyone else's...  
> 
> Does not seem too bad to have something like a DMA_EXCL flag in
> dma_chan to tell the core not to show this channel to any other
> clients.

Yes, or maybe provide an interface for simply requesting a channel
without having to register any callbacks. With some drivers, the number
of required channels is fixed, and not using DMA just isn't an option.
A simple "get a channel which satisfies these constraints" interface
would simplify these drivers a lot.

Haavard
