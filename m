Return-Path: <linux-kernel-owner+w=401wt.eu-S1765123AbXHFWZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765123AbXHFWZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbXHFWZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:25:39 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:9370 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbXHFWZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:25:38 -0400
Date: Mon, 06 Aug 2007 16:25:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit	DMA	mapping"
In-reply-to: <46B79F25.50205@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Olaf Hering <olh@suse.de>, linuxppc-dev@ozlabs.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <46B79FD7.9020801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
 <1186272926.938.8.camel@localhost.localdomain>
 <46B5824B.1000103@s5r6.in-berlin.de>
 <1186351473.938.21.camel@localhost.localdomain>
 <20070806135124.GA2900@suse.de>
 <1186436848.938.75.camel@localhost.localdomain>
 <46B79F25.50205@s5r6.in-berlin.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Benjamin Herrenschmidt wrote:
>> Oh and, don't do the set_dma_mask() in sbp2, it has nothing to do there.
>> It should be in the ohci1394 driver.
> 
> That's not quite right.  OHCI-1394 implementations can go beyond 4GB bus
> address space.  (Although I don't know if there are such implementations
> available.  At least there are two implementations which can set the
> so-called Physical Range bigger than 4GB.)
> 
> Sbp2 however requires that everything which it DMA-maps resides in the
> Physical Range of the controller.  This way the CPU is not involved in
> most of the data transfers.  The OHCI-1394 controller acts as bus bridge
> between IEEE 1394 bus and local bus, with a 1:1 mapping of IEEE 1394 bus
> addresses to and from local bus addresses --- but not in the whole 48
> bits white IEEE 1394 bus address range, only in the
> implementation-dependent Physical Range.  The minimum Physical Range
> that all OHCI-1394 implementations guarantee is 4GB.  I could actually
> have set a bigger mask in sbp2 when the controller supports a
> programmable bigger range.
> 
> So that's the story why that dma_set_mask went into sbp2:  Sbp2 wants
> mappings in a _subset_ of the OHCI-1394 controllers DMA range.
> 
> Anyway.  For now I will simply go with what 2.6.23-rc has and what
> 2.6.21 had:  No dma_set_mask anywhere in the 1394 subsystem.  We can
> revisit this whenever an actual need arises.

Not sure this is a very good idea. This seems rather likely to fail on 
x86_64 machines with >4GB of RAM for example..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

