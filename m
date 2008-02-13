Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbYBMTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbYBMTYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYBMTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:24:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56083 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbYBMTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:24:03 -0500
Date: Wed, 13 Feb 2008 20:24:02 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Message-ID: <20080213202402.22818482@siona>
In-Reply-To: <e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 12:07:26 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> > +struct dma_slave_descriptor {
> > +       struct dma_async_tx_descriptor txd;
> > +       struct list_head client_node;
> > +};  
> 
> Can you explain a bit why client_node is needed?  I do not think we
> need dma_slave_descriptor if dma_unmap data / control is added to
> dma_async_tx_descriptor.  Hmm?

Well, it's perhaps not needed for slave transfers as such. But the MMC
driver (and I suspect quite a few other users of the slave interface)
deals with scatterlists, so it needs a way to keep track of all the
descriptors it submits. Hence the list node.

But looking at your latest patch series, I guess we can use the new
"next" field instead. It's not like we really need the full
capabilities of list_head.

Haavard
