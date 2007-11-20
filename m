Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXKTUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXKTUFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbXKTUFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:05:31 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10479 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXKTUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:05:30 -0500
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: SCSI breakage on non-cache coherent architectures
X-Message-Flag: Warning: May contain useful information
References: <1195450523.7022.37.camel@pasglop>
	<20071119.003802.100741794.davem@davemloft.net>
	<1195501874.6539.5.camel@pasglop>
	<20071120082927.GA8856@alpha.franken.de>
	<1195569362.3131.3.camel@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 20 Nov 2007 12:05:17 -0800
In-Reply-To: <1195569362.3131.3.camel@localhost.localdomain> (James Bottomley's message of "Tue, 20 Nov 2007 08:36:02 -0600")
Message-ID: <adaabp8wuma.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Nov 2007 20:05:18.0579 (UTC) FILETIME=[AC58AC30:01C82BB0]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Actually, we already established on IRC that the lasi700 driver doesn't
 > need this, principally because the parisc architecture doesn't do an
 > invalidate for DMA_FROM_DEVICE but a flush and invalidate
 > (architecturally, if you read our manuals, even pdc is entitled to write
 > back dirty lines, so it's not clear there's actually an invalidate
 > instruction we can use).   This is also one possible temporary fix for
 > the other architectures if we can't get a different method to work
 > nicely.

I think doing a writeback and invalidate is a very fragile way to deal
with DMA into the middle of a data structure.  It may work OK for now,
but you have to make sure forever into the future that no codepath
anywhere else ever touches the cacheline that you're DMAing into while
the DMA is pending.  It just leaves a hidden trap that is too easy to
step on, because the architectures that get pretty much all testing
all have cache-coherent DMA.

Reviving my ancient __dma_buffer patch seems far preferable to me.

 - R.
