Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbYBNTVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbYBNTVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYBNTV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:21:27 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53778 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756772AbYBNTV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:21:26 -0500
Date: Thu, 14 Feb 2008 20:21:28 +0100
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
Message-ID: <20080214202128.245adfd3@siona>
In-Reply-To: <e9c3a7c20802141034t1b2994ebyf9b7df216536c6b2@mail.gmail.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
	<20080213220646.081583d6@siona>
	<e9c3a7c20802131555y5217f300pc94f82f192ffb60a@mail.gmail.com>
	<20080214093623.78d3baf3@dhcp-252-066.norway.atmel.com>
	<e9c3a7c20802141034t1b2994ebyf9b7df216536c6b2@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 11:34:03 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> On Thu, Feb 14, 2008 at 1:36 AM, Haavard Skinnemoen
> <hskinnemoen@atmel.com> wrote:
> >  It's ok to use PIO for small and/or odd transfers like "read 2 bytes
> >  from this SDIO register", something that the mmc-block driver would
> >  never ask us to do. Using PIO for huge block data transfers will really
> >  hurt.
> 
> Except your testing has already shown that running out of descriptors
> rarely, if ever happens.  It just becomes an exercise in tuning the
> pool size, and letting this simple fall back mechanism be a safety net
> for the corner cases.

True...it's just that you normally expect _better_ performance when
increasing the size of the transfer. I'm just afraid that someone might
start tuning things elsewhere, only to find that crossing a certain
threshold gives a drastic reduction in performance. That would be
completely counter-intuitive.

> >  I think I'll try triggering the mmc tasklet from the DMA callback for
> >  now. Scheduling a tasklet from another tasklet should work just fine,
> >  right?
> 
> Yeah that should work because you are no longer under the channel lock.

Right. And if we insert the interrupt descriptor somewhere in the
middle instead of at the end, we should be able to submit a new batch
of descriptors before the previous batch is exhausted, thus maintaining
maximum throughput without any pauses.

I'll probably keep it simple at first though. Gotta save some
optimizations for later ;)

Haavard
