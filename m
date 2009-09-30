Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZI3N4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZI3N4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZI3N4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:56:13 -0400
Received: from relay.atmel.no ([80.232.32.139]:64535 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbZI3N4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:56:13 -0400
Date: Wed, 30 Sep 2009 15:55:57 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 1/2] atmel-mci: change use of dma slave interface
Message-ID: <20090930155557.7dae503b@hskinnemoen-d830>
In-Reply-To: <4AC35E1D.7040802@atmel.com>
References: <1253204967-30010-1-git-send-email-nicolas.ferre@atmel.com>
	<1253204967-30010-2-git-send-email-nicolas.ferre@atmel.com>
	<20090929122928.f5fea29b.akpm@linux-foundation.org>
	<4AC35E1D.7040802@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > You'll still need typecasts to support the dma_request_channel()
> > callback, but the code will be safer and cleaner, I expect.  
> 
> My concern are:
> 1/ allow the use of either dmaengine driver
> 2/ avoid too much modification to dw_dma_slave as it
> is also used for audio stuff on avr32 platforms...
> 3/ not introduce heavy weigh solution like the use of an union

We used to have a struct dma_slave in linux/dmaengine.h which took care
of all this, but it got removed at some point.

How about introducing a new mach/atmel-mci.h file with a struct
mci_dma_data encapsulating either a struct dw_dma_slave or a struct
at_dma_slave, as well as any other DMA-related definitions needed by
the atmel-mci driver?

Then we just need to make sure that we either
  1) use the same name on all fields in struct {dw,at}_dma_slave which
     are used by the atmel-mci driver, or
  2) add accessor functions or macros for those fields.

I think I would prefer the latter, but both should work equally well.

Haavard
