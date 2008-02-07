Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYBGR45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYBGR45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYBGR4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:56:49 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62698 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753873AbYBGR4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:56:48 -0500
Date: Thu, 7 Feb 2008 18:56:46 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Message-ID: <20080207185646.024ed294@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20802061308q56cf7d25paae75aed9bde4035@mail.gmail.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<200801292330.05874.david-b@pacbell.net>
	<20080130102706.15c88346@dhcp-252-066.norway.atmel.com>
	<200801300252.50344.david-b@pacbell.net>
	<20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
	<e9c3a7c20802061308q56cf7d25paae75aed9bde4035@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 14:08:35 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> On Jan 30, 2008 5:26 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> [..]
> > Right. I'll add a "unsigned int engine_type" field so that engine
> > drivers can go ahead and extend the standard dma_device structure.
> > Maybe we should add a "void *platform_data" field to the dma_slave
> > struct as well so that platforms can pass arbitrary platform-specific
> > information to the DMA controller driver?
> >  
> 
> I think we can get away with not adding an engine_type field:
> 1/ For a given platform there will usually only be one driver active.
> For example I have an architecture (IOP) specific dma_copy_to_user
> implementation that can safely assume it is talking to the iop-adma
> driver since ioat_dma and others are precluded by the Kconfig.
> 2/ If there was a situation where two dma drivers were active in a
> system you could tell them apart by comparing the function pointers,
> i.e. dma_device1->device_prep_dma_memcpy !=
> dma_device2->device_prep_dma_memcpy.

What would you be comparing them against? Perhaps you could pass a
struct device * from the platform code, which can be compared against
"dev" in struct dma_device? Or you could check dma_device->dev->name
perhaps.

In any case, I agree we probably don't need the engine_type field.

Haavard
