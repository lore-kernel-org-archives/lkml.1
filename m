Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZA1Agx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZA1Agx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZA1Ago
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:36:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:49575 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZA1Agn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:36:43 -0500
Date: Wed, 28 Jan 2009 09:35:17 +0900
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: swiotlb default size (64 MB) too small?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <tkrat.511cc93cd769cafe@s5r6.in-berlin.de>
References: <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
	<497F9CC5.8080807@s5r6.in-berlin.de>
	<tkrat.511cc93cd769cafe@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090128093443H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 01:03:34 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > FUJITA Tomonori wrote:
> >> On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
> >> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >>> +	if (orb->page_table_bus)
> >>> +		dma_unmap_single(card_device, orb->page_table_bus,
> >>> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
> >> 
> >> Well, this does not look correct since zero can be a valid dma
> >> address.
> 
> 
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: firewire: sbp2: fix DMA mapping leak on the failure path
> 
> Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> who also provided a first version of the fix.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/fw-sbp2.c |   27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)

It's time to ask him to test this patch with the default or _less_
swiotlb resource, I guess.
