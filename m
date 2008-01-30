Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbYA3I5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbYA3I5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbYA3I4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:56:51 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60677 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759951AbYA3I4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:56:50 -0500
Date: Wed, 30 Jan 2008 09:56:41 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Message-ID: <20080130095641.39eaad13@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801292256.14553.david-b@pacbell.net>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<20080129215453.1e3758ab@siona>
	<200801292256.14553.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 22:56:14 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Tuesday 29 January 2008, Haavard Skinnemoen wrote:
> >
> > Btw, there's one issue I forgot to mention: I believe the DMA Engine
> > framework is currently misusing the DMA mapping API, and this patchset
> > makes things worse.
> > 
> > Currently, the async_tx bits of the API do the required calls to
> > dma_map_single() and/or dma_map_page(), but they rely on the driver to
> > do the unmapping. This is problematic ...
> > 
> > How do we solve this?  
> 
> How about:  for peripheral DMA, don't let the engine see anything
> except dma_addr_t values.

I don't think it does, but the dma_addr_t value is enough to call
dma_unmap_single() and dma_unmap_page().

> The engine needs to be able to dma_alloc_coherent() memory too,
> which is pre-mapped.

Right, which is another argument for not doing any unmapping in the DMA
engine driver. We really need to push this responsibility to the client.

Haavard
