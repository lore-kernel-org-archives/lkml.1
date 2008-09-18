Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYIROq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYIROq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYIROqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:46:16 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:37605 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbYIROqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:46:14 -0400
Date: Thu, 18 Sep 2008 16:45:35 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Timur Tabi <timur@freescale.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48D2664D.7040204@freescale.com>
References: <48D02589.8070601@freescale.com>
	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
	<48D2664D.7040204@freescale.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Sep 2008 14:45:29.0571 (UTC) FILETIME=[31F8AB30:01C9199D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> wrote:
> Haavard Skinnemoen wrote:
> 
> > Wouldn't it be better if the dmaengine layer made sure it didn't pass
> > the same channel several times to a client?  
> 
> Wouldn't that require it to keep track of which clients have already seen which
> channels?  It might make more sense, but it's probably easier the current way.

I guess so. What would be even more simple is to simply prevent other
clients from taking a channel once someone has acked it, which would be
perfect for my purposes, but perhaps not everyone else's...

How common is for several clients to use the same channel anyway
though? Wouldn't you risk stalling the network stack if the md subsystem
has submitted a large xor operation on the same channel that the
network stack was about to use?

Haavard
